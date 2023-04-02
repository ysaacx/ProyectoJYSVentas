USE BDSVAlmacen
go
--Delete from EntidadesRoles where ENTID_Codigo = '29417594'
--Delete from Entidades where ENTID_Codigo = '29417594'

Delete From Logistica.LOG_Stocks
--select * from Logistica.LOG_Stocks

DELETE FROM Logistica.ABAS_IngresoPorPiezasDetalle
DELETE FROM Logistica.ABAS_IngresoPorPiezas
DELETE FROM Ventas.VENT_PedidoPiezas
DELETE FROM Ventas.VENT_PedidosDetalle
DELETE FROM Ventas.VENT_Pedidos
DELETE FROM Historial.VENT_Pedidos

DELETE FROM Logistica.DIST_GuiasRemisionVentas
DELETE FROM Ventas.VENT_DocsVentaDetalle

Delete FROM Transportes.TRAN_ViajesVentas

DELETE FROM transportes.TRAN_OrdenesTransportes

DELETE FROM transportes.TRAN_CotizacionesDetalle
DELETE FROM transportes.TRAN_CotizacionesFletes

ALTER TABLE [Transportes].[TRAN_CotizacionesFletes]
CHECK CONSTRAINT [FK_TRAN_CotizacionesFletes_Cotizacion]
GO

ALTER TABLE [Transportes].[TRAN_Fletes]
CHECK CONSTRAINT [FK_TRAN_Fletes_TRAN_Cotizaciones]
GO

DELETE FROM transportes.TRAN_ViajesIngresos
DELETE FROM transportes.TRAN_Fletes
DELETE FROM transportes.TRAN_Cotizaciones

ALTER TABLE [Ventas].[VENT_DocsRelacion]
CHECK CONSTRAINT [FK_VENT_DocsRelacion_CodReferencia]
GO


DELETE FROM Ventas.VENT_DocsVentaPagos
DELETE FROM Tesoreria.TESO_CajaDocsPago
DELETE FROM Tesoreria.TESO_Recibos
DELETE FROM Tesoreria.TESO_DocsPagos
go
DISABLE TRIGGER [TRIGD_TESO_Caja] ON [Tesoreria].[TESO_Caja]
GO
DELETE FROM Tesoreria.TESO_Caja
DELETE FROM Historial.TESO_Caja
go
ENABLE TRIGGER [TRIGD_TESO_Caja] ON [Tesoreria].[TESO_Caja]
GO
DELETE FROM Ventas.VENT_DocsRelacion
DELETE FROM Contabilidad.CONT_DocsPercepcionDetalle
DELETE FROM Contabilidad.CONT_DocsPercepcion
DELETE FROM Ventas.VENT_DocsVenta --where DOCVE_Referencia In (Select DOCVE_Codigo From Ventas.VENT_DocsVenta)

DELETE FROM Historial.VENT_DocsVenta 

DELETE FROM Logistica.ABAS_Costeos
DELETE FROM Logistica.ABAS_DocsCompraDetalle
DELETE FROM Logistica.ABAS_DocsCompra
DELETE FROM Logistica.ABAS_IngresosCompraDetalle
DELETE FROM Logistica.ABAS_IngresosCompra
DELETE FROM Logistica.ABAS_OrdenesCompraDetalle
DELETE FROM Logistica.ABAS_OrdenesCompra
DELETE FROM Logistica.ABAS_CotizacionesCompraDetalle
DELETE FROM Logistica.ABAS_CotizacionesCompra

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
Select * From Logistica.LOG_Stocks 
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* Eliminar Registro de la Tabla Logistica.LOG_Stocks*/
Select * From Logistica.LOG_Stocks where Not DOCVE_Codigo Is Null
Delete From Logistica.LOG_Stocks 
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* Eliminar Registro de la Tabla Ventas.VENT_DocsVentaDetalle */
Select * From Ventas.VENT_DocsVentaPagos
Delete From Ventas.VENT_DocsVentaPagos
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* Elimianr los Registro de Ventas */
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* Elimianr los Registro de Ventas */
Select * From Tesoreria.TESO_Caja 
Delete From Tesoreria.TESO_Caja 

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

Select * From Ventas.VENT_PedidosDetalle
Delete From Ventas.VENT_PedidosDetalle
Select * From Ventas.VENT_Pedidos
Delete From Ventas.VENT_Pedidos



DELETE FROM Logistica.DESP_GuiaRSalidas
DELETE FROM Logistica.DIST_GuiasRemisionDetalle
DELETE FROM Logistica.DIST_GuiasRemision

DELETE FROM Logistica.DIST_GuiasRemision
DELETE FROM Historial.DIST_GuiasRemision

DELETE FROM Logistica.DIST_OrdenesDetalle
go
DISABLE TRIGGER [TRIGD_DIST_Ordenes] ON [Logistica].[DIST_Ordenes]
GO
DELETE FROM Logistica.DIST_Ordenes
DELETE FROM Historial.DIST_Ordenes
go
ENABLE TRIGGER [TRIGD_DIST_Ordenes] ON [Logistica].[DIST_Ordenes]
GO

DELETE FROM Transportes.TRAN_Documentos
DELETE FROM Transportes.TRAN_DocumentosDetalle

DELETE FROM Data.VENT_DocsVentaDetalle
DELETE FROM Data.VENT_DocsVenta

