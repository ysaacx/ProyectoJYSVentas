USE BDSisSCC

/*========================================================================================================================*/

UPDATE dbo.Parametros SET PARMT_Valor = '3.3.0.5' WHERE PARMT_Id = 'pg_Version'
/*========================================================================================================================*/


/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/
/*========================================================================================================================*/

/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRL_STOCKSS_KardexXArticulo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRL_STOCKSS_KardexXArticulo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRL_STOCKSS_KardexXArticulo]
(
	@ARTIC_Codigo VarChar(14)
	,@ALMAC_Id Integer
	,@PERIO_Codigo VarChar(4)
	,@ZONAS_Codigo VarChar(5)
	,@FecIni DateTime
	,@FecFin DateTime	 
)
As

--Declare @ARTIC_Codigo VarChar(14)
--Declare @ALMAC_Id Integer
--Declare @PERIO_Codigo VarChar(4)
--Declare @ZONAS_Codigo VarChar(5)
--Declare @FecIni DateTime
--Declare @FecFin DateTime

--Set @ARTIC_Codigo = '0801012'
--Set @ALMAC_Id = 3
--Set @PERIO_Codigo = '2013'
--Set @ZONAS_Codigo = '54.00'
--Set @FecIni = '01-01-2013'
--Set @FecFin = '07-17-2013'
Select Convert(date, @FecIni) As Fecha
	,@ALMAC_Id As ALMAC_Id
	,'Stock Inicial al ' + Convert(VarChar, @FecIni, 103) As Almacen
	,ARTIC_Codigo
	,Sum(Ingreso) As Ingreso
	,Sum(Salida) As Salida
	,Convert(Decimal(14,4), 0.00) Stock
	,'-' As DOCVE_Codigo
	, 'Stock Inicial al ' + Convert(VarChar, @FecIni, 103) As Descripcion
	,'-' As D
	,-1 As A
	,0 As Movimiento
Into #StockInicial
From (
	Select LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	From Logistica.LOG_Stocks LSt
		Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	Where ARTIC_Codigo = @ARTIC_Codigo 
		And PERIO_Codigo = @PERIO_Codigo
		And LSt.STOCK_Estado <> 'X'
		And ZONAS_Codigo = @ZONAS_Codigo
		And LSt.ALMAC_Id = @ALMAC_Id
		And Convert(Date, LSt.STOCK_Fecha) < @FecIni
	Union All
	Select SI.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STINI_Cantidad, 0 
	From Logistica.LOG_StockIniciales As SI
		Inner Join Almacenes As Alm On Alm.ALMAC_Id = SI.ALMAC_Id
	Where ARTIC_Codigo = @ARTIC_Codigo 
		And PERIO_Codigo = @PERIO_Codigo
		And ZONAS_Codigo = @ZONAS_Codigo
		And SI.ALMAC_Id = @ALMAC_Id
) As C
Group By ALMAC_Id, ARTIC_Codigo, ALMAC_Descripcion


--select * from Articulos where ARTIC_Codigo = @ARTIC_Codigo
/* FACTURAS */
Select Convert(date, Ven.DOCVE_FechaDocumento) As DOCVE_FechaDocumento
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion
	, LSt.ARTIC_Codigo
	, STOCK_CantidadIngreso As Ingreso
	, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00) As Stock
	,Left(TDoc.TIPOS_DescCorta, 1) + '-' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_DescripcionCliente
	,Ven.DOCVE_Estado
	,LSt.STOCK_Id
	,0 As Movimiento	
