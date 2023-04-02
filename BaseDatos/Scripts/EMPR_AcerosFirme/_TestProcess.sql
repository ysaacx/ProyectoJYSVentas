

BEGIN TRAN x

 EXEC VENT_VENTSS_RomperRelacionDocsVentas @DOCVE_Codigo=N'01F0010000001',@PVENT_Id=1,@XPago=0
 
 DELETE FROM Logistica.LOG_Stocks WHERE     STOCK_Id = 2And ALMAC_Id = 1

 DELETE FROM Ventas.VENT_DocsVentaDetalle  WHERE   DOCVE_Codigo = '01F0010000001'
------------------------------------------------
 --DELETE FROM Tesoreria.TESO_CajaDocsPago WHERE DOCVE_Codigo = '01F0010000001'
 --DELETE FROM Tesoreria.TESO_DocsPagos WHERE DOCVE_Codigo = '01F0010000001'
------------------------------------------------
SELECT * FROM Tesoreria.TESO_CajaDocsPago
SELECT * FROM Tesoreria.TESO_DocsPagos
------------------------------------------------
DELETE FROM Ventas.VENT_DocsVenta WHERE   DOCVE_Codigo = '01F0010000001'
 
ROLLBACK TRAN x


--SELECT * FROM Logistica.LOG_Stocks
