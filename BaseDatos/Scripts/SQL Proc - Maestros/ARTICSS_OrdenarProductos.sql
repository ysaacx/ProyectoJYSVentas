GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_OrdenarProductos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_OrdenarProductos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 09/10/2013
-- Descripcion         : Obtener el listado de Productos para Ordenarlos
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_OrdenarProductos]
(
	 @PERIO_Codigo VarChar(6)
	,@ALMAC_Id CodAlmacen
	,@ZONAS_Codigo CodigoZona
	,@Linea VarChar(10) = Null
	,@SubLinea VarChar(10) = Null
	,@Fecha DateTime = Null
)
As

Select Li.LINEA_Codigo
	,Li.LINEA_Nombre As Linea
	,SLi.LINEA_Nombre As SubLinea
	,ARTIC_Descripcion As Descripcion
	,IsNull(ARTIC_Orden, 99) As Orden
	,TIPOS_CodCategoria
	,TIPOS_CodUnidadMedida
	,TIPOS_CodTipoProducto
	,Art.*
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

