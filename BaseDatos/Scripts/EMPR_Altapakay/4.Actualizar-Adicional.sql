USE BDInkaPeru
GO
/*===================================================================================================================================================================*/
DECLARE @SUCUR_Id INT = 1
DECLARE @PVENT_Id INT = 1
DECLARE @ALMAC_Id INT = 1
DECLARE @ZONAS_Codigo CHAR(5) = '84.00'
DECLARE @PVDOCU_Id INT = ISNULL((SELECT MAX(PVDOCU_Id) FROM Ventas.VENT_PVentDocumento), 0) + 1

/*===================================================================================================================================================================*/

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
    FROM ( SELECT [PVDOCU_Id] = @PVDOCU_Id + 1              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPD01'    , [PVDOCU_Serie] = '002'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
      UNION SELECT [PVDOCU_Id] = @PVDOCU_Id + 2              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPD03'    , [PVDOCU_Serie] = '002'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
      UNION SELECT [PVDOCU_Id] = @PVDOCU_Id + 3              , [ZONAS_Codigo] = @ZONAS_Codigo        , [SUCUR_Id] = @SUCUR_Id                  , [PVENT_Id] = @PVENT_Id
                , [ALMAC_Id] = @ALMAC_Id       , [TIPOS_CodTipoDocumento] = 'CPD09'    , [PVDOCU_Serie] = '002'                  , [PVDOCU_Autorizacion] = NULL
                , [PVDOCU_NroLineas] = 0       , [PVDOCU_Predeterminado]  = 1          , [PVDOCU_PredetBoleta] = 0               , [PVDOCU_PredetGuiaRemisRemitTransportista] = 0
                , [PVDOCU_PredetGuiaRemisRemitVentas] = NULL
                , [PVDOCU_PredetGuiaRemisTransportista] = 0 
                , [PVDOCU_DispositivoImpresion] = NULL
                , [PVDOCU_App] = 'VTA'
                , [PVDOCU_UsrCrea] = 'SISTEMAS', [PVDOCU_FecCrea] = GETDATE()          , [PVDOCU_Top] = 0                        , [PVDOCU_Left] = 0
                , [PVDOCU_TipoImpresion] = 'C'      
    ) DOCUS WHERE NOT DOCUS.TIPOS_CodTipoDocumento +'-' + DOCUS.PVDOCU_Serie IN (SELECT TIPOS_CodTipoDocumento + '-' + PVDOCU_Serie FROM Ventas.VENT_PVentDocumento)

/*===================================================================================================================================================================*/
SELECT * FROM dbo.Lineas
UPDATE Lineas SET LINEA_Nombre = 'Construcción' WHERE LINEA_Codigo IN ('08', '0801')

SELECT * FROM dbo.Lineas WHERE LEFT(LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11', '12', '14', '17', '19')
SELECT * FROM dbo.Lineas WHERE LINEA_Nombre LIKE '%otros%'
SELECT * FROM dbo.Lineas WHERE LINEA_Codigo IN ('13')
SELECT * FROM dbo.Lineas WHERE LINEA_Codigo LIKE '13%'



INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '1309'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Otros Productos',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1310'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Fibraforte',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1311'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Balletas y Accesorio',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1312'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Bisagras y Complemen',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1313'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PRE FABRICADOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1314'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Supertecho',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)


INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '07'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0701' ,LINEA_CodPadre = '07',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '08'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0801' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS AREQUIPA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0802' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'SIDERPERU',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0803' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '09'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CLAVOS Y ALAMBRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0901' ,LINEA_CodPadre = '09',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CLAVOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0902' ,LINEA_CodPadre = '09',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ALAMBRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '10'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TECNOPOR',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1001'   ,LINEA_CodPadre = '10',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TECNOPOR',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '11'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1101' ,LINEA_CodPadre = '11',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  --UNION SELECT LINEA_Codigo = '05'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  --UNION SELECT LINEA_Codigo = '0501' ,LINEA_CodPadre = '05',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '06'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0601' ,LINEA_CodPadre = '06',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 /*===================================================================================================================================================================*/
--SELECT * FROM tipos WHERE TIPOS_Codigo LIKE 'CPD%'
GO
/*===================================================================================================================================================================*/
USE BDSAdmin
GO
/*===================================================================================================================================================================*/

   INSERT INTO dbo.Usuarios
        ( NIVE_Codigo                  , GRUP_Codigo                  , USER_CodUsr                  
        , USER_Nombre                  , USER_DNI                     , USER_Desc                    , USER_PassUsr                 
        , USER_Activo                  , USER_Mail                    , USER_Prog                    , USER_UsrCrea                 
        , USER_FecCrea                 )
   SELECT NIVE_Codigo                  , GRUP_Codigo                  , USER_CodUsr                  
        , USER_Nombre                  , USER_DNI                     , USER_Desc                    , USER_PassUsr                 
        , USER_Activo                  , USER_Mail                    , USER_Prog                    , USER_UsrCrea                 
        , USER_FecCrea
    FROM (
           SELECT NIVE_Codigo = '002'          , GRUP_Codigo = NULL           , USER_CodUsr = 'KARINAA' -- ADMINISTRACION: KARINA ANO UMAN       DNI 43595460
                , USER_Nombre = 'KARINA'       , USER_DNI = '43595460'        , USER_Desc = 'ANO UMAN'       , USER_PassUsr = ''                
                , USER_Activo = 1              , USER_Mail = '.'              , USER_Prog = 0                , USER_UsrCrea = 'SISTEMAS'
                , USER_FecCrea = GETDATE()
     UNION SELECT NIVE_Codigo = '002'          , GRUP_Codigo = NULL           , USER_CodUsr = 'MIRIANP' -- MIRIAN GREACE PIZARRO LOAYZA DNI: 41615854
                , USER_Nombre = 'MIRIAN GREACE', USER_DNI = '41615854'        , USER_Desc = 'PIZARRO LOAYZA' , USER_PassUsr = ''                
                , USER_Activo = 1              , USER_Mail = '.'              , USER_Prog = 0                , USER_UsrCrea = 'SISTEMAS'
                , USER_FecCrea = GETDATE()
     UNION SELECT NIVE_Codigo = '002'          , GRUP_Codigo = NULL           , USER_CodUsr = 'EDISONM' -- EDISON MANRIQUE VILCA 41157333
                , USER_Nombre = 'EDISON'       , USER_DNI = '41157333'        , USER_Desc = 'MANRIQUE VILCA' , USER_PassUsr = ''                
                , USER_Activo = 1              , USER_Mail = '.'              , USER_Prog = 0                , USER_UsrCrea = 'SISTEMAS'
                , USER_FecCrea = GETDATE()
     UNION SELECT NIVE_Codigo = '002'          , GRUP_Codigo = NULL           , USER_CodUsr = 'SHIRLEY' -- SHIRLEY 
                , USER_Nombre = 'MIRIAN GREACE', USER_DNI = '________'        , USER_Desc = 'PIZARRO LOAYZA' , USER_PassUsr = ''                
                , USER_Activo = 1              , USER_Mail = '.'              , USER_Prog = 0                , USER_UsrCrea = 'SISTEMAS'
                , USER_FecCrea = GETDATE()
    ) USUA WHERE NOT USUA.USER_CodUsr IN (SELECT USER_CodUsr FROM dbo.Usuarios)

/*===================================================================================================================================================================*/

--SELECT * FROM dbo.Usuarios