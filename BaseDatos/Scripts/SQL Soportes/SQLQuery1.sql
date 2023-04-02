USE BDNOVACERO
go
exec ARTICSS_Busqueda @Linea=NULL,@Cadena=N'tubo '

select * from Articulos where ARTIC_Codigo = '0202135'
select * from Ventas.VENT_DocsVenta where DOCVE_Numero = 16073
select * from Ventas.VENT_DocsVenta where DOCVE_Codigo = '01F0010016073'

select * from Ventas.VENT_DocsVentaDetalle where DOCVE_Codigo = '01F0010016073'

select DOCVD_Cantidad, DOCVD_PrecioUnitario, DOCVD_Cantidad * DOCVD_PrecioUnitario, DOCVD_SubImporteVenta, DOCVD_SubTotal  from Ventas.VENT_DocsVentaDetalle where DOCVE_Codigo = '01F0010016073'

select DOCVD_Cantidad, DOCVD_PrecioUnitario, DOCVD_SubImporteVenta, DOCVD_SubTotal  from Ventas.VENT_DocsVentaDetalle where DOCVE_Codigo = '01F0010016073'
and DOCVD_Cantidad * DOCVD_PrecioUnitario <> DOCVD_SubImporteVenta

select ARTIC_Codigo, DOCVD_Cantidad, DOCVD_PrecioUnitario, DOCVD_Cantidad * DOCVD_PrecioUnitario, DOCVD_SubImporteVenta, DOCVD_SubTotal  from Ventas.VENT_DocsVentaDetalle 
WHERE ROUND(DOCVD_Cantidad * DOCVD_PrecioUnitario, 2) <> DOCVD_SubImporteVenta


SELECT PEDID_Numero, PEDID_Id, * FROM Ventas.VENT_Pedidos WHERE PEDID_Codigo = 'CT0010044977'

exec VENT_PEDIDSS_BusCotizacion @FecIni='2023-01-17 00:00:00',@FecFin='2023-01-17 00:00:00',@ZONAS_Codigo=N'83.00',@PVENT_Id=1,@SUCUR_Id=1,@PEDID_Tipo=N'C',@Opcion=1,@Cadena=N'',@Todos=1,@Rehusados=0



SELECT PEDID_Numero, PEDID_Id, * FROM Ventas.VENT_Pedidos WHERE PEDID_Codigo = 'CT0010044977'
SELECT PEDID_Numero, PEDID_Id, * FROM Ventas.VENT_Pedidos WHERE ENTID_CodigoCliente = '10479181778'
SELECT * FROM Ventas.VENT_PedidosDetalle WHERE PEDID_Codigo = 'CT0010044977'

SELECT * FROM dbo.Articulos WHERE ARTIC_Percepcion = 1
SELECT * FROM Historial.Articulos
SELECT * FROM Historial.VENT_Pedidos WHERE PEDID_Codigo = 'CT0010044977'
SELECT * FROM Historial.VENT_Pedidos WHERE PEDID_Codigo = 'CT0010044971'
SELECT * FROM Ventas.VENT_PedidosDetalle WHERE PEDID_Codigo = 'CT0010044971'

SELECT * FROM Ventas.VENT_PedidosDetalle WHERE ARTIC_Codigo = '0202135' AND  PEDID_Codigo IN (SELECT PEDID_Codigo FROM Ventas.VENT_Pedidos WHERE ENTID_CodigoCliente = '10479181778' ) ORDER BY PDDET_FecCrea ASC

SELECT * FROM Ventas.VENT_PedidosDetalle WHERE ARTIC_Codigo = '0202135' ORDER BY PDDET_FecCrea asc

