USE BDSAdmin
GO

SELECT * FROM dbo.Sucursales
SELECT * FROM dbo.Empresas
SELECT * FROM dbo.Aplicaciones
UPDATE Sucursales SET SUCUR_BaseDatos = 'BDSAdmin'
UPDATE dbo.Empresas SET EMPR_Activo = 1 , EMPR_BaseDatos = 'BDSVAlmacen' WHERE EMPR_Codigo = 'ACDYA'

SELECT * FROM dbo.Usuarios

USE BDSVAlmacen
GO

SELECT * FROM dbo.PuntoVenta
SELECT * FROM dbo.Sucursales
UPDATE PuntoVenta SET PVENT_BaseDatos = 'BDSVAlmacen', PVENT_BDAdmin = 'BDSAdmin'
