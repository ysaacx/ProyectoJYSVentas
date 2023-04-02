GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTISS_TodosAyudaConductores]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTISS_TodosAyudaConductores] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/08/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTISS_TodosAyudaConductores]
(
	 @Opcion SmallInt
	,@Cadena VarChar(50)
	,@ROLES_Id BigInt
	,@ENTID_Transportista VarChar(14)
)
As

SELECT Distinct 
	m_Ent.ENTID_Codigo As Codigo
	, m_Ent.ENTID_RazonSocial As [Razon Social]
	, m_Ent.ENTID_Nombres As Nombre, m_Ent.ENTID_NroDocumento As [Doc./R.U.C.]
	, m_Ent.ENTID_Id As Interno
	, m_Ent.UBIGO_Codigo As Ubigeo
FROM Entidades as m_Ent
	Inner Join EntidadesRoles As ERol On ERol.ENTID_Codigo = m_Ent.ENTID_Codigo And ERol.ROLES_Id = @ROLES_Id
	Inner Join EntidadRelacion As Rel On Rel.ENTID_CodRelacion = m_Ent.ENTID_Codigo 
		And Rel.ENTID_Codigo = @ENTID_Transportista
Where (Case @Opcion 
		When 0 Then m_Ent.ENTID_Codigo
		When 1 Then ENTID_RazonSocial
		When 2 Then m_Ent.ENTID_Codigo
		Else ENTID_RazonSocial 
	  End) Like '%' + @Cadena + '%'



GO 
/***************************************************************************************************************************************/ 

