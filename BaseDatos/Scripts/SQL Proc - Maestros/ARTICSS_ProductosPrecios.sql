GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_ProductosPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_ProductosPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_ProductosPrecios]
(
	  @ZONAS_Codigo VarChar(5)
	 ,@LINEA_Codigo CodigoLinea = Null
)
As

Select Art.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,ARTIC_Orden
	,ARTIC_Peso
	,Art.LINEA_Codigo
	,SL.LINEA_Nombre As LINEA_Nombre
	,L.LINEA_Nombre As SubLinea
	,TProd.TIPOS_Descripcion As TIPOS_Producto
	,TCat.TIPOS_Descripcion As TIPOS_Categoria
	,TUni.TIPOS_DescCorta As TIPOS_UndMedCorta
	,TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
	,Col.TIPOS_Descripcion
	--,TMon.TIPOS_DescCorta As TIPOS_TipoMonedaCorta
	--,TMon.TIPOS_Descripcion As TIPOS_TipoMoneda
Into #Artic
From Articulos Art
	Inner Join Lineas As L		On L.LINEA_Codigo = Art.LINEA_Codigo
	Inner Join Lineas As SL		On SL.LINEA_Codigo = L.LINEA_CodPadre
	Inner Join Tipos As TProd	On TProd.TIPOS_Codigo = Art.TIPOS_CodTipoProducto
	Inner Join Tipos As TCat	On TCat.TIPOS_Codigo = Art.TIPOS_CodCategoria
	Inner Join Tipos As TUni	On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	--Inner Join Tipos As TMon	On TMon.TIPOS_Codigo = Art.TIPOS_CodTipoMoneda
	Left Join Tipos As Col		On Col.TIPOS_Codigo = Art.TIPOS_CodTipoColor
Where Art.LINEA_Codigo = ISNULL(@LINEA_Codigo, Art.LINEA_Codigo)
Order By ARTIC_Codigo, ARTIC_Detalle			

Select * From #Artic

Select Lista.LPREC_Id
	, Arti.ARTIC_Codigo
	, Lista.LPREC_Descripcion,
	LArt.ALPRE_PorcentaVenta
	, Pre.PRECI_Precio
	,(LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PrecioCalculado
	,(LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PrecioOriginal
	,Pre.TIPOS_CodTipoMoneda
from Articulos As Arti
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt On LArt.ARTIC_Codigo = Arti.ARTIC_Codigo
	Inner Join [Ventas].[VENT_ListaPrecios] As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Arti.ARTIC_Codigo
Where Arti.ARTIC_Codigo In (Select ARTIC_Codigo From #Artic)  And Lista.ZONAS_Codigo = @ZONAS_Codigo
--Order By Lista.LPREC_Id

Select * from Ventas.VENT_ListaPrecios Where ZONAS_Codigo = @ZONAS_Codigo

Drop Table #Artic




GO 
/***************************************************************************************************************************************/ 

