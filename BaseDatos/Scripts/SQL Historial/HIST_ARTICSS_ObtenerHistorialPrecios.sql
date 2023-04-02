GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[HIST_ARTICSS_ObtenerHistorialPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[HIST_ARTICSS_ObtenerHistorialPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[HIST_ARTICSS_ObtenerHistorialPrecios]
(
     @ARTIC_Codigo CodArticulo
     ,@ZONAS_Codigo vARcHAR(5)
     ,@Cantidad Integer
)
As

Select Top (@Cantidad)
     *
From Historial.Precios
Where ARTIC_Codigo = @ARTIC_Codigo
Order By PRECI_Id Desc

Declare @Precio Integer
Set @Precio = (Select COUNT(*) From Ventas.VENT_ListaPrecios)


--Select LPREC_Id, LPREC_Codigo, LPREC_Descripcion, LPREC_Comision From Ventas.VENT_ListaPrecios Where ZONAS_Codigo = @ZONAS_Codigo

  SELECT TOP (@Cantidad * @Precio)
         Pre.PRECI_Id
       , Pre.ARTIC_Codigo   
       , Lista.LPREC_Id
       --,Pre.PRECI_Precio
       , (LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PRECI_Precio
       , LArt.ALPRE_PorcentaVenta
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Pre.TIPOS_CodTipoMoneda
       , LArt.ALPRE_Constante
    FROM Historial.Precios As Pre 
   Inner Join Articulos As Art On Art.ARTIC_Codigo = Pre.ARTIC_Codigo
   Inner Join Historial.VENT_ListaPreciosArticulos As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo
    And Pre.PRECI_Id = LArt.PRECI_Id
   Inner Join Ventas.VENT_ListaPrecios As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Pre.TIPOS_CodTipoMoneda
   WHERE Pre.ARTIC_Codigo = @ARTIC_Codigo
   ORDER By PRECI_Id Desc, ARTIC_Codigo


GO 
/***************************************************************************************************************************************/ 


exec HIST_ARTICSS_ObtenerHistorialPrecios @ARTIC_Codigo=N'1201001',@ZONAS_Codigo=N'83.00',@Cantidad=25