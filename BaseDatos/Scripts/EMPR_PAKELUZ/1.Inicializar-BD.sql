--USE BDImportacionesZegarra
USE BDPakeluz
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

ALTER TABLE [dbo].[Clientes]
ALTER COLUMN [SUCUR_Id] [CodSucursal] NULL

UPDATE dbo.Clientes SET SUCUR_Id = NULL, LPREC_Id = NULL
-----------------------------------------------------------------------------------------------------------------------------
DELETE from PuntoVenta 
DELETE FROM UsuariosPorAlmacen
DELETE FROM dbo.Almacenes
DELETE FROM Correlativos
DELETE FROM dbo.Parametros
delete from dbo.Sucursales
-----------------------------------------------------------------------------------------------------------------------------
--DELETE FROM Ventas.VENT_ListaPreciosArticulos
--DELETE FROM dbo.Precios
--DELETE FROM dbo.Articulos
--DELETE FROM Ventas.VENT_ListaPrecios
-----------------------------------------------------------------------------------------------------------------------------

GO

--select * from Entidades where ENTID_Codigo = '00000000000'
UPDATE dbo.Clientes SET ENTID_CodigoVendedor = '00000000000' WHERE ENTID_CodigoVendedor <> '00000000000'


/*============================================================================================================================*/
-------------------------------------
-- CREAR DATA BASE PARA EL SISTEMA --
-------------------------------------
--SELECT * FROM BDSisSCC..zonas
--SELECT * FROM BDDACEROSLAM..zonas

BEGIN TRAN x
--ROLLBACK TRAN x

DECLARE @ZONAS_Codigo CHAR(5) = '83.00'
DECLARE @SUCUR_Id INT = 1
DECLARE @PVENT_Id INT = 1
DECLARE @ALMAC_Id INT = 1
DECLARE @PVENT_Descripcion VARCHAR(50) = 'Punto de venta Principal'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '192.168.1.5'
DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDPAKELUZ'
--DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDImportacionesZegarra'
DECLARE @PVENT_BDAdmin VARCHAR(25) = 'BDSAdmin'
DECLARE @PVENT_Glosa VARCHAR(200) = 'CUSCO - PERU'

DECLARE @PVENT_ZonaContable VARCHAR(3) = 'CUS'
DECLARE @UBIGO_Codigo VARCHAR(10) = '08.01.08'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'PAKEL'
--DECLARE @EMPRE_Codigo VARCHAR(5) = 'INZEG'
DECLARE @SUCUR_Nombre VARCHAR(50) = 'SUCURSAL PRINCIPAL'
DECLARE @ALMAC_Descripcion VARCHAR(50) = 'ALMACEN PRINCIPAL'
DECLARE @ALMAC_DescCorta VARCHAR(10) = 'PRINCIPAL'

DECLARE @SUCUR_Direccion VARCHAR(60) = 'VIA EXPRESA E5 PARQUE INDUSTRIAL WANCHAQ CUSCO'
DECLARE @PVENT_Direccion VARCHAR(200) = @SUCUR_Direccion
DECLARE @ALMAC_Direccion VARCHAR(120) = @SUCUR_Direccion

DECLARE @Empresaruc VARCHAR(20) = '20491202069'
DECLARE @EmpresaNombre VARCHAR(100) = 'INVERSIONES PAKELUZ S.R.L.'
--DECLARE @Empresaruc VARCHAR(20) = '20455452377'
--DECLARE @EmpresaNombre VARCHAR(100) = 'IMPORTACIONES ZEGARRA S.R.L.'
DECLARE @LPREC_Id_default INT = 2
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

--SELECT * FROM dbo.Zonas

