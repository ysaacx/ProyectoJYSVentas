USE BDSAdmin
go

--SELECT * FROM Empresas
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

DECLARE @EMPR_Codigo VARCHAR(5) = 'NOVAC'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '(LOCAL)\SQL12'
--UPDATE dbo.Sucursales SET SUCUR_DireccionIP = @PVENT_DireccionIP
--UPDATE dbo.Aplicaciones SET APLI_BaseDatos = NULL WHERE APLI_BaseDatos IS NOT NULL  

 INSERT INTO dbo.Empresas( 
        EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea ,       EMPR_Activo)
 SELECT EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea ,       EMPR_Activo
 FROM (  SELECT EMPR_Codigo = @EMPR_Codigo   
              , EMPR_Desc = 'NOVACERO.'         
              , EMPR_Direc = 'Cal. Wichaypampa Lt. Z1 - Mza 7 - Vía Principal'
              , EMPR_RUC = '20563926719', EMPR_Servidor = @PVENT_DireccionIP          , EMPR_BaseDatos = 'BDNOVACERO'
              , EMPR_BDFija = 0         , EMPR_Isolation = 0                          , EMPR_UsrCrea = 'SISTEMAS'
              , EMPR_FecCrea = GETDATE(), EMPR_Activo = 1
      ) AS EMPRE
  WHERE NOT EMPRE.EMPR_Codigo IN (SELECT EMPR_Codigo FROM dbo.Empresas)

  --UPDATE Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo = 'DJMMS'
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--SELECT * FROM dbo.Empresas
--SELECT * FROM dbo.Sucursales
--SELECT * FROM dbo.Usuarios

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo = @EMPR_Codigo

IF NOT EXISTS(SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo = @EMPR_Codigo AND USER_IdUser = 104)
    BEGIN
        INSERT INTO dbo.UsuariosEmpresas( EMPR_Codigo ,USER_IdUser ,USER_CodUsr ,UEMP_Fecha ,UEMP_UsrCrea ,UEMP_FecCrea)
        VALUES  ( @EMPR_Codigo ,104 , 'SISTEMAS' , GETDATE() , 'SISTEMAS' , GETDATE())
    END 
--SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo = 'SCCYR'

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
IF NOT EXISTS(SELECT * FROM dbo.UsuariosAplicaciones WHERE EMPR_Codigo = @EMPR_Codigo AND USER_IdUser = 104)
    BEGIN
        INSERT INTO dbo.UsuariosAplicaciones( USER_IdUser ,EMPR_Codigo ,APLI_Codigo ,APLI_UsrCrea ,APLI_FecCrea)
        VALUES  ( 104 , @EMPR_Codigo , 'VTA' , 'SISTEMAS' , GETDATE() )
    END 
--SELECT * FROM dbo.UsuariosAplicaciones

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--BEGIN TRAN X

-- =========================================================================================================== --
GO

---DROP TABLE #PMenu
SELECT * INTO #PMenu FROM PlantillasMenu WHERE APLI_Codigo = 'VTA'

DECLARE @EMPR_Codigo VARCHAR(5) = 'JAIVI'
UPDATE #PMenu SET EMPR_Codigo = @EMPR_Codigo

INSERT INTO PlantillasMenu
SELECT * FROM #PMenu

-- =========================================================================================================== --
--SELECT * FROM Usuarios
SELECT * INTO #USR_sistemas FROM dbo.Usuarios WHERE USER_IdUser = 104
UPDATE #USR_sistemas SET USER_IdUser = 1

--DBCC CHECKIDENT( 'dbo.Usuarios' , RESEED, 0 );
--INSERT INTO dbo.Usuarios
--        ( NIVE_Codigo ,          GRUP_Codigo ,          USER_CodUsr ,          USER_Nombre ,
--          USER_DNI ,          USER_Desc ,          USER_PassUsr ,          USER_Activo ,
--          USER_Mail ,          USER_Prog ,          USER_UsrCrea ,          USER_FecCrea ,
--          USER_UsrMod ,          USER_FecMod
--        )
--   SELECT NIVE_Codigo ,          GRUP_Codigo ,          USER_CodUsr ,          USER_Nombre ,
--          USER_DNI ,          USER_Desc ,          USER_PassUsr ,          USER_Activo ,
--          USER_Mail ,          USER_Prog ,          USER_UsrCrea ,          USER_FecCrea ,
--          USER_UsrMod ,          USER_FecMod 
--     FROM #USR_sistemas

DBCC CHECKIDENT( 'dbo.Usuarios' , RESEED, 200 );
---SELECT * FROM Usuarios
--3123
-- =========================================================================================================== --
GO
--DROP TABLE #UPlant
--SELECT * FROM UsuariosPlantillas
DECLARE @EMPR_Codigo VARCHAR(5) = 'JAIVI'
SELECT * INTO #UPlant FROM UsuariosPlantillas WHERE USER_IdUser = 104 AND APLI_Codigo = 'vta' --AND EMPR_Codigo = 'FISUR'

UPDATE #UPlant SET USER_IdUser = 104, EMPR_Codigo = 'JAIVI'

DELETE FROM UsuariosPlantillas 
INSERT INTO UsuariosPlantillas 
SELECT * FROM #UPlant

-- =========================================================================================================== --
SELECT * INTO #TMP_UAPLI FROM dbo.UsuariosAplicaciones
UPDATE #TMP_UAPLI SET EMPR_Codigo = 'JAIVI'
DELETE FROM UsuariosAplicaciones
INSERT INTO UsuariosAplicaciones SELECT * FROM #TMP_UAPLI
-- =========================================================================================================== --
SELECT * INTO #TMP_UEMP FROM UsuariosEmpresas
UPDATE #TMP_UEMP SET EMPR_Codigo = 'JAIVI'

DELETE FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo <> 'JAIVI'
INSERT INTO UsuariosEmpresas SELECT * FROM #TMP_UEMP
-- =========================================================================================================== --
UPDATE dbo.UsuariosProcesos SET EMPR_Codigo = 'JAIVI'
-- =========================================================================================================== --

DELETE FROM dbo.UsuariosPlantillas WHERE USER_IdUser <> 104
DELETE FROM dbo.UsuariosAplicaciones WHERE USER_IdUser <> 104
DELETE FROM dbo.UsuariosEmpresas WHERE USER_IdUser <> 104
DELETE FROM dbo.UsuariosProcesos WHERE USER_IdUser <> 104
DELETE FROM dbo.Usuarios WHERE USER_IdUser <> 104

SELECT * FROM dbo.Usuarios

DBCC CHECKIDENT( 'dbo.Usuarios' , RESEED, 1 );


delete FROM dbo.UsuariosPlantillas WHERE EMPR_Codigo <> 'JAIVI'
DELETE FROM dbo.PlantillasMenu WHERE EMPR_Codigo <> 'JAIVI'
delete FROM dbo.Empresas WHERE EMPR_Codigo <> 'JAIVI'

--DELETE FROM dbo.Aplicaciones WHERE NOT APLI_Codigo IN ('VTA', 'MSG', 'ADM', 'SAG')
SELECT * FROM dbo.Aplicaciones --WHERE APLI_Codigo IN ('VTA', 'MSG', 'ADM', 'SAG')
SELECT * FROM Empresas
--SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo

--SELECT * FROM dbo.PlantillasMenu WHERE APLI_Codigo = 'VTA' AND EMPR_Codigo = @EMPR_Codigo
--SELECT * FROM dbo.UsuariosPlantillas WHERE APLI_Codigo = 'VTA' AND EMPR_Codigo = @EMPR_Codigo AND USER_IdUser = 104



--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--