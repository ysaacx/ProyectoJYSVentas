GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ORDENSS_ObtenerSaldoEntrega]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ORDENSS_ObtenerSaldoEntrega] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 31/08/2012
-- Descripcion         : Obtener el stock actual de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ORDENSS_ObtenerSaldoEntrega]
(
	 @ORDCO_Codigo VarChar(12)
)
As

Select Art.ARTIC_Codigo
	,DetOrd.ORDCD_Item
	,Art.ARTIC_Descripcion, TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
	,DetOrd.ORDCD_Cantidad As INGCD_CantidadTotal
	,Art.TIPOS_CodUnidadMedida As TIPOS_CodUnidadMedida
	,IsNull(Det.INGCD_Cantidad, 0.0) As Entregado
	,IsNull(DetOrd.ORDCD_Cantidad, 0.0) - IsNull(Det.INGCD_Cantidad, 0.0) As INGCD_Cantidad
	,IsNull(DetOrd.ORDCD_PesoUnitario, 0.0) As INGCD_PesoUnitario
From Logistica.ABAS_OrdenesCompraDetalle As DetOrd
	Left Join (
		Select ARTIC_Codigo, Sum(Det.INGCD_Cantidad) As INGCD_Cantidad
			from Logistica.ABAS_IngresosCompra As Ing
				Inner Join Logistica.ABAS_IngresosCompraDetalle As Det
					On Det.INGCO_Id = Ing.INGCO_Id
						And Det.ALMAC_Id = Ing.ALMAC_Id
						And Not INGCO_Estado = 'X'
			Where Ing.ORDCO_Codigo = @ORDCO_Codigo
		Group By ARTIC_Codigo
	) As Det 
		On Det.ARTIC_Codigo = DetOrd.ARTIC_Codigo
	Inner Join Articulos As Art
		On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
	Inner Join Tipos As TUni
		On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where DetOrd.ORDCO_Codigo = @ORDCO_Codigo


GO 
/***************************************************************************************************************************************/ 