UPDATE Zonas SET ZONAS_Activo = 0 WHERE ZONAS_Activo = 1
UPDATE Zonas SET ZONAS_Activo = 1 WHERE ZONAS_Codigo = @ZONAS_Codigo

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* SUCURSALES */

    INSERT INTO dbo.Sucursales( ZONAS_Codigo ,SUCUR_Id ,UBIGO_Codigo ,EMPRE_Codigo ,SUCUR_Nombre ,SUCUR_Direccion ,SUCUR_UsrCrea ,SUCUR_FecCrea )
    SELECT ZONAS_Codigo ,SUCUR_Id ,UBIGO_Codigo ,EMPRE_Codigo ,SUCUR_Nombre ,SUCUR_Direccion ,SUCUR_UsrCrea ,SUCUR_FecCrea 
      FROM (SELECT ZONAS_Codigo = @ZONAS_Codigo     , SUCUR_Id = @SUCUR_Id                  , UBIGO_Codigo = @UBIGO_Codigo    , EMPRE_Codigo = @EMPRE_Codigo
                 , SUCUR_Nombre = @SUCUR_Nombre     , SUCUR_Direccion = @SUCUR_Direccion    , SUCUR_UsrCrea = 'SISTEMAS'      , SUCUR_FecCrea = GETDATE()
    --  UNION SELECT ZONAS_Codigo = '83.00' ,SUCUR_Id = '2',UBIGO_Codigo = '03.01.01',EMPRE_Codigo = 'IFERR',SUCUR_Nombre = 'Sucursal Almudena'
				--, SUCUR_Direccion = 'ALMUDENA S/N - CUSCO / CUSCO / SAN JERONIMO',SUCUR_UsrCrea = 'SISTEMAS',SUCUR_FecCrea = GETDATE()
	 ) SUCR
 WHERE NOT SUCR.ZONAS_Codigo + '-' + RTRIM(SUCR.SUCUR_Id) IN (SELECT ISNULL(ZONAS_Codigo + '-' + RTRIM(SUCUR_Id), '') FROM	SUCURSALES)
     
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* ALMACEN */
    INSERT INTO dbo.Almacenes
	     ( ALMAC_Id ,ZONAS_Codigo ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea,ALMAC_Activo ,ALMAC_DescCorta)
    SELECT ALMAC_Id ,ZONAS_Codigo ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea,ALMAC_Activo ,ALMAC_DescCorta
           FROM (SELECT ALMAC_Id = @ALMAC_Id                     , ZONAS_Codigo = @ZONAS_Codigo          , SUCUR_Id = @SUCUR_Id          , TIPOS_CodTipoAlmacen = 'ALM01' 
                      , ALMAC_Descripcion = @ALMAC_Descripcion   , ALMAC_Direccion = @ALMAC_Direccion    , ALMAC_UsrCrea = 'SISTEMAS'    , ALMAC_FecCrea = GETDATE()
                      , ALMAC_Activo = 1                         , ALMAC_DescCorta = @ALMAC_DescCorta
          --UNION SELECT ALMAC_Id = 2,ZONAS_Codigo = '83.00' ,SUCUR_Id = 2 ,TIPOS_CodTipoAlmacen = 'ALM01',ALMAC_Descripcion = 'Almacen Almudena' ,
		        --	   ALMAC_Direccion = 'ALMUDENA S/N - CUSCO / CUSCO / SAN JERONIMO',ALMAC_UsrCrea = 'SISTEMAS' ,ALMAC_FecCrea = GETDATE(),ALMAC_Activo = 1,ALMAC_DescCorta = 'ALMUDENA'
      ) ALMA
  WHERE NOT ALMA.ALMAC_Id IN (SELECT ALMAC_Id FROM dbo.Almacenes)

