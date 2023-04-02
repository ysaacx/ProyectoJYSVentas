GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOGI_DOCSS_FacturasCemento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOGI_DOCSS_FacturasCemento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOGI_DOCSS_FacturasCemento]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Cadena VarChar(100)
	,@Campo SmallInt
)
As

	Select Case 
			When (Select Count(*) From [Logistica].[DIST_DocsTraslados] 
					  Where DOCVE_Codigo = m_vent_docsventa.DOCCO_Codigo) > 0 
			Then Convert(Bit, 1) Else Convert(Bit, 0) End As Guias
		, Cli.ENTID_RazonSocial As ENTID_Proveedor
		, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
		, TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
		, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
		, TPag.TIPOS_DescCorta As TIPOS_TipoPago
		, m_vent_docsventa.* 
	From Logistica.ABAS_DocsCompra As m_vent_docsventa
		Inner Join dbo.Entidades As Cli On Cli.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoProveedor
		Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = m_vent_docsventa.TIPOS_CodTipoDocumento
		Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = m_vent_docsventa.TIPOS_CodTipoMoneda
		Inner Join dbo.Tipos As TPag On TPag.TIPOS_Codigo = m_vent_docsventa.TIPOS_CodTipoPago
	Where   Convert(Date, DOCCO_FechaDocumento) Between @FecIni AND @FecFin
		 AND
			Case @Campo 
				When 1 Then ISNULL(Cli.ENTID_RazonSocial, '') 
				When 2 Then ISNULL(Cli.ENTID_NroDocumento, '') 
				Else ISNULL(Cli.ENTID_RazonSocial, '')
			End Like '%' + @Cadena + '%'


GO 
/***************************************************************************************************************************************/ 

