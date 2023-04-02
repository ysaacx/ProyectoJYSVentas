GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_GUIASS_ObtDetDocVenta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDetDocVenta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/09/2012
-- Descripcion         : Obtener el detalle del documento de venta para generar la guia de remision
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDetDocVenta]
(
	 @DOCVE_Codigo VarChar(14)
	,@ALMAC_Id SmallInt
)
As

Select IsNull(Guia.DDTRA_Cantidad, 0.0) As Entregado
	, DDocs.DOCVD_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0) As Diferencia
	, ARTIC_Descripcion, TIPOS_Descripcion As TIPOS_UnidadMedida
	, TIPOS_DescCorta As TIPOS_UnidadMedidaCorta
	, Alm.ALMAC_Descripcion
	, DDocs.DOCVD_Cantidad
	, Art.ARTIC_Peso As DOCVD_PesoUnitario
	, DDocs.ARTIC_Codigo
	, DDocs.DOCVD_Item
	, Art.TIPOS_CodUnidadMedida
	,DDocs.ALMAC_Id
From Ventas.VENT_DocsVentaDetalle As DDocs
	Left Join  (
				 Select DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario, Sum(DDTRA_Cantidad) As DDTRA_Cantidad From (
					Select C.DOCVE_Codigo, D.ARTIC_Codigo, D.GUIRD_PesoUnitario, Sum(D.GUIRD_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_GuiasRemision As C
						Inner Join Logistica.DIST_GuiasRemisionDetalle As D On D.GUIAR_Codigo = C.GUIAR_Codigo
					Where C.DOCVE_Codigo = @DOCVE_Codigo
						And C.GUIAR_Estado <> 'X'
					Group By C.DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
					Union All
					Select C.DOCVE_Codigo, D.ARTIC_Codigo, Art.ARTIC_Peso, Sum(D.ORDET_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_Ordenes As C
						Inner Join Logistica.DIST_OrdenesDetalle As D On D.ORDEN_Codigo = C.ORDEN_Codigo
						Inner Join Articulos As Art On Art.ARTIC_Codigo = D.ARTIC_Codigo 
					Where C.DOCVE_Codigo = @DOCVE_Codigo
						And C.ORDEN_Estado <> 'X'
					Group By C.DOCVE_Codigo, D.ARTIC_Codigo, Art.ARTIC_Peso
				 ) As Tabla
				 Group By DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
				) 
		As Guia On Guia.DOCVE_Codigo = DDocs.DOCVE_Codigo And Guia.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where DDocs.DOCVE_Codigo = @DOCVE_Codigo
	--And DDocs.ALMAC_Id = @ALMAC_Id
	And (DDocs.DOCVD_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0)) > 0
Order By DDocs.DOCVD_Item



GO 
/***************************************************************************************************************************************/ 