-- SELECT * FROM Almacenes
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* PUNTO DE VENTA */
   INSERT INTO dbo.PuntoVenta
        ( [PVENT_Id]                   , [ZONAS_Codigo]               , [SUCUR_Id]                   , [ALMAC_Id]                   
        , [PVENT_Descripcion]          , [PVENT_Principal]            , [PVENT_DireccionIP]          , [PVENT_BaseDatos]            
        , [PVENT_DireccionIPAC]        , [PVENT_BaseDatosAC]          , [PVENT_Activo]               , [PVENT_BDAdmin]              
        , [PVENT_User]                 , [PVENT_Password]             , [PVENT_DireccionIPDesc]      , [PVENT_Glosa]                
        , [PVENT_Impresion]            , [PVENT_Direccion]            , [PVENT_ZonaContable]         , [PVENT_ActivoDespachos])
   SELECT [PVENT_Id]                   , [ZONAS_Codigo]               , [SUCUR_Id]                   , [ALMAC_Id]                   
        , [PVENT_Descripcion]          , [PVENT_Principal]            , [PVENT_DireccionIP]          , [PVENT_BaseDatos]            
        , [PVENT_DireccionIPAC]        , [PVENT_BaseDatosAC]          , [PVENT_Activo]               , [PVENT_BDAdmin]              
        , [PVENT_User]                 , [PVENT_Password]             , [PVENT_DireccionIPDesc]      , [PVENT_Glosa]                
        , [PVENT_Impresion]            , [PVENT_Direccion]            , [PVENT_ZonaContable]         , [PVENT_ActivoDespachos]
    FROM (SELECT PVENT_Id = @PVENT_Id                       , ZONAS_Codigo = @ZONAS_Codigo          , SUCUR_Id = @SUCUR_Id                      , ALMAC_Id = @ALMAC_Id 
               , PVENT_Descripcion = @PVENT_Descripcion     , PVENT_Principal = 1                   , PVENT_DireccionIP = @PVENT_DireccionIP    , PVENT_BaseDatos = @PVENT_BaseDatos
               , PVENT_DireccionIPAC = @PVENT_DireccionIP   , PVENT_BaseDatosAC = @PVENT_BaseDatos  , PVENT_Activo = 1                          , PVENT_BDAdmin = @PVENT_BDAdmin
               , PVENT_User = NULL                          , PVENT_Password = NULL                 , PVENT_DireccionIPDesc = NULL              , PVENT_Glosa = @PVENT_Glosa
               , PVENT_Impresion = 1                        , PVENT_Direccion = @PVENT_Direccion    , PVENT_ZonaContable = @PVENT_ZonaContable  , PVENT_ActivoDespachos = 1
  --UNION SELECT PVENT_Id = 2 ,ZONAS_Codigo = '83.00' ,SUCUR_Id = 2 ,ALMAC_Id = 2 ,PVENT_Descripcion = 'Punto de Parusttacca' ,PVENT_Principal = 0 ,PVENT_DireccionIP = 'SERVERIF\SQL12' ,
		--	   PVENT_BaseDatos = 'BDInkasFerro' ,PVENT_DireccionIPAC = '(Local)\SQL12' ,PVENT_BaseDatosAC = 'BDInkasFerro',PVENT_Activo = 1,PVENT_BDAdmin = 'BDSAdmin' ,
		--	   PVENT_User = NULL , PVENT_Password = NULL,PVENT_DireccionIPDesc = NULL , PVENT_Glosa = 'CUSCO - PERU' ,PVENT_Impresion = 1 ,
		--	   PVENT_Direccion = 'URB LA CANTUTA A-9 CALLE KANTU VERSALLES - CUSCO / CUSCO / SAN JERONIMO' ,PVENT_ZonaContable = 'DOl' ,PVENT_ActivoDespachos = 1
	  ) PVENTA
	WHERE NOT PVENTA.PVENT_Id IN (SELECT PVENT_Id FROM dbo.PuntoVenta)
    
    
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
INSERT INTO dbo.VerStockPtoVenta( PVENT_Id ,ALMAC_Id ,VSPVA_Activo ,VSPVA_UsrCrea ,VSPVA_FecCrea ,VSPVA_ParaPedidos)
VALUES  ( 1 , 1 , 0 , 'SISTEMAS' , GETDATE() , 1 )
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
   INSERT INTO Ventas.VENT_PVentDocumento
        ( [PVDOCU_Id]                              , [ZONAS_Codigo]                               , [SUCUR_Id]                       , [PVENT_Id]                               
        , [ALMAC_Id]                               , [TIPOS_CodTipoDocumento]                     , [PVDOCU_Serie]                   , [PVDOCU_Autorizacion]                               
        , [PVDOCU_NroLineas]                       , [PVDOCU_Predeterminado]                      , [PVDOCU_PredetBoleta]            , [PVDOCU_PredetGuiaRemisTransportista]                               
        , [PVDOCU_PredetGuiaRemisRemitVentas]      , [PVDOCU_PredetGuiaRemisRemitTransportista]   , [PVDOCU_DispositivoImpresion]    , [PVDOCU_App]                               
        , [PVDOCU_UsrCrea]                         , [PVDOCU_FecCrea]
        , [PVDOCU_Top]                             , [PVDOCU_Left]                                , [PVDOCU_TipoImpresion]                                )
   SELECT [PVDOCU_Id]                              , [ZONAS_Codigo]                               , [SUCUR_Id]                       , [PVENT_Id]                               
        , [ALMAC_Id]                               , [TIPOS_CodTipoDocumento]                     , [PVDOCU_Serie]                   , [PVDOCU_Autorizacion]                               
        , [PVDOCU_NroLineas]                       , [PVDOCU_Predeterminado]                      , [PVDOCU_PredetBoleta]            , [PVDOCU_PredetGuiaRemisTransportista]                               
        , [PVDOCU_PredetGuiaRemisRemitVentas]      , [PVDOCU_PredetGuiaRemisRemitTransportista]   , [PVDOCU_DispositivoImpresion]    , [PVDOCU_App]                               
        , [PVDOCU_UsrCrea]                         , [PVDOCU_FecCrea]
        , [PVDOCU_Top]                             , [PVDOCU_Left]                                , [PVDOCU_TipoImpresion]
    FROM ( SELECT [PVDOCU_Id] = 1              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDRI'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
      UNION SELECT [PVDOCU_Id] = 2              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDRE'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
      UNION SELECT [PVDOCU_Id] = 3              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDCJ'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
    ) DOCUS
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
INSERT INTO dbo.UsuariosPorPuntoVenta(ZONAS_Codigo ,SUCUR_Id ,PVENT_Id ,ENTID_Codigo ,USPTA_UsrCrea ,USPTA_FecCrea)
VALUES  ( @ZONAS_Codigo ,@SUCUR_Id , @PVENT_Id , '00000000' , 'SISTEMAS' ,GETDATE())