Into #Kardex
From Logistica.LOG_Stocks As LSt
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = LSt.DOCVE_Codigo
	Inner Join Ventas.VENT_DocsVentaDetalle As DVen On DVen.DOCVE_Codigo = Ven.DOCVE_Codigo And DVen.DOCVD_Item = LSt.DOCVD_Item
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
Where LSt.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All  /* ORDENES */
Select Convert(date, LSt.STOCK_Fecha)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, LSt.ARTIC_Codigo
	, STOCK_CantidadIngreso As Ingreso
	, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,'OR' + '' + Left(Right(Ord.ORDEN_Codigo, 10), 3) + '-' + Right(Ord.ORDEN_Codigo, 7) 
	 + ' / ' + TFDoc2.TIPOS_DescCorta + ' ' + Left(Right(Ord.DOCVE_Codigo, 10), 3) + '-' + Right(Ord.DOCVE_Codigo, 7)
	,Ord.ORDEN_DescripcionCliente
	,Ord.ORDEN_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Logistica.DIST_Ordenes As Ord On Ord.ORDEN_Codigo = LSt.ORDEN_Codigo 
	Inner Join Logistica.DIST_OrdenesDetalle As ODet On ODet.ORDEN_Codigo = LSt.ORDEN_Codigo
		And ODet.ORDET_Item = LSt.ORDET_Item
	Left Join Tipos As TFDoc2 On TFDoc2.TIPOS_Codigo = ('CPD' + Left(Ord.DOCVE_Codigo, 2))
	Left Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
Where Lst.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All /* INGRESOS DE COMPRA */
Select Convert(date, LSt.STOCK_Fecha)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, LSt.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,Left(TFDoc3.TIPOS_DescCorta, 1) + '-' +  Ing.INGCO_Serie + '-' + Right('0000000' + Rtrim(Ing.INGCO_Numero), 7)
	 --+'IC' + ' ' + Right('000' + RTrim(Ing.ALMAC_Id), 3) + '-' + Right('0000000' + RTrim(Ing.INGCO_Id), 7) 
	 + ' / ' + TFDoc2.TIPOS_DescCorta + ' ' + Left(Right(Ing.DOCCO_Codigo, 10), 3) + '-' + Right(Ing.DOCCO_Codigo, 7)
	 + ' - ' + RTrim(Ing.INGCO_Id)
	,Ent.ENTID_RazonSocial
	,Ing.INGCO_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Logistica.ABAS_IngresosCompra As Ing On Ing.INGCO_Id = LSt.INGCO_Id
	Inner Join Logistica.ABAS_IngresosCompraDetalle As DIng On DIng.INGCO_Id = Ing.INGCO_Id And DIng.INGCD_Item = LSt.INGCD_Item
	Left Join Tipos As TFDoc2 On TFDoc2.TIPOS_Codigo = ('CPD' + Left(Ing.DOCCO_Codigo, 2))
	Left Join Tipos As TFDoc3 On TFDoc3.TIPOS_Codigo = Ing.TIPOS_CodTipoDocumento
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ing.ENTID_CodigoProveedor
Where LSt.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All /* INGRESOS/EGRESOS POR TRASLADO */
Select Convert(date, LSt.STOCK_Fecha)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, Lst.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,Left(TDoc.TIPOS_DescCorta, 1) + '-' + Guia.GUIAR_Serie + '-' + Right('0000000' + RTrim(Guia.GUIAR_Numero), 7) 
	,Guia.GUIAR_Descripcioncliente + ' / Traslado : ' + AlmD.ALMAC_Descripcion
	,Guia.GUIAR_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Logistica.DIST_GuiasRemision As Guia On Guia.GUIAR_Codigo = LSt.GUIAR_Codigo And Guia.GUIAR_Estado <> 'X'
	Inner Join Logistica.DIST_GuiasRemisionDetalle As DGuia On DGuia.GUIAR_Codigo = Guia.GUIAR_Codigo And DGuia.GUIRD_Item = LSt.GUIRD_Item
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	Inner Join Almacenes As AlmD On AlmD.ALMAC_Id = Guia.ALMAC_IdDestino
Where Lst.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All /* Guias de Facturas de Devolvieron Stock */
Select Convert(date, Guia.GUIAR_FechaEmision)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, Lst.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,Left(TDoc.TIPOS_DescCorta, 1) + '-' + Guia.GUIAR_Serie + '-' + Right('0000000' + RTrim(Guia.GUIAR_Numero), 7) 
	 + ' / ' + TDFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
	,Guia.GUIAR_Descripcioncliente + ' / Traslado de Pendiente Devuelta'
	,Guia.GUIAR_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Logistica.DIST_GuiasRemision As Guia On Guia.GUIAR_Codigo = LSt.GUIAR_Codigo And Guia.GUIAR_Estado <> 'X'
	Inner Join Logistica.DIST_GuiasRemisionDetalle As DGuia On DGuia.GUIAR_Codigo = Guia.GUIAR_Codigo And DGuia.GUIRD_Item = LSt.GUIRD_Item
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Left Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id And ZONAS_Codigo = @ZONAS_Codigo
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo And Ven.DOCVE_StockDevuelto = 1
	Left Join Tipos As TDFac On TDFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Lst.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All /* PEDIDOS */
