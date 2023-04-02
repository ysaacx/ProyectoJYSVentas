
USE bdmaster
GO

SELECT COUNT(*) FROM dbo.Ingresos
SELECT COUNT(*) FROM dbo.Ingresos_Detalle

SELECT COUNT(*) FROM dbo.Compras
SELECT COUNT(*) FROM dbo.Compras_Detalle

SELECT COUNT(*) FROM dbo.Ventas
SELECT COUNT(*) FROM dbo.Ventas_Detalle

SELECT COUNT(*) FROM dbo.Movimientos
SELECT COUNT(*) FROM dbo.Movimientos_Detalle

SELECT COUNT(*) FROM dbo.Kardex_valorado
SELECT COUNT(*) FROM dbo.detalle
SELECT TOP 100 * FROM dbo.detalle


/*===============================================================================================*/

DELETE FROM dbo.Ingresos_Detalle
DELETE FROM dbo.Ingresos

DELETE FROM dbo.Compras_Detalle
DELETE FROM dbo.Compras

DELETE FROM dbo.Ventas_Detalle
DELETE FROM dbo.Ventas

DELETE FROM dbo.Movimientos_Detalle
DELETE FROM dbo.Movimientos

DELETE FROM dbo.Kardex_valorado
DELETE FROM dbo.detalle

DELETE FROM dbo.StockInicial
DELETE FROM dbo.Clientes
DELETE FROM dbo.Total_Valorado

DELETE FROM dbo.Productos
DELETE FROM dbo.Proveedor
DELETE FROM dbo.Stocks
DELETE FROM TipoCambio

/*===============================================================================================*/

Use BDMaster
dbcc sqlperf(logspace)
backup log BDADyA to disk = 'D:\Deleted\BK.LOG' WITH NO_TRUNCATE
backup log BDADyA to disk = 'D:\Deleted\BK.LOG'
use BDMaster
DBCC SHRINKFILE ('BDMasterAceros_log',NOTRUNCATE)
DBCC SHRINKFILE ('BDMasterAceros_log',TRUNCATEONLY)
DBCC SHRINKDATABASE ('BDMaster')
CHECKPOINT 
dbcc sqlperf(logspace)
backup log BDMaster to disk = 'D:\Deleted\BK.LOG' WITH NO_TRUNCATE
backup log BDMaster to disk = 'D:\Deleted\BK.LOG'  

ALTER DATABASE BDMaster
SET RECOVERY SIMPLE;
GO
-- reducirmos el archivo log a 1 MB.
DBCC SHRINKFILE (BDMasterAceros_log, 1);
GO
-- devolvemos el nivel de recovery a full
ALTER DATABASE BDMaster
SET RECOVERY FULL;
GO

