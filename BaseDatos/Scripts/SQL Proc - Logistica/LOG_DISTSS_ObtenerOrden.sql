GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_ObtenerOrden]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_ObtenerOrden] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 30/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_ObtenerOrden]
(
	 @ORDEN_Codigo VarChar(12)
	 ,@Detalle Bit = Null
)
As

Select IsNull(TFDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + RIGHT('0000000' + Rtrim(Ven.DOCVE_Numero), 7),
			 TFDoc2.TIPOS_DescCorta + ' ' + Left(Right(Ord.DOCVE_Codigo, 10), 3) + '-' + Right(Ord.DOCVE_Codigo, 7))
		As DocVenta
	,Ent.ENTID_Direccion + IsNull(' / ' + Dep.UBIGO_Descripcion + ' / ' + Pro.UBIGO_Descripcion + ' / ' + Dis.UBIGO_Descripcion, '') As ENTID_Direccion
	,Us.ENTID_RazonSocial As Usuario
	
	,Ord.*
From Logistica.DIST_Ordenes As Ord
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Ord.DOCVE_Codigo
	Left Join Tipos As TFDoc On TFDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TFDoc2 On TFDoc2.TIPOS_Codigo = ('CPD' + Left(Ord.DOCVE_Codigo, 2))
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ord.ENTID_CodigoCliente 
	Left Join Entidades As Us On Us.ENTID_Codigo = IsNull(Ord.ORDEN_UsrCreaRemoto, Ord.ORDEN_UsrCrea)
	Left Join Ubigeos As Dep On Dep.UBIGO_Codigo = Left(Ent.UBIGO_Codigo, 2)
	Left Join Ubigeos As Pro On Pro.UBIGO_Codigo = Left(Ent.UBIGO_Codigo, 5)
	Left Join Ubigeos As Dis On Dis.UBIGO_Codigo = Ent.UBIGO_Codigo
	
Where Ord.ORDEN_Codigo = @ORDEN_Codigo

If IsNull(@Detalle, 1) = 1
Begin
	Select Det.*
		,Art.ARTIC_Descripcion
		,Art.ARTIC_Peso As PesoUnitario
		,TUni.TIPOS_DescCorta As TIPOS_UnidadMedida
	From Logistica.DIST_OrdenesDetalle As Det
		Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
		Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Where ORDEN_Codigo= @ORDEN_Codigo
End


GO 
/***************************************************************************************************************************************/ 

