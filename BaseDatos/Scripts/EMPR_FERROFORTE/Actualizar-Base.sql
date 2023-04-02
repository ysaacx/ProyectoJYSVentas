USE BDFERROFORTE
GO

--select * from Almacenes
--select * from Sucursales
--select * from PuntoVenta
--select * from Ventas.VENT_PVentDocumento

--select * from  Parametros where PARMT_Id = 'Empresa'
--select * from  Parametros where PARMT_Id = 'EmpresaRS'

begin tran x

DECLARE @PVENT_BaseDatos VARCHAR(25) = 'BDFERROFORTE'
DECLARE @SUCUR_Direccion VARCHAR(60) = 'OTR.PARCELA CONDEBAMBA NRO. 10 SEC. PAMPLONA'
DECLARE @Empresaruc VARCHAR(20) = '20607724394'
DECLARE @EmpresaNombre VARCHAR(100) = 'FERROFORTE SAC'
DECLARE @EMPRE_Codigo VARCHAR(5) = 'FERRO'
DECLARE @PVENT_DireccionIP VARCHAR(25) = '(LOCAL)\SQL12'

UPDATE Almacenes set ALMAC_Direccion = @SUCUR_Direccion
UPDATE Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion
UPDATE PuntoVenta SET PVENT_DireccionIP = @PVENT_DireccionIP, PVENT_BaseDatos = @PVENT_BaseDatos, PVENT_DireccionIPAC = @PVENT_DireccionIP, PVENT_BaseDatosAC = @PVENT_BaseDatos
UPDATE Parametros SET PARMT_Valor = @Empresaruc where PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = @EmpresaNombre where PARMT_Id = 'EmpresaRS'


--DELETE FROM BDSAdmin.dbo.UsuariosAplicaciones WHERE EMPR_Codigo <> @EMPRE_Codigo
--DELETE FROM BDSAdmin.dbo.UsuariosEmpresas WHERE EMPR_Codigo <> @EMPRE_Codigo

--DELETE FROM BDSAdmin.dbo.PlantillasMenu WHERE EMPR_Codigo <> @EMPRE_Codigo
--DELETE FROM BDSAdmin.dbo.UsuariosProcesos WHERE EMPR_Codigo <> @EMPRE_Codigo
--DELETE FROM BDSAdmin.dbo.UsuariosPlantillas WHERE EMPR_Codigo <> @EMPRE_Codigo
--DELETE FROM BDSAdmin.dbo.PlantillasMenu WHERE EMPR_Codigo <> @EMPRE_Codigo

--DELETE FROM BDSAdmin.dbo.UsuariosEmpresas WHERE EMPR_Codigo <> @EMPRE_Codigo
--DELETE FROM BDSAdmin.dbo.Usuarios WHERE NOT USER_IdUser IN (5, 104)
--DELETE FROM BDSAdmin.dbo.Sucursales



PRINT 'UPDATE EMPRESAS'
UPDATE BDSAdmin..EMPRESAS SET EMPR_Desc = @EmpresaNombre, EMPR_Codigo = @EMPRE_Codigo, EMPR_RUC = @Empresaruc, EMPR_Servidor = @PVENT_DireccionIP, EMPR_BaseDatos = @PVENT_BaseDatos
      , EMPR_Direc = @SUCUR_Direccion
UPDATE bdsadmin..Sucursales SET SUCUR_DireccionIP = @PVENT_DireccionIP
select * from bdsadmin..Empresas --WHERE EMPR_Codigo <> 'NOVAC'
select * from bdsadmin..Sucursales
--UPDATE BDSAdmin..Sucursales SET EMPRE_Codigo = @EMPRE_Codigo, SUCUR_Direccion = @SUCUR_Direccion, SUCUR_DireccionIP = @PVENT_DireccionIP


--INSERT INTO BDSAdmin.dbo.Sucursales
--        ( ZONAS_Codigo ,          SUCUR_Id ,          UBIGO_Codigo ,          EMPRE_Codigo ,
--          SUCUR_Nombre ,          SUCUR_Direccion ,          SUCUR_Telefono ,          SUCUR_DireccionIP ,
--          SUCUR_BaseDatos ,          SUCUR_Activo ,          SUCUR_UsrCrea ,          SUCUR_FecCrea 
--        )
-- SELECT ZONAS_Codigo ,          SUCUR_Id ,              UBIGO_Codigo ,            EMPRE_Codigo ,
--        SUCUR_Nombre ,          SUCUR_Direccion ,       SUCUR_Telefono ,          SUCUR_DireccionIP ,
--        SUCUR_BaseDatos ,       SUCUR_Activo ,          SUCUR_UsrCrea ,           SUCUR_FecCrea 
--   FROM (SELECT ZONAS_Codigo = '83.00', SUCUR_Id = 1,        UBIGO_Codigo = NULL,      EMPRE_Codigo = @EMPRE_Codigo,
--                SUCUR_Nombre = 'Sucursal Principal',          SUCUR_Direccion = @SUCUR_Direccion,
--                SUCUR_Telefono = NULL,                       SUCUR_DireccionIP = @PVENT_DireccionIP,
--                SUCUR_BaseDatos = 'BDSAdmin',                SUCUR_Activo = 1,          
--                SUCUR_UsrCrea = 'SISTEMAS',                  SUCUR_FecCrea = GETDATE()
--              ) SUCUR
--          WHERE NOT SUCUR.ZONAS_Codigo + '-' + RTRIM(SUCUR.SUCUR_Id) + '-' + SUCUR.EMPRE_Codigo 
--             IN (SELECT ZONAS_Codigo + '-' + RTRIM(SUCUR_Id) + '-' + EMPRE_Codigo FROM dbo.Sucursales)


commit tran x
--rollback tran x


--SELECT * FROM BDSAdmin..Sucursales


--SELECT * FROM BDSAdmin..EMPRESAS


--select GETUTCDATE()



DECLARE @Empresaruc VARCHAR(20) = '20607724394'
DECLARE @EmpresaNombre VARCHAR(100) = 'FERROFORTE SAC'

UPDATE dbo.Parametros SET PARMT_Valor = @Empresaruc WHERE PARMT_Id = 'Empresa'
UPDATE dbo.Parametros SET PARMT_Valor = @EmpresaNombre WHERE PARMT_Id = 'EmpresaRS'


DECLARE @Empresaruc VARCHAR(20) = '20607724394'
DECLARE @EmpresaNombre VARCHAR(100) = 'FERROFORTE SAC'

