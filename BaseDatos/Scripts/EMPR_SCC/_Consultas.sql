USE BDSisSCC
GO

--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'MST%'
--SELECT * FROM Ventas.VENT_DocsVenta WHERE TIPOS_CodTipoDocumento = 'CPD07'
--SELECT * FROM Ventas.VENT_DocsVentaDetalle WHERE DOCVE_Codigo = '070010000005'
--SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo IN ('0401049', '0401047')

--SELECT * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0401029'
--SELECT * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0401049'
--SELECT * FROM Ventas.VENT_DocsRelacion WHERE DOCVE_Codigo = '010050003449'


BEGIN TRAN X

DECLARE @STOCK_Id BIGINT
SET @STOCK_Id = (SELECT MAX(STOCK_Id) FROM Logistica.LOG_Stocks WHERE PERIO_Codigo = '2017' AND ALMAC_Id = 1)

INSERT INTO Logistica.LOG_Stocks( [PERIO_Codigo]                               , [ARTIC_Codigo]                               , [ALMAC_Id]                               , [STOCK_Id]                               
, [ENTID_CodigoProveedor]                               , [ENTID_CodigoCliente]                               , [TIPOS_CodTipoDocEntrega]                               , [TIPOS_CodTipoUnidad]                               
, [DOCCO_Codigo]                               , [DOCCD_Item]                               , [INGCO_Id]                               , [INGCD_Item]                               
, [DOCVE_Codigo]                               , [DOCVD_Item]                               , [PEDID_Codigo]                               , [PDDET_Item]                               
, [ORDCO_Codigo]                               , [GUIAR_Codigo]                               , [GUIRD_Item]                               , [ORDEN_Codigo]                               
, [ORDET_Item]                               , [STOCK_Fecha]                               , [STOCK_CantidadIngreso]                               , [STOCK_CantidadSalida]                               
, [STOCK_Estado]                               , [STOCK_UsrCrea]                               , [STOCK_FecCrea]                               , [STOCK_UsrMod]                               
, [STOCK_FecMod]                               , [TIPOS_CodTipoMotivo]                               , [ARREG_Codigo]                               , [ARRDT_Item]                               
)
VALUES ( 
'2017'            , '0401029'    , 1             , @STOCK_Id + 1                     
, NULL            , NULL         , NULL          , 'UND08'          
, NULL            , NULL         , NULL          , NULL                   
, '070010000004'  , 1         , NULL          , NULL                   
, NULL            , NULL         , NULL          , NULL                 
, NULL            , '2018-05-24' , 14            , 0         
, 'I'             , '29736349'   , '2018-05-24'  , NULL                 
, NULL            , 'MST14'      , NULL          , NULL
)

INSERT INTO Logistica.LOG_Stocks( 
  [PERIO_Codigo]                               , [ARTIC_Codigo]                               , [ALMAC_Id]                               , [STOCK_Id]                               
, [ENTID_CodigoProveedor]                      , [ENTID_CodigoCliente]                               , [TIPOS_CodTipoDocEntrega]                               , [TIPOS_CodTipoUnidad]                               
, [DOCCO_Codigo]                               , [DOCCD_Item]                               , [INGCO_Id]                               , [INGCD_Item]                               
, [DOCVE_Codigo]                               , [DOCVD_Item]                               , [PEDID_Codigo]                               , [PDDET_Item]                               
, [ORDCO_Codigo]                               , [GUIAR_Codigo]                               , [GUIRD_Item]                               , [ORDEN_Codigo]                               
, [ORDET_Item]                                 , [STOCK_Fecha]                               , [STOCK_CantidadIngreso]                               , [STOCK_CantidadSalida]                               
, [STOCK_Estado]                               , [STOCK_UsrCrea]                               , [STOCK_FecCrea]                               , [STOCK_UsrMod]                               
, [STOCK_FecMod]                               , [TIPOS_CodTipoMotivo]                               , [ARREG_Codigo]                               , [ARRDT_Item]                               
)
VALUES ( 
'2017'            , '0401047'    , 1             , @STOCK_Id + 2
, NULL            , NULL         , NULL          , 'UND07'          
, NULL            , NULL         , NULL          , NULL                   
, '070010000004'  , 2         , NULL          , NULL                   
, NULL            , NULL         , NULL          , NULL                 
, NULL            , '2018-05-24' , 10            , 0         
, 'I'             , '29736349'   , '2018-05-24'  , NULL                 
, NULL            , 'MST14'      , NULL          , NULL
)

UPDATE Ventas.VENT_DocsVenta SET DOCVE_Estado = 'I' WHERE DOCVE_Codigo = '070010000004'

--SELECT * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0401029'
--SELECT * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0401049'

exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=N'0401029',@ALMAC_Id=1,@PERIO_Codigo=N'2017',@ZONAS_Codigo=N'83.00',@FecIni='2018-05-06 00:00:00',@FecFin='2018-06-06 00:00:00'
exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=N'0401047',@ALMAC_Id=1,@PERIO_Codigo=N'2017',@ZONAS_Codigo=N'83.00',@FecIni='2018-05-06 00:00:00',@FecFin='2018-06-06 00:00:00'

ROLLBACK TRAN X



SELECT * FROM BDSisSCC..Lineas