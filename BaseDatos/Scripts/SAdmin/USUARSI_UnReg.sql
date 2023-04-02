USE bdsadmin
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USUARSI_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[USUARSI_UnReg]

GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 16/01/2017
-- Descripcion         : Procedimiento de Inserción de la tabla UsuariosAplicaciones
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[USUARSI_UnReg]
(	@USER_IdUser int,
	@EMPR_Codigo char(5),
	@APLI_Codigo char(3),
	@Usuario Usuario
)
AS

   INSERT INTO [UsuariosAplicaciones](	USER_IdUser,	EMPR_Codigo,	APLI_Codigo,	APLI_UsrCrea,	APLI_FecCrea)
   VALUES (@USER_IdUser,	@EMPR_Codigo,	@APLI_Codigo,	@Usuario,	GetDate())

IF NOT EXISTS( SELECT * FROM dbo.UsuariosPlantillas
                WHERE USER_IdUser = @USER_IdUser
                  AND APLI_Codigo = @APLI_Codigo
                  AND EMPR_Codigo = @EMPR_Codigo)

   BEGIN
      PRINT 'ASIGNAR PLANTILLAS DE MENU'
        INSERT INTO dbo.UsuariosPlantillas( USER_IdUser ,APLI_Codigo ,EMPR_Codigo ,PTLA_Codigo ,PUSR_Activo ,PUSR_UsrCrea ,PUSR_FecCrea )
        SELECT USER_IdUser = @USER_IdUser,
               APLI_Codigo = @APLI_Codigo,
               EMPR_Codigo = @EMPR_Codigo,
               PTLA_Codigo ,
               PUSR_Activo = 'A' ,
               PUSR_UsrCrea = @Usuario ,
               PUSR_FecCrea = GETDATE()
          FROM dbo.PlantillasMenu
         WHERE APLI_Codigo = @APLI_Codigo
           AND EMPR_Codigo = @EMPR_Codigo
           AND ISNULL(PTLA_CopyDefault, 0) = 1
         
        INSERT INTO dbo.UsuariosPlantillas( USER_IdUser ,APLI_Codigo ,EMPR_Codigo ,PTLA_Codigo ,PUSR_Activo ,PUSR_UsrCrea ,PUSR_FecCrea )
        SELECT USER_IdUser = @USER_IdUser,
               APLI_Codigo = @APLI_Codigo,
               EMPR_Codigo = @EMPR_Codigo,
               PTLA_Codigo ,
               PUSR_Activo = 'V',
               PUSR_UsrCrea = @Usuario ,
               PUSR_FecCrea = GETDATE()
          FROM dbo.PlantillasMenu
         WHERE APLI_Codigo = @APLI_Codigo
           AND EMPR_Codigo = @EMPR_Codigo
           AND ISNULL(PTLA_VisibleDefault, 0) = 0 --AND ISNULL(PTLA_CopyDefault, 0) = 0
           AND NOT RTRIM(PTLA_Codigo) + rtrim(EMPR_Codigo)
               IN (SELECT RTRIM(PTLA_Codigo) + rtrim(EMPR_Codigo)
                     FROM UsuariosPlantillas WHERE APLI_Codigo = @APLI_Codigo
                     AND EMPR_Codigo = @EMPR_Codigo
                     AND USER_IdUser = @USER_IdUser)

         PRINT '@APLI_Codigo = ' + @APLI_Codigo + ' | @EMPR_Codigo = ' + @EMPR_Codigo
   END

IF NOT EXISTS(SELECT * FROM UsuariosProcesos 
               WHERE EMPR_Codigo = @EMPR_Codigo AND APLI_Codigo = @APLI_Codigo 
                 AND USER_IdUser = @USER_IdUser)
   BEGIN
       PRINT 'ASIGNAR PROCESOS'

      INSERT INTO dbo.UsuariosProcesos
           ( USER_IdUser ,APLI_Codigo ,EMPR_Codigo ,PROC_Codigo ,PTPR_Fecha ,PTPR_UsrCrea ,PTPR_FecCrea)
      SELECT USER_IdUser   = @USER_IdUser
           , APLI_Codigo   = @APLI_Codigo
           , EMPR_Codigo   = @EMPR_Codigo
           , PROC_Codigo 
           , PTPR_Fecha    = GETDATE()
           , PTPR_UsrCrea  = @Usuario
           , PTPR_FecCrea  = GETDATE()
      FROM dbo.Procesos
     WHERE APLI_Codigo = @APLI_Codigo
       AND PROC_CopyDefault = 1

   END

GO

----BEGIN TRAN X

-- exec USUARSD_UnReg @USER_IdUser=104,@EMPR_Codigo=N'00001',@APLI_Codigo=N'SAG'
-- --exec APLISS_AplicacionesXUsuario @EMPR_Codigo=N'00001',@USER_IdUser=104

-- exec USUARSI_UnReg @USER_IdUser=104,@EMPR_Codigo=N'00001',@APLI_Codigo=N'SAG',@Usuario=N'SISTEMAS'
-- --exec APLISS_AplicacionesXUsuario @EMPR_Codigo=N'00001',@USER_IdUser=104
 
-- ROLLBACK TRAN X

 


--SELECT * FROM dbo.UsuariosPlantillas WHERE USER_IdUser = 104 AND PUSR_Activo = 'V'
-- SELECT * FROM dbo.Usuarios
--INSERT INTO UsuariosPlantillas

/*
SELECT * INTO #pltA FROM dbo.PlantillasMenu
   WHERE APLI_Codigo = 'LOG'
   AND EMPR_Codigo = 'ADECO'

UPDATE #pltA SET EMPR_CODIGO = 'EMPRE'

INSERT INTO dbo.PlantillasMenu
SELECT * FROM  #pltA   

SELECT * FROM  PlantillasMenu WHERE APLI_Codigo = 'loG' AND EMPR_Codigo = 'EMPRE'
*/