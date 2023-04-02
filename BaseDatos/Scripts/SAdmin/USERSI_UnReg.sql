USE BDSAdmin
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERSI_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[USERSI_UnReg]

GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 19/03/2019
-- Descripcion         : Procedimiento de Inserción de la tabla Usuarios
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[USERSI_UnReg]
(	@USER_IdUser INT  out,
	@NIVE_Codigo char(3),
	@GRUP_Codigo varchar(17) = null ,
	@USER_CodUsr varchar(20),
	@USER_Nombre varchar(60) = null ,
	@USER_DNI varchar(12),
	@USER_Desc varchar(50) = null ,
	@USER_PassUsr varchar(32),
	@USER_Activo BIT ,
	@USER_Mail varchar(70) = null ,
	@USER_Prog  BIT = null ,
	@Usuario VARCHAR(20)
)

AS

-- =========================================================================== --

  INSERT INTO [Usuarios](
	      NIVE_Codigo,	GRUP_Codigo,	USER_CodUsr,	USER_Nombre
       ,	USER_DNI,	   USER_Desc,	   USER_PassUsr,	USER_Activo
       ,	USER_Mail,	   USER_Prog,	   USER_UsrCrea,	USER_FecCrea)
 VALUES(
	     @NIVE_Codigo,	@GRUP_Codigo,	@USER_CodUsr,	@USER_Nombre
      , @USER_DNI,	   @USER_Desc,	   @USER_PassUsr,	@USER_Activo
      , @USER_Mail,	   @USER_Prog,	   @Usuario,	   GETDATE())

 SELECT @USER_IdUser = @@IDENTITY 
-- =========================================================================== --

   INSERT dbo.UsuariosEmpresas
        ( EMPR_Codigo             , USER_IdUser             , USER_CodUsr            , UEMP_Fecha            
        , UEMP_UsrCrea            , UEMP_FecCrea            , UEMP_UsrMod            , UEMP_FecMod        )
   SELECT EMPR_Codigo     
        , USER_IdUser     = @USER_IdUser
        , USER_CodUsr     = @USER_CodUsr
        , UEMP_Fecha      = GETDATE()
        , UEMP_UsrCrea    = @Usuario
        , UEMP_FecCrea    = GETDATE()
        , UEMP_UsrMod     = NULL
        , UEMP_FecMod     = NULL
     FROM dbo.Empresas
    WHERE EMPR_Activo = 1

