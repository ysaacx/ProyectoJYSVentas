GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRLSS_PendientesVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRLSS_PendientesVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/02/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRLSS_PendientesVentas]
(
	 @FecFin DateTime
	,@ALMAC_Id SmallInt
	,@Linea VarChar(10) = Null
)
As

Select DDocs.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,DDocs.DOCVD_Cantidad - IsNull((Select SUM(Tot) From (
		Select IsNull(Sum(IsNull(Det.GUIRD_Cantidad, 0)), 0) As Tot 
		From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo 
				And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
				And Det.GUIRD_ItemDocumento = DDocs.DOCVD_Item
				And G.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente	
		Where DOCVE_Codigo = Doc.DOCVE_Codigo
			And G.GUIAR_Estado <> 'X'
		Union All
		Select Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad
			from Logistica.DIST_Ordenes As Ing
				Inner Join Logistica.DIST_OrdenesDetalle As Det On Det.ORDEN_Codigo = Ing.ORDEN_Codigo 
					And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
			Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
				And Ing.ALMAC_IdOrigen = @ALMAC_Id
				And Ing.ORDEN_Estado <> 'X'
				And Ing.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
		Group By ARTIC_Codigo, ALMAC_IdOrigen
		) As Suma
	), 0) As Saldo
Into #Ventas
From Ventas.VENT_DocsVentaDetalle As DDocs
	Inner Join Ventas.VENT_DocsVenta As Doc On Doc.DOCVE_Codigo = DDocs.DOCVE_Codigo 
		And Doc.DOCVE_Estado <> 'X' 
		And DOCVE_EstEntrega = 'P'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo 
		And Art.ARTIC_Codigo <> '1301001'
		And Art.LINEA_Codigo Like @Linea + '%'
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where CONVERT(Date, DOCVE_FechaDocumento) <= @FecFin
	And DDocs.ALMAC_Id = @ALMAC_Id	
	And (DDocs.DOCVD_Cantidad - IsNull((Select SUM(Tot) From (
			/* Guias de Remision */
			Select IsNull(Sum(IsNull(Det.GUIRD_Cantidad, 0)), 0) As Tot 
			From Logistica.DIST_GuiasRemision As G
				Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
					And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
					And Det.GUIRD_ItemDocumento = DDocs.DOCVD_Item
			Where G.DOCVE_Codigo = Doc.DOCVE_Codigo
				And G.GUIAR_Estado <> 'X'
				And G.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
			Union All /* Ordenes */
			Select Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad
				from Logistica.DIST_Ordenes As Ing
					Inner Join Logistica.DIST_OrdenesDetalle As Det
						On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
							And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
				Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
					And Ing.ALMAC_IdOrigen = @ALMAC_Id
					And Ing.ORDEN_Estado <> 'X'
					And Ing.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
			Group By ARTIC_Codigo, ALMAC_IdOrigen
			Union All /* Nota de Credito */
			Select SUM(IsNull(DetOrd.DOCVD_Cantidad, 0))
			From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
				Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
					And Cab.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
					And Cab.DOCVE_NCPendienteDespachos = 1
			Where DetOrd.ALMAC_Id = @ALMAC_Id
				And DetOrd.DOCVE_CodigoReferencia = Doc.DOCVE_Codigo
				And Cab.TIPOS_CodTipoDocumento = 'CPD07'
			Group By ARTIC_Codigo, ALMAC_Id
			Union All /* Multiples Guias */
			Select Sum(IsNull(GUIVE_CantidadEntregada, 0)) From Logistica.DIST_GuiasRemisionVentas As GRVen
			Where GRVen.DOCVE_Codigo = Doc.DOCVE_Codigo
				And GRVen.ARTIC_Codigo = DDocs.ARTIC_Codigo
				And GRVen.GUIVE_Estado <> 'X'
				And GRVen.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
		) As Suma
	), 0)) > 0
	And DDocs.ARTIC_Codigo = DDocs.ARTIC_Codigo
Order By Art.ARTIC_Codigo, Doc.ENTID_CodigoCliente, Doc.DOCVE_Codigo, DDocs.DOCVD_Item


Select ARTIC_Codigo, ARTIC_Detalle, SUM(Saldo) As Saldo, COUNT(*) As C
From #Ventas As Doc
Group By ARTIC_Codigo, ARTIC_Detalle



GO 
/***************************************************************************************************************************************/ 

