GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_ObtDetPedidoReposicion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_ObtDetPedidoReposicion] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/07/2013
-- Descripcion         : Obtener el detalle del documento de venta para generar la guia de remision
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_ObtDetPedidoReposicion]
(
	 @PEDID_Codigo VarChar(14)
	,@ALMAC_Id SmallInt
)
As

Select Art.ARTIC_Descripcion As ARTIC_Descripcion
	,PDet.PDDET_Item
	, Art.ARTIC_Codigo As ARTIC_Codigo
	, Art.ARTIC_Peso As ARTIC_Peso
	, Art.ARTIC_Percepcion As ARTIC_Percepcion
	, Art.ARTIC_Peso As PDDET_PesoUnitario
	, Art.TIPOS_CodUnidadMedida As TIPOS_CodUnidadMedida
	, TUni.TIPOS_Descripcion As TIPOS_Descripcion
	, TUni.TIPOS_DescCorta As TIPOS_UnidadMedida
	, Alm.ALMAC_Descripcion As ALMAC_Descripcion
	, 0.00 As Entregado
	,PDet.PDDET_Cantidad
	, PDet.PDDET_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0) As Diferencia
	,(Select SUM(DDTRA_Cantidad)
		From (
				Select ARTIC_Codigo, Sum(Det.GUIRD_Cantidad) As DDTRA_Cantidad, ALMAC_IdOrigen
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.PEDID_Codigo = PDet.PEDID_Codigo
						And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Group By ARTIC_Codigo, ALMAC_IdOrigen
				
			) As DetOrd
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		) SaldoArticulos
From Ventas.VENT_PedidosDetalle As PDet 
	Left Join  (
				 Select DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario, Sum(DDTRA_Cantidad) As DDTRA_Cantidad From (
					Select C.DOCVE_Codigo, D.ARTIC_Codigo, D.GUIRD_PesoUnitario, Sum(D.GUIRD_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_GuiasRemision As C
						Inner Join Logistica.DIST_GuiasRemisionDetalle As D On D.GUIAR_Codigo = C.GUIAR_Codigo
					Where C.PEDID_Codigo = @PEDID_Codigo
						And C.GUIAR_Estado <> 'X'
					Group By C.DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
				 ) As Tabla
				 Group By DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
				) 
		As Guia On Guia.DOCVE_Codigo = PDet.PEDID_Codigo And Guia.ARTIC_Codigo = PDet.ARTIC_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = PDet.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = PDet.ALMAC_Id
WHERE PDet.PEDID_Codigo = @PEDID_Codigo


GO 
/***************************************************************************************************************************************/ 

