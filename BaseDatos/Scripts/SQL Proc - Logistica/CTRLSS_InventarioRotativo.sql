GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRLSS_InventarioRotativo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRLSS_InventarioRotativo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/02/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRLSS_InventarioRotativo]
(
	 @PERIO_Codigo VarChar(6)
	,@ALMAC_Id CodAlmacen
	,@ZONAS_Codigo CodigoZona
	,@Articulo VarChar(50)
	,@Linea VarChar(10) = Null
)
As

Declare @TipoCambio Decimal(10, 4)
Set @TipoCambio = (Select TIPOC_VentaOficina From TipoCambio Where TIPOC_Fecha = (Select MAX(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0))
Print @TipoCambio

Select Art.ARTIC_Codigo
	,Art.LINEA_Codigo
	,ARTIC_Descripcion
	,(
		Select SUM(Ingreso) - SUM(Salida) As STOCK_Cantidad
		From
		(
			Select LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, IsNull(STOCK_CantidadIngreso, 0) As Ingreso, IsNull(STOCK_CantidadSalida, 0) As Salida 
			From Logistica.LOG_Stocks LSt
				Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
			Where ARTIC_Codigo = Art.ARTIC_Codigo 
				And Lst.ALMAC_Id = @ALMAC_Id 
				And PERIO_Codigo = @PERIO_Codigo
				And LSt.STOCK_Estado <> 'X'
				And ZONAS_Codigo = @ZONAS_Codigo
			Union All
			Select SI.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, IsNull(STINI_Cantidad, 0), 0 
			From Logistica.LOG_StockIniciales As SI
				Inner Join Almacenes As Alm On Alm.ALMAC_Id = SI.ALMAC_Id
			Where ARTIC_Codigo = Art.ARTIC_Codigo
				And SI.ALMAC_Id = @ALMAC_Id 
				And PERIO_Codigo = @PERIO_Codigo
				And ZONAS_Codigo = @ZONAS_Codigo
		) As C
		Group By ALMAC_Id, ARTIC_Codigo, ALMAC_Descripcion
	) As StockLocal
	,Uni.TIPOS_Descripcion As TIPOS_UnidadMedida
	, Uni.TIPOS_DescCorta As TIPOS_UndMedCorta
	--,Art.*
	,IsNull(ARTIC_Orden, 99) As ARTIC_Orden
From dbo.Articulos As Art 
	Inner Join dbo.Tipos As Uni On Uni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo And Pre.ZONAS_Codigo = @ZONAS_Codigo
WHERE IsNull(Art.ARTIC_Descontinuado, 0) = 0
	And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	And Art.ARTIC_Descripcion Like '%' + IsNull(@Articulo, '') + '%'
Order By ARTIC_Orden ASC



GO 
/***************************************************************************************************************************************/ 