--SELECT * FROM UsuariosPorAlmacen
INSERT INTO dbo.UsuariosPorAlmacen( ZONAS_Codigo ,SUCUR_Id ,ALMAC_Id ,ENTID_Codigo ,USALM_UsrCrea ,USALM_FecCrea)
VALUES  ( @ZONAS_Codigo ,@SUCUR_Id , @ALMAC_Id , '00000000' , 'SISTEMAS' , GETDATE() )

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

INSERT INTO dbo.Parametros
        ( PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General)
   SELECT PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General
    FROM (SELECT PARMT_Id = 'Empresa', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = @Empresaruc , PARMT_Descripcion = 'Codigo de la Empresa', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'EmpresaRS', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = @EmpresaNombre , PARMT_Descripcion = 'Nombre Comercial', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'ListaPrecioDefa', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '2' , PARMT_Descripcion = 'Lista de Precios por Defecto', PARMT_TipoDato = 'Long', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_BloqueoMND', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Bloquear el campo moneda', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_BusqAutoma', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Busqueda en automatico para entidades/clientes', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_BusqEntAll', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Busqueda de Todas las Entidades', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CamFechFactu', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Permitir cambiar la fecha en la facturacion', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CargaMax', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '42500' , PARMT_Descripcion = 'Carga Maxima para las Guias de Remision', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CargaMax', APLIC_Codigo = 'vta', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '430000' , PARMT_Descripcion = 'Carga Maxima para las Guias de Remision', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ChangeColor', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Cambiar el Color por la Configuracion definida ', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorBack', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '211,211,211' , PARMT_Descripcion = 'Color de Fondo', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorDegred', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '186,176,177' , PARMT_Descripcion = 'Color Degrade', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorTitle', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '57,51,51' , PARMT_Descripcion = 'Color de Titulo', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CondXVehi', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Conductores por Vehiculo', PARMT_TipoDato = 'Integer', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CondXVehi', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Conductores por Vehiculo', PARMT_TipoDato = 'Integer', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_CotizNuevo', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Cargar la cotizacion para Ingresar un registro', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_DesCarPrec', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Desactiva mostrar los precios al entrar ', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_FacDetCtaCte', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'Cta. Cte. Bco de la Nación 101-091929' , PARMT_Descripcion = 'Cuenta de Banco', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_Facturar', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '0' , PARMT_Descripcion = 'Definir la operacion de Facturar Pedido', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_FecIniFletes', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '02-03-2012' , PARMT_Descripcion = 'Fecha de Inicio de Fletes por Facturar', PARMT_TipoDato = 'DateTime', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_FFechaHora', APLIC_Codigo = 'LOG', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyyy hh:mm tt' , PARMT_Descripcion = 'Formato de Fecha Hora', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FFechaHora', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyyy hh:mm tt' , PARMT_Descripcion = 'Formato de Fecha Hora', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FFechaHora', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyyy hh:mm tt' , PARMT_Descripcion = 'Formato de Fecha Hora', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FMondo2d', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '#,###,##0.00' , PARMT_Descripcion = 'Formato de Moneda 2 decimales', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FMondo3d', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '#,###,##0.000' , PARMT_Descripcion = 'Formato de Moneda 3 Decimales', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FMondo4d', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '#,###,##0.0000' , PARMT_Descripcion = 'Formato de Moneda 4 Decimales', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FormatoFecha', APLIC_Codigo = 'LOG', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyy' , PARMT_Descripcion = 'Formato Fecha', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FormatoFecha', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyy' , PARMT_Descripcion = 'Formato Fecha', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FormatoFecha', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'dd/MM/yyy' , PARMT_Descripcion = 'Formato Fecha', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_ImpDefault', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '\\Scc-hp\epson lx-350 facturas' , PARMT_Descripcion = 'Impresora por Defecto', PARMT_TipoDato = 'String', PARMT_General = 0
    UNION SELECT PARMT_Id = 'pg_ImpOrden', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '\\Scc-hp\epson lx-350 facturas' , PARMT_Descripcion = 'Impresora para Ordenes de Recojo', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_LimitDoc', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '700' , PARMT_Descripcion = 'Precio minimo permitido para datos del comprador', PARMT_TipoDato = 'System.Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_LimitRedonde', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Limite de importe para ser redondeado', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_LongTexAyuda', APLIC_Codigo = 'DIS', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '3' , PARMT_Descripcion = 'Longitud para activar la ayuda de las busquedas', PARMT_TipoDato = 'Integer', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_LongTexAyuda', APLIC_Codigo = 'LOG', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '3' , PARMT_Descripcion = 'Longitud para activar la ayuda de las busquedas', PARMT_TipoDato = 'Integer', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_LongTexAyuda', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Longitud para activar la ayuda de las busquedas', PARMT_TipoDato = 'Integer', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_LongTexAyuda', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '2' , PARMT_Descripcion = 'Longitud para activar la ayuda de las busquedas', PARMT_TipoDato = 'Integer', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_NeumaMoneda', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'MND002' , PARMT_Descripcion = 'Moneda para el precio de los neumaticos', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_NeumaMoneda', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'MND002' , PARMT_Descripcion = 'Moneda para el precio de los neumaticos', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_NotCredCuot', APLIC_Codigo = 'LOG', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'CPD07' , PARMT_Descripcion = 'Codigo de la nota de credito para el control de cu', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ocultarGrafi', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Ocultar los graficos de Neumaticos', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ocultarGrafi', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Ocultar los graficos de Neumaticos', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_PercBolCant1', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Sin percepción para boletas con 1 solo item y 1 pr', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_PercNormal', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '2' , PARMT_Descripcion = 'Percepción Normal de Un Cliente', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_PerStockNega', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = NULL, PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_PreLimBoleta', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1500' , PARMT_Descripcion = 'LIMITE', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_PreLimBoleta', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1500' , PARMT_Descripcion = 'Precio minimo permitido sin percepcion en boletas', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_RUCCombustib', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '20330033313' , PARMT_Descripcion = 'R.U.C. Empresa de Consumo de Combustible Local', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_SetMoneda', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'MND1' , PARMT_Descripcion = 'Moneda por Defecto', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_TDODefault', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'CPD01' , PARMT_Descripcion = 'Tipo de documento de facturacion por defa ', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_TipoRepCot', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = 'A' , PARMT_Descripcion = 'Tipo de Reporte de Cotizacion de Venta', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_TPendiente', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '3' , PARMT_Descripcion = 'Tiempo en que se mostraran la pendientes', PARMT_TipoDato = 'System.Integer', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_USeriePrin', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Parametro indica si se usara en la impresion', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_USeriePrint', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '1' , PARMT_Descripcion = 'Parametro indica si se usara en la impresion', PARMT_TipoDato = 'Boolean', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_VendedorDefa', APLIC_Codigo = 'TRA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '00000000000' , PARMT_Descripcion = 'Porcentaje I.G.V.', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_VendedorDefa', APLIC_Codigo = 'VTA', ZONAS_Codigo = @ZONAS_Codigo, SUCUR_Id = @SUCUR_Id, PARMT_Valor = '00000000000' , PARMT_Descripcion = 'Vendedor por Defecto', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_Version', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '3.3.1.5' , PARMT_Descripcion = 'Version de la Aplicacion', PARMT_TipoDato = 'String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_VersionLOG', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '0.2.1.0' , PARMT_Descripcion = 'Version del Sistema de Logistica', PARMT_TipoDato = 'System.String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_VersionSAG', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '0.1.0.2' , PARMT_Descripcion = 'Version del Sistema de Administracion General', PARMT_TipoDato = 'System.String', PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_VersionTRA', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '3.0.0.1' , PARMT_Descripcion = 'Version del Sistema de Transportes', PARMT_TipoDato = 'String', PARMT_General = NULL
    UNION SELECT PARMT_Id = 'PIGV', APLIC_Codigo = '   ', ZONAS_Codigo = NULL, SUCUR_Id = 0, PARMT_Valor = '18' , PARMT_Descripcion = 'Porcentaje I.G.V.', PARMT_TipoDato = 'Decimal', PARMT_General = NULL
    ) AS PARA
