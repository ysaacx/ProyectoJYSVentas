
/*
DROP TABLE #tmp
CREATE TABLE #tmp(CODIGO VARCHAR(10), STOCK DECIMAL(15,2))
INSERT INTO #tmp values('0801004',251)
INSERT INTO #tmp values('0801003',465)
INSERT INTO #tmp values('0801007',160)
INSERT INTO #tmp values('0829008',101)
INSERT INTO #tmp values('0801022',316)
INSERT INTO #tmp values('0801028',18)
INSERT INTO #tmp values('0801020',-173)
INSERT INTO #tmp values('0801021',-148)
INSERT INTO #tmp values('0801026',41)
INSERT INTO #tmp values('0801012',10086)
INSERT INTO #tmp values('0701020',40)
INSERT INTO #tmp values('1001138',1)
INSERT INTO #tmp values('1803003',4)
INSERT INTO #tmp values('0933003',1)
INSERT INTO #tmp values('1101145',102)
INSERT INTO #tmp values('1101149',160)
INSERT INTO #tmp values('1309005',1)
INSERT INTO #tmp values('1309022',4)
INSERT INTO #tmp values('1309023',12)
INSERT INTO #tmp values('1309024',29)
INSERT INTO #tmp values('1309025',3)
INSERT INTO #tmp values('1309026',2)
INSERT INTO #tmp values('1309030',1)
INSERT INTO #tmp values('1309031',18)
INSERT INTO #tmp values('1309032',1)
INSERT INTO #tmp values('1309033',0)
INSERT INTO #tmp values('1309044',3)
INSERT INTO #tmp values('1309050',45)


*/

DECLARE @ARTIC_Codigo VARCHAR(10) = '0829005'
DECLARE @Esperado DECIMAL(15,2) = 5854
DECLARE @FecIni DATETIME = '2020-01-01'
DECLARE @FecFin DATETIME = '2020-12-31'

CREATE TABLE #TMP_RESULTADO(ARTIC_Codigo VARCHAR(10), STOCKINICIAL DECIMAL(15,2), COMPRAS DECIMAL(15,2), VENTAS DECIMAL(15,2), STOCK DECIMAL(15,2), DIFERENCIA DECIMAL(15,2), TOTAL DECIMAL(15,2))

DECLARE Art CURSOR FOR 
	Select CODIGO, STOCK From #tmp WHERE codigo IN ('0801007') --, '1107014', '0904053', '1309022','1309023','1309024','1309025', '1309026', '1309032', '1309031', '1309034')
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
        --SELECT * FROM Logistica.LOG_StockIniciales WHERE ARTIC_Codigo = @ARTIC_Codigo AND PERIO_Codigo = YEAR(@FecFin)

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


