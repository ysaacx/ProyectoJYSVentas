USE BDInkaPeru
GO

--SELECT * FROM Logistica.LOG_Stocks WHERE STOCK_Id >= 112648 AND PERIO_Codigo = 2019
--SELECT * FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) >= '2021-10-01'
--SELECT * FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) >= '2021-10-01' AND STOCK_UsrCrea = 'SISTEMAS'
--SELECT * FROM Logistica.LOG_Stocks WHERE PERIO_Codigo = 2019 AND ARTIC_Codigo = '0801003'
BEGIN TRAN x
UPDATE Logistica.LOG_Stocks SET PERIO_Codigo = '2020' WHERE PERIO_Codigo = '2021' AND GUIAR_Codigo = '090050001886'
ROLLBACK TRAN x

BEGIN TRAN x
    UPDATE Logistica.LOG_Stocks SET PERIO_Codigo = '2019' 
     WHERE GUIAR_Codigo IN ('090050001546', '090050001620', '090050001621', '090050001648', '090050001650', '090050001670'
                           , '090050001717'
                           , '090050001550', '090050001553', '090050001562', '090050001575', '090050001581', '090050001592', '090050001598', '090050001498'
                           , '090050001674', '090050001769', '090050001647', '090050001631', '090050001731', '090050001559', '090050001559')
       AND PERIO_Codigo = '2020'

    UPDATE Logistica.LOG_Stocks SET PERIO_Codigo = '2019' 
     WHERE DOCVE_Codigo IN ('01F0010005037')
       AND PERIO_Codigo = '2020'
    --UPDATE Logistica.LOG_Stocks
    --    SET PERIO_Codigo = '2019'
    --Where ARTIC_Codigo = '0801003'
    --    And PERIO_Codigo = '2020'
    --    And STOCK_Estado <> 'X'
    --    --And ZONAS_Codigo = '84.00'
    --    And ALMAC_Id = 1
    --    And Convert(Date, STOCK_Fecha) < '2020-01-01'
ROLLBACK TRAN x


BEGIN TRAN x

DECLARE @ARTIC_Codigo VARCHAR(10) = '0801003'
DECLARE @Guias VARCHAR(200) = '090050001886, 090050001877' 
                            + ',090050001785'
DECLARE @FecIni DATETIME = '2020-01-01'
DECLARE @FecFin DATETIME = '2020-12-31'
                          
DECLARE @Periodo CHAR(4) = '2020'
DECLARE @STOCK_Id INT = ISNULL((SELECT MAX(STOCK_Id) FROM Logistica.LOG_Stocks), 0) --  WHERE PERIO_Codigo = @Periodo AND ALMAC_Id = 1
PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
PRINT 'INSERT GUIAS'
INSERT INTO Logistica.LOG_Stocks
        ( PERIO_Codigo ,
          ARTIC_Codigo ,
          ALMAC_Id ,
          STOCK_Id ,
          ENTID_CodigoProveedor ,
          ENTID_CodigoCliente ,
          TIPOS_CodTipoDocEntrega ,
          TIPOS_CodTipoUnidad ,
          GUIAR_Codigo ,
          GUIRD_Item ,
          STOCK_Fecha ,
          STOCK_CantidadIngreso ,
          STOCK_CantidadSalida ,
          STOCK_Estado ,
          STOCK_UsrCrea ,
          STOCK_FecCrea           
        )
   SELECT PERIO_Codigo = @Periodo ,
          GUIR.ARTIC_Codigo ,
          ALMAC_Id = 1,
          STOCK_Id = @STOCK_Id --ISNULL((SELECT MAX(STOCK_Id) FROM Logistica.LOG_Stocks WHERE PERIO_Codigo = @Periodo AND ALMAC_Id = 1), 0) + 
                     + ROW_NUMBER()OVER(ORDER BY GUIR.ARTIC_Codigo),
          ENTID_CodigoProveedor = NULL ,
          ENTID_CodigoCliente  = GUIA.ENTID_CodigoCliente,
          TIPOS_CodTipoDocEntrega = GUIA.TIPOS_CodMotivoTraslado , --MST01
          TIPOS_CodTipoUnidad = ARTIC.TIPOS_CodUnidadMedida,
          GUIAR_Codigo = GUIA.GUIAR_Codigo,
          GUIRD_Item ,
          STOCK_Fecha = GUIA.GUIAR_FechaEmision,
          STOCK_CantidadIngreso = 0,
          STOCK_CantidadSalida = GUIR.GUIRD_Cantidad,
          STOCK_Estado = 'I',
          STOCK_UsrCrea = 'SISTEMAS' ,
          STOCK_FecCrea = GETDATE()
     FROM Logistica.DIST_GuiasRemisionDetalle GUIR 
    INNER JOIN Logistica.DIST_GuiasRemision GUIA ON GUIA.GUIAR_Codigo = GUIR.GUIAR_Codigo
    INNER JOIN ARTICULOS ARTIC ON ARTIC.ARTIC_Codigo = GUIR.ARTIC_Codigo
    WHERE GUIR.GUIAR_Codigo IN (SELECT Item FROM dbo.SplitString(@Guias, ',')) --('090050000756', '090050000583', '090050000950')
      AND GUIR.GUIAR_Codigo NOT IN (SELECT GUIAR_Codigo 
                                     FROM Logistica.LOG_Stocks 
                                    WHERE GUIAR_Codigo IN (SELECT Item FROM dbo.SplitString(@Guias, ',')))

--    SELECT * FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo IN ('090050000756', '090050000583', '090050000950')
PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=@ARTIC_Codigo,@ALMAC_Id=1,@PERIO_Codigo=@Periodo,@ZONAS_Codigo=N'84.00',@FecIni=@FecIni,@FecFin=@FecFin

ROLLBACK TRAN x


--DELETE FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) = '2021-11-01'