DELETE FROM Historial.ABAS_Costeos
DELETE FROM Historial.LOG_StockIniciales
DELETE FROM Historial.LOG_Stocks

DELETE FROM Historial.Pendientes
DELETE FROM Historial.Precios
DELETE FROM Historial.TRAN_Fletes
DELETE FROM Historial.TRAN_Viajes

DELETE FROM Logistica.CTRL_ArreglosDetalle
DELETE FROM Logistica.CTRL_Arreglos

DELETE FROM Logistica.DESP_Salidas

--SELECT * FROM Logistica.LOG_StockIniciales
Delete From Logistica.LOG_StockIniciales --where PERIO_Codigo = '2013'

DELETE FROM Tesoreria.TESO_CajaChicaPagos
DELETE FROM Tesoreria.TESO_CajaChicaIngreso

DELETE FROM Tesoreria.TESO_DocumentosDetalle
DELETE FROM Tesoreria.TESO_Documentos

DELETE FROM Tesoreria.TESO_Sencillo

select * from VerStockPtoVenta 
delete from VerStockPtoVenta where PVENT_Id <> 1 
delete from VerStockPtoVenta where PVENT_Id = 1 and ALMAC_Id <> 1

delete from Transportes.TRAN_VehiculosConductores
delete from Transportes.TRAN_VehiculosInventarioDetalle
delete from Transportes.TRAN_VehiculosInventario
delete from Transportes.TRAN_VehiculosMantenimiento
delete from Transportes.TRAN_Vehiculos

delete from Ventas.VENT_PVentDocumento where PVENT_Id <> 1

delete from UsuariosPorPuntoVenta where PVENT_Id <> 1
--delete from UsuariosPorAlmacen where PVENT_Id <> 1
delete from RRHH.PLAN_Pendientes

delete from PuntoVenta where PVENT_Id <> 1

select * from Clientes
update Clientes set SUCUR_Id = 1 where SUCUR_Id<> 1

delete from UsuariosPorAlmacen where SUCUR_Id <> 1
select * from UsuariosPorAlmacen where SUCUR_Id = 1
update UsuariosPorAlmacen set ALMAC_Id = 1 

delete from UsuariosPorPuntoVenta where SUCUR_Id <> 1

--delete from Parametros where SUCUR_Id <> 1

Update Ventas.VENT_PVentDocumento set SUCUR_Id = 1

select * from PuntoVenta
select * from Almacenes

delete from Almacenes where SUCUR_Id <> 1

delete from Correlativos where SUCUR_Id <> 1

delete from Sucursales where SUCUR_Id<> 1

update Logistica.LOG_StockIniciales set ALMAC_Id = 1

SELECT * FROM ventas.VENT_ListaPreciosArticulos

delete from Ventas.VENT_ListaPreciosArticulos where ZONAS_Codigo <> '54.00'
delete from Ventas.VENT_ListaPrecios where ZONAS_Codigo <> '54.00'

delete from Precios where ZONAS_Codigo <> '54.00'

--select * from Tesoreria.TESO_SIniciales

/* Optimizar la Base de Datos */

Use BDSVAlmacen
dbcc sqlperf(logspace)
backup log BDADyA to disk = 'E:\Eliminar\BK.LOG' WITH NO_TRUNCATE
backup log BDADyA to disk = 'E:\Eliminar\BK.LOG'
use BDSVAlmacen
DBCC SHRINKFILE ('BDAceCom_log',NOTRUNCATE)
DBCC SHRINKFILE ('BDAceCom_log',TRUNCATEONLY)
DBCC SHRINKDATABASE ('BDSVAlmacen')
CHECKPOINT 
dbcc sqlperf(logspace)
backup log BDADyA to disk = 'D:\Eliminar\BK.LOG' WITH NO_TRUNCATE
backup log BDADyA to disk = 'D:\Eliminar\BK.LOG'  


ALTER DATABASE BDSVAlmacen
SET RECOVERY SIMPLE;
GO
-- reducirmos el archivo log a 1 MB.
DBCC SHRINKFILE (BDAceCom_log, 1);
GO
-- devolvemos el nivel de recovery a full
ALTER DATABASE BDSVAlmacen
SET RECOVERY FULL;
GO


/* Inicializar Admin */
USE bdsadmin
go
Select * From UsuariosAplicaciones
delete from UsuariosAplicaciones

delete from UsuariosEmpresas where empr_codigo <> 'adya'

delete from usuariosplantillas

delete from usuariosprocesos

delete from usuariosaplicaciones

delete from usuarios where user_codusr <> 'ysaacx'

delete from procesos

delete from plantillasmenu



/* Inicializar Stocks */

--Select * from Logistica.LOG_StockIniciales

--Update Logistica.LOG_StockIniciales Set STINI_Cantidad = 0 

/* inICIALIZAR LISTAS DE PRECIOS */

--SELECT * FROM Ventas.VENT_ListaPrecios
--DELETE FROM Ventas.VENT_ListaPrecios WHERE LPREC_Id > 2

--UPDATE Ventas.VENT_ListaPrecios SET LPREC_Descripcion = 'DECORADORES' WHERE LPREC_Id = 1
--UPDATE Ventas.VENT_ListaPrecios SET LPREC_Descripcion = 'CLIENTES' WHERE LPREC_Id = 2
