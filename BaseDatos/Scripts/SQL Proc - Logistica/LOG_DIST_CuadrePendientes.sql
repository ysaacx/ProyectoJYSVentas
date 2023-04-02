GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_CuadrePendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_CuadrePendientes] 
GO 
CREATE PROCEDURE [dbo].[LOG_DIST_CuadrePendientes]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ALMAC_Id SmallInt
)
As

Select 
	Cab.DOCVE_Codigo
	,Tdoc.TIPOS_DescCorta + ' ' + Cab.DOCVE_Serie + '-' + Right('0000000' + RTRIM(Cab.DOCVE_Numero), 7) As Documento
	,Cab.DOCVE_FechaDocumento
	,Cab.ENTID_CodigoCliente
	,Cab.DOCVE_DescripcionCliente
	,DDocs.DOCVD_Item
	,DDocs.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,DDocs.DOCVD_Cantidad	
	,DDocs.DOCVD_Cantidad - IsNull((
		Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
		Where DOCVE_Codigo = Cab.DOCVE_Codigo
			And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
			And Det.GUIRD_ItemDocumento = DDocs.DOCVD_Item
	), 0) As Saldo
	,DOCVE_EstEntrega
From Ventas.VENT_DocsVentaDetalle As DDocs
	Inner Join Ventas.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = DDocs.DOCVE_Codigo And Cab.DOCVE_Estado <> 'X'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Cab.TIPOS_CodTipoDocumento
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where CONVERT(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And DDocs.ALMAC_Id = @ALMAC_Id
	And DOCVE_EstEntrega = 'P'
	And (DDocs.DOCVD_Cantidad - IsNull((Select SUM(Tot) From (
		Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) As Tot From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
		Where DOCVE_Codigo = Cab.DOCVE_Codigo
			And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
			And Det.GUIRD_ItemDocumento = DDocs.DOCVD_Item
		Union All
		Select Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad
			from Logistica.DIST_Ordenes As Ing
				Inner Join Logistica.DIST_OrdenesDetalle As Det
					On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
						And Not ORDEN_Estado = 'X'
			Where Ing.DOCVE_Codigo = Cab.DOCVE_Codigo
				And Ing.ALMAC_IdOrigen = 3
		Group By ARTIC_Codigo, ALMAC_IdOrigen
		) As Suma
	), 0)) > 0
Order By DDocs.DOCVD_Item
GO 
/***************************************************************************************************************************************/ 

