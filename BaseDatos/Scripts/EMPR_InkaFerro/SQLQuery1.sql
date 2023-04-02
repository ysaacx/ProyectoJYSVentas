USE ACAdmin
GO


SELECT * FROM dbo.Niveles
SELECT * FROM dbo.NivelesPltaMenu
SELECT * FROM dbo.Usuarios
SELECT * FROM dbo.UsuariosProcesos WHERE USER_IdUser = 5
SELECT *  FROM dbo.Empresas


USE BDInkasFerro_Almudena
go
SELECT * FROM Tesoreria.TESO_Caja

exec VENT_DOCVESS_CajaPagos @DOCVE_Codigo=N'03F0010000001'


USE BDSAdmin

SELECT * FROM dbo.Empresas

USE BDInkasFerro_Parusttacca
--UPDATE Ventas.VENT_PVentDocumento SET PVENT_Id = 2 WHERE PVENT_Id is null
--UPDATE Ventas.VENT_PVentDocumento SET PVDOCU_DispositivoImpresion = 'PDFCreator'