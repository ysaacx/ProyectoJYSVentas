USE BDSAdmin
GO

UPDATE dbo.Sucursales SET SUCUR_DireccionIP = '(Local)\SQL12'
UPDATE dbo.Empresas SET EMPR_Servidor = '(Local)\SQL12'

USE BDSVAlmacen
GO
UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12'