-- =========================================================================== --

   Declare @EMPR_Codigo CHAR(5)
   Declare @EMPR_BaseDatos VARCHAR(50)
   DECLARE @APLI_Codigo CHAR(3) = 'VTA'

   DECLARE CEmpresa CURSOR FOR 
	 SELECT EMPR_Codigo, EMPR_BaseDatos From Empresas WHERE EMPR_Activo = 1
   Open CEmpresa

   FETCH NEXT FROM CEmpresa
	   INTO @EMPR_Codigo, @EMPR_BaseDatos

   WHILE @@FETCH_STATUS = 0
      Begin
	   
         EXEC dbo.USUARSI_UnReg @USER_IdUser = @USER_IdUser, -- int
             @EMPR_Codigo = @EMPR_Codigo, -- char(5)
             @APLI_Codigo = @APLI_Codigo, -- char(3)
             @Usuario = @Usuario -- Usuario

         -- ----------------------------------------------------------------------------- --
         DECLARE @SQL_BDPRINCIPAL NVARCHAR(MAX)

         SET @SQL_BDPRINCIPAL = ' DECLARE @ENTID_Id BIGINT = ISNULL((SELECT MAX(ENTID_Id) FROM ' + @EMPR_BaseDatos + '..Entidades), 0) + 1 ' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' DECLARE @ENTID_Codigo VARCHAR(15) = ''' + @USER_DNI + '''' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' DECLARE @ENTID_Nombres VARCHAR(100) = ''' + @USER_Desc + ', ' + @USER_Nombre + '''' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' DECLARE @Usuario VARCHAR(20) = ''' + @Usuario + '''' + CHAR(10)
         --SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' 
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' INSERT INTO ' + @EMPR_BaseDatos + '..Entidades' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '      ( ENTID_Codigo ,TIPOS_CodTipoDocumento ,ENTID_Id ,ENTID_TipoEntidadPDT ,ENTID_Nombres ,ENTID_NroDocumento ,ENTID_Estado ,ENTID_UsrCrea ,ENTID_FecCrea, USUAR_Codigo)' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' SELECT ENTID_Codigo ,TIPOS_CodTipoDocumento ,ENTID_Id ,ENTID_TipoEntidadPDT ,ENTID_Nombres ,ENTID_NroDocumento ,ENTID_Estado ,ENTID_UsrCrea ,ENTID_FecCrea, USUAR_Codigo' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' FROM (SELECT ENTID_Codigo = @ENTID_Codigo, TIPOS_CodTipoDocumento = ''DID1'', ENTID_Id = @ENTID_Id, ENTID_TipoEntidadPDT = ''N'', ENTID_Nombres = @ENTID_Nombres' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '      , ENTID_NroDocumento = @ENTID_Codigo, ENTID_Estado = ''A'', ENTID_UsrCrea = @Usuario, ENTID_FecCrea = GETDATE(), USUAR_Codigo = @ENTID_Codigo' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '   ) AS ENT WHERE NOT ENT.ENTID_Codigo IN (SELECT ENTID_Codigo FROM ' + @EMPR_BaseDatos + '..Entidades)' + CHAR(10)
         --SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' 
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' INSERT INTO ' + @EMPR_BaseDatos + '..EntidadesRoles( ENTID_Codigo ,              ROLES_Id ,              ENROL_UsrCrea ,              ENROL_FecCrea)    ' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + ' SELECT ENTID_Codigo ,ROLES_Id ,ENROL_UsrCrea ,ENROL_FecCrea' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '  FROM (SELECT ENTID_Codigo = @ENTID_Codigo, ROLES_Id = 1, ENROL_UsrCrea = @Usuario, ENROL_FecCrea = GETDATE()) AS EROL ' + CHAR(10)
         SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '  WHERE ENTID_Codigo NOT IN (SELECT ENTID_Codigo FROM ' + @EMPR_BaseDatos + '..EntidadesRoles)' + CHAR(10)

         --PRINT @SQL_BDPRINCIPAL

         EXECUTE sp_executesql @SQL_BDPRINCIPAL
         PRINT '-- ----------------------------------------------------------------------------- --'
         -- ----------------------------------------------------------------------------- --
	      FETCH NEXT FROM CEmpresa
	      INTO @EMPR_Codigo, @EMPR_BaseDatos
      End

   CLOSE CEmpresa
   DEALLOCATE CEmpresa
   -- =========================================================================== --

GO

BEGIN TRAN x

declare @p1 int
set @p1=NULL
exec USERSI_UnReg @USER_IdUser=@p1 output,@NIVE_Codigo=N'002',@GRUP_Codigo=NULL,@USER_CodUsr=N'321',@USER_Nombre=N'321',@USER_DNI=N'321',@USER_Desc=N'321',@USER_PassUsr=N'482422985709b4e78d144dec7bb9d74d',@USER_Activo=1,@USER_Mail=N'321',@USER_Prog=0,@Usuario=N'SISTEMAS'
--select @p1

--SELECT * FROM dbo.Usuarios WHERE USER_IdUser = @p1
--SELECT * FROM UsuariosEmpresas WHERE USER_IdUser = @p1
--SELECT * FROM dbo.UsuariosAplicaciones WHERE USER_IdUser = @p1
--SELECT * FROM UsuariosPlantillas WHERE USER_IdUser = @p1

--USE BDSisSCC
SELECT * FROM BDSisSCC..Entidades WHERE ENTID_Codigo = '321'
SELECT * FROM BDInkaPeru..Entidades WHERE ENTID_Codigo = '321'

ROLLBACK TRAN x


--SELECT * FROM BDSisSCC..Entidades WHERE ENTID_Codigo = '25252525'
--SELECT * FROM BDSisSCC..EntidadesRoles WHERE ENTID_Codigo = '40975980'
--SELECT * FROM BDSisSCC..Roles
--SELECT *  FROM BDSisSCC..Entidades WHERE ENTID_Codigo = '40975980'
--SELECT *  FROM BDSisSCC..UsuariosPorPuntoVenta WHERE ENTID_Codigo = '40975980'

--BEGIN TRAN x

--DECLARE @SQL_BDPRINCIPAL VARCHAR(MAX)


--SET @SQL_BDPRINCIPAL = ' DECLARE @ENTID_Id BIGINT = ISNULL((SELECT MAX(ENTID_Id) FROM BDSisSCC..Entidades), 0) + 1 ' + CHAR(10)
--SET @SQL_BDPRINCIPAL = @SQL_BDPRINCIPAL + '   DECLARE @ENTID_Codigo VARCHAR(15) = '409759801''
--   DECLARE @ENTID_Nombres VARCHAR(100) = ''
--   DECLARE @Usuario VARCHAR(20) = ''

--   INSERT INTO BDSisSCC..Entidades
--        ( ENTID_Codigo ,          TIPOS_CodTipoDocumento ,          ENTID_Id ,          ENTID_TipoEntidadPDT ,
--          ENTID_Nombres ,         ENTID_NroDocumento ,              ENTID_Estado ,      ENTID_UsrCrea ,
--          ENTID_FecCrea         )
--   SELECT ENTID_Codigo ,          TIPOS_CodTipoDocumento ,          ENTID_Id ,          ENTID_TipoEntidadPDT ,
--          ENTID_Nombres ,         ENTID_NroDocumento ,              ENTID_Estado ,      ENTID_UsrCrea ,
--          ENTID_FecCrea
--   FROM (
--   SELECT ENTID_Codigo = @ENTID_Codigo
--        , TIPOS_CodTipoDocumento = 'DID1'
--        , ENTID_Id = @ENTID_Id
--        , ENTID_TipoEntidadPDT = 'N'
--        , ENTID_Nombres = @ENTID_Nombres
--        , ENTID_NroDocumento = @ENTID_Codigo
--        , ENTID_Estado = 'A'
--        , ENTID_UsrCrea = @Usuario
--        , ENTID_FecCrea = GETDATE()
--     ) AS ENT
--    WHERE NOT ENT.ENTID_Codigo IN (SELECT ENTID_Codigo FROM BDSisSCC..Entidades)

--   INSERT INTO dbo.EntidadesRoles
--        ( ENTID_Codigo ,              ROLES_Id ,              ENROL_UsrCrea ,              ENROL_FecCrea)    
--   SELECT ENTID_Codigo ,              ROLES_Id ,              ENROL_UsrCrea ,              ENROL_FecCrea
--    FROM (SELECT ENTID_Codigo = @ENTID_Codigo
--       , ROLES_Id = 1
--       , ENROL_UsrCrea = @Usuario
--       , ENROL_FecCrea = GETDATE()
--    ) AS EROL WHERE ENTID_Codigo NOT IN (SELECT ENTID_Codigo FROM EntidadesRoles)

--ROLLBACK TRAN x


--SELECT * FROM dbo.EntidadesRoles WHERE ENTID_Codigo = '40975980'
--SELECT * FROM dbo.Roles

----SELECT * FROM Entidades WHERE ENTID_Codigo = '40975980'

----SELECT * FROM dbo.Empresas
----UPDATE dbo.Empresas SET EMPR_Activo = 0 WHERE NOT EMPR_Codigo IN ('SCCYR', 'IFERR', 'INKAP', 'FISUR')
----UPDATE dbo.Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo IN ('SCCYR', 'IFERR', 'INKAP', 'FISUR')
----SELECT * FROM UsuariosEmpresas
----SELECT * FROM dbo.Aplicaciones


--BEGIN TRAN X
--DECLARE @ENTID_Id BIGINT = ISNULL((SELECT MAX(ENTID_Id) FROM BDSisSCC..Entidades), 0) + 1 
-- DECLARE @ENTID_Codigo VARCHAR(15) = '321'
-- DECLARE @ENTID_Nombres VARCHAR(100) = '321, 321'
-- DECLARE @Usuario VARCHAR(20) = 'SISTEMAS'
-- INSERT INTO BDSisSCC..Entidades
--      ( ENTID_Codigo ,TIPOS_CodTipoDocumento ,ENTID_Id ,ENTID_TipoEntidadPDT ,ENTID_Nombres ,ENTID_NroDocumento ,ENTID_Estado ,ENTID_UsrCrea ,ENTID_FecCrea)
-- SELECT ENTID_Codigo ,TIPOS_CodTipoDocumento ,ENTID_Id ,ENTID_TipoEntidadPDT ,ENTID_Nombres ,ENTID_NroDocumento ,ENTID_Estado ,ENTID_UsrCrea ,ENTID_FecCrea
-- FROM (SELECT ENTID_Codigo = @ENTID_Codigo, TIPOS_CodTipoDocumento = 'DID1', ENTID_Id = @ENTID_Id, ENTID_TipoEntidadPDT = 'N', ENTID_Nombres = @ENTID_Nombres
--      , ENTID_NroDocumento = @ENTID_Codigo, ENTID_Estado = 'A', ENTID_UsrCrea = @Usuario, ENTID_FecCrea = GETDATE()
--   ) AS ENT WHERE NOT ENT.ENTID_Codigo IN (SELECT ENTID_Codigo FROM BDSisSCC..Entidades)
-- INSERT INTO BDSisSCC..EntidadesRoles( ENTID_Codigo ,              ROLES_Id ,              ENROL_UsrCrea ,              ENROL_FecCrea)    
-- SELECT ENTID_Codigo ,ROLES_Id ,ENROL_UsrCrea ,ENROL_FecCrea
--  FROM (SELECT ENTID_Codigo = @ENTID_Codigo, ROLES_Id = 1, ENROL_UsrCrea = @Usuario, ENROL_FecCrea = GETDATE()) AS EROL 
--  WHERE ENTID_Codigo NOT IN (SELECT ENTID_Codigo FROM BDSisSCC..EntidadesRoles)

--ROLLBACK TRAN X