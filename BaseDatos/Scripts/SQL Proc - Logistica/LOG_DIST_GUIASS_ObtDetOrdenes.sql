GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_GUIASS_ObtDetOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDetOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 02/02/2013
-- Descripcion         : Obtener el detalle del documento de venta para generar la guia de remision
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtDetOrdenes]
(
	 @ORDEN_Codigo VarChar(14)
	,@ALMAC_Id SmallInt
)
As

Select IsNull(Guia.DDTRA_Cantidad, 0.0) As Entregado
	, DDocs.ORDET_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0) As Diferencia
	, ARTIC_Descripcion, TIPOS_Descripcion As TIPOS_UnidadMedida
	, TIPOS_DescCorta As TIPOS_UnidadMedidaCorta
	--, Alm.ALMAC_Descripcion
	, DDocs.ORDET_Cantidad DOCVD_Cantidad
	, Art.ARTIC_Peso As DOCVD_PesoUnitario
	, DDocs.ARTIC_Codigo
	, DDocs.ORDET_Item As  DOCVD_Item
From Logistica.DIST_OrdenesDetalle As DDocs
	Left Join  (
					Select C.ORDEN_Codigo, D.ARTIC_Codigo, D.GUIRD_PesoUnitario, Sum(D.GUIRD_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_GuiasRemision As C
						Inner Join Logistica.DIST_GuiasRemisionDetalle As D On D.GUIAR_Codigo = C.GUIAR_Codigo
					Where C.ORDEN_Codigo = @ORDEN_Codigo
						And C.GUIAR_Estado <> 'X'
					Group By C.ORDEN_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
				) 
		As Guia On Guia.ORDEN_Codigo = DDocs.ORDEN_Codigo And Guia.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	--Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
Where DDocs.ORDEN_Codigo = @ORDEN_Codigo --And DDocs.ALMAC_Id = @ALMAC_Id
	And (DDocs.ORDET_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0)) > 0
Order By DOCVD_Item



GO 
/***************************************************************************************************************************************/ 

