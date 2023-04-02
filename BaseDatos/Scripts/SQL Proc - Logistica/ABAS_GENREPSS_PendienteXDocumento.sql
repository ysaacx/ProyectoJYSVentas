GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ABAS_GENREPSS_PendienteXDocumento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ABAS_GENREPSS_PendienteXDocumento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 25/01/2011
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ABAS_GENREPSS_PendienteXDocumento]
(
	 @FecIni As DateTime
	,@FecFin As DateTime
)

AS

Select Cab.DOCVE_Codigo, Det.ARTIC_Codigo, Art.ARTIC_Descripcion
	, Det.DOCVD_Cantidad, IsNull(Tras.DDTRA_Cantidad, 0) As DDTRA_Cantidad
	,(IsNull(Det.DOCVD_Cantidad, 0) - IsNull(Tras.DDTRA_Cantidad, 0)) As Saldo --, Count(*) 
	,DOCVD_Item
Into #Detalle
From Ventas.VENT_DocsVenta As Cab
	Inner Join Ventas.VENT_DocsVentaDetalle As Det On Det.DOCVE_Codigo = Cab.DOCVE_Codigo
	Left Join (
		Select DDet.ARTIC_Codigo, Doc.DOCVE_Codigo, Sum(DDet.DDTRA_Cantidad) As DDTRA_Cantidad
		From [Logistica].[DIST_DocsTraslados] As Doc
			Inner Join [Logistica].[DIST_DocsTrasladosDetalle] As DDet On DDet.DOTRA_Codigo = Doc.DOTRA_Codigo
		Where Not Doc.DOCVE_Codigo Is Null
		Group By DDet.ARTIC_Codigo, Doc.DOCVE_Codigo
	) As Tras On Tras.DOCVE_Codigo = Cab.DOCVE_Codigo And Tras.ARTIC_Codigo = Det.ARTIC_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo 
Where Not Cab.DOCVE_Estado = 'X'
	And Left(Cab.DOCVE_Codigo, 2) In ('01', '03')
	And (IsNull(Det.DOCVD_Cantidad, 0) - IsNull(Tras.DDTRA_Cantidad, 0)) > 0
	And DOCVE_FechaDocumento Between @FecIni And @FecFin
	
Select Cab.DOCVE_Codigo, DOCVE_FechaDocumento, ENTID_CodigoCliente, Ent.ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Cab.DOCVE_Serie + '-' + Right('0000000' + RTrim(DOCVE_Numero), 7) As Documento
From Ventas.VENT_DocsVenta As Cab
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Cab.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_codigo = Cab.TIPOS_CodTipoDocumento
Where Cab.DOCVE_Codigo In (Select DOCVE_Codigo From #Detalle) 
		
Select * From #Detalle


GO 
/***************************************************************************************************************************************/ 

