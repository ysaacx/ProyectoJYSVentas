USE BDSAdmin
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PTLASD_TodosMenu]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[PTLASD_TodosMenu] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/01/2017
-- Descripcion         : Procedimiento de Eliminación de la tabla UsuariosAplicaciones
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[PTLASD_TodosMenu]
(
    @EMPR_Codigo char(5),
    @APLI_Codigo char(3)
)AS
BEGIN 

   ALTER TABLE [dbo].[UsuariosPlantillas]
   NOCHECK CONSTRAINT [FK_PtlaUser_PtlaMenu]

   Delete from PlantillasMenu where Apli_Codigo = @APLI_Codigo And EMPR_codigo = @EMPR_Codigo

   ALTER TABLE [dbo].[UsuariosPlantillas]
   CHECK CONSTRAINT [FK_PtlaUser_PtlaMenu]

END 
GO


