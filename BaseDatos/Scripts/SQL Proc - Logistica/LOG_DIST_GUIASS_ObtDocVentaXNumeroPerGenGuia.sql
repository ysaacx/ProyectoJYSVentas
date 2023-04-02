GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_GUIASS_ObtDocVentaXNumeroPerGenGuia]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDocVentaXNumeroPerGenGuia] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDocVentaXNumeroPerGenGuia]
(
	 @Numero VarChar(7)
	,@Serie VarChar(4)
	,@TIPOS_CodTipoDocumento VarChar(6)
	,@ALMAC_Id SmallInt
	,@PVENT_Id Id
	,@DesBloqueo Bit = Null
)
As

Select
	Case When (Select Count(*) From Logistica.DIST_GuiasRemision 
				Where DOCVE_Codigo = Doc.DOCVE_Codigo 
				And Left(GUIAR_Codigo, 2) = 'GR') > 0 
			Then Convert(Bit, 1) 
			Else Convert(Bit, 0) 
	 End As Guias
	,Convert(Bit, 0)  Notas
	,Case When (Select Count(*) From Logistica.DIST_GuiasRemision 
					Where DOCVE_Codigo = Doc .DOCVE_Codigo 
						And Left(GUIAR_Codigo, 2) = 'OR') > 0 
				Then Convert(Bit, 1) 
				Else Convert(Bit, 0) 
	 End As Orden
	,Case DOCVE_EstEntrega When 'P' Then Convert(Bit, 1) Else Convert(Bit, 0) End As Pendiente
	,Case When DOCVE_FecAnulacion Is Null Then Convert(Bit, 0) Else Convert(Bit, 1) End As Anulada
	,Doc.* , Cli.ENTID_RazonSocial As ENTID_Cliente
	,Vend.ENTID_RazonSocial As ENTID_Vendedor
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Us.ENTID_RazonSocial As Usuario
From Ventas.VENT_DocsVenta As Doc
	Inner Join dbo.Entidades As Cli On Cli.ENTID_Codigo = Doc.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Doc.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	Left Join dbo.Entidades As Us On Us.ENTID_Codigo = Doc.DOCVE_UsrCrea
Where   ISNULL(DOCVE_Estado, '') = 'I' 
	And IsNull(Doc.DOCVE_PerGenGuia, 0) = 1
	And Doc.DOCVE_Serie = @Serie
	And Doc.TIPOS_CodTipoDocumento = @TIPOS_CodTipoDocumento
	And RTrim(Doc.DOCVE_Numero) Like '%' + @Numero + '%'
	AND Doc.DOCVE_EstEntrega = 'P'
	AND  ISNULL(PVENT_Id, '') = @PVENT_Id
	And Abs((Select SUM(DDTRA_Cantidad)
		From (
				Select ARTIC_Codigo, Sum(IsNull(Det.GUIRD_Cantidad, 0)) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All
				Select ARTIC_Codigo, Sum(IsNull(Det.ORDET_Cantidad, 0)) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_Ordenes As Ing
						Inner Join Logistica.DIST_OrdenesDetalle As Det
							On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
								And Not ORDEN_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All
				Select ARTIC_Codigo, SUM(IsNull(DetOrd.DOCVD_Cantidad, 0)), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
					Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
				Where DetOrd.ALMAC_Id = @ALMAC_Id
					And DetOrd.DOCVE_CodigoReferencia = Doc.DOCVE_Codigo
					And Cab.DOCVE_NCPendienteDespachos = 1
					And Cab.TIPOS_CodTipoDocumento = 'CPD07'
				Group By ARTIC_Codigo, ALMAC_Id
				Union All
				Select ARTIC_Codigo, -1 * SUM(IsNull(DetOrd.DOCVD_Cantidad, 0)), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
					Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
				Where DetOrd.DOCVE_Codigo = Doc.DOCVE_Codigo 
					And DetOrd.ALMAC_Id = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_Id
			) As DetOrd
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		)) > 0



GO 
/***************************************************************************************************************************************/ 

