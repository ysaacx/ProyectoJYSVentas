USE BDMaster
GO



SELECT * FROM dbo.Ventas WHERE YEAR(Fecha_Ingreso) = 2019 ORDER BY Fecha_Ingreso DESC

SELECT D.Cantidad_Producto, * FROM dbo.Compras C
 INNER JOIN dbo.Compras_Detalle D ON D.EMPR_Codigo = C.EMPR_Codigo AND D.Id_Compra = C.Id_Compra AND D.Id_Proveedor = C.Id_Proveedor
 WHERE Fecha_Ingreso BETWEEN '2019-09-01' AND '2019-09-30' AND D.Id_Producto = '0601002'

SELECT * FROM BDCOMAFISUR.Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo IN ('01F0210863760', '01F0210086376')
SELECT * FROM BDCOMAFISUR.Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo = '01F0210863760'
--SELECT * FROM dbo.Compras_Detalle



USE BDCOMAFISUR

SELECT * FROM Ventas.VENT_DocsVenta