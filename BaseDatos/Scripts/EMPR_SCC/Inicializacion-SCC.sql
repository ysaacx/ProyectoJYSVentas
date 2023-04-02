

--SELECT * FROM BDSAdmin..Empresas
--SELECT * FROM BDSisSCC..Sucursales
--SELECT * FROM BDSisSCC..PuntoVenta
--SELECT * FROM dbo.Almacenes
/*
UPDATE BDSisSCC.dbo.PuntoVenta SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12' 
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = '(Local)\SQL12' WHERE EMPR_Codigo = 'SCCYR'

USE BDSisSCC
go

*/
BEGIN TRAN x

SELECT * FROM Zonas
UPDATE dbo.Zonas SET ZONAS_Descripcion = 'Cusco' WHERE ZONAS_Codigo = '83.00'
UPDATE dbo.Zonas SET ZONAS_Activo = 0 WHERE ZONAS_Codigo = '84.00'

DELETE FROM dbo.UsuariosPorPuntoVenta WHERE ZONAS_Codigo = '84.00' AND SUCUR_Id = 1
DELETE FROM dbo.PuntoVenta WHERE ZONAS_Codigo = '84.00' AND SUCUR_Id = 1
DELETE FROM dbo.Almacenes WHERE ZONAS_Codigo= '84.00' AND SUCUR_Id = 1
DELETE FROM dbo.Sucursales WHERE ZONAS_Codigo = '84.00' AND SUCUR_Id = 1

UPDATE dbo.Sucursales SET SUCUR_Nombre = 'Sucursal Cantuta'
UPDATE dbo.Almacenes SET ALMAC_Descripcion = 'Almacen Cantuta', ALMAC_Direccion = 'URB LA CANTUTA A-9 VS KSNTU VERSALES - CUSCO / CUSCO / SAN JERONIMO'
UPDATE dbo.PuntoVenta SET PVENT_Descripcion = 'Punto de Venta Cantuta'

SELECT * FROM Sucursales
SELECT * FROM PuntoVenta
SELECT * FROM UsuariosPorPuntoVenta

ROLLBACK TRAN x
COMMIT TRAN x

UPDATE ventas.VENT_PVentDocumento SET PVENT_Id = 1, ALMAC_Id = NULL, ZONAS_Codigo = '83.00' WHERE PVENT_Id = 2

--PRINT '==================================================================='
--PRINT ' ELIMINAR '

--SELECT * INTO #TMP_PAG FROM Tesoreria.TESO_DocsPagos
--SELECT * INTO #TMP_STI FROM Logistica.LOG_StockIniciales
--SELECT * INTO #TMP_CDP FROM Tesoreria.TESO_CajaDocsPago
--SELECT * INTO #TMP_TCA FROM Tesoreria.TESO_Caja

--DELETE FROM Tesoreria.TESO_Caja
--DELETE FROM Tesoreria.TESO_CajaDocsPago
--DELETE FROM Tesoreria.TESO_DocsPagos
--DELETE FROM Logistica.LOG_StockIniciales


--SELECT * INTO #TMP_UP FROM UsuariosPorPuntoVenta
--DELETE FROM UsuariosPorPuntoVenta
--SELECT * INTO #TMP_PV FROM PuntoVenta
--DELETE FROM PuntoVenta
--SELECT * INTO #TMP_AL FROM dbo.Almacenes 
--DELETE FROM dbo.Almacenes



--PRINT '==================================================================='
--PRINT 'Actualizar Sucursal'

--UPDATE dbo.Sucursales SET SUCUR_Nombre = 'Sucursal Cantuta', ZONAS_Codigo = '84.00'

----UPDATE dbo.Almacenes SET ALMAC_Descripcion = 'Almacen Cantuta', ALMAC_Direccion = 'URB LA CANTUTA A-9 VS KSNTU VERSALES - CUSCO / CUSCO / SAN JERONIMO', ZONAS_Codigo = '84.00'
----UPDATE dbo.PuntoVenta SET PVENT_Descripcion = 'Punto de Venta Cantuta', ZONAS_Codigo = '84.00'
--PRINT '==================================================================='
--PRINT 'Ingresar Almacen'
--INSERT INTO dbo.Almacenes ( ALMAC_Id ,ZONAS_Codigo ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea ,
--          ALMAC_UsrMod ,ALMAC_FecMod ,ALMAC_Activo ,ALMAC_DescCorta)
--SELECT ALMAC_Id 
--      ,ZONAS_Codigo = '84.00'
--      ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea ,
--      ALMAC_UsrMod ,ALMAC_FecMod ,ALMAC_Activo ,ALMAC_DescCorta
--  FROM #TMP_AL

--PRINT '==================================================================='
--PRINT 'Ingresar Punto de Venta'
--INSERT INTO dbo.PuntoVenta( PVENT_Id ,ZONAS_Codigo ,SUCUR_Id ,ALMAC_Id ,PVENT_Descripcion ,PVENT_Principal ,PVENT_DireccionIP ,PVENT_BaseDatos ,
--          PVENT_DireccionIPAC ,PVENT_BaseDatosAC ,PVENT_Activo ,PVENT_BDAdmin ,PVENT_User ,PVENT_Password ,PVENT_DireccionIPDesc ,PVENT_Glosa ,
--          PVENT_Impresion ,PVENT_Direccion ,PVENT_ZonaContable ,PVENT_ActivoDespachos)
--SELECT PVENT_Id ,ZONAS_Codigo = '84.00' ,SUCUR_Id ,ALMAC_Id 
--      ,PVENT_Descripcion ,PVENT_Principal ,PVENT_DireccionIP ,PVENT_BaseDatos ,
--          PVENT_DireccionIPAC ,PVENT_BaseDatosAC ,PVENT_Activo ,PVENT_BDAdmin ,PVENT_User ,PVENT_Password ,PVENT_DireccionIPDesc ,PVENT_Glosa ,
--          PVENT_Impresion ,PVENT_Direccion ,PVENT_ZonaContable ,PVENT_ActivoDespachos
--FROM #TMP_PV


--PRINT 'Ingresar Usuario por Punto de Venta'

--INSERT INTO dbo.UsuariosPorPuntoVenta
--SELECT ZONAS_Codigo = '84.00',SUCUR_Id ,PVENT_Id ,ENTID_Codigo ,USPTA_UsrCrea ,USPTA_FecCrea ,
--          USPTA_UsrMod = NULL ,USPTA_FecMod = NULL  
-- FROM #TMP_UP
--PRINT '==================================================================='
SELECT * FROM Sucursales
SELECT * FROM PuntoVenta
SELECT * FROM UsuariosPorPuntoVenta

ROLLBACK TRAN x
--COMMIT TRAN x

--SELECT * FROM Tesoreria.TESO_DocsPagos
--SELECT * FROM Logistica.LOG_StockIniciales

--SELECT * FROM Ventas.VENT_Pedidos