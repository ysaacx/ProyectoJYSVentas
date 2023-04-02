use BDDACEROSLAM
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
		And Convert(Date, LSt.STOCK_Fecha) < convert(date, @FecIni)
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

--select * from #StockInicial
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
   INNER JOIN Logistica.ABAS_DocsCompra DOCCO ON DOCCO.ALMAC_Id = Ing.ALMAC_Id 
     AND DOCCO.DOCCO_Codigo = Ing.DOCCO_Codigo AND DOCCO.ENTID_CodigoProveedor = Ing.ENTID_CodigoProveedor
     AND DOCCO.DOCCO_Estado <> 'X'
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

Union All /* INGRESOS DE COMPRA - SOLO INGRESO POR COMPRA */
Select Convert(date, LSt.STOCK_Fecha)
	,LSt.ALMAC_Id, Alm.ALMAC_Descripcion, LSt.ARTIC_Codigo, STOCK_CantidadIngreso As Ingreso, STOCK_CantidadSalida As Salida 
	,Convert(Decimal(14,4), 0.00)
	,Left(TFDoc3.TIPOS_DescCorta, 1) + '-' +  Ing.INGCO_Serie + '-' + Right('0000000' + Rtrim(Ing.INGCO_Numero), 7)
	 --+'IC' + ' ' + Right('000' + RTrim(Ing.ALMAC_Id), 3) + '-' + Right('0000000' + RTrim(Ing.INGCO_Id), 7) 
	 + ' / ' + TFDoc2.TIPOS_DescCorta + ' ' + Left(Right(Ing.DOCCO_Codigo, 10), 3) + '-' + Right(Ing.DOCCO_Codigo, 7)
	 + ' - ' + RTrim(Ing.INGCO_Id) + '(S.Ing.)'
	,Ent.ENTID_RazonSocial
	,Ing.INGCO_Estado
	,LSt.STOCK_Id
	,0 As Movimiento
From Logistica.LOG_Stocks As LSt
Inner Join Logistica.ABAS_IngresosCompra As Ing On Ing.INGCO_Id = LSt.INGCO_Id
--   INNER JOIN Logistica.ABAS_DocsCompra DOCCO ON DOCCO.ALMAC_Id = Ing.ALMAC_Id 
     --AND DOCCO.DOCCO_Codigo = Ing.DOCCO_Codigo AND DOCCO.ENTID_CodigoProveedor = Ing.ENTID_CodigoProveedor
     --AND DOCCO.DOCCO_Estado <> 'X'
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
Union All /* Guias que descuentan stcok*/
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
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo And ISNULL(Ven.DOCVE_StockDevuelto, 0) = 0
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
	,IsNull(Ped.PEDID_DescripcionCliente, Cli.ENTID_RazonSocial) + ' / Separación de Mercaderia / ' + IsNull(Alm1.ALMAC_Descripcion, '')
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
	,'Movimiento de Arreglo / ' + ISNULL(TDoc.TIPOS_Descripcion, '') + ' / ' + ISNULL(Arr.ARREG_Observaciones, '')
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
	--And LSt.STOCK_Estado <> 'X'
   AND Arr.ARREG_Estado <> 'X'
	And Alm.ZONAS_Codigo = @ZONAS_Codigo
	And Convert(Date, LSt.STOCK_Fecha) Between CONVERT(DATE, @FecIni) And CONVERT(DATE, @FecFin)
	
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
/***************************************************************************************************************************************/ 


--use BDDACEROSLAM
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_INGSS_Consulta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_INGSS_Consulta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 28/12/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_INGSS_Consulta]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select  Ent.ENTID_RazonSocial As ENTID_Proveedor
	, Alma.ALMAC_Descripcion As ALMAC_Descripcion
	, TDoc.TIPOS_DescCorta As TIPOS_Documento
	, IsNull((TDocC.TIPOS_DescCorta + ' ' + DC.DOCCO_Serie + '-' + Right('0000000' + RTRIM(DC.DOCCO_Numero), 7))
		, (TDocC2.TIPOS_DescCorta + ' '+ Left(Right(IComp.DOCCO_Codigo, 10), 3)) + '-' + RIGHT(IComp.DOCCO_Codigo, 7)) As Compra
	,(Case When DC.DOCCO_Codigo Is Null 
	  Then CONVERT(Bit, 0) Else CONVERT(Bit, 1) End) As CompraReg
	, 'OC ' + OC.ORDCO_Serie + '-' + Right('0000000' + RTRIM(OC.ORDCO_Numero), 7) As Orden
	,IComp.DOCCO_Codigo
	,IComp.INGCO_Serie
	,IComp.INGCO_Numero
	,IComp.ENTID_CodigoProveedor
	,IComp.INGCO_FechaDocumento
	,IComp.ALMAC_Id
	,IComp.INGCO_Id
	,IComp.INGCO_Estado
	--,IComp.* 
Into #Ingresos
From Logistica.ABAS_IngresosCompra As IComp 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = IComp.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = IComp.ALMAC_Id
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = IComp.TIPOS_CodTipoDocumento
	Left Join Logistica.ABAS_OrdenesCompra As OC On OC.ORDCO_Codigo = IComp.ORDCO_Codigo
	Left Join Logistica.ABAS_DocsCompra As DC On DC.DOCCO_Codigo = IComp.DOCCO_Codigo
		And DC.ENTID_CodigoProveedor = IComp.ENTID_CodigoProveedor
	Left Join Tipos As TDocC On TDocC.TIPOS_Codigo = DC.TIPOS_CodTipoDocumento
	Left Join Tipos As TDocC2 On TDocC2.TIPOS_Codigo = 'CPD' + LEFT(IComp.DOCCO_Codigo, 2)
 WHERE Convert(date, IComp.INGCO_FechaDocumento) Between @FecIni AND @FecFin
		AND DC.DOCCO_TipoRegistro = 'R'
        AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
						  When 1 Then RTrim(IComp.INGCO_Id)
						  When 2 Then IComp.DOCCO_Codigo
						  When 3 Then IComp.INGCO_Codigo
						  Else Ent.ENTID_RazonSocial
			 End)
			Like '%' + @Cadena + '%' 
		
IF @Todos = 1
    BEGIN 
	    Select * From #Ingresos Order By INGCO_FechaDocumento Desc
    END
ELSE
    BEGIN
	    Select * From #Ingresos Where ISNULL(INGCO_Estado, '') = 'I' Order By INGCO_FechaDocumento DESC
    END

GO 
/***************************************************************************************************************************************/ 

update Logistica.ABAS_IngresosCompra set DOCCO_Codigo = '010010016475', INGCO_DCItem = 2 where INGCO_Id= 15