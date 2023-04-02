--USE BDImportacionesZegarra
USE BDSisCARLO
GO

/*============================================================================================================================*/

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
-----------------------------------------------------------------------------------------------------------------------------
delete from VerStockPtoVenta 
delete from Ventas.VENT_PVentDocumento
delete from UsuariosPorPuntoVenta
delete from RRHH.PLAN_Pendientes
DELETE FROM RRHH.PLAN_CuentasBancarias
DELETE FROM RRHH.PLAN_Trabajador
-----------------------------------------------------------------------------------------------------------------------------
delete FROM Tesoreria.TESO_CCExcluidos
-----------------------------------------------------------------------------------------------------------------------------

--ALTER TABLE [dbo].[Clientes]
--ALTER COLUMN [SUCUR_Id] [CodSucursal] NULL

--UPDATE dbo.Clientes SET SUCUR_Id = NULL, LPREC_Id = NULL
-----------------------------------------------------------------------------------------------------------------------------
--DELETE from PuntoVenta 
--DELETE FROM UsuariosPorAlmacen
--DELETE FROM dbo.Almacenes
--DELETE FROM Correlativos
--DELETE FROM dbo.Parametros
--delete from dbo.Sucursales
-----------------------------------------------------------------------------------------------------------------------------
--DELETE FROM Ventas.VENT_ListaPreciosArticulos
--DELETE FROM dbo.Precios
--DELETE FROM dbo.Articulos
--DELETE FROM Ventas.VENT_ListaPrecios
-----------------------------------------------------------------------------------------------------------------------------

GO
/*============================================================================================================================*/
-------------------------------------
-- CREAR DATA BASE PARA EL SISTEMA --
-------------------------------------

sp_helptext HIST_ARTICSS_ObtenerHistorialPrecios
exec HIST_ARTICSS_ObtenerHistorialPrecios @ARTIC_Codigo=N'0401328',@ZONAS_Codigo=N'83.00',@Cantidad=25

BEGIN TRAN x
--ROLLBACK TRAN x

DECLARE @SUCUR_Id INT = 1
DECLARE @PVENT_Id INT = 1
DECLARE @ALMAC_Id INT = 1
DECLARE @PVENT_Descripcion VARCHAR(50) = 'Punto de venta Principal'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '192.168.1.10'
DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDSisCARLO'
--DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDImportacionesZegarra'
DECLARE @PVENT_BDAdmin VARCHAR(25) = 'BDSAdmin'
DECLARE @PVENT_Glosa VARCHAR(200) = 'AREQUIPA - PERU'

DECLARE @PVENT_ZonaContable VARCHAR(3) = 'Cusco'
DECLARE @UBIGO_Codigo VARCHAR(10) = '04.01.03'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'CARLO'
DECLARE @SUCUR_Nombre VARCHAR(50) = 'SUCURSAL PRINCIPAL'
DECLARE @ALMAC_Descripcion VARCHAR(50) = 'ALMACEN PRINCIPAL'
DECLARE @ALMAC_DescCorta VARCHAR(10) = 'PRINCIPAL'

DECLARE @SUCUR_Direccion VARCHAR(60) = 'VÍA DE EVITAMIENTO MZ A LOTE 7 APV SAN ANTONIO DISTRITO DE SAN SEBASTIÁN'
DECLARE @PVENT_Direccion VARCHAR(200) = @SUCUR_Direccion
DECLARE @ALMAC_Direccion VARCHAR(120) = @SUCUR_Direccion

DECLARE @Empresaruc VARCHAR(20) = '10047493078'
DECLARE @EmpresaNombre VARCHAR(100) = 'INDUSTRIAS DEL ACERO CARLOTTO'
--DECLARE @Empresaruc VARCHAR(20) = '20455452377'
--DECLARE @EmpresaNombre VARCHAR(100) = 'IMPORTACIONES ZEGARRA S.R.L.'
DECLARE @LPREC_Id_default INT = 2
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* SUCURSALES */
   UPDATE dbo.Sucursales
      SET SUCUR_Nombre = @SUCUR_Nombre, SUCUR_Direccion = SUCUR_Direccion, EMPRE_Codigo = @EMPRE_Codigo
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
COMMIT TRAN x
--ROLLBACK TRAN x


--SELECT * FROM Ventas.VENT_PVentDocumento WHERE TIPOS_CodTipoDocumento IN ('CPDRI', 'CPDRE', 'CPDCJ')
--SELECT * FROM UsuariosPorPuntoVenta
--SELECT * FROM Tesoreria.TESO_CCExcluidos 
--SELECT * FROM PuntoVenta
--SELECT * FROM Ventas.VENT_ListaPrecios
--SELECT * FROM Parametros