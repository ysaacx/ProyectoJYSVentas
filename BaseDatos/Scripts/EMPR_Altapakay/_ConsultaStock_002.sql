USE BDInkaPeru
GO

SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0801003' AND GUIAR_Codigo LIKE '%1877'
SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0801003' AND DOCVE_Codigo LIKE '%6977'
SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo IN ( '090050001785')
SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE DOCVE_Codigo IN ( '03B0010022010')
SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo IN ( '90050001739', '90050001789', '90050001781', '90050001804'
, '90050001666', '90050001718', '90050001730', '90050001732', '90050001750', '90050001817', '90050001829', '90050001826')
SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE DOCVE_Codigo IN ( '01F0010006567', '01F0010006589', '01F0010006635'
, '01F0010006645', '01F0010006707', '01F0010006982', '03B0010020029', '03B0010020075', '03B0010021161', '03B0010021161'
, '03B0010021807', '03B0010021913', '03B0010021968', '03B0010021981', '03B0010022488')

SELECT SUM(DOCVD_Cantidad) FROM Ventas.VENT_DocsVentaDetalle WHERE DOCVE_Codigo IN ( '01F0010006567', '01F0010006589', '01F0010006635'
, '01F0010006645', '01F0010006707', '01F0010006982', '03B0010020029', '03B0010020075', '03B0010021161', '03B0010021161'
, '03B0010021807', '03B0010021913', '03B0010021968', '03B0010021981', '03B0010022488')
 AND ARTIC_Codigo = '0801012'

SELECT GUIRD_Cantidad, * FROM Logistica.DIST_GuiasRemisionDetalle WHERE GUIAR_Codigo IN ( '90050001739', '90050001789', '90050001781', '90050001804'
, '90050001666', '90050001718', '90050001730', '90050001732', '90050001750', '90050001817', '90050001829', '90050001826')
 AND ARTIC_Codigo = '0801012'

SELECT * FROM Logistica.DIST_GuiasRemision WHERE GUIAR_Numero = 1877
SELECT * FROM Logistica.DIST_GuiasRemision WHERE GUIAR_Numero = 1886

exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=@ARTIC_Codigo,@ALMAC_Id=1,@PERIO_Codigo=@Periodo,@ZONAS_Codigo=N'84.00',@FecIni=@FecIni,@FecFin=@FecFin

SELECT * FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo IN ('090050001546', '090050001620', '090050001621', '090050001648', '090050001650', '090050001670')

    SELECT LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso AS Ingreso, STOCK_CantidadSalida AS Salida 
        , LSt.*
    From Logistica.LOG_Stocks LSt
        Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
    Where ARTIC_Codigo = '0801007'
        And PERIO_Codigo = '2020'
        And LSt.STOCK_Estado <> 'X'
        And ZONAS_Codigo = '84.00'
        And LSt.ALMAC_Id = 1
        And Convert(Date, LSt.STOCK_Fecha) < '2020-01-01'


  SELECT LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso AS Ingreso, STOCK_CantidadSalida AS Salida 
        , LSt.*
    From Logistica.LOG_Stocks LSt
        Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
    Where  PERIO_Codigo = '2020'
        And LSt.STOCK_Estado <> 'X'
        And ZONAS_Codigo = '84.00'
        And LSt.ALMAC_Id = 1
        And Convert(Date, LSt.STOCK_Fecha) < '2020-01-01'

   SELECT LSt.ALMAC_Id, Alm.ALMAC_Descripcion, ARTIC_Codigo, STOCK_CantidadIngreso AS Ingreso, STOCK_CantidadSalida AS Salida 
        , LSt.*
    From Logistica.LOG_Stocks LSt
        Inner Join Almacenes As Alm On Alm.ALMAC_Id = LSt.ALMAC_Id
    Where  PERIO_Codigo = '2019'
        And LSt.STOCK_Estado <> 'X'
        And ZONAS_Codigo = '84.00'
        And LSt.ALMAC_Id = 1
        And Convert(Date, LSt.STOCK_Fecha) < '2019-01-01'

--SELECT STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE ARTIC_Codigo = '0801568'

--SELECT VEN.DOCVE_FechaDocumento, * FROM Ventas.VENT_DocsVentaDetalle DET
-- INNER JOIN Ventas.VENT_DocsVenta VEN ON VEN.DOCVE_Codigo = DET.DOCVE_Codigo
-- WHERE ARTIC_Codigo = '0801568'

--SELECT * FROM Logistica.DIST_GuiasRemisionDetalle WHERE ARTIC_Codigo = '0801568'

--SELECT STOCK_Fecha, STOCK_Fecha, * FROM Logistica.LOG_Stocks WHERE PERIO_Codigo = '2019' AND GUIAR_Codigo IS NOT NULL ORDER BY STOCK_FecCrea

---- ============================================================================================================================== --
--DROP TABLE #tmp_detventas

--SELECT CODIGO = DET.DOCVE_Codigo + '|' + DET.ARTIC_Codigo , DET.* INTO #tmp_detventas  FROM Ventas.VENT_DocsVentaDetalle DET
-- INNER JOIN Ventas.VENT_DocsVenta CAB ON CAB.DOCVE_Codigo = DET.DOCVE_Codigo
-- WHERE CAB.DOCVE_Estado <> 'X'
--   AND DET.DOCVE_Codigo + '|' + ARTIC_Codigo IN (SELECT DOCVE_Codigo + '|' + ARTIC_Codigo FROM Logistica.LOG_Stocks WHERE DOCVE_Codigo IS NOT NULL )


--SELECT * FROM Logistica.DIST_GuiasRemisionDetalle DET
-- INNER JOIN Logistica.DIST_GuiasRemision CAB ON CAB.GUIAR_Codigo = DET.GUIAR_Codigo
-- WHERE CAB.GUIAR_Estado <> 'X' 
--   AND NOT CAB.DOCVE_Codigo + '|' + DET.ARTIC_Codigo IN (SELECT CODIGO FROM #tmp_detventas)
--   AND NOT CAB.GUIAR_Codigo + '|' + DET.ARTIC_Codigo IN (SELECT GUIAR_Codigo + '|' + ARTIC_Codigo FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo IS NOT NULL )
----AND #tmp_detventas

--SELECT ARTIC_Codigo FROM Logistica.DIST_GuiasRemisionDetalle

--SELECT ARTIC_Codigo FROM Logistica.LOG_Stocks


--SELECT * FROM Logistica.DIST_GuiasRemision WHERE GUIAR_Numero = 756
--SELECT * FROM Logistica.DIST_GuiasRemision WHERE GUIAR_Codigo = '090050000756'
--SELECT * FROM Logistica.DIST_GuiasRemisionDetalle WHERE GUIAR_Codigo = '090050000756'


--SELECT * FROM Logistica.LOG_Stocks WHERE DOCVE_Codigo = '01F0010002466'

--SELECT * FROM Logistica.LOG_Stocks WHERE GUIAR_Codigo = '090050000545'
--SELECT * FROM Logistica.LOG_Stocks WHERE DOCVE_Codigo = '01F0010001573'
