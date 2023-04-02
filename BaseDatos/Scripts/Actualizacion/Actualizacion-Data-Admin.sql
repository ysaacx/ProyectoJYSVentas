USE BDSAdmin
GO
/* ======================================================================================================================================== */

UPDATE dbo.Aplicaciones SET APLI_BaseDatos = NULL WHERE APLI_Codigo = 'VTA'

/* ======================================================================================================================================== */
--SELECT * FROM ACAdmin..Empresas

INSERT INTO dbo.Empresas( EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea )
 SELECT EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea 
 FROM (  SELECT EMPR_Codigo = 'EBASE',  EMPR_Desc = 'Base',   EMPR_Direc = 'Base',          
                EMPR_RUC = 'Base',      EMPR_Servidor = '' ,  EMPR_BaseDatos = '',
                EMPR_BDFija = 0,        EMPR_Isolation = 1,   EMPR_UsrCrea = 'SISTEMAS',
                EMPR_FecCrea = GETDATE()
--UNION SELECT EMPR_Codigo = 'EBASE',  EMPR_Desc = 'Base',   EMPR_Direc = 'Base',          
--                EMPR_RUC = 'Base',      EMPR_Servidor = '' ,  EMPR_BaseDatos = '',
--                EMPR_BDFija = 0,        EMPR_Isolation = 1,   EMPR_UsrCrea = 'SISTEMAS',
--                EMPR_FecCrea = GETDATE()
      ) AS EMPRE
  WHERE NOT EMPRE.EMPR_Codigo IN (SELECT EMPR_Codigo FROM dbo.Empresas)


/* ======================================================================================================================================== */

--SELECT *  FROM ACAdmin..Aplicaciones
--USE BDSAdmin
/* ======================================================================================================================================== */

   INSERT INTO dbo.Aplicaciones(
          APLI_Codigo                  , APLI_Nombre                  , APLI_Desc                    , APLI_NomArc                  
        , APLI_DirTra                  , APLI_TipoLic                 , APLI_TipoEnv                 , APLI_NumLic                  
        , APLI_NumEmpr                 , APLI_BaseDatos               , APLI_Icono                   , APLI_Isolation               
        , APLI_UsrCrea                 , APLI_FecCrea                 , APLI_Activo                  , APLI_ConProceso              )
  SELECT  APLI_Codigo                  , APLI_Nombre                  , APLI_Desc                    , APLI_NomArc                  
        , APLI_DirTra                  , APLI_TipoLic                 , APLI_TipoEnv                 , APLI_NumLic                  
        , APLI_NumEmpr                 , APLI_BaseDatos               , APLI_Icono                   , APLI_Isolation               
        , APLI_UsrCrea                 , APLI_FecCrea                 , APLI_Activo                  , APLI_ConProceso              
FROM (SELECT  APLI_Codigo = 'MSG'                           , APLI_Nombre = 'Master General'            , APLI_Desc = 'Master General'                   
            , APLI_NomArc = 'ACPMasterGeneral.exe'          , APLI_DirTra = 'D:\Sistema\MasterGeneral'  , APLI_TipoLic = NULL
            , APLI_TipoEnv = NULL                           , APLI_NumLic = NULL                        , APLI_NumEmpr = NULL
            , APLI_BaseDatos = NULL                         , APLI_Icono = 5                            , APLI_Isolation = 0
            , APLI_UsrCrea  = 'SISTEMAS'                    , APLI_FecCrea = GETDATE()                  , APLI_Activo = 1
            , APLI_ConProceso = NULL
            ) AS APLI
    WHERE NOT APLI.APLI_Codigo IN (SELECT APLI_Codigo FROM Aplicaciones)

    --SELECT * FROM Aplicaciones
