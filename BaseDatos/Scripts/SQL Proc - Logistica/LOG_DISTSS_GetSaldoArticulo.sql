USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_GetSaldoArticulo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_GetSaldoArticulo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_GetSaldoArticulo]
(
	 @DOCVE_Codigo VarChar(13)
	,@ARTIC_Codigo VarChar(7)
	,@Orden Bit = Null
)
As

If IsNull(@Orden, 0) = 0
Begin

	Select 
		DOCVD_Cantidad - IsNull((Select Sum(Det.GUIRD_Cantidad) From Logistica.DIST_GuiasRemisionDetalle As Det
									Inner Join Logistica.DIST_GuiasRemision As Cab On Cab.GUIAR_Codigo = Det.GUIAR_Codigo
									Where Cab.DOCVE_Codigo = VDet.DOCVE_Codigo And Det.ARTIC_Codigo = VDet.ARTIC_Codigo
										And Cab.GUIAR_Estado <> 'X'
		  ), 0) As Saldo
	From Ventas.VENT_DocsVentaDetalle As VDet
	Where DOCVE_Codigo = @DOCVE_Codigo
		And ARTIC_Codigo = @ARTIC_Codigo
		
--DOCVE_Serie = '001' And TIPOS_CodTipoDocumento = 'CPD01'
End
Else
Begin
	Select 
		ORDET_Cantidad - IsNull((Select Sum(Det.GUIRD_Cantidad) From Logistica.DIST_GuiasRemisionDetalle As Det
			Inner Join Logistica.DIST_GuiasRemision As Cab On Cab.GUIAR_Codigo = Det.GUIAR_Codigo
		  Where Cab.DOCVE_Codigo = VDet.ORDEN_Codigo And Det.ARTIC_Codigo = VDet.ARTIC_Codigo And Cab.GUIAR_Estado <> 'X'), 0) As Saldo
	From Logistica.DIST_OrdenesDetalle As VDet
	Where ORDEN_Codigo = @DOCVE_Codigo
		And ARTIC_Codigo = @ARTIC_Codigo
End



GO 
/***************************************************************************************************************************************/ 