Select Convert(date, Ped.PEDID_FechaDocumento)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, Lst.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,LEFT(Ped.PEDID_Codigo, 2) + '' + Right('000' + RTRIM(Ped.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Ped.PEDID_Numero), 7)  
	 	 + ISNULL(' / ' + Left(TGuia.TIPOS_DescCorta, 1) + '-' + Guia.GUIAR_Serie + '-' + Right('0000000' + RTrim(Guia.GUIAR_Numero), 7),'')
	  --+ ' / ' + TDoc.TIPOS_DescCorta + ' ' + Ped.DOCVE_Codigo
	,IsNull(Ped.PEDID_DescripcionCliente, Cli.ENTID_RazonSocial) + ' / SeparaciÃ³n de Mercaderia / ' + IsNull(Alm1.ALMAC_Descripcion, '')
	,Ped.PEDID_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Ventas.VENT_Pedidos As Ped On Ped.PEDID_Codigo = LSt.PEDID_Codigo
	Inner Join Ventas.VENT_PedidosDetalle As DPed On DPed.PEDID_Codigo = Ped.PEDID_Codigo And DPed.PDDET_Item = LSt.PDDET_Item
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Left Join Almacenes As Alm1 On Alm1.ALMAC_Id = Ped.ALMAC_IdRelacionado
	Left Join Logistica.DIST_GuiasRemision As Guia On Guia.PEDID_Codigo = Ped.PEDID_Codigo And Guia.GUIAR_Estado <> 'X'
	Left Join Tipos As TGuia On TGuia.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
Where Lst.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
Union All /* ARREGLOS */
Select Convert(date, Arr.ARREG_FechaIngreso)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, Lst.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,TDoc.TIPOS_DescCorta + ' ' + ARREG_Serie + '-' + Right('0000000' + RTrim(Arr.ARREG_Numero), 7) 
	,'Movimiento de Arreglo / ' + TDoc.TIPOS_Descripcion + ' / ' + Arr.ARREG_Observaciones
	,Arr.ARREG_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
	Inner Join Logistica.CTRL_Arreglos As Arr On Arr.ARREG_Codigo = LSt.ARREG_Codigo
	Inner Join Logistica.CTRL_ArreglosDetalle As DArr On DArr.ARREG_Codigo = Arr.ARREG_Codigo And DArr.ARRDT_Item = LSt.ARRDT_Item
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Arr.TIPOS_CodTipoArreglo
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
	--Inner Join Entidades As Cli On Cli.ENTID_Codigo = Ped.ENTID_CodigoCliente
Where Lst.ARTIC_Codigo = @ARTIC_Codigo
	And Lst.ALMAC_Id = @ALMAC_Id
	And PERIO_Codigo = @PERIO_Codigo
	And LSt.STOCK_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between @FecIni And @FecFin
	
Union All /* STOCK INICIAL */
Select * From #StockInicial
Order By DOCVE_FechaDocumento Asc, Documento Asc


-- 84

Declare @STOCK_Id Integer

DECLARE Art CURSOR FOR 
	Select STOCK_Id From #Kardex  Order By DOCVE_FechaDocumento
Open Art

FETCH NEXT FROM Art
	INTO @STOCK_Id

Declare @Stock Decimal(14, 4) Set @Stock = 0
Declare @Id Integer Set @Id = 1

