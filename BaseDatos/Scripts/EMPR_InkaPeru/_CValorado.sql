USE BDInkaPeru
go
--SET LANGUAGE ENGLISH

SELECT DISTINCT DETA.ARTIC_Codigo, ARTI.ARTIC_Descripcion FROM VENTAS.VENT_DocsVentaDetalle DETA
 INNER JOIN VENTAS.VENT_DocsVenta CAB ON CAB.DOCVE_Codigo = DETA.DOCVE_Codigo
 INNER JOIN dbo.Articulos ARTI ON ARTI.ARTIC_Codigo = DETA.ARTIC_Codigo
 WHERE CONVERT(DATE, CAB.DOCVE_FechaDocumento) BETWEEN '2019-01-01' AND '2019-12-31'
   AND CAB.DOCVE_Estado <> 'X'
UNION 
SELECT DISTINCT DETA.ARTIC_Codigo, ARTI.ARTIC_Descripcion 
  FROM Logistica.ABAS_DocsCompraDetalle DETA
 INNER JOIN Logistica.ABAS_DocsCompra COMP ON COMP.DOCCO_Codigo = DETA.DOCCO_Codigo 
   AND COMP.ENTID_CodigoProveedor = DETA.ENTID_CodigoProveedor
 INNER JOIN dbo.Articulos ARTI ON ARTI.ARTIC_Codigo = DETA.ARTIC_Codigo
 WHERE CONVERT(DATE, COMP.DOCCO_FechaDocumento) BETWEEN '2019-01-01' AND '2019-12-31'
  AND COMP.DOCCO_Estado <> 'X'

SELECT DISTINCT PROD.Id_Producto, PROD.Nombre_Producto FROM BDMaster..Movimientos_Detalle MOVD
 INNER JOIN BDMaster..Movimientos MOVI ON MOVI.EMPR_Codigo = MOVD.EMPR_Codigo AND MOVI.Registro = MOVD.Registro AND MOVI.Id_Documento = MOVD.Id_Documento AND MOVI.Id_CliPro = MOVD.Id_CliPro
 INNER JOIN BDMaster..Productos PROD ON PROD.EMPR_Codigo = MOVI.EMPR_Codigo AND PROD.Id_Producto = MOVD.Id_Producto
 WHERE MOVI.EMPR_Codigo = 'INKAP' AND Fecha BETWEEN '2019-01-01' AND '2019-12-31'


SELECT * FROM BDMaster..Almacenes
--UPDATE BDMaster..Almacenes SET Direccion_IP = '(Local)\SQL12', Direccion_IPNuevo = '(Local)\SQL12'
 ----------------------------------------------------

SELECT DISTINCT DETA.ARTIC_Codigo, ARTI.ARTIC_Descripcion FROM VENTAS.VENT_DocsVentaDetalle DETA
 INNER JOIN VENTAS.VENT_DocsVenta CAB ON CAB.DOCVE_Codigo = DETA.DOCVE_Codigo
 INNER JOIN dbo.Articulos ARTI ON ARTI.ARTIC_Codigo = DETA.ARTIC_Codigo
 WHERE CONVERT(DATE, CAB.DOCVE_FechaDocumento) BETWEEN '2020-01-01' AND '2020-12-31'
   AND CAB.DOCVE_Estado <> 'X'
UNION 
SELECT DISTINCT DETA.ARTIC_Codigo, ARTI.ARTIC_Descripcion 
  FROM Logistica.ABAS_DocsCompraDetalle DETA
 INNER JOIN Logistica.ABAS_DocsCompra COMP ON COMP.DOCCO_Codigo = DETA.DOCCO_Codigo 
   AND COMP.ENTID_CodigoProveedor = DETA.ENTID_CodigoProveedor
 INNER JOIN dbo.Articulos ARTI ON ARTI.ARTIC_Codigo = DETA.ARTIC_Codigo
 WHERE CONVERT(DATE, COMP.DOCCO_FechaDocumento) BETWEEN '2020-01-01' AND '2020-12-31'
  AND COMP.DOCCO_Estado <> 'X'
