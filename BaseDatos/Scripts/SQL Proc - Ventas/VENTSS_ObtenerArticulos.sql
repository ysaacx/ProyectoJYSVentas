--USE BDJAYVIC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENTSS_ObtenerArticulos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENTSS_ObtenerArticulos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 29/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENTSS_ObtenerArticulos]
(
	 @PERIO_Codigo VarChar(6)
	,@ALMAC_Id CodAlmacen
	,@ZONAS_Codigo CodigoZona
	,@LINEA_Codigo VarChar(8)
)
As

Declare @TipoCambio Decimal(10, 4)
Set @TipoCambio = (Select TIPOC_VentaOficina From TipoCambio Where TIPOC_Fecha = (Select MAX(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0))
Print @TipoCambio

Select Uni.TIPOS_Descripcion As TIPOS_UnidadMedida
	, Uni.TIPOS_DescCorta As TIPOS_UndMedCorta
    , ARTIC_CodigoAlterno
	--,Pre.PRECI_Precio
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
	,Pre.TIPOS_CodTipoMoneda
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ROUND(((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ), 2) * @TipoCambio
					Else ROUND(((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ), 2)
		End
	 As PrecioXMayor
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ROUND(((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ), 2) * @TipoCambio
					Else ROUND(((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ), 2)
		End
	 As PrecioPublico
	
	--,Art.*
	,Art.ARTIC_Codigo
	,LINEA_Codigo
	--,ARTIC_Detalle
	,ARTIC_Descripcion
	,IsNull(ARTIC_Orden, 99) As ARTIC_Orden
	,TIPOS_CodCategoria
	,TIPOS_CodUnidadMedida
	,TIPOS_CodTipoProducto
	,Art.ARTIC_Percepcion
	,Art.ARTIC_Peso
   , ALPRE_PorcentaVenta1 = LArt.ALPRE_PorcentaVenta
   , ALPRE_PorcentaVenta2 = LArtP.ALPRE_PorcentaVenta
From dbo.Articulos As Art 
	Inner Join dbo.Tipos As Uni On Uni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo And LArt.LPREC_Id = 1 And LArt.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArtP On LArtP.ARTIC_Codigo = Art.ARTIC_Codigo And LArtP.LPREC_Id = 2 And LArtP.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo And Pre.ZONAS_Codigo = @ZONAS_Codigo
	--Left Join Precios As  Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo
WHERE ISNULL(Art.LINEA_Codigo, '') = isnull(@LINEA_Codigo, ISNULL(Art.LINEA_Codigo, ''))
	And IsNull(Art.ARTIC_Descontinuado, 0) = 0
Order By ARTIC_Orden ASC

GO 
/***************************************************************************************************************************************/ 

--exec VENTSS_ObtenerArticulos @PERIO_Codigo=N'2014',@ALMAC_Id=1,@ZONAS_Codigo=N'54.00',@LINEA_Codigo=N'0101'
--exec VENTSS_ObtenerArticulos @PERIO_Codigo=N'2016',@ALMAC_Id=1,@ZONAS_Codigo=N'54.00',@LINEA_Codigo=NULL 
