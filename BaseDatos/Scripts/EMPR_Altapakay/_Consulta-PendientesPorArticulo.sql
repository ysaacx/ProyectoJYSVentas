--exec LOG_DIST_GUIASS_ObtDetDocVenta @DOCVE_Codigo=N'01F0010004994',@ALMAC_Id=1
USE BDInkaPeru
GO

DECLARE @ARTIC_Codigo VARCHAR(10) = '0801012'
DECLARE @FecIni DATETIME = '2020-01-01'
DECLARE @FecFin DATETIME = '2020-12-31'
DECLARE @Periodo CHAR(4) = '2020'


Select IsNull(Guia.DDTRA_Cantidad, 0.0) As Entregado
	, DDocs.DOCVD_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0) As Diferencia
    , TDOC.TIPOS_DescCorta
    , VENTA.DOCVE_Serie
    , VENTA.DOCVE_Numero
    , VENTA.DOCVE_FechaDocumento
	, ARTIC_Descripcion, TUNI.TIPOS_Descripcion As TIPOS_UnidadMedida
	, TUNI.TIPOS_DescCorta As TIPOS_UnidadMedidaCorta
	, Alm.ALMAC_Descripcion
	, DDocs.DOCVD_Cantidad
	, Art.ARTIC_Peso As DOCVD_PesoUnitario
	, DDocs.ARTIC_Codigo
	, DDocs.DOCVD_Item
	, Art.TIPOS_CodUnidadMedida
	,DDocs.ALMAC_Id
