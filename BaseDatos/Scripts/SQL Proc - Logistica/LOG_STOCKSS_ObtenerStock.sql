GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_STOCKSS_ObtenerStock]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_STOCKSS_ObtenerStock] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 31/08/2012
-- Descripcion         : Obtener el stock actual de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSS_ObtenerStock]
(
	 @PERIO_Codigo VarChar(6)
	,@ARTIC_Codigo CodArticulo
	,@ZONAS_Codigo CodigoZona
)
As

Select ALMAC_Id, ALMAC_Descripcion, ARTIC_Codigo, SUM(Ingreso) - SUM(Salida) As STOCK_Cantidad
From
(
	Select LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	From Logistica.LOG_Stocks LSt
		Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	Where ARTIC_Codigo = @ARTIC_Codigo 
		And PERIO_Codigo = @PERIO_Codigo
		And LSt.STOCK_Estado <> 'X'
		And ZONAS_Codigo = @ZONAS_Codigo
	Union All
	Select SI.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STINI_Cantidad, 0 
	From Logistica.LOG_StockIniciales As SI
		Inner Join Almacenes As Alm On Alm.ALMAC_Id = SI.ALMAC_Id
	Where ARTIC_Codigo = @ARTIC_Codigo 
		And PERIO_Codigo = @PERIO_Codigo
		And ZONAS_Codigo = @ZONAS_Codigo
) As C
Group By ALMAC_Id, ARTIC_Codigo, ALMAC_Descripcion


GO 
/***************************************************************************************************************************************/ 

EXEC dbo.LOG_STOCKSS_ObtenerStock    @PERIO_Codigo = '2017', -- varchar(6)
    @ARTIC_Codigo = NULL, -- CodArticulo
    @ZONAS_Codigo = NULL -- CodigoZona
