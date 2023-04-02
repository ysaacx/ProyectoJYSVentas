USE BDInkaPeru
GO

--SELECT * FROM Logistica.LOG_Stocks WHERE STOCK_Id >= 112648 AND PERIO_Codigo = 2019
--SELECT * FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) >= '2021-10-01'
--SELECT * FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) >= '2021-10-01' AND STOCK_UsrCrea = 'SISTEMAS'
--SELECT * FROM Logistica.LOG_Stocks WHERE PERIO_Codigo = 2019 AND ARTIC_Codigo = '0801003'

BEGIN TRAN x

DECLARE @ARTIC_Codigo VARCHAR(10) = '0801003'
DECLARE @Guias VARCHAR(200) = '090050000756,090050000583,090050000950' 
                            + ',090050000707,090050000855,090050000687,090050000722,090050000946,090050001034' -- 0801003
                            --+ ',090050000545,090050000549,090050000550,090050000564,090050000569,090050000663' --90050000650
                            

DECLARE @Periodo CHAR(4) = '2019'
DECLARE @STOCK_Id INT = ISNULL((SELECT MAX(STOCK_Id) FROM Logistica.LOG_Stocks), 0) --  WHERE PERIO_Codigo = @Periodo AND ALMAC_Id = 1

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

exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=@ARTIC_Codigo,@ALMAC_Id=1,@PERIO_Codigo=N'2019',@ZONAS_Codigo=N'84.00',@FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00'

ROLLBACK TRAN x


--DELETE FROM Logistica.LOG_Stocks WHERE CONVERT(DATE, STOCK_FecCrea) = '2021-11-01'