From Ventas.VENT_DocsVentaDetalle As DDocs
	Left Join  (
				 Select DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario, Sum(DDTRA_Cantidad) As DDTRA_Cantidad From (
					Select C.DOCVE_Codigo, D.ARTIC_Codigo, D.GUIRD_PesoUnitario, Sum(D.GUIRD_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_GuiasRemision As C
						Inner Join Logistica.DIST_GuiasRemisionDetalle As D On D.GUIAR_Codigo = C.GUIAR_Codigo
					Where C.GUIAR_Estado <> 'X'
					Group By C.DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
					Union All
					Select C.DOCVE_Codigo, D.ARTIC_Codigo, Art.ARTIC_Peso, Sum(D.ORDET_Cantidad) As DDTRA_Cantidad 
					From Logistica.DIST_Ordenes As C
						Inner Join Logistica.DIST_OrdenesDetalle As D On D.ORDEN_Codigo = C.ORDEN_Codigo
						Inner Join Articulos As Art On Art.ARTIC_Codigo = D.ARTIC_Codigo 
					Where C.ORDEN_Estado <> 'X'
					Group By C.DOCVE_Codigo, D.ARTIC_Codigo, Art.ARTIC_Peso
				 ) As Tabla
				 Group By DOCVE_Codigo, ARTIC_Codigo, GUIRD_PesoUnitario
				) 
		As Guia On Guia.DOCVE_Codigo = DDocs.DOCVE_Codigo And Guia.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = DDocs.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = DDocs.ALMAC_Id
    INNER JOIN Ventas.VENT_DocsVenta VENTA ON VENTA.DOCVE_Codigo = DDocs.DOCVE_Codigo
    INNER JOIN dbo.Tipos TDOC ON TDOC.TIPOS_Codigo = VENTA.TIPOS_CodTipoDocumento
Where (DDocs.DOCVD_Cantidad - IsNull(Guia.DDTRA_Cantidad, 0.0)) > 0
  AND convert(date, VENTA.DOCVE_FechaDocumento) BETWEEN @FecIni AND @FecFin
  AND Art.ARTIC_Codigo = @ARTIC_Codigo
  AND VENTA.DOCVE_EstEntrega = 'P'
  AND VENTA.DOCVE_Estado <> 'X'
Order By DOCVE_FechaDocumento


--SELECT DISTINCT DOCVE_EstEntrega  FROM Ventas.VENT_DocsVenta 
--SELECT RIGHT(VENTA.TIPOS_CodTipoDocumento, 2) + VENTA.DOCVE_Serie + RIGHT('00000000' + RTRIM(VENTA.DOCVE_Numero), 8)
--  FROM Ventas.VENT_DocsVentaDetalle DETA 
-- INNER JOIN Ventas.VENT_DocsVenta VENTA ON VENTA.DOCVE_Codigo = DETA.DOCVE_Codigo
-- WHERE DETA.ARTIC_Codigo = @ARTIC_Codigo
--   AND convert(date, VENTA.DOCVE_FechaDocumento) BETWEEN @FecIni AND @FecFin


--exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=N'0801001',@ALMAC_Id=1,@PERIO_Codigo=N'2019',@ZONAS_Codigo=N'84.00',@FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00'

-- +--------------------------------------------------+
-- | STOCKS
-- +--------------------------------------------------+

--SELECT * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = @ARTIC_Codigo AND PERIO_Codigo = 2019

-- +--------------------------------------------------+
-- | VENTAS
-- +--------------------------------------------------+

SELECT TDOC = 'DOCVE' 
     , DOCUMENTO = MOVI.Id_Documento
     , GUIAR_Codigo = CONVERT(VARCHAR(50), '')
     , DMOV.Cantidad_Producto
     , DETA.DOCVD_Cantidad 
     , STOCK_STOCK_CantidadIngreso = STOCK.STOCK_CantidadIngreso
     , STOCK_STOCK_CantidadSalida = STOCK.STOCK_CantidadSalida
     , STOCK_STOCK_Id = STOCK.STOCK_Id
     --, STOCK_GUIA_GUIAR_Codigo = STOCK_GUIA.GUIAR_Codigo
     , STOCK_GUIA_STOCK_CantidadIngreso = STOCK_GUIA.STOCK_CantidadIngreso
     , STOCK_GUIA_STOCK_CantidadSalida = STOCK_GUIA.STOCK_CantidadSalida
     , GUIA.GUIAR_Codigo
     , DGUIA.GUIRD_Cantidad
     , MOVI.*
  FROM BDMaster..Movimientos MOVI
 INNER JOIN BDMaster.dbo.Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro
       ---------------------------------
  LEFT JOIN Ventas.VENT_DocsVenta VENTA ON VENTA.DOCVE_Codigo = MOVI.Id_Documento
  LEFT JOIN Ventas.VENT_DocsVentaDetalle DETA ON DETA.DOCVE_Codigo = VENTA.DOCVE_Codigo AND DETA.ARTIC_Codigo = DMOV.Id_Producto
   AND DMOV.Cantidad_Producto = DETA.DOCVD_Cantidad
       ----------------------------------
  LEFT JOIN Logistica.LOG_Stocks STOCK ON STOCK.DOCVE_Codigo = VENTA.DOCVE_Codigo AND STOCK.DOCVD_Item = DETA.DOCVD_Item AND STOCK.ARTIC_Codigo = DETA.ARTIC_Codigo
       ----------------------------------
  LEFT JOIN Logistica.DIST_GuiasRemision GUIA ON GUIA.DOCVE_Codigo = DETA.DOCVE_Codigo AND GUIA.GUIAR_Estado <> 'X'
  LEFT JOIN Logistica.DIST_GuiasRemisionDetalle DGUIA ON DGUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND DGUIA.ARTIC_Codigo = DETA.ARTIC_Codigo
       ----------------------------------
  LEFT JOIN Logistica.LOG_Stocks STOCK_GUIA ON STOCK_GUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND STOCK_GUIA.GUIRD_Item = DGUIA.GUIRD_Item 
   AND STOCK_GUIA.ARTIC_Codigo = DMOV.Id_Producto
       ----------------------------------
 WHERE DMOV.Id_Producto = @ARTIC_Codigo
   AND convert(date, MOVI.Fecha) BETWEEN @FecIni AND @FecFin
   AND DMOV.Registro = 'RV'
   AND STOCK.STOCK_Id IS NULL
 ORDER BY MOVI.Id_Documento

 --UNION
 --SELECT TDOC = 'GUIR' 
 --     , MOVI.Id_Documento
 --     , GUIA.GUIAR_Codigo
 --    --, RIGHT(VENTA.TIPOS_CodTipoDocumento, 2) + ' ' + VENTA.DOCVE_Serie + '-' + RIGHT('0000000' + RTRIM(VENTA.DOCVE_Numero), 8)
 --    , DMOV.Cantidad_Producto
 --    , DETA.DOCVD_Cantidad 
 --    --, STOCK_STOCK_CantidadIngreso = STOCK.STOCK_CantidadIngreso
 --    , STOCK_STOCK_CantidadSalida = STOCK_GUIA.STOCK_CantidadSalida
 --    , STOCK_STOCK_Id = STOCK_GUIA.STOCK_Id
 --    --, STOCK_GUIA_GUIAR_Codigo = STOCK_GUIA.GUIAR_Codigo
 --    ----, STOCK_GUIA_STOCK_CantidadIngreso = STOCK_GUIA.STOCK_CantidadIngreso
 --    --, STOCK_GUIA_STOCK_CantidadSalida = STOCK_GUIA.STOCK_CantidadSalida

 --    , GUIA.GUIAR_Codigo
 --    , DGUIA.GUIRD_Cantidad
 --    , MOVI.*
 -- FROM BDMaster..Movimientos MOVI
 --INNER JOIN BDMaster.dbo.Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro
 --      ---------------------------------
 -- LEFT JOIN Ventas.VENT_DocsVenta VENTA ON VENTA.DOCVE_Codigo = MOVI.Id_Documento
 -- LEFT JOIN Ventas.VENT_DocsVentaDetalle DETA ON DETA.DOCVE_Codigo = VENTA.DOCVE_Codigo AND DETA.ARTIC_Codigo = DMOV.Id_Producto
 --  AND DMOV.Cantidad_Producto = DETA.DOCVD_Cantidad
 --      ----------------------------------
 -- LEFT JOIN Logistica.LOG_Stocks STOCK ON STOCK.DOCVE_Codigo = VENTA.DOCVE_Codigo AND STOCK.DOCVD_Item = DETA.DOCVD_Item AND STOCK.ARTIC_Codigo = DETA.ARTIC_Codigo
 --      ----------------------------------
 -- LEFT JOIN Logistica.DIST_GuiasRemision GUIA ON GUIA.DOCVE_Codigo = DETA.DOCVE_Codigo AND GUIA.GUIAR_Estado <> 'X'
 -- LEFT JOIN Logistica.DIST_GuiasRemisionDetalle DGUIA ON DGUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND DGUIA.ARTIC_Codigo = DETA.ARTIC_Codigo
 --      ----------------------------------
 -- LEFT JOIN Logistica.LOG_Stocks STOCK_GUIA ON STOCK_GUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND STOCK_GUIA.GUIRD_Item = DGUIA.GUIRD_Item 
 --  AND STOCK_GUIA.ARTIC_Codigo = DMOV.Id_Producto
 --      ----------------------------------
 --WHERE DMOV.Id_Producto = @ARTIC_Codigo
 --  AND convert(date, MOVI.Fecha) BETWEEN @FecIni AND @FecFin
 --  AND DMOV.Registro = 'RV'
 --  AND STOCK.STOCK_Id IS NULL --AND GUIA.GUIAR_Codigo IS NOT NULL
 --ORDER BY DOCUMENTO

 
--SELECT MOVI.Id_Documento
--     --, RIGHT(VENTA.TIPOS_CodTipoDocumento, 2) + ' ' + VENTA.DOCVE_Serie + '-' + RIGHT('0000000' + RTRIM(VENTA.DOCVE_Numero), 8)
--     , DMOV.Cantidad_Producto
--     , DETA.DOCVD_Cantidad 
--     --, STOCK_STOCK_CantidadIngreso = STOCK.STOCK_CantidadIngreso
--     , STOCK_STOCK_CantidadSalida = STOCK.STOCK_CantidadSalida
--     , STOCK_STOCK_Id = STOCK.STOCK_Id
--     --, STOCK_GUIA_GUIAR_Codigo = STOCK_GUIA.GUIAR_Codigo
--     ----, STOCK_GUIA_STOCK_CantidadIngreso = STOCK_GUIA.STOCK_CantidadIngreso
--     --, STOCK_GUIA_STOCK_CantidadSalida = STOCK_GUIA.STOCK_CantidadSalida

--     --, GUIA.GUIAR_Codigo
--     --, DGUIA.GUIRD_Cantidad
--     , MOVI.*
--  FROM BDMaster..Movimientos MOVI
-- INNER JOIN BDMaster.dbo.Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro
--       ---------------------------------
--  LEFT JOIN Ventas.VENT_DocsVenta VENTA ON VENTA.DOCVE_Codigo = MOVI.Id_Documento
--  LEFT JOIN Ventas.VENT_DocsVentaDetalle DETA ON DETA.DOCVE_Codigo = VENTA.DOCVE_Codigo AND DETA.ARTIC_Codigo = DMOV.Id_Producto
--   AND DMOV.Cantidad_Producto = DETA.DOCVD_Cantidad
--       ----------------------------------
--  LEFT JOIN Logistica.LOG_Stocks STOCK ON STOCK.DOCVE_Codigo = VENTA.DOCVE_Codigo AND STOCK.DOCVD_Item = DETA.DOCVD_Item AND STOCK.ARTIC_Codigo = DETA.ARTIC_Codigo
--       ----------------------------------
--  --LEFT JOIN Logistica.DIST_GuiasRemision GUIA ON GUIA.DOCVE_Codigo = DETA.DOCVE_Codigo AND GUIA.GUIAR_Estado <> 'X'
--  --LEFT JOIN Logistica.DIST_GuiasRemisionDetalle DGUIA ON DGUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND DGUIA.ARTIC_Codigo = DETA.ARTIC_Codigo
--  --     ----------------------------------
--  --LEFT JOIN Logistica.LOG_Stocks STOCK_GUIA ON STOCK_GUIA.GUIAR_Codigo = GUIA.GUIAR_Codigo AND STOCK_GUIA.GUIRD_Item = DGUIA.GUIRD_Item 
--  -- AND STOCK_GUIA.ARTIC_Codigo = DMOV.Id_Producto
--       ----------------------------------
-- WHERE DMOV.Id_Producto = @ARTIC_Codigo
--   AND convert(date, MOVI.Fecha) BETWEEN @FecIni AND @FecFin
--   AND DMOV.Registro = 'RV'
--   AND STOCK.STOCK_Id IS NULL
-- ORDER BY MOVI.Id_Documento


SELECT VENTA.DOCVE_Codigo
     , DETA.DOCVD_Cantidad 
     , VENTA.*
  FROM Ventas.VENT_DocsVenta VENTA 
 INNER JOIN Ventas.VENT_DocsVentaDetalle DETA ON DETA.DOCVE_Codigo = VENTA.DOCVE_Codigo
       ----------------------------------
  --LEFT JOIN BDMaster..Movimientos MOVI ON MOVI.Id_Documento = VENTA.DOCVE_Codigo
  --LEFT JOIN BDMaster.dbo.Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro 
  -- AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro AND DMOV.Registro = 'RV' AND DMOV.Id_Producto = DETA.ARTIC_Codigo
 WHERE DETA.ARTIC_Codigo = @ARTIC_Codigo
   AND convert(date, VENTA.DOCVE_FechaDocumento) BETWEEN @FecIni AND @FecFin

-- +--------------------------------------------------+
-- | COMPRAS
-- +--------------------------------------------------+
--SELECT TOP 100 * FROM BDMaster..Movimientos_Detalle

SELECT MOVI.Id_Documento
     , MOVI.Id_CliPro
     , COMP.DOCCO_Codigo
     , COMP.ENTID_CodigoProveedor
     , MOVI.*
  FROM BDMaster..Movimientos MOVI
 INNER JOIN BDMaster..Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro 
  AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro
       ----------------------------------
  LEFT JOIN Logistica.ABAS_DocsCompra COMP ON COMP.DOCCO_Codigo = MOVI.Id_Documento AND COMP.ENTID_CodigoProveedor = MOVI.Id_CliPro
  LEFT JOIN Logistica.ABAS_DocsCompraDetalle DCOM ON DCOM.DOCCO_Codigo = COMP.DOCCO_Codigo AND DCOM.ENTID_CodigoProveedor = COMP.ENTID_CodigoProveedor
   AND DCOM.ARTIC_Codigo = DMOV.Id_Producto
 WHERE DMOV.Id_Producto = @ARTIC_Codigo
   AND CONVERT(DATE, MOVI.Fecha) BETWEEN @FecIni AND @FecFin
   AND DMOV.Registro = 'RC'
/*
SELECT COMP.DOCCO_Codigo
     , COMP.ENTID_CodigoProveedor
     --, MOVI.Id_Documento
     --, MOVI.Id_CliPro
  FROM Logistica.ABAS_DocsCompra COMP
 INNER JOIN Logistica.ABAS_DocsCompraDetalle DCOM ON DCOM.DOCCO_Codigo = COMP.DOCCO_Codigo AND DCOM.ENTID_CodigoProveedor = COMP.ENTID_CodigoProveedor
       ----------------------------------
 --LEFT JOIN BDMaster..Movimientos MOVI ON MOVI.Id_Documento = COMP.DOCCO_Codigo AND MOVI.Id_CliPro = COMP.ENTID_CodigoProveedor
 --LEFT JOIN BDMaster..Movimientos_Detalle DMOV ON DMOV.EMPR_Codigo = MOVI.EMPR_Codigo AND DMOV.Registro = MOVI.Registro 
 -- AND DMOV.Id_Documento = MOVI.Id_Documento AND DMOV.Id_CliPro = MOVI.Id_CliPro AND DMOV.Id_Producto = DCOM.ARTIC_Codigo
 -- AND DMOV.Registro = 'RC'
 WHERE DCOM.ARTIC_Codigo = @ARTIC_Codigo
   AND CONVERT(DATE, COMP.DOCCO_FechaDocumento) BETWEEN @FecIni AND @FecFin
*/


CREATE TABLE #TMP_Kardex(
DOCVE_FechaDocumento VARCHAR(15)
, ALMAC_Id INT 
, ALMAC_Descripcion VARCHAR(500)
, ARTIC_Codigo VARCHAR(15)
, Ingreso DECIMAL(15,2)
, Salida DECIMAL(15,2)
, Stock DECIMAL(15,2)
, Documento VARCHAR(200)
, DOCVE_DescripcionCliente VARCHAR(200)
, DOCVE_Estado VARCHAR(20)
, STOCK_Id BIGINT
, Movimiento INT
)

INSERT INTO #TMP_Kardex
exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=@ARTIC_Codigo,@ALMAC_Id=1,@PERIO_Codigo=N@Periodo,@ZONAS_Codigo=N'84.00',@FecIni=@FecIni,@FecFin=@FecFin

SELECT Documento, COUNT(*) FROM #TMP_Kardex GROUP BY Documento HAVING COUNT(*) > 1

DROP TABLE #TMP_Kardex

