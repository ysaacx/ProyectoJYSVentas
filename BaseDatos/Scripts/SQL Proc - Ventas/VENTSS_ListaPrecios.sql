GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENTSS_ListaPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENTSS_ListaPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 29/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENTSS_ListaPrecios]
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
	,Lin.LINEA_Nombre As Linea
	,SubLin.LINEA_Nombre As SubLinea
	--,ARTIC_Detalle
	,ARTIC_Descripcion
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
		When 'MND2' Then ((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
					Else ((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
		End
	 As Lista1
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
					Else ((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
		End
	 As Lista2
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ((LArt3.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
					Else ((LArt3.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
		End
	 As Lista3
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ((LArt4.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
					Else ((LArt4.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
		End
	 As Lista4
	,Case Pre.TIPOS_CodTipoMoneda 
		When 'MND2' Then ((LArt5.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
					Else ((LArt5.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
		End
	 As Lista5
	,Uni.TIPOS_Descripcion As TIPOS_UnidadMedida
	, Uni.TIPOS_DescCorta As TIPOS_UndMedCorta
	--,Art.*
	,IsNull(ARTIC_Orden, 99) As ARTIC_Orden
	,TIPOS_CodCategoria
	,TIPOS_CodUnidadMedida
	,TIPOS_CodTipoProducto
	,Art.ARTIC_Percepcion
	,Art.ARTIC_Peso
	,LArt.ALPRE_PorcentaVenta
	,LArtP.ALPRE_PorcentaVenta
	,LArt3.ALPRE_PorcentaVenta
	,LArt4.ALPRE_PorcentaVenta
	,LArt5.ALPRE_PorcentaVenta
From dbo.Articulos As Art 
	Inner Join dbo.Tipos As Uni On Uni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
	Inner Join Lineas As SubLin On SubLin.LINEA_Codigo = Art.LINEA_Codigo
	Inner Join Lineas As Lin On Lin.LINEA_Codigo = Left(Art.LINEA_Codigo, 2)
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo And LArt.LPREC_Id = 1 And LArt.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArtP On LArtP.ARTIC_Codigo = Art.ARTIC_Codigo And LArtP.LPREC_Id = 2 And LArtP.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt3 On LArt3.ARTIC_Codigo = Art.ARTIC_Codigo And LArt3.LPREC_Id = 3 And LArt3.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt4 On LArt4.ARTIC_Codigo = Art.ARTIC_Codigo And LArt4.LPREC_Id = 4 And LArt4.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt5 On LArt5.ARTIC_Codigo = Art.ARTIC_Codigo And LArt5.LPREC_Id = 5 And LArt5.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo And Pre.ZONAS_Codigo = @ZONAS_Codigo
	--Left Join Precios As  Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo
WHERE IsNull(Art.ARTIC_Descontinuado, 0) = 0
	And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	And Art.ARTIC_Descripcion Like '%' + IsNull(@Articulo, '') + '%'
Order By Linea, SubLinea, ARTIC_Orden ASC



GO 
/***************************************************************************************************************************************/ 

