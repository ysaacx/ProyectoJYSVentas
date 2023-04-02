
/*
DROP TABLE #tmp
CREATE TABLE #tmp(CODIGO VARCHAR(10), STOCK DECIMAL(15,2))
INSERT INTO #tmp values('0829002',6802)
INSERT INTO #tmp values('0801001',2549)
INSERT INTO #tmp values('0801004',1147)
INSERT INTO #tmp values('0801003',10107)
INSERT INTO #tmp values('0829005',5854)
INSERT INTO #tmp values('0801006',3612)
INSERT INTO #tmp values('0801007',281)
INSERT INTO #tmp values('0829008',162)
INSERT INTO #tmp values('0801022',3958)
INSERT INTO #tmp values('0801027',1739)
INSERT INTO #tmp values('0801028',767)
INSERT INTO #tmp values('0801020',5472)
INSERT INTO #tmp values('0801021',3181)
INSERT INTO #tmp values('0801019',1979)
INSERT INTO #tmp values('0801018',570)
INSERT INTO #tmp values('0801026',145)
INSERT INTO #tmp values('1201001',6721.5)
INSERT INTO #tmp values('1201003',5676)
INSERT INTO #tmp values('1107003',2588)
INSERT INTO #tmp values('1107004',2617.5)
INSERT INTO #tmp values('0901024',378)
INSERT INTO #tmp values('0901025',563)
INSERT INTO #tmp values('1107013',13)
INSERT INTO #tmp values('1107014',20)
INSERT INTO #tmp values('0801012',1427)
INSERT INTO #tmp values('0801565',-711)
INSERT INTO #tmp values('1001001',245)
INSERT INTO #tmp values('1001136',-33)
INSERT INTO #tmp values('1001133',187)
INSERT INTO #tmp values('1001137',32)
INSERT INTO #tmp values('0933001',10)
INSERT INTO #tmp values('0904054',1)
INSERT INTO #tmp values('1101149',319)
INSERT INTO #tmp values('0933003',86)
INSERT INTO #tmp values('1101145',216)
INSERT INTO #tmp values('0904053',86)
INSERT INTO #tmp values('1309004',176)
INSERT INTO #tmp values('1309005',7)
INSERT INTO #tmp values('1309006',184)
INSERT INTO #tmp values('1309007',0)
INSERT INTO #tmp values('1309008',460)
INSERT INTO #tmp values('1309022',50)
INSERT INTO #tmp values('1309023',50)
INSERT INTO #tmp values('1309024',25)
INSERT INTO #tmp values('1309025',25)
INSERT INTO #tmp values('1309012',10)
INSERT INTO #tmp values('1309018',10)
INSERT INTO #tmp values('1309026',10)
INSERT INTO #tmp values('1309027',3)
INSERT INTO #tmp values('1309021',12)
INSERT INTO #tmp values('1309028',19)
INSERT INTO #tmp values('1309017',20)
INSERT INTO #tmp values('1309029',0)
INSERT INTO #tmp values('1309032',20)
INSERT INTO #tmp values('1309014',18)
INSERT INTO #tmp values('1309031',20)
INSERT INTO #tmp values('1309030',19)
INSERT INTO #tmp values('1309016',10)
INSERT INTO #tmp values('1309034',10)
INSERT INTO #tmp values('1309015',6)
INSERT INTO #tmp values('1309011',7)
INSERT INTO #tmp values('1309013',10)
INSERT INTO #tmp values('1309010',3)
INSERT INTO #tmp values('1309009',8)

*/

DECLARE @ARTIC_Codigo VARCHAR(10) = '0829005'
DECLARE @Esperado DECIMAL(15,2) = 5854
DECLARE @FecIni DATETIME = '2019-01-01'
DECLARE @FecFin DATETIME = '2019-12-31'

CREATE TABLE #TMP_RESULTADO(ARTIC_Codigo VARCHAR(10), STOCKINICIAL DECIMAL(15,2), COMPRAS DECIMAL(15,2), VENTAS DECIMAL(15,2), STOCK DECIMAL(15,2), DIFERENCIA DECIMAL(15,2), TOTAL DECIMAL(15,2))

DECLARE Art CURSOR FOR 
	Select CODIGO, STOCK From #tmp --WHERE codigo IN ('1107013', '1107014', '0904053', '1309022','1309023','1309024','1309025', '1309026', '1309032', '1309031', '1309034')
Open Art

FETCH NEXT FROM Art
	INTO @ARTIC_Codigo, @Esperado

