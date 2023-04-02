USE BDSAdmin
go

SELECT * FROM dbo.Empresas
SELECT * FROM Sucursales 
SELECT * FROM dbo.Usuarios

UPDATE Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo = 'ADECO'
UPDATE Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo = 'DAFLO'
UPDATE dbo.Usuarios SET USER_Activo = 1 WHERE USER_DNI = '40975980'
UPDATE BDAdmin..Empresas SET EMPR_Servidor = '(Local)\SQL12' WHERE EMPR_Codigo = 'SCCYR'
--SELECT * FROM BDSAdmin..Sucursales
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = '(Local)\SQL12'

USE BDAmbientaDecora
GO

SELECT * FROM dbo.PuntoVenta
UPDATE PuntoVenta SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12', PVENT_BDAdmin = 'BDSAdmin'


SELECT * FROM dbo.UsuariosPorPuntoVenta

INSERT INTO dbo.UsuariosPorPuntoVenta ( ZONAS_Codigo ,SUCUR_Id ,PVENT_Id ,ENTID_Codigo ,USPTA_UsrCrea ,USPTA_FecCrea )
VALUES  ( '54.00' ,1 , 1,'00000000','SISTEMAS' ,GETDATE() )
