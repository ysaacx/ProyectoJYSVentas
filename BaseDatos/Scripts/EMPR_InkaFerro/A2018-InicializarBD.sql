
DELETE FROM Logistica.LOG_Stocks
DELETE FROM Logistica.ABAS_IngresoPorPiezasDetalle
DELETE FROM Logistica.ABAS_IngresoPorPiezas
DELETE FROM Ventas.VENT_PedidoPiezas
DELETE FROM Ventas.VENT_PedidosDetalle

GO
DISABLE TRIGGER Ventas.TRIGD_VENT_Pedidos ON Ventas.VENT_Pedidos
go

DELETE FROM Ventas.VENT_Pedidos
GO
ENABLE TRIGGER Ventas.TRIGD_VENT_Pedidos ON Ventas.VENT_Pedidos
go

DELETE FROM Logistica.DIST_GuiasRemisionVentas
DELETE FROM Ventas.VENT_DocsVentaDetalle
DELETE FROM Transportes.TRAN_ViajesVentas
DELETE FROM transportes.TRAN_OrdenesTransportes
DELETE FROM transportes.TRAN_CotizacionesDetalle
DELETE FROM transportes.TRAN_CotizacionesFletes

DELETE FROM transportes.TRAN_ViajesIngresos
DELETE FROM transportes.TRAN_Fletes
DELETE FROM transportes.TRAN_Cotizaciones


DELETE FROM Ventas.VENT_DocsVentaPagos
DELETE FROM Tesoreria.TESO_CajaDocsPago
DELETE FROM Tesoreria.TESO_Recibos
DELETE FROM Tesoreria.TESO_DocsPagos


go
DISABLE TRIGGER [TRIGD_TESO_Caja] ON [Tesoreria].[TESO_Caja]
GO
DELETE FROM Tesoreria.TESO_Caja

go
ENABLE TRIGGER [TRIGD_TESO_Caja] ON [Tesoreria].[TESO_Caja]
GO


DELETE FROM Ventas.VENT_DocsRelacion
DELETE FROM Contabilidad.CONT_DocsPercepcionDetalle
DELETE FROM Contabilidad.CONT_DocsPercepcion
DELETE FROM Ventas.VENT_DocsVenta --where DOCVE_Referencia In (Select DOCVE_Codigo From Ventas.VENT_DocsVenta)


DELETE FROM Logistica.ABAS_Costeos
DELETE FROM Logistica.ABAS_DocsCompraDetalle
DELETE FROM Logistica.ABAS_DocsCompra
DELETE FROM Logistica.ABAS_IngresosCompraDetalle
DELETE FROM Logistica.ABAS_IngresosCompra
DELETE FROM Logistica.ABAS_OrdenesCompraDetalle
DELETE FROM Logistica.ABAS_OrdenesCompra
DELETE FROM Logistica.ABAS_CotizacionesCompraDetalle
DELETE FROM Logistica.ABAS_CotizacionesCompra
Delete From Logistica.LOG_StockIniciales


DELETE FROM Logistica.DESP_GuiaRSalidas
DELETE FROM Logistica.DIST_GuiasRemisionDetalle
go
DISABLE TRIGGER Logistica.TRIGD_DIST_GuiasRemision ON Logistica.DIST_GuiasRemision
go
DELETE FROM Logistica.DIST_GuiasRemision
go
ENABLE TRIGGER Logistica.TRIGD_DIST_GuiasRemision ON Logistica.DIST_GuiasRemision
go


DELETE FROM Logistica.DIST_OrdenesDetalle
go
DISABLE TRIGGER [TRIGD_DIST_Ordenes] ON [Logistica].[DIST_Ordenes]
GO
DELETE FROM Logistica.DIST_Ordenes

go
ENABLE TRIGGER [TRIGD_DIST_Ordenes] ON [Logistica].[DIST_Ordenes]
GO

DELETE FROM Transportes.TRAN_Documentos
DELETE FROM Transportes.TRAN_DocumentosDetalle
DELETE FROM Data.VENT_DocsVentaDetalle
DELETE FROM Data.VENT_DocsVenta
DELETE FROM Logistica.CTRL_ArreglosDetalle
DELETE FROM Logistica.CTRL_Arreglos
DELETE FROM Logistica.DESP_Salidas
DELETE FROM Tesoreria.TESO_CajaChicaPagos
DELETE FROM Tesoreria.TESO_CajaChicaIngreso
DELETE FROM Tesoreria.TESO_DocumentosDetalle
DELETE FROM Tesoreria.TESO_Documentos
DELETE FROM Tesoreria.TESO_Sencillo

delete from Transportes.TRAN_VehiculosConductores
delete from Transportes.TRAN_VehiculosInventarioDetalle
delete from Transportes.TRAN_VehiculosInventario
delete from Transportes.TRAN_VehiculosMantenimiento
delete from Transportes.TRAN_Vehiculos
-----------------------------------------------------------------------------------------------------------------------------
DELETE FROM Historial.VENT_Pedidos
DELETE FROM Historial.TESO_Caja
DELETE FROM Historial.VENT_DocsVenta 
DELETE FROM Historial.DIST_GuiasRemision
DELETE FROM Historial.DIST_Ordenes
DELETE FROM Historial.ABAS_Costeos
DELETE FROM Historial.LOG_StockIniciales
DELETE FROM Historial.LOG_Stocks
DELETE FROM Historial.Pendientes
DELETE FROM Historial.Precios
DELETE FROM Historial.TRAN_Fletes
DELETE FROM Historial.TRAN_Viajes



USE BDInkasFerro_Almudena
go
ALTER TABLE [Logistica].[DIST_GuiasRemision]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL 
GO
ALTER TABLE historial.[DIST_GuiasRemision]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL 
GO



