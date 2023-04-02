USE BDInkaceroPeru
GO

begin tran x

DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDInkaceroPeru'
DECLARE @SUCUR_Direccion VARCHAR(60) = 'CAL.ALEJANDRO VELASCO ASTETE NRO. 606'
DECLARE @Empresaruc VARCHAR(20) = '20609111268'
DECLARE @EmpresaNombre VARCHAR(100) = 'INKACERO PERU S.A.C.'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'INKAC'
DECLARE @PVENT_DireccionIP VARCHAR(25) = 'SERVERINKACERO\SQL12'

UPDATE Almacenes set ALMAC_Direccion = @SUCUR_Direccion
UPDATE Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion
UPDATE PuntoVenta SET PVENT_DireccionIP = @PVENT_DireccionIP, PVENT_BaseDatos = @PVENT_BaseDatos, PVENT_DireccionIPAC = @PVENT_DireccionIP, PVENT_BaseDatosAC = @PVENT_BaseDatos
UPDATE Parametros SET PARMT_Valor = @Empresaruc where PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = @EmpresaNombre where PARMT_Id = 'EmpresaRS'

PRINT 'UPDATE EMPRESAS'

UPDATE BDSAdmin..EMPRESAS SET EMPR_Desc = @EmpresaNombre, EMPR_Codigo = @EMPRE_Codigo, EMPR_RUC = @Empresaruc, EMPR_Servidor = @PVENT_DireccionIP, EMPR_BaseDatos = @PVENT_BaseDatos
      , EMPR_Direc = LEFT(@SUCUR_Direccion, 50)
UPDATE bdsadmin..Sucursales SET SUCUR_DireccionIP = @PVENT_DireccionIP
UPDATE BDSAdmin..Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion, SUCUR_DireccionIP = @PVENT_DireccionIP
UPDATE dbo.Parametros SET PARMT_Valor = @Empresaruc WHERE PARMT_Id = 'Empresa'
UPDATE dbo.Parametros SET PARMT_Valor = @EmpresaNombre WHERE PARMT_Id = 'EmpresaRS'

--insert into UsuariosPorPuntoVenta(ZONAS_Codigo,SUCUR_Id,PVENT_Id,ENTID_Codigo,USPTA_UsrCrea,USPTA_FecCrea)
--values('84.00',1, 1,'00000000', 'SISTEMAS', GETDATE() )

--SELECT * FROM dbo.Periodos
delete FROM dbo.Periodos WHERE PERIO_Codigo < 2020

UPDATE dbo.Periodos SET PERIO_Codigo = '2022', PERIO_Descripcion = 'Periodo 2022' WHERE PERIO_Codigo = 2020

SELECT * FROM dbo.Parametros
select * from bdsadmin..Empresas --WHERE EMPR_Codigo <> 'NOVAC'
select * from bdsadmin..Sucursales
select * from periodos  

--INSERT INTO Ventas.VENT_PVentDocumento
--SELECT * FROM BDCOMAFISUR.Ventas.VENT_PVentDocumento

commit tran x
--rollback tran x

SELECT * FROM UsuariosPorPuntoVenta
SELECT * FROM Articulos
--SELECT * FROM BDCOMAFISUR.Ventas.VENT_PVentDocumento
--select * from bdsadmin..usuarios    


--USE BDSAdmin
--go
USE BDAcerosFirme