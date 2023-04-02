GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_ObtenerArreglo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_ObtenerArreglo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 09/09/2013
-- Descripcion         : Obtener un Arreglo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_ObtenerArreglo]
(
	 @ARREG_Codigo VarChar(14)
	,@ALMAC_Id Integer
)
As

	Select TDoc.TIPOS_Descripcion As TIPOS_TipoArreglo
		,Ent.ENTID_RazonSocial As UsuarioCreador
		,Cab.* 
	From Logistica.CTRL_Arreglos As Cab
		Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Cab.TIPOS_CodTipoArreglo
		Left Join Entidades As Ent On Ent.ENTID_Codigo = Cab.ARREG_UsrCrea
	Where ARREG_Codigo = @ARREG_Codigo
	
	Select Art.ARTIC_Descripcion
		,TUni.TIPOS_DescCorta As TIPOS_UnidadMedida
		,Det.*
	From Logistica.CTRL_ArreglosDetalle As Det
		Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
		Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Where ARREG_Codigo = @ARREG_Codigo
	Order By Det.ARRDT_Item


GO 
/***************************************************************************************************************************************/ 

