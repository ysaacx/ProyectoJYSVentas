GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_CuadrePendientesVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_CuadrePendientesVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_CuadrePendientesVentas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ALMAC_Id SmallInt
	,@PVENT_Id BigInt = Null
	,@ARTIC_Codigo VarChar(14) = Null
	,@ENTID_Codigo VarChar(14) = Null
	,@Fecha Bit = Null
	,@DesBloqueo Bit = Null
)
As

If IsNull(@Fecha, 1) = 0
	Set @FecIni = Convert(Date, '01-01-2000')
	
Declare @Tiempo Integer 
Select @Tiempo = (-1 * PARMT_Valor) From Parametros Where PARMT_Id = 'pg_TPendiente'
Print @Tiempo
Print DATEADD(Month, @Tiempo, Convert(Date, GetDate()))
	
Select Doc.DOCVE_Codigo
	,Tdoc.TIPOS_DescCorta + ' ' + Doc.DOCVE_Serie + '-' + Right('0000000' + RTRIM(Doc.DOCVE_Numero), 7) As Documento
	,Doc.DOCVE_FechaDocumento
	,Doc.ENTID_CodigoCliente
	,Doc.DOCVE_DescripcionCliente
	,DDocs.DOCVD_Item
	,DDocs.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,DDocs.DOCVD_Cantidad	
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
	,DOCVE_EstEntrega
	,Art.ARTIC_Peso As DOCVD_PesoUnitario
	,Doc.PVENT_Id
	,0 As PVENT_IdOrigen
	,0 As PVENT_IdDestino
	
	
Into #Ventas
From Ventas.VENT_DocsVentaDetalle As DDocs
	Inner Join Ventas.VENT_DocsVenta As Doc On Doc.DOCVE_Codigo = DDocs.DOCVE_Codigo 
		And Doc.DOCVE_Estado <> 'X' 
		And Doc.PVENT_Id = IsNull(@PVENT_Id, Doc.PVENT_Id)
		And DOCVE_EstEntrega = 'P'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo 
		And Art.ARTIC_Codigo <> '1301001'
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where CONVERT(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	
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
	And Doc.ENTID_CodigoCliente = ISNULL(@ENTID_Codigo, Doc.ENTID_CodigoCliente)
	And DDocs.ARTIC_Codigo = IsNull(@ARTIC_Codigo, DDocs.ARTIC_Codigo)
Order By Doc.ENTID_CodigoCliente, Doc.DOCVE_Codigo, DDocs.DOCVD_Item

If IsNull(@DesBloqueo, 0) = 1
	Select * From #Ventas As Doc
Else
	Select * From #Ventas As Doc
	Where CONVERT(Date, Doc.DOCVE_FechaDocumento) > DATEADD(Month, @Tiempo, Convert(Date, GETDATE()))


GO 
/***************************************************************************************************************************************/ 

