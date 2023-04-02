USE BDInkasFerro_Parusttacca
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_CargarPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_CargarPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_CargarPrecios]
(
      @ZONAS_Codigo VarChar(5)
    , @Linea CodigoLinea = Null
    , @Cadena VarChar(50)
    , @Fecha DateTime = NULL
    , @TipoConsulta CHAR(1) = NULL   
    , @PERIO_Codigo VarChar(6)   = NULL
    , @ALMAC_Id CodAlmacen       = NULL
)
As

/*
   M => Modificados
   P => Productos
*/

Declare @TipoCambio Decimal(10, 4)
Set @TipoCambio = (Select TIPOC_VentaOficina From TipoCambio Where TIPOC_Fecha = (Select MAX(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0))

 SELECT Art.ARTIC_Codigo
      , ARTIC_Descripcion
      , Pre.PRECI_Precio 
      , CASE Pre.TIPOS_CodTipoMoneda When 'MND2' Then Pre.PRECI_Precio Else Pre.PRECI_Precio / Pre.PRECI_TipoCambio End PrecioDolares
        --, Pre.PRECI_Precio
        --,Pre.PRECI_TipoCambio
      , @TipoCambio As PRECI_TipoCambio
      , Pre.PRECI_FecMod
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
      , ARTIC_NuevoIngreso = ISNULL(ARTIC_NuevoIngreso, 0)
      , TipoConsulta = @TipoConsulta
   INTO #ART
   FROM Articulos As Art
  INNER JOIN Precios As Pre ON Pre.ARTIC_Codigo = Art.ARTIC_Codigo 
    AND ZONAS_Codigo = @ZONAS_Codigo
    AND Convert(Date, IsNull(Pre.PRECI_FecMod, Pre.PRECI_FecCrea)) >= IsNull(@Fecha, Convert(Date, IsNull(Pre.PRECI_FecMod, Pre.PRECI_FecCrea)))
  WHERE LINEA_Codigo Like CASE ISNULL(@TipoConsulta, 'P') 
                                             WHEN 'P' THEN ISNULL(@Linea, LINEA_Codigo) + '%'
                                             WHEN 'M' THEN '%'
                                        END 
                                        --ISNULL(@Linea, LINEA_Codigo) + '%'
    AND ARTIC_Descripcion Like '%' + @Cadena + '%'
    AND ARTIC_Descontinuado <> 1
    AND CASE @TipoConsulta WHEN 'P' THEN 0 ELSE ISNULL(ARTIC_NuevoIngreso, 0) END  
         = CASE ISNULL(@TipoConsulta, 'P') 
                WHEN 'P' THEN ISNULL(ARTIC_NuevoIngreso, 0) --0
                WHEN 'M' THEN 1
            END 
  ORDER BY Art.ARTIC_Descripcion
    
 SELECT * FROM #ART ORDER BY ARTIC_Descripcion

 SELECT LPREC_Id, LPREC_Codigo, LPREC_Descripcion, LPREC_Comision 
      FROM VENTAS.VENT_ListaPrecios Where ZONAS_Codigo = @ZONAS_Codigo

  SELECT Pre.ARTIC_Codigo
       , Lista.LPREC_Id
         --,Pre.PRECI_Precio
       , (LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PRECI_Precio
       , LArt.ALPRE_PorcentaVenta
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Pre.TIPOS_CodTipoMoneda
       , LArt.ALPRE_Constante
       , ARTIC_NuevoIngreso = ''
      , TipoConsulta = ''
    into #LPrecios
    FROM Precios As Pre 
   INNER JOIN Articulos As Art On Art.ARTIC_Codigo = Pre.ARTIC_Codigo And Art.ARTIC_Descontinuado <> 1
   INNER JOIN Ventas.VENT_ListaPreciosArticulos As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo And LArt.ZONAS_Codigo = @ZONAS_Codigo
   INNER JOIN Ventas.VENT_ListaPrecios As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
   INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = Pre.TIPOS_CodTipoMoneda
   WHERE 
            --Art.LINEA_Codigo Like CASE ISNULL(@TipoConsulta, 'P') 
            --                        WHEN 'P' THEN IsNull(@Linea, LINEA_Codigo) + '%'
            --                        WHEN 'M' THEN '%'
            --                   END 
            --                   --IsNull(@Linea, LINEA_Codigo) + '%'
    --ARTIC_Descripcion Like '%' + @Cadena + '%'
        Pre.ZONAS_Codigo = @ZONAS_Codigo
    AND Art.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM #ART)
  ORDER BY Pre.ARTIC_Codigo, Lista.LPREC_Id


    
       --AND ZONAS_Codigo + '-' + rtrim(LPREC_Id) in (SELECT ZONAS_Codigo + '-' + rtrim(LPREC_Id) FROM #LPrecios)

  SELECT * FROM #LPrecios 
  ORDER BY ARTIC_Codigo, LPREC_Id
  --ORDER BY ARTIC_Descripcion


GO 
/***************************************************************************************************************************************/ 

--exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'83.00',@Linea=N'0101',@Cadena=N'1"  x',@TipoConsulta=N'P',@PERIO_Codigo=N'2017',@ALMAC_Id=1
exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'83.00',@Linea=N'0101',@Cadena='',@TipoConsulta=N'P',@PERIO_Codigo=N'2017',@ALMAC_Id=1

--exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'83.00',@Linea=N'1201',@Cadena=N'',@TipoConsulta=N'P'--,@PERIO_Codigo=N'2017',@ALMAC_Id=1
--exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'83.00',@Linea=N'0202',@Cadena=N'1.8',@TipoConsulta=N'P',@PERIO_Codigo=N'2017',@ALMAC_Id=1

--SELECT m_articulos.* , CodTip.TIPOS_Descripcion AS TIP_Descripcion
-- FROM dbo.Articulos AS m_articulos 
-- INNER JOIN dbo.Tipos AS CodTip ON CodTip.TIPOS_Codigo = m_articulos.TIPOS_CodTipoProducto WHERE  ISNULL(CONVERT(VARCHAR(100), m_Articulos.ARTIC_Detalle), '') LIKE '%Tubo Cuadrado 50 X 1.8%'
