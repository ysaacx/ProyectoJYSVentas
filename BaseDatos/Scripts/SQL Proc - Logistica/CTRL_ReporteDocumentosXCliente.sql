GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRL_ReporteDocumentosXCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRL_ReporteDocumentosXCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRL_ReporteDocumentosXCliente]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ALMAC_Id SmallInt
	,@PVENT_Id BigInt = Null
	,@ARTIC_Codigo VarChar(14) = Null
	,@ENTID_Codigo VarChar(14) = Null
	,@Fecha Bit = Null
)
As

If IsNull(@Fecha, 1) = 0
	Set @FecIni = Convert(Date, '01-01-2000')
	
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
	,DDocs.DOCVD_Cantidad - IsNull((Select SUM(Tot) From (
		Select IsNull(Sum(IsNull(Det.GUIRD_Cantidad, 0)), 0) As Tot 
		From Logistica.DIST_GuiasRemision As G
			Inner Join Logistica.DIST_GuiasRemisionDetalle As Det On G.GUIAR_Codigo = Det.GUIAR_Codigo
		Where DOCVE_Codigo = Cab.DOCVE_Codigo
			And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
			And Det.GUIRD_ItemDocumento = DDocs.DOCVD_Item
			And G.GUIAR_Estado <> 'X'
		Union All
		Select Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad
			from Logistica.DIST_Ordenes As Ing
				Inner Join Logistica.DIST_OrdenesDetalle As Det
					On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
						And Ing.ORDEN_Estado <> 'X'
			Where Ing.DOCVE_Codigo = Cab.DOCVE_Codigo
				And Ing.ALMAC_IdOrigen = @ALMAC_Id
				And Det.ARTIC_Codigo = DDocs.ARTIC_Codigo
		Group By ARTIC_Codigo, ALMAC_IdOrigen
		) As Suma
	), 0) As Saldo
	,DOCVE_EstEntrega
	,DDocs.DOCVD_PesoUnitario
	,Cab.PVENT_Id
	,0 As PVENT_IdOrigen
	,0 As PVENT_IdDestino
From Ventas.VENT_DocsVentaDetalle As DDocs
	Inner Join Ventas.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = DDocs.DOCVE_Codigo And Cab.DOCVE_Estado <> 'X' And Cab.PVENT_Id = IsNull(@PVENT_Id, Cab.PVENT_Id)
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Cab.TIPOS_CodTipoDocumento
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo And Art.ARTIC_Codigo = ISNULL(@ARTIC_Codigo, Art.ARTIC_Codigo)
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where CONVERT(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And DDocs.ALMAC_Id = @ALMAC_Id
	And DOCVE_EstEntrega = 'P'
	And Cab.ENTID_CodigoCliente = ISNULL(@ENTID_Codigo, Cab.ENTID_CodigoCliente)
Order By Cab.ENTID_CodigoCliente, DDocs.DOCVD_Item


GO 
/***************************************************************************************************************************************/ 

