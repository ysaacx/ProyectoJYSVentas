GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTISS_TodosAyudaConductor]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTISS_TodosAyudaConductor] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/07/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTISS_TodosAyudaConductor]
(
	@ROLES_Id Id
	,@Cadena VarChar(50)
	,@Opcion SmallInt
	
)
As

Select 
	Ent.ENTID_Codigo As Codigo, Ent.ENTID_RazonSocial As [Razon Social], Ent.ENTID_Nombres As Nombre, Ent.ENTID_NroDocumento As [Doc./R.U.C.]
From Entidades As Ent
	Inner Join EntidadesRoles As Rol On Rol.ENTID_Codigo = Ent.ENTID_Codigo 
		And Rol.ROLES_Id = @ROLES_Id
Where
	Case @Opcion 
		When 1 Then ENTID_NroDocumento
		When 2 Then ENTID_RazonSocial
		Else ENTID_RazonSocial
	End Like '%' + @Cadena + '%' 


GO 
/***************************************************************************************************************************************/ 