WHILE @@FETCH_STATUS = 0
Begin
        DECLARE @StockInicial DECIMAL(15,2) = 0
        DECLARE @Compras DECIMAL(15,2) = 0
        DECLARE @Ventas DECIMAL(15,2) = 0
        DECLARE @Compras_c DECIMAL(15,2) = 0
        DECLARE @Ventas_c DECIMAL(15,2) = 0

        SELECT @StockInicial = STINI_Cantidad FROM Logistica.LOG_StockIniciales WHERE ARTIC_Codigo = @ARTIC_Codigo AND PERIO_Codigo = YEAR(@FecFin)

        SELECT --@Compras = SUM(DCOM.DOCCD_Cantidad), @Compras_c = COUNT(*) 
               Descripcion = 'COMPRAS'
             , CANTIDAD = DCOM.DOCCD_Cantidad, ARTIC_Codigo = @ARTIC_Codigo
             , Fecha = CDOC.DOCCO_FechaDocumento
             , CDOC.TIPOS_CodTipoDocumento
             , Documento= CDOC.TIPOS_CodTipoDocumento + ' ' + CDOC.DOCCO_Serie + '-' + RTRIM(CDOC.DOCCO_Numero)
          INTO #COMPRAS
          FROM Logistica.ABAS_DocsCompraDetalle DCOM
         INNER JOIN Logistica.ABAS_DocsCompra CDOC ON CDOC.DOCCO_Codigo = DCOM.DOCCO_Codigo 
           AND CDOC.ENTID_CodigoProveedor = DCOM.ENTID_CodigoProveedor
         WHERE DCOM.ARTIC_Codigo = @ARTIC_Codigo
           AND CONVERT(DATE, CDOC.DOCCO_FechaDocumento) BETWEEN @FecIni AND @FecFin
           AND CDOC.DOCCO_Estado <> 'X'

        SELECT --@Ventas = SUM(DVEN.DOCVD_Cantidad), @Ventas_c = COUNT(*) 
               Descripcion = 'VENTAS'
             , CANTIDAD     = DVEN.DOCVD_Cantidad
             , ARTIC_Codigo = @ARTIC_Codigo
             , Fecha = CVEN.DOCVE_FechaDocumento
             , CVEN.TIPOS_CodTipoDocumento
             , Documento = CVEN.TIPOS_CodTipoDocumento + ' ' + CVEN.DOCVE_Serie + '-' + RTRIM(CVEN.DOCVE_Numero)
          INTO #VENTAS
          FROM Ventas.VENT_DocsVentaDetalle DVEN 
         INNER JOIN Ventas.VENT_DocsVenta CVEN ON CVEN.DOCVE_Codigo = DVEN.DOCVE_Codigo
         WHERE DVEN.ARTIC_Codigo = @ARTIC_Codigo
           AND CONVERT(DATE, CVEN.DOCVE_FechaDocumento) BETWEEN @FecIni AND @FecFin
           AND CVEN.DOCVE_Estado <> 'X'

        /*
        SELECT ARTIC_Codigo
             , ENTRADA = (CASE TIPOS_CodTipoDocumento WHEN 'CPD07' THEN CANTIDAD ELSE 0 END)
             , SALIDA = (CASE TIPOS_CodTipoDocumento WHEN 'CPD07' THEN 0 ELSE CANTIDAD END) --CANTIDAD
             , Fecha 
             , TIPOS_CodTipoDocumento
             , Documento
          FROM #VENTAS
        UNION 
        SELECT ARTIC_Codigo, ENTRADA = CANTIDAD, SALIDA = 0.00, Fecha, TIPOS_CodTipoDocumento, Documento FROM #COMPRAS
        ORDER BY Fecha ASC
        */

        SELECT @Compras = ISNULL(SUM(CANTIDAD), 0), @Compras_c = COUNT(*) FROM #COMPRAS 
        SELECT @Ventas  = ISNULL(SUM(CANTIDAD), 0), @Ventas_c  = COUNT(*) FROM #VENTAS WHERE TIPOS_CodTipoDocumento <> 'CPD07'
        SELECT @Compras  = @Compras + ISNULL(SUM(CANTIDAD), 0), @Ventas_c  = @Ventas_c + ISNULL(COUNT(*), 0) FROM #VENTAS WHERE TIPOS_CodTipoDocumento = 'CPD07'

        DECLARE @Stock DECIMAL(15,2) =  @StockInicial + @Compras - @Ventas

        INSERT INTO #TMP_RESULTADO(ARTIC_Codigo, STOCKINICIAL, COMPRAS, VENTAS, STOCK, DIFERENCIA, TOTAL)
         SELECT @ARTIC_Codigo
              , STOCKINICIAL = @StockInicial, COMPRAS = @Compras, VENTAS = @Ventas, Stock = @Stock
              , DIFERENCIA = @Stock - @Esperado
              --, @Compras_c, @Ventas_c 
              , @Compras_c + @Ventas_c

        DROP TABLE #COMPRAS
        DROP TABLE #VENTAS

	FETCH NEXT FROM Art
	INTO @ARTIC_Codigo, @Esperado
End

CLOSE Art
DEALLOCATE Art

SELECT * FROM #TMP_RESULTADO

DROP TABLE #TMP_RESULTADO

--SELECT C.CANTIDAD, V.CANTIDAD , DIFERENCIA = @StockInicial + (C.CANTIDAD - V.CANTIDAD)
--  FROM #COMPRAS C INNER JOIN #VENTAS V ON V.ARTIC_Codigo = C.ARTIC_Codigo


