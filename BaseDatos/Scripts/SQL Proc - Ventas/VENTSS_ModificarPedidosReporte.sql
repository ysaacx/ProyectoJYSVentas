GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENTSS_ModificarPedidosReporte]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENTSS_ModificarPedidosReporte] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 25/07/2013
-- Descripcion         : Modificar los datos adicionales de la cotizacion
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENTSS_ModificarPedidosReporte]
(
	 @PEDID_Codigo VarChar(14)
	,@PEDID_Condiciones VarChar(120)
	,@PEDID_CondicionEntrega VarChar(120)
	,@PEDID_Nota VarChar(120)
)
As


Update Ventas.VENT_Pedidos
Set PEDID_Condiciones = @PEDID_Condiciones
	,PEDID_CondicionEntrega = @PEDID_CondicionEntrega
	,PEDID_Nota = @PEDID_Nota
	,PEDID_ModReporte = 1
Where PEDID_Codigo = @PEDID_Codigo


GO 
/***************************************************************************************************************************************/ 