WHERE NOT PARA.PARMT_Id + '-' + PARA.APLIC_Codigo + '-' + RTRIM(PARA.SUCUR_Id) IN (SELECT PARMT_Id + '-' + APLIC_Codigo + '-' + RTRIM(SUCUR_Id) FROM Parametros)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

--SELECT * FROM dbo.Precios
--UPDATE Ventas.VENT_ListaPrecios SET ZONAS_Codigo = @ZONAS_Codigo

--SELECT * FROM Ventas.VENT_ListaPrecios
--SELECT * FROM dbo.Precios
 --  INSERT INTO Ventas.VENT_ListaPrecios
 --       ( ZONAS_Codigo                 , LPREC_Id                     , LPREC_Codigo                 , LPREC_Descripcion            
 --       , LPREC_Comision               , LPREC_UsrCrea                , LPREC_FecCrea )
 --  SELECT ZONAS_Codigo                 , LPREC_Id                     , LPREC_Codigo                 , LPREC_Descripcion            
 --       , LPREC_Comision               , LPREC_UsrCrea                , LPREC_FecCrea 
 --FROM (SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 0, LPREC_Codigo = 'L0' , LPREC_Descripcion = 'LISTA 0' , LPREC_Comision = 0.003000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --UNION SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 1, LPREC_Codigo = 'L1' , LPREC_Descripcion = 'LISTA 1' , LPREC_Comision = 0.003000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --UNION SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 2, LPREC_Codigo = 'L2' , LPREC_Descripcion = 'LISTA 2' , LPREC_Comision = 0.005000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --UNION SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 3, LPREC_Codigo = 'L3' , LPREC_Descripcion = 'LISTA 3' , LPREC_Comision = 0.008000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --UNION SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 4, LPREC_Codigo = 'L4' , LPREC_Descripcion = 'LISTA 4' , LPREC_Comision = 0.011000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --UNION SELECT ZONAS_Codigo = @ZONAS_Codigo , LPREC_Id = 5, LPREC_Codigo = 'L5' , LPREC_Descripcion = 'LISTA 5' , LPREC_Comision = 0.014000 , LPREC_UsrCrea = 'SISTEMAS', LPREC_FecCrea = GETDATE()
 --) LPREC
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

UPDATE dbo.Clientes SET SUCUR_Id = @SUCUR_Id, ZONAS_Codigo = @ZONAS_Codigo, LPREC_Id = @LPREC_Id_default
     --SELECT * FROM Clientes


COMMIT TRAN x
--ROLLBACK TRAN x

/*
(61 row(s) affected)
Msg 547, Level 16, State 0, Line 240
The UPDATE statement conflicted with the FOREIGN KEY constraint "FK_Clientes_ListaPrecios". The conflict occurred in database "BDPAKELUZ", table "Ventas.VENT_ListaPrecios".
The statement has been terminated.
*/


--SELECT * FROM Ventas.VENT_PVentDocumento WHERE TIPOS_CodTipoDocumento IN ('CPDRI', 'CPDRE', 'CPDCJ')
--SELECT * FROM UsuariosPorPuntoVenta
--SELECT * FROM Tesoreria.TESO_CCExcluidos 
--SELECT * FROM PuntoVenta
--SELECT * FROM Ventas.VENT_ListaPrecios
--SELECT * FROM Parametros