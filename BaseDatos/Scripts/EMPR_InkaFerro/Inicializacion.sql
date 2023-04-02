USE BDInkasFerro
GO
/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
/* Acceso */

--SELECT * FROM BDSAdmin..Empresas
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = 'SERVERIF\SQL12' WHERE EMPR_Codigo = 'IFERR'
--SELECT * FROM BDSAdmin..Sucursales
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'SERVERIF\SQL12'

UPDATE dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'SERVERIF\SQL12', PVENT_DireccionIPAC = 'SERVERIF\SQL12' 
     , PVENT_BaseDatos = 'BDInkasFerro'
     , PVENT_BDAdmin = 'BDSAdmin'

UPDATE Parametros SET PARMT_Valor = '20490262181' WHERE PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = 'INVERSIONES INKASFERRO SRL' WHERE PARMT_Id = 'EmpresaRS'

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


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

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

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

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
--USE BDSVAlmacen
--SELECT *  FROM dbo.Periodos
--UPDATE dbo.Periodos SET PERIO_Activo = 0, PERIO_StockActivo = 0 WHERE PERIO_Codigo <> '2017'
INSERT INTO dbo.Periodos         ( PERIO_Codigo ,PERIO_Descripcion ,PERIO_StockActivo ,PERIO_Lock ,PERIO_UsrCrea ,PERIO_FecCrea ,PERIO_UsrMod ,PERIO_FecMod ,PERIO_Activo)
VALUES  ( '2017' ,'Periodo 2017' ,1 ,NULL ,'SISTEMAS' , GETDATE() , NULL , NULL , 1 )

--SELECT * FROM Logistica.LOG_StockIniciales where PERIO_Codigo = '2014' AND ALMAC_Id = 1
UPDATE Logistica.LOG_StockIniciales SET stini_cantidad = 0, ALMAC_Id = 1, PERIO_Codigo = '2017' WHERE ALMAC_Id = 1
Delete From Logistica.LOG_StockIniciales where PERIO_Codigo <> '2017' 

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

delete from VerStockPtoVenta where PVENT_Id <> 1 
delete from VerStockPtoVenta where PVENT_Id = 1 and ALMAC_Id <> 1
delete from Ventas.VENT_PVentDocumento where PVENT_Id <> 1
delete from UsuariosPorPuntoVenta where PVENT_Id <> 1
delete from RRHH.PLAN_Pendientes


UPDATE Tesoreria.TESO_SIniciales SET PVENT_Id = 1, ENTID_Codigo = '20600704495', SINIC_Importe = 0
UPDATE Tesoreria.TESO_CCExcluidos SET ENTID_Codigo = '20600704495', PVENT_Id = 1 WHERE entid_codigo = '20100241022'

delete FROM Tesoreria.TESO_CCExcluidos where PVENT_Id <> 1
delete from PuntoVenta where PVENT_Id <> 1

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

update Clientes set SUCUR_Id = 1 where SUCUR_Id<> 1
delete from UsuariosPorAlmacen where SUCUR_Id <> 1
--select * from UsuariosPorAlmacen where SUCUR_Id = 1
update UsuariosPorAlmacen set ALMAC_Id = 1 

delete from UsuariosPorPuntoVenta where SUCUR_Id <> 1
Update Ventas.VENT_PVentDocumento set SUCUR_Id = 1
/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


--Delete from EntidadesRoles where ENTID_Codigo = '29417594'
--Delete from Entidades where ENTID_Codigo = '29417594'


SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '20600704495'
--select * from VerStockPtoVenta 
SELECT * FROM Tesoreria.TESO_SIniciales
SELECT * FROM Tesoreria.TESO_CCExcluidos
select * from Clientes

--delete from Parametros where SUCUR_Id <> 1
select * from PuntoVenta
select * from Almacenes

SELECT * FROM Logistica.LOG_StockIniciales
SELECT * FROM Almacenes
delete from Almacenes where SUCUR_Id <> 1 AND ALMAC_ID <> 1
UPDATE ALMACENES SET SUCUR_ID = 1
update PuntoVenta set sucur_id = 1

delete FROM Parametros where not sucur_id in (0, 1)

delete from Correlativos where SUCUR_Id <> 1
delete from Sucursales where SUCUR_Id<> 1


SELECT * FROM ventas.VENT_ListaPreciosArticulos where ZONAS_Codigo <> '54.00'

delete from Ventas.VENT_ListaPreciosArticulos where ZONAS_Codigo <> '54.00'
delete from Ventas.VENT_ListaPrecios where ZONAS_Codigo <> '54.00'

delete from Precios where ZONAS_Codigo <> '54.00'

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/



--select * from Tesoreria.TESO_SIniciales

/* Optimizar la Base de Datos */

Use bdSisScc
dbcc sqlperf(logspace)
backup log BDADyA to disk = 'E:\Eliminar\BK.LOG' WITH NO_TRUNCATE
backup log BDADyA to disk = 'E:\Eliminar\BK.LOG'
use bdSisScc
DBCC SHRINKFILE ('BDAceCom_log',NOTRUNCATE)
DBCC SHRINKFILE ('BDAceCom_log',TRUNCATEONLY)
DBCC SHRINKDATABASE ('bdSisScc')
CHECKPOINT 
dbcc sqlperf(logspace)
backup log BDADyA to disk = 'D:\Eliminar\BK.LOG' WITH NO_TRUNCATE
backup log BDADyA to disk = 'D:\Eliminar\BK.LOG'  


ALTER DATABASE bdSisScc
SET RECOVERY SIMPLE;
GO
-- reducirmos el archivo log a 1 MB.
DBCC SHRINKFILE (BDAceCom_log, 1);
GO
-- devolvemos el nivel de recovery a full
ALTER DATABASE bdSisScc
SET RECOVERY FULL;
GO

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

Update almacenes set ALMAC_Descripcion = 'Almacen Principal'
update puntoventa set PVENT_Descripcion = 'Punto de Venta Principal'
update sucursales set SUCUR_Nombre = 'Sucursal Principal'


select * from UsuariosPorPuntoVenta

insert into UsuariosPorPuntoVenta(ZONAS_Codigo,SUCUR_Id,PVENT_Id,ENTID_Codigo,USPTA_UsrCrea,USPTA_FecCrea)
values('54.00',1, 1,'00000000', 'SISTEMAS', GETDATE() )


SELECT * FROM dbo.Parametros

UPDATE dbo.Parametros SET PARMT_Valor = '3.1.1.1' WHERE PARMT_Id = 'pg_Version'


SELECT * FROM Ventas.VENT_PVentDocumento WHERE TIPOS_CodTipoDocumento IN ('CPD03', 'CPD01', 'CPD09')
DELETE FROM Ventas.VENT_PVentDocumento WHERE TIPOS_CodTipoDocumento IN ('CPDNP')
DELETE FROM Ventas.VENT_PVentDocumento WHERE TIPOS_CodTipoDocumento IN ('CPD03', 'CPD01', 'CPD09')


/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
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



