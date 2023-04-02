USE BDJAYVIC
GO

--select * from Almacenes
--select * from Sucursales
--select * from PuntoVenta
--select * from Ventas.VENT_PVentDocumento
--SELECT * FROM dbo.Zonas
--SELECT * FROM UsuariosPorPuntoVenta

--select * from  Parametros where PARMT_Id = 'Empresa'
--select * from  Parametros where PARMT_Id = 'EmpresaRS'

begin tran x

DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDJAYVIC'
DECLARE @SUCUR_Direccion VARCHAR(60) = 'NRO. S/N WICHAYPAMPA (LOTE Z1 MZA 7 VIA PRINCIPAL 2CDRS D PTE)'
DECLARE @Empresaruc VARCHAR(20) = '20563926709'
DECLARE @EmpresaNombre VARCHAR(100) = 'INVERSIONES JAYVIC EIRL.'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'JAYVI'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '(LOCAL)\SQL12'

UPDATE Almacenes  SET ALMAC_Direccion = @SUCUR_Direccion
UPDATE Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion
UPDATE PuntoVenta SET PVENT_DireccionIP = @PVENT_DireccionIP, PVENT_BaseDatos = @PVENT_BaseDatos, PVENT_DireccionIPAC = @PVENT_DireccionIP, PVENT_BaseDatosAC = @PVENT_BaseDatos
UPDATE Parametros SET PARMT_Valor = @Empresaruc where PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = @EmpresaNombre where PARMT_Id = 'EmpresaRS'

PRINT 'UPDATE EMPRESAS'

UPDATE BDSAdmin..EMPRESAS SET EMPR_Desc = @EmpresaNombre, EMPR_Codigo = @EMPRE_Codigo, EMPR_RUC = @Empresaruc, EMPR_Servidor = @PVENT_DireccionIP, EMPR_BaseDatos = @PVENT_BaseDatos
      , EMPR_Direc = LEFT(@SUCUR_Direccion, 50)
UPDATE bdsadmin..Sucursales SET SUCUR_DireccionIP = @PVENT_DireccionIP
UPDATE BDSAdmin..Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion, SUCUR_DireccionIP = @PVENT_DireccionIP, ZONAS_Codigo = '84.00'
UPDATE dbo.Parametros SET PARMT_Valor = @Empresaruc WHERE PARMT_Id = 'Empresa'
UPDATE dbo.Parametros SET PARMT_Valor = @EmpresaNombre WHERE PARMT_Id = 'EmpresaRS'

insert into UsuariosPorPuntoVenta(ZONAS_Codigo,SUCUR_Id,PVENT_Id,ENTID_Codigo,USPTA_UsrCrea,USPTA_FecCrea)
values('84.00',1, 1,'00000000', 'SISTEMAS', GETDATE() )
SELECT * FROM Periodos
delete FROM dbo.Periodos WHERE PERIO_Codigo < 2020

UPDATE dbo.Periodos SET PERIO_Codigo = '2021', PERIO_Descripcion = 'Periodo 2021' WHERE PERIO_Codigo = 2020

SELECT * FROM dbo.Parametros
select * from bdsadmin..Empresas --WHERE EMPR_Codigo <> 'NOVAC'
select * from bdsadmin..Sucursales
select * from periodos  

--INSERT INTO Ventas.VENT_PVentDocumento
--SELECT * FROM BDCOMAFISUR.Ventas.VENT_PVentDocumento

commit tran x
--rollback tran x
--sp_who2

--SELECT * FROM UsuariosPorPuntoVenta
--SELECT * FROM Articulos
--SELECT * FROM BDCOMAFISUR.Ventas.VENT_PVentDocumento
--select * from bdsadmin..usuarios    


--USE BDSAdmin
--go
USE BDAcerosFirme
go
--SELECT * FROM dbo.UsuariosPorPuntoVenta
--SELECT * FROM dbo.Zonas
--SELECT * FROM BDCOMAFISUR.dbo.UsuariosPorPuntoVenta

--SELECT * FROM BDCOMAFISUR.dbo.Zonas
--SELECT * FROM BDNOVACERO.dbo.Zonas



--INSERT INTO Ventas.VENT_ListaPreciosArticulos
--SELECT * FROM BDCOMAFISUR.Ventas.VENT_ListaPreciosArticulos

--INSERT INTO Precios
--SELECT * FROM BDCOMAFISUR.dbo.Precios

--INSERT INTO Articulos
--SELECT * FROM dbo.Articulos

--INSERT INTO Ventas.VENT_ListaPrecios
--SELECT * FROM Ventas.VENT_ListaPrecios