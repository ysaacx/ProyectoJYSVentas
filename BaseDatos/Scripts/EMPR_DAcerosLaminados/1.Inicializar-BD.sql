USE BDDACEROSLAM
GO

/*============================================================================================================================*/
-------------------------------------
-- CREAR DATA BASE PARA EL SISTEMA --
-------------------------------------

BEGIN TRAN x
--ROLLBACK TRAN x

DECLARE @ZONAS_Codigo CHAR(5) = '84.00'
DECLARE @SUCUR_Id INT = 1
DECLARE @PVENT_Id INT = 1
DECLARE @ALMAC_Id INT = 1
DECLARE @PVENT_Descripcion VARCHAR(50) = 'Punto de venta Principal'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '(LOCAL)\SQL12'
DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDDACEROSLAM'
DECLARE @PVENT_BDAdmin VARCHAR(25) = 'BDSAdmin'
DECLARE @PVENT_Glosa VARCHAR(200) = 'CUSCO - PERU'

DECLARE @PVENT_ZonaContable VARCHAR(3) = 'CUSCO'
DECLARE @UBIGO_Codigo VARCHAR(10) = '04.01.03'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'DALAM'
DECLARE @SUCUR_Nombre VARCHAR(50) = 'SUCURSAL PRINCIPAL'
DECLARE @ALMAC_Descripcion VARCHAR(50) = 'ALMACEN PRINCIPAL'
DECLARE @ALMAC_DescCorta VARCHAR(10) = 'PRINCIPAL'

DECLARE @SUCUR_Direccion VARCHAR(60) = 'AV. MANCO CCAPAC A-2 - SAN JERONIMO - CUSCO'
DECLARE @PVENT_Direccion VARCHAR(200) = 'AV. MANCO CCAPAC A-2 - SAN JERONIMO - CUSCO'
DECLARE @ALMAC_Direccion VARCHAR(120) = 'AV. MANCO CCAPAC A-2 - SAN JERONIMO - CUSCO'

DECLARE @Empresaruc VARCHAR(20) = '20601868823'
DECLARE @EmpresaNombre VARCHAR(100) = 'D´ACEROS LAMINADOS & SERVICIOS SAC'
DECLARE @LPREC_Id_default INT = 2
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

--SELECT * FROM dbo.Zonas

