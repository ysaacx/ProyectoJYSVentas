USE bdsadmin
go
IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USUARSD_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[USUARSD_UnReg]

GO

-- =============================================
-- Autor - Fecha Crea  : Generador - 16/01/2017
-- Descripcion         : Procedimiento de Eliminación de la tabla UsuariosAplicaciones
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[USUARSD_UnReg]
(
	@USER_IdUser int,
	@EMPR_Codigo char(5),
	@APLI_Codigo char(3)
)

AS

DELETE FROM [UsuariosAplicaciones]
WHERE
	  USER_IdUser = @USER_IdUser
  And EMPR_Codigo = @EMPR_Codigo
  And APLI_Codigo = @APLI_Codigo


  IF EXISTS( SELECT * FROM dbo.UsuariosPlantillas
              WHERE USER_IdUser = @USER_IdUser AND APLI_Codigo = @APLI_Codigo
                AND EMPR_Codigo = @EMPR_Codigo)
      BEGIN
         DELETE FROM dbo.UsuariosPlantillas
          WHERE APLI_Codigo = @APLI_Codigo
            AND EMPR_Codigo = @EMPR_Codigo
            AND USER_IdUser = @USER_IdUser
      END

IF EXISTS(SELECT * FROM UsuariosProcesos 
           WHERE EMPR_Codigo = @EMPR_Codigo AND APLI_Codigo = @APLI_Codigo 
             AND USER_IdUser = @USER_IdUser)
   BEGIN
      DELETE dbo.UsuariosProcesos
       WHERE EMPR_Codigo = @EMPR_Codigo 
         AND APLI_Codigo = @APLI_Codigo 
         AND USER_IdUser = @USER_IdUser
   END

GO

--EXEC dbo.USUARSD_UnReg @USER_IdUser = 104, -- int
--    @EMPR_Codigo = '', -- char(5)
--    @APLI_Codigo = '' -- char(3)
