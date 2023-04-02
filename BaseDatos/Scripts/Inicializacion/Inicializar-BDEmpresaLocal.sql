

SELECT * FROM BDSAdmin..Sucursales
SELECT * FROM BDSAdmin..Empresas
GO
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = 'Ysaacx-LP\SQL12' WHERE EMPR_Codigo = 'SCCYR'
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'Ysaacx-LP\SQL12'

USE BDInkasFerro_Almudena
GO

UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = 'Ysaacx-LP\SQL12', PVENT_DireccionIPAC = 'Ysaacx-LP\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_Parusttacca' WHERE PVENT_Id = 1
UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = 'Ysaacx-LP\SQL12', PVENT_DireccionIPAC = 'Ysaacx-LP\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_Almudena' WHERE PVENT_Id = 2

SELECT * FROM dbo.PuntoVenta
SELECT * FROM dbo.Almacenes


USE BDSisSCC

UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' , PVENT_BaseDatos = 'BDSisSCC' WHERE PVENT_Id = 1
UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' , PVENT_BaseDatos = 'BDSisSCC' WHERE PVENT_Id = 2
