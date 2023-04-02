GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_ObtenerPrecioLista]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_ObtenerPrecioLista] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/07/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo por codigo de lista
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_ObtenerPrecioLista]
(
	 @ARTIC_Codigo CodArticulo
	 ,@ZONAS_Codigo vARcHAR(5)
	 ,@LPREC_Id Integer
)
As

Select Lista.LPREC_Id, Lista.LPREC_Descripcion,
	LArt.ALPRE_PorcentaVenta
	,(LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PrecioCalculado
	,(LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PrecioOriginal
	,Pre.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMonedaCorta
	,TMon.TIPOS_Descripcion As TIPOS_TipoMoneda
from Articulos As Arti
	Inner Join [Ventas].[VENT_ListaPreciosArticulos] As LArt On LArt.ARTIC_Codigo = Arti.ARTIC_Codigo
	Inner Join [Ventas].[VENT_ListaPrecios] As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
	Inner Join Precios As Pre On Pre.ARTIC_Codigo = Arti.ARTIC_Codigo And Pre.ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Pre.TIPOS_CodTipoMoneda
Where Arti.ARTIC_Codigo = @ARTIC_Codigo  
	And Lista.ZONAS_Codigo = @ZONAS_Codigo
	And Lista.LPREC_Id = @LPREC_Id
Order By Lista.LPREC_Id


GO 
/***************************************************************************************************************************************/ 

