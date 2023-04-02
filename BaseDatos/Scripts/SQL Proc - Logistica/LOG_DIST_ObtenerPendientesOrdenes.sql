GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_ObtenerPendientesOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_ObtenerPendientesOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 30/01/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_ObtenerPendientesOrdenes]
(
	 @FecFin DateTime
	,@ALMAC_Id SmallInt
	,@PVENT_Id BigInt = Null
	,@DesBloqueo Bit = Null
)
As

Declare @Tiempo Integer 
Select @Tiempo = (-1 * PARMT_Valor) From Parametros Where PARMT_Id = 'pg_TPendiente'

Select Distinct
	Cab.ORDEN_Codigo
	,Cab.DOCVE_Codigo + '/' + Cab.ORDEN_Codigo As DOCVE_Codigo
	,'OR ' + Cab.ORDEN_Serie + '-' + Right('0000000' + RTRIM(Cab.ORDEN_Numero), 7) 
	 + ' / ' + TDoc.TIPOS_DescCorta + ' ' + Right(Left(DOCVE_Codigo, 5), 3) + '-' + Right(DOCVE_Codigo, 7)
	 As Documento
	,Cab.ORDEN_FechaDocumento
	,Cab.ORDEN_FechaEntrega
	,Cab.ORDEN_FechaEntrega As ORDEN_FechaEntrega_Old
	,Cab.ORDEN_FechaIngreso
	,Cab.ENTID_CodigoCliente
	,Cab.ORDEN_DescripcionCliente As Cliente
	,'' DOCVE_EstEntrega
	,Cab.PVENT_Id
	,Cab.PVENT_IdOrigen
	,Cab.PVENT_IdDestino
Into #Ventas
From Logistica.DIST_Ordenes As Cab 
	Inner Join Logistica.DIST_OrdenesDetalle As DDocs On Cab.ORDEN_Codigo = DDocs.ORDEN_Codigo And Cab.ORDEN_Estado <> 'X'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = 'CPD' + Left(Cab.DOCVE_Codigo, 2)
	--Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where CONVERT(Date, ORDEN_FechaEntrega) <= @FecFin
	--And DDocs.ALMAC_Id = @ALMAC_Id
	--And DOCVE_EstEntrega = 'P'
	And Cab.PVENT_IdDestino = @PVENT_Id
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
Order By Documento, ENTID_CodigoCliente

If IsNull(@DesBloqueo, 0) = 1
	Select * From #Ventas As Doc
Else
Begin
	Select * From #Ventas As Doc
	Where CONVERT(Date, Doc.ORDEN_FechaDocumento) > DATEADD(Month, @Tiempo, Convert(Date, GETDATE()))
	
End	


GO 
/***************************************************************************************************************************************/ 

