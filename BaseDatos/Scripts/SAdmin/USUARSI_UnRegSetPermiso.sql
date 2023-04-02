USE BDSAdmin
go


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USUARSI_UnRegSetPermiso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[USUARSI_UnRegSetPermiso]

GO

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/12/2017
-- Descripcion         : Procedimiento de Inserción de la tabla UsuariosPlantillas
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[USUARSI_UnRegSetPermiso]
(	@USER_IdUser INT,
	@APLI_Codigo char(3),
	@EMPR_Codigo char(5),
	@PTLA_Codigo varchar(50),
	@PUSR_Activo char(1),
	@Usuario     VARCHAR(20)
)

AS

IF EXISTS(SELECT * 
            FROM UsuariosPlantillas 
           WHERE USER_IdUser = @USER_IdUser
             AND APLI_Codigo = @APLI_Codigo
             AND EMPR_Codigo = @EMPR_Codigo
             AND PTLA_Codigo = @PTLA_Codigo )

    BEGIN 
        PRINT 'UPDATE'
        UPDATE [UsuariosPlantillas]
        SET [PUSR_Activo] = @PUSR_Activo
          , [PUSR_UsrMod] = @Usuario
          , [PUSR_FecMod] = GetDate()

        WHERE
         USER_IdUser = @USER_IdUser
          And APLI_Codigo = @APLI_Codigo
          And EMPR_Codigo = @EMPR_Codigo
          And PTLA_Codigo = @PTLA_Codigo
    END
ELSE
    BEGIN
        PRINT 'INSERT' 
        INSERT INTO [UsuariosPlantillas]
            (	USER_IdUser
            ,	APLI_Codigo
            ,	EMPR_Codigo
            ,	PTLA_Codigo
            ,	PUSR_Activo
            ,	PUSR_UsrCrea
            ,	PUSR_FecCrea
            )
        VALUES
            (	@USER_IdUser
            ,	@APLI_Codigo
            ,	@EMPR_Codigo
            ,	@PTLA_Codigo
            ,	@PUSR_Activo
            ,	@Usuario
            ,	GetDate()
            )
    END 


GO