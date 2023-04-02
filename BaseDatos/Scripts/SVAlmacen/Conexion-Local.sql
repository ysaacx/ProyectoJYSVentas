
USE BDSAdmin

--SELECT * FROM dbo.Sucursales
--SELECT * FROM dbo.Empresas
--UPDATE dbo.Sucursales SET SUCUR_DireccionIP = '192.168.1.33\SQL12'
--UPDATE dbo.Empresas SET EMPR_Servidor = '192.168.1.33\SQL12'

UPDATE dbo.Sucursales SET SUCUR_DireccionIP = '(Local)\SQL12'
UPDATE dbo.Empresas SET EMPR_Servidor = '(Local)\SQL12'

--SELECT * FROM Empresas
--UPDATE Empresas SET EMPR_Activo = 0 , EMPR_Isolation = 0
--UPDATE Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo IN ('ADECO', 'DAFLO')

USE BDInkaPeru
go
--SELECT * FROM Puntoventa
--UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = '192.168.1.33\SQL12', PVENT_DireccionIPAC = '192.168.1.33\SQL12'
UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12'

--SELECT * FROM EMPRESAS

--SELECT *  FROM SE




