GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[COSTESS_ArticulosCosteados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[COSTESS_ArticulosCosteados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 08/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[COSTESS_ArticulosCosteados]
(
	@ARTIC_Codigo CodArticulo
	,@Cantidad Integer
)
As

	Select Top (@Cantidad)
		TDes.TIPOS_Descripcion As TIPOS_TipoDestino
		,TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
		,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCCO_Serie + '-' + Right('0000000' + RTRIM(Doc.DOCCO_Numero), 7) As Documento
		,Ent.ENTID_RazonSocial
		,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
		,Doc.TIPOS_CodTipoMoneda
		,Doc.DOCCO_FechaDocumento
		,DocCodetalle.* 
	From Logistica.ABAS_DocsCompraDetalle As DocCodetalle 
		Inner Join Logistica.ABAS_DocsCompra As Doc On Doc.DOCCO_Codigo = DocCodetalle.DOCCO_Codigo
		Inner Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_CodigoProveedor
		left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
		Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = DocCodetalle.ARTIC_Codigo
		left Join dbo.Tipos As TDes On TDes.TIPOS_Codigo = DocCodetalle.TIPOS_CodTipoDestino
		left Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
		left Join dbo.Tipos As Mon On Mon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	WHERE Art.ARTIC_Codigo = @ARTIC_Codigo
		--And IsNull(DocCodetalle.DOCCD_Costo, 0) > 0
	Order By Doc.DOCCO_FechaDocumento Desc


GO 
/***************************************************************************************************************************************/ 

exec COSTESS_ArticulosCosteados @ARTIC_Codigo=N'0201032',@Cantidad=25

--SELECT * FROM Logistica.ABAS_DocsCompraDetalle WHERE ARTIC_Codigo=N'0201032'
--SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo = '010060051615'