UPDATE Zonas SET ZONAS_Activo = 0 WHERE ZONAS_Activo = 1
DELETE FROM dbo.Zonas WHERE ZONAS_Codigo <> @ZONAS_Codigo
--DECLARE @ZONAS_Codigo CHAR(5) = '84.00'
UPDATE Zonas SET ZONAS_Activo = 1 WHERE ZONAS_Codigo = @ZONAS_Codigo

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* SUCURSALES */

   UPDATE dbo.Sucursales 
      SET ZONAS_Codigo = @ZONAS_Codigo
        , UBIGO_Codigo = @UBIGO_Codigo
        , EMPRE_Codigo = @EMPRE_Codigo
        , SUCUR_Nombre = @SUCUR_Nombre
        , SUCUR_Direccion = @SUCUR_Direccion
    WHERE SUCUR_Id = @SUCUR_Id
     
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* ALMACEN */
   UPDATE Almacenes
      SET ALMAC_Descripcion = @ALMAC_Descripcion
        , ALMAC_Direccion = @ALMAC_Direccion
        , ALMAC_DescCorta = @ALMAC_DescCorta
        , ZONAS_Codigo = @ZONAS_Codigo
    WHERE ALMAC_Id = @ALMAC_Id

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
/* PUNTO DE VENTA */

   UPDATE PuntoVenta
      SET ZONAS_Codigo = @ZONAS_Codigo
        , PVENT_DireccionIP = @PVENT_DireccionIP
        , PVENT_BaseDatos = @PVENT_BaseDatos
        , PVENT_BDAdmin = @PVENT_BDAdmin
        , PVENT_Glosa = @PVENT_Glosa
        , PVENT_Descripcion = @PVENT_Descripcion
        , PVENT_DireccionIPAC = @PVENT_DireccionIP
        , PVENT_Direccion = @PVENT_Direccion    
    WHERE PVENT_Id = @PVENT_Id
    
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--INSERT INTO dbo.VerStockPtoVenta( PVENT_Id ,ALMAC_Id ,VSPVA_Activo ,VSPVA_UsrCrea ,VSPVA_FecCrea ,VSPVA_ParaPedidos)
--VALUES  ( 1 , 1 , 0 , 'SISTEMAS' , GETDATE() , 1 )
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

   --INSERT INTO Ventas.VENT_PVentDocumento
   --     ( [PVDOCU_Id]                              , [ZONAS_Codigo]                               , [SUCUR_Id]                       , [PVENT_Id]                               
   --     , [ALMAC_Id]                               , [TIPOS_CodTipoDocumento]                     , [PVDOCU_Serie]                   , [PVDOCU_Autorizacion]                               
   --     , [PVDOCU_NroLineas]                       , [PVDOCU_Predeterminado]                      , [PVDOCU_PredetBoleta]            , [PVDOCU_PredetGuiaRemisTransportista]                               
   --     , [PVDOCU_PredetGuiaRemisRemitVentas]      , [PVDOCU_PredetGuiaRemisRemitTransportista]   , [PVDOCU_DispositivoImpresion]    , [PVDOCU_App]                               
   --     , [PVDOCU_UsrCrea]                         , [PVDOCU_FecCrea]
   --     , [PVDOCU_Top]                             , [PVDOCU_Left]                                , [PVDOCU_TipoImpresion]                                )
   --SELECT [PVDOCU_Id]                              , [ZONAS_Codigo]                               , [SUCUR_Id]                       , [PVENT_Id]                               
   --     , [ALMAC_Id]                               , [TIPOS_CodTipoDocumento]                     , [PVDOCU_Serie]                   , [PVDOCU_Autorizacion]                               
   --     , [PVDOCU_NroLineas]                       , [PVDOCU_Predeterminado]                      , [PVDOCU_PredetBoleta]            , [PVDOCU_PredetGuiaRemisTransportista]                               
   --     , [PVDOCU_PredetGuiaRemisRemitVentas]      , [PVDOCU_PredetGuiaRemisRemitTransportista]   , [PVDOCU_DispositivoImpresion]    , [PVDOCU_App]                               
   --     , [PVDOCU_UsrCrea]                         , [PVDOCU_FecCrea]
   --     , [PVDOCU_Top]                             , [PVDOCU_Left]                                , [PVDOCU_TipoImpresion]
   -- FROM ( SELECT [PVDOCU_Id] = 1              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
   --             , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDRI'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
   --             , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
   --             , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
   --             , [PVDOCU_PredetGuiaRemisTransportista] = 0 
   --             , [PVDOCU_DispositivoImpresion] = NULL
   --             , [PVDOCU_App] = 'VTA'
   --             , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
   --             , [PVDOCU_TipoImpresion] = 'C'      
   --   UNION SELECT [PVDOCU_Id] = 2              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
   --             , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDRE'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
   --             , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
   --             , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
   --             , [PVDOCU_PredetGuiaRemisTransportista] = 0 
   --             , [PVDOCU_DispositivoImpresion] = NULL
   --             , [PVDOCU_App] = 'VTA'
   --             , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
   --             , [PVDOCU_TipoImpresion] = 'C'      
   --   UNION SELECT [PVDOCU_Id] = 3              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
   --             , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPDCJ'    , [PVDOCU_Serie] = '001'                  , [PVDOCU_Autorizacion] = NULL
   --             , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
   --             , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
   --             , [PVDOCU_PredetGuiaRemisTransportista] = 0 
   --             , [PVDOCU_DispositivoImpresion] = NULL
   --             , [PVDOCU_App] = 'VTA'
   --             , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
   --             , [PVDOCU_TipoImpresion] = 'C'      
   -- ) DOCUS
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

   UPDATE dbo.Parametros SET PARMT_Valor = @Empresaruc WHERE PARMT_Id = 'Empresa'
   UPDATE dbo.Parametros SET PARMT_Valor = @EmpresaNombre WHERE PARMT_Id = 'EmpresaRS'

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

UPDATE dbo.Clientes SET SUCUR_Id = @SUCUR_Id, ZONAS_Codigo = @ZONAS_Codigo, LPREC_Id = @LPREC_Id_default

--ROLLBACK TRAN x
COMMIT TRAN x

