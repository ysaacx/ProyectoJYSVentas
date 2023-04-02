GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRLSS_PendientesOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRLSS_PendientesOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/02/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRLSS_PendientesOrdenes]
(
	 @FecFin DateTime
	,@ALMAC_Id SmallInt
	,@Linea VarChar(10) = Null
)
As



Select DDocs.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,DDocs.ORDET_Cantidad - IsNull((
		Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
		Where ORDEN_Codigo = Cab.ORDEN_Codigo
			And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
			And Det.GUIRD_ItemDocumento = DDocs.ORDET_Item
			And G.GUIAR_Estado <> 'X'
	), 0) As Saldo
Into #Ventas
From Logistica.DIST_OrdenesDetalle As DDocs
	Inner Join Logistica.DIST_Ordenes As Cab On Cab.ORDEN_Codigo = DDocs.ORDEN_Codigo And Cab.ORDEN_Estado <> 'X'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = 'CPD' + Left(Cab.DOCVE_Codigo, 2)
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo  And Art.LINEA_Codigo Like @Linea + '%'
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join PuntoVenta As PVen On PVen.ALMAC_Id = @ALMAC_Id
Where CONVERT(Date, ORDEN_FechaDocumento) <= @FecFin
	And Cab.PVENT_IdDestino = PVen.PVENT_Id
	And (DDocs.ORDET_Cantidad - IsNull((Select SUM(Tot) From (
		Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) As Tot From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
				And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
				And Det.GUIRD_ItemDocumento = DDocs.ORDET_Item
		Where ORDEN_Codigo = Cab.ORDEN_Codigo
			And G.GUIAR_Estado <> 'X'
			And G.ENTID_CodigoCliente = Cab.ENTID_CodigoCliente
		Union All
		Select Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad
			from Logistica.DIST_Ordenes As Ing
				Inner Join Logistica.DIST_OrdenesDetalle As Det
					On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
						And Not ORDEN_Estado = 'X'
			Where Ing.DOCVE_Codigo = Cab.ORDEN_Codigo
				And Ing.ALMAC_IdDestino = @ALMAC_Id
				And Ing.ENTID_CodigoCliente = Cab.ENTID_CodigoCliente
		Group By ARTIC_Codigo, ALMAC_IdOrigen
		) As Suma
	), 0)) > 0
	And Cab.ENTID_CodigoCliente = Cab.ENTID_CodigoCliente
	And DDocs.ARTIC_Codigo = DDocs.ARTIC_Codigo
Order By ENTID_CodigoCliente,
DDocs.ORDET_Item

Select ARTIC_Codigo, ARTIC_Detalle, SUM(Saldo) As Saldo , COUNT(*) As C
From #Ventas As Doc
Group by ARTIC_Codigo, ARTIC_Detalle


GO 
/***************************************************************************************************************************************/ 

