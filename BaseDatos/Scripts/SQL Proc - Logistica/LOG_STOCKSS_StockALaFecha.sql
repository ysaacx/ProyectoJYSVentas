USE BDCOMAFISUR
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_STOCKSS_StockALaFecha]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_STOCKSS_StockALaFecha] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/08/2013
-- Descripcion         : Obtener el stock actual de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSS_StockALaFecha]
(
	 @PERIO_Codigo VarChar(6)
	,@ALMAC_Id CodAlmacen
	,@ZONAS_Codigo CodigoZona
	,@Linea VarChar(10) = Null
	,@SubLinea VarChar(10) = Null
	,@Fecha DateTime = Null
)
As

Declare @TipoCambio Decimal(6, 4)
Set @TipoCambio = (Select TIPOC_VentaOficina From TipoCambio Where TIPOC_Fecha = (Select MAX(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0))


Select 
	Art.ARTIC_Codigo As Codigo
	,Li.LINEA_Codigo
	,Li.LINEA_Nombre As Linea
	,SLi.LINEA_Nombre As SubLinea
	,ARTIC_Descripcion As Descripcion
	,IsNull(ARTIC_Orden, 99) As Orden
	,TIPOS_CodCategoria
	,TIPOS_CodUnidadMedida
	,TIPOS_CodTipoProducto
	,Art.ARTIC_Percepcion
	,Art.ARTIC_Peso
	,(Select SUM(Ingreso) - SUM(Salida) As STOCK_Cantidad
		From
		(
			Select LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
			From Logistica.LOG_Stocks LSt
				Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
			Where ARTIC_Codigo = Art.ARTIC_Codigo 
				And Lst.ALMAC_Id = @ALMAC_Id 
				And PERIO_Codigo = @PERIO_Codigo
				And LSt.STOCK_Estado <> 'X'
				And ZONAS_Codigo = @ZONAS_Codigo
				And Convert(Date, LSt.STOCK_Fecha) <= ISNULL(@Fecha, Convert(Date, LSt.STOCK_Fecha))
			Union All
			Select SI.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STINI_Cantidad, 0 
			From Logistica.LOG_StockIniciales As SI
				Inner Join Almacenes As Alm On Alm.ALMAC_Id = SI.ALMAC_Id
			Where ARTIC_Codigo = Art.ARTIC_Codigo
				And SI.ALMAC_Id = @ALMAC_Id 
				And PERIO_Codigo = @PERIO_Codigo
				And ZONAS_Codigo = @ZONAS_Codigo
		) As C
	 Group By ALMAC_Id, ARTIC_Codigo, ALMAC_Descripcion) As Stock
	,Pre.TIPOS_CodTipoMoneda
    , UCosto = isnull((SELECT TOP 1 ISNULL(DOCCD.DOCCD_CostoIGV, DOCCD.DOCCD_Costo)
                  FROM Logistica.ABAS_DocsCompra DOCCO
                 INNER JOIN Logistica.ABAS_DocsCompraDetalle DOCCD ON DOCCD.DOCCO_Codigo = DOCCO.DOCCO_Codigo AND DOCCD.ENTID_CodigoProveedor = DOCCO.ENTID_CodigoProveedor
                 WHERE DOCCD.ARTIC_Codigo = Art.ARTIC_Codigo
                   AND YEAR(DOCCO.DOCCO_FechaDocumento) = CONVERT(INT, @PERIO_Codigo)
                   AND CONVERT(VARCHAR(10), DOCCO.DOCCO_FechaDocumento, 112)
                    = (SELECT CONVERT(VARCHAR(10), MAX(DOCCO_BASE.DOCCO_FechaDocumento), 112)
                         FROM Logistica.ABAS_DocsCompra DOCCO_BASE
                        INNER JOIN Logistica.ABAS_DocsCompraDetalle DOCCD_BASE ON DOCCD_BASE.DOCCO_Codigo = DOCCO_BASE.DOCCO_Codigo AND DOCCD_BASE.ENTID_CodigoProveedor = DOCCO_BASE.ENTID_CodigoProveedor
                        WHERE YEAR(DOCCO_BASE.DOCCO_FechaDocumento) = CONVERT(INT, @PERIO_Codigo)
                          AND DOCCD_BASE.ARTIC_Codigo = Art.ARTIC_Codigo
                      )
                   ), 0)
    , (SELECT CONVERT(VARCHAR(10), MAX(DOCCO_BASE.DOCCO_FechaDocumento), 112)
                         FROM Logistica.ABAS_DocsCompra DOCCO_BASE
                        INNER JOIN Logistica.ABAS_DocsCompraDetalle DOCCD_BASE ON DOCCD_BASE.DOCCO_Codigo = DOCCO_BASE.DOCCO_Codigo AND DOCCD_BASE.ENTID_CodigoProveedor = DOCCO_BASE.ENTID_CodigoProveedor
                        WHERE YEAR(DOCCO_BASE.DOCCO_FechaDocumento) = CONVERT(INT, @PERIO_Codigo)
                          AND DOCCD_BASE.ARTIC_Codigo = Art.ARTIC_Codigo
                      )
	--,Case Pre.TIPOS_CodTipoMoneda 
	--	When 'MND2' Then ((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
	--				Else ((LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
	--	End
	-- As PrecioXMayor
	--,Case Pre.TIPOS_CodTipoMoneda 
	--	When 'MND2' Then ((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 ) * @TipoCambio
	--				Else ((LArtP.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 )
	--	End
	-- As PrecioPublico
From Articulos As Art
	Inner Join dbo.Tipos As Uni On Uni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo And LArt.LPREC_Id = 1 And LArt.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArtP On LArtP.ARTIC_Codigo = Art.ARTIC_Codigo And LArtP.LPREC_Id = 2 And LArtP.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo And Pre.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Lineas As Li On Li.LINEA_Codigo = Left(Art.LINEA_Codigo, 2) And Li.LINEA_Codigo = IsNull(@Linea, Li.LINEA_Codigo)
	Inner Join Lineas As SLi On SLi.LINEA_Codigo = Art.LINEA_Codigo And SLi.LINEA_Codigo = IsNull(@SubLinea, SLi.LINEA_Codigo)
	--Left Join Precios As  Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo
Where IsNull(Art.ARTIC_Descontinuado, 0) = 0
Order By Li.LINEA_Nombre, SLi.LINEA_Nombre, Art.ARTIC_Orden
	



GO 
/***************************************************************************************************************************************/ 

exec LOG_STOCKSS_StockALaFecha @PERIO_Codigo=N'2020',@ALMAC_Id=1,@ZONAS_Codigo=N'84.00',@Linea=NULL,@SubLinea=NULL,@Fecha='2020-12-26 17:49:32.257'