GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTISS_TodosAyuda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTISS_TodosAyuda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/08/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTISS_TodosAyuda]
(
	 @Opcion SmallInt
	,@Cadena VarChar(50)
	,@ROLES_Id BigInt
)
As

SELECT Distinct 
	m_Ent.ENTID_Codigo As Codigo
	, m_Ent.ENTID_RazonSocial As [Razon Social]
	, m_Ent.ENTID_Nombres As Nombre, m_Ent.ENTID_NroDocumento As [Doc./R.U.C.]
	,IsNUll(ENTID_Direccion,'') + ' - ' 
		+ IsNull(Dis.UBIGO_Descripcion + ' / ' + Pro.UBIGO_Descripcion + ' / ' + Dep.UBIGO_Descripcion, '') As Dirección
	, m_Ent.ENTID_Id As Interno
	, m_Ent.UBIGO_Codigo As Ubigeo
FROM Entidades as m_Ent
	Left Join Ubigeos As Dep On Dep.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 2)
	Left Join Ubigeos As Pro On Pro.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 5)
	Left Join Ubigeos As Dis On Dis.UBIGO_Codigo = m_Ent.UBIGO_Codigo
	Inner Join EntidadesRoles As ERol On ERol.ENTID_Codigo = m_Ent.ENTID_Codigo And ERol.ROLES_Id = @ROLES_Id
	Inner Join Roles As Rol On Rol.ROLES_Id = ERol.ROLES_Id
Where (Case @Opcion 
		When 0 Then m_Ent.ENTID_Codigo
		When 1 Then ENTID_RazonSocial
		When 2 Then m_Ent.ENTID_Codigo
		Else ENTID_RazonSocial 
	  End) Like '%' + @Cadena + '%'


GO 
/***************************************************************************************************************************************/ 