WHILE @@FETCH_STATUS = 0
Begin
	Set @Stock  = @Stock + (Select Ingreso - Salida From #Kardex Where STOCK_Id = @STOCK_Id)
		
	Update #Kardex Set Stock = @Stock 
		,Movimiento = @Id
	Where STOCK_Id = @STOCK_Id
	
	Set @Id = @Id + 1
	
	FETCH NEXT FROM Art
	INTO @STOCK_Id
End

CLOSE Art
DEALLOCATE Art

Select * From #Kardex Order By DOCVE_FechaDocumento

--Select Convert(date, Guia.GUIAR_FechaEmision)
--	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, Lst.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
--	,Convert(Decimal(14,4), 0.00)
--	,TDoc.TIPOS_DescCorta + ' ' + Guia.GUIAR_Serie + '-' + Right('0000000' + RTrim(Guia.GUIAR_Numero), 7) 
--	,Guia.GUIAR_Descripcioncliente + ' / Traslado de Stock Devuelto'
--	,Guia.GUIAR_Estado
--	,LSt.STOCK_Id
--	,0 As Movimiento
--From Logistica.LOG_Stocks As LSt
--	Inner Join Logistica.DIST_GuiasRemision As Guia On Guia.GUIAR_Codigo = LSt.GUIAR_Codigo And Guia.GUIAR_Estado <> 'X'
--	Inner Join Logistica.DIST_GuiasRemisionDetalle As DGuia On DGuia.GUIAR_Codigo = Guia.GUIAR_Codigo And DGuia.GUIRD_Item = LSt.GUIRD_Item
--	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo And Ven.DOCVE_StockDevuelto = 1
--	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
--	Left Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id And Alm.ZONAS_Codigo = @ZONAS_Codigo
--Where Lst.ARTIC_Codigo = @ARTIC_Codigo
--	And Lst.ALMAC_Id = @ALMAC_Id
--	And PERIO_Codigo = @PERIO_Codigo
--	And LSt.STOCK_Estado <> 'X'
--	And Alm.ZONAS_Codigo = @ZONAS_Codigo
--	And Convert(Date, Guia.GUIAR_FechaEmision) Between @FecIni And @FecFin
	
	
Drop Table #Kardex


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DOCCSS_UltimasCompras]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[DOCCSS_UltimasCompras] 
GO
/*====================================================================================================*/
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
    AND ISNULL(ARTIC_NuevoIngreso, 0) = CASE ISNULL(@TipoConsulta, 'P') 
                                             WHEN 'P' THEN 0
                                             WHEN 'M' THEN 1
                                        END 
  ORDER BY Art.ARTIC_Orden
    
 SELECT * FROM #ART

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


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[COSTESS_ArticulosCosteados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[COSTESS_ArticulosCosteados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 08/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[COSTESS_ArticulosCosteados]
(
	@ARTIC_Codigo CodArticulo
	,@Cantidad Integer
)
As

	Select Top (@Cantidad)
		TDes.TIPOS_Descripcion As TIPOS_TipoDestino
		,TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
		,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCCO_Serie + '-' + Right('0000000' + RTRIM(Doc.DOCCO_Numero), 7) As Documento
		,Ent.ENTID_RazonSocial
		,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
		,Doc.TIPOS_CodTipoMoneda
		,Doc.DOCCO_FechaDocumento
		,DocCodetalle.* 
	From Logistica.ABAS_DocsCompraDetalle As DocCodetalle 
		Inner Join Logistica.ABAS_DocsCompra As Doc On Doc.DOCCO_Codigo = DocCodetalle.DOCCO_Codigo
		Inner Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_CodigoProveedor
		left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
		Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = DocCodetalle.ARTIC_Codigo
		left Join dbo.Tipos As TDes On TDes.TIPOS_Codigo = DocCodetalle.TIPOS_CodTipoDestino
		left Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
		left Join dbo.Tipos As Mon On Mon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	WHERE Art.ARTIC_Codigo = @ARTIC_Codigo
		--And IsNull(DocCodetalle.DOCCD_Costo, 0) > 0
	Order By Doc.DOCCO_FechaDocumento Desc


GO
/*====================================================================================================*/

