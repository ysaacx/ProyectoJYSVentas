GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_GUIASS_ObtDocVenta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDocVenta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/09/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDocVenta]
(
	 @TConsulta SmallInt
	,@Cadena VarChar(50)
	,@ALMAC_Id SmallInt
	,@PVENT_Id Id
	,@FecIni DateTime
	,@FecFin DateTime
	,@DesBloqueo Bit = Null
)
As

Declare @Tiempo Integer 
Select @Tiempo = (-1 * PARMT_Valor) From Parametros Where PARMT_Id = 'pg_TPendiente'

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
	,IsNull(Doc.DOCVE_DescripcionCliente, Cli.ENTID_RazonSocial) As ENTID_Cliente
	,Vend.ENTID_RazonSocial As ENTID_Vendedor
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Us.ENTID_RazonSocial As Usuario
	, (Select SUM(DDTRA_Cantidad)
		From (  /* Guias de Remision */
				Select ARTIC_Codigo, Sum(Det.GUIRD_Cantidad) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All /* Ordenes de Recojo */
				Select ARTIC_Codigo, Sum(Det.ORDET_Cantidad) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_Ordenes As Ing
						Inner Join Logistica.DIST_OrdenesDetalle As Det
							On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
								And Not ORDEN_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All 	/* Nota de Credito*/
				Select ARTIC_Codigo, SUM(IsNull(DetOrd.DOCVD_Cantidad, 0)), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
					Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
				Where DetOrd.ALMAC_Id = @ALMAC_Id
					And DetOrd.DOCVE_CodigoReferencia = Doc.DOCVE_Codigo
					And Cab.DOCVE_NCPendienteDespachos = 1
					And Cab.TIPOS_CodTipoDocumento = 'CPD07'
					--And Cab.docve_cod
				Group By ARTIC_Codigo, ALMAC_Id
				Union All /* Documento de Venta */
				Select ARTIC_Codigo, -1 * SUM(DetVen.DOCVD_Cantidad), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetVen
					Inner Join [Ventas].[VENT_DocsVenta] As CabVen On CabVen.DOCVE_Codigo = DetVen.DOCVE_Codigo
				Where DetVen.DOCVE_Codigo = Doc.DOCVE_Codigo 
					And DetVen.ALMAC_Id = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_Id
			) As DetOrd
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		) SaldoArticulos
	,(Case Doc.ENTID_CodigoCliente When '11000000000' Then ' - ' Else Doc.ENTID_CodigoCliente End) As ENTID_CodigoCliente
	,Doc.DOCVE_FechaDocumento
	,Doc.DOCVE_Serie
	,Doc.DOCVE_Numero
	,Doc.DOCVE_TotalPagar
	,Doc.DOCVE_Codigo
	,Doc.TIPOS_CodTipoDocumento
	,Doc.DOCVE_UsrCrea
	,Doc.DOCVE_FecCrea
	,Doc.DOCVE_PerGenGuia
   , Doc.DOCVE_EstEntrega
	--,Doc.*
Into #Ventas
From Ventas.VENT_DocsVenta As Doc
	Inner Join dbo.Entidades As Cli On Cli.ENTID_Codigo = Doc.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Doc.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Doc.DOCVE_UsrCrea
Where   ISNULL(DOCVE_Estado, '') = 'I' 
	And (Case @TConsulta 
			When 0 Then Cli.ENTID_RazonSocial 
			When 1 Then Doc.DOCVE_Codigo
			When 2 Then Us.ENTID_RazonSocial
			Else Cli.ENTID_RazonSocial 
		 End
		) Like '%' + @Cadena + '%'
	AND Doc.DOCVE_EstEntrega = 'P'
	AND  Convert(Date, DOCVE_FechaDocumento) Between @FecIni AND @FecFin
	AND  ISNULL(PVENT_Id, '') = @PVENT_Id
	And Abs((Select SUM(DDTRA_Cantidad)
		From (	
				/* Guias de Remision */
				Select ARTIC_Codigo, Sum(IsNull(Det.GUIRD_Cantidad, 0)) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
						And IsNull(Ing.GUIAR_FactMultiples, 0) = 0
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All /* Ordenes */
				Select ARTIC_Codigo, Sum(IsNull(Det.ORDET_Cantidad, 0)) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_Ordenes As Ing
						Inner Join Logistica.DIST_OrdenesDetalle As Det
							On Det.ORDEN_Codigo = Ing.ORDEN_Codigo
								And Not ORDEN_Estado = 'X'
					Where Ing.DOCVE_Codigo = Doc.DOCVE_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				Union All /* Nota de Credito */
				Select ARTIC_Codigo, SUM(IsNull(DetOrd.DOCVD_Cantidad, 0)), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
					Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
				Where DetOrd.ALMAC_Id = @ALMAC_Id
					And DetOrd.DOCVE_CodigoReferencia = Doc.DOCVE_Codigo
					And Cab.DOCVE_NCPendienteDespachos = 1
				Group By ARTIC_Codigo, ALMAC_Id
				Union All /* Documento de Venta */
				Select ARTIC_Codigo, -1 * SUM(IsNull(DetOrd.DOCVD_Cantidad, 0)), ALMAC_Id
				From [Ventas].[VENT_DocsVentaDetalle] As DetOrd
					Inner Join [Ventas].[VENT_DocsVenta] As Cab On Cab.DOCVE_Codigo = DetOrd.DOCVE_Codigo
				Where DetOrd.DOCVE_Codigo = Doc.DOCVE_Codigo 
					And DetOrd.ALMAC_Id = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_Id
				Union All /* Multiples Guias */
				Select GRVen.ARTIC_Codigo, Sum(IsNull(GUIVE_CantidadEntregada, 0)), @ALMAC_Id 
				From Logistica.DIST_GuiasRemisionVentas As GRVen
				Where GRVen.DOCVE_Codigo = Doc.DOCVE_Codigo
					--And GRVen.ENTID_CodigoCliente = Doc.ENTID_CodigoCliente
				Group By ARTIC_Codigo
			) As DetOrd
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		)) > 0

If IsNull(@DesBloqueo, 0) = 1
	Select * From #Ventas As Doc
Else
	Select * From #Ventas As Doc
	Where CONVERT(Date, Doc.DOCVE_FechaDocumento) > DATEADD(Month, @Tiempo, Convert(Date, GETDATE()))




GO 
/***************************************************************************************************************************************/ 



--exec LOG_DIST_GUIASS_ObtDocVenta @TConsulta=0,@Cadena=N'',@ALMAC_Id=1,@PVENT_Id=1,@FecIni='2019-04-10 00:00:00',@FecFin='2019-04-10 00:00:00',@DesBloqueo=1