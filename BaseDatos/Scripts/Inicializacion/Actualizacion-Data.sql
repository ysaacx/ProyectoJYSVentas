
USE BDSisSCC
GO


SELECT * FROM Logistica.ABAS_IngresosCompra WHERE ENTID_CodigoProveedor = ''
SELECT * FROM Logistica.ABAS_IngresosCompra WHERE INGCO_Serie = '038'

SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '20370146994'
SELECT * FROM Logistica.ABAS_IngresosCompra WHERE DOCCO_Codigo = '010380024021' AND ENTID_CodigoProveedor = '20370146994'

SELECT * FROM Logistica.ABAS_IngresosCompraDetalle WHERE INGCO_Id = 111
SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo  = '010380024021' AND ENTID_CodigoProveedor = '20370146994'

DELETE FROM Logistica.LOG_Stocks WHERE INGCO_Id = 111

exec LOG_DOCCOSS_TodosDocCompra @ZONAS_Codigo=N'83.00',@SUCUR_Id=1,@Cadena=N'',@Opcion=0,@Todos=1,@FecIni='2017-09-01 00:00:00',@FecFin='2017-09-23 00:00:00'


SELECT * FROM Logistica.ABAS_IngresosCompra WHERE DOCCO_Codigo = '010380024020' AND ENTID_CodigoProveedor = '20370146994'
SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo  = '010380024020' AND ENTID_CodigoProveedor = '20370146994'

SELECT * FROM Logistica.ABAS_IngresosCompra WHERE DOCCO_Codigo = '010150012028' AND ENTID_CodigoProveedor = '20370146994'
SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo  = '010150012028' AND ENTID_CodigoProveedor = '20370146994'

