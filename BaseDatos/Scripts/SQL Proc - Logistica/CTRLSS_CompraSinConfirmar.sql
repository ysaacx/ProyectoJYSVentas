GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRLSS_CompraSinConfirmar]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRLSS_CompraSinConfirmar] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRLSS_CompraSinConfirmar]
(
	 @FecFin DateTime
	,@ALMAC_Id SmallInt
	,@Linea VarChar(10) = Null
)
As

Select Det.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,Det.INGCD_Cantidad

Into #Compras
From Logistica.ABAS_IngresosCompra As Cab
	Inner Join Logistica.ABAS_IngresosCompraDetalle As Det On Det.ALMAC_Id = Cab.ALMAC_Id And Det.INGCO_Id = Cab.INGCO_Id
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like @Linea + '%'
Where Not INGCO_Estado In ('C', 'X')
	And Cab.ALMAC_Id = @ALMAC_Id

Select ARTIC_Codigo, ARTIC_Detalle, SUM(INGCD_Cantidad) As Saldo, COUNT(*)
From #Compras
Group By ARTIC_Codigo
	,ARTIC_Detalle


GO 
/***************************************************************************************************************************************/ 

