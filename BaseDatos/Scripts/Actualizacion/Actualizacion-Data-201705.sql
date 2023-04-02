USE BDSisSCC

---------------------------------------==========================================================---------------------------------------

USE BDSisSCC
GO

DECLARE @ID INT
SET @ID = ISNULL((SELECT MAX(ENTID_Id) FROM Entidades), 0) + 1

IF NOT EXISTS(SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '10000000000')
   BEGIN 
      INSERT INTO dbo.[Entidades](ENTID_Codigo, TIPOS_CodTipoDocumento, UBIGO_Codigo, ENTID_Id, ENTID_TipoEntidadPDT, ENTID_Nombres, ENTID_NroDocumento, ENTID_RazonSocial, ENTID_NombreComercial, ENTID_FecNacimiento, ENTID_PtrApeMaterno, ENTID_PtrNombre1, ENTID_PtrNombre2, ENTID_EMail, ENTID_Estado, ENTID_Direccion, ENTID_Telefono1, ENTID_Telefono2, ENTID_Fax, USUAR_Codigo, ENTID_CodUsuario, ENTID_CodBusqueda, ENTID_UsrCrea, ENTID_FecCrea, ENTID_UsrMod, ENTID_FecMod) 
      VALUES ('10000000000', 'DID6', NULL   ,  @ID  , 'J', 'CLIENTE ANULADO', '10000000000', 'CLIENTE ANULADO', 'CLIENTE ANULADO', '09-10-2011 11:10:07', NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '40975980' , '09-10-2011 11:11:42' , NULL , NULL )
END

IF NOT EXISTS(SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '10000000001')
   BEGIN 
      SET @ID = @ID + 1

      INSERT INTO dbo.[Entidades](ENTID_Codigo, TIPOS_CodTipoDocumento, UBIGO_Codigo, ENTID_Id, ENTID_TipoEntidadPDT, ENTID_Nombres, ENTID_NroDocumento, ENTID_RazonSocial, ENTID_NombreComercial, ENTID_FecNacimiento, ENTID_PtrApeMaterno, ENTID_PtrNombre1, ENTID_PtrNombre2, ENTID_EMail, ENTID_Estado, ENTID_Direccion, ENTID_Telefono1, ENTID_Telefono2, ENTID_Fax, USUAR_Codigo, ENTID_CodUsuario, ENTID_CodBusqueda, ENTID_UsrCrea, ENTID_FecCrea, ENTID_UsrMod, ENTID_FecMod) 
      VALUES ('10000000001', 'DID6', NULL,  @ID , 'J', 'CLIENTE EN BLANCO', '10000000001', '- -', 'CLIENTE EN BLANCO', '04-13-2012 09:14:50', NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '40975980' , '04-13-2012 09:15:26' , NULL , NULL )
   END 

---------------------------------------==========================================================---------------------------------------


DELETE FROM BDSAdmin..UsuariosPlantillas WHERE EMPR_Codigo IN (SELECT EMPR_Codigo FROM BDSAdmin..Empresas WHERE EMPR_Activo = 0)
DELETE FROM BDSAdmin..PlantillasMenu WHERE EMPR_Codigo IN (SELECT EMPR_Codigo FROM BDSAdmin..Empresas WHERE EMPR_Activo = 0)
DELETE FROM BDSAdmin..UsuariosProcesos WHERE EMPR_Codigo IN (SELECT EMPR_Codigo FROM BDSAdmin..Empresas WHERE EMPR_Activo = 0)
DELETE FROM BDSAdmin..Empresas WHERE EMPR_Activo = 0

UPDATE dbo.Parametros SET PARMT_Valor = '3.3.1.1' WHERE PARMT_Id = 'pg_Version'

UPDATE BDSAdmin.dbo.Sucursales SET SUCUR_DireccionIP = 'SCC-HP\SQL12', SUCUR_BaseDatos = 'BDSAdmin'
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = 'SCC-HP\SQL12'
UPDATE BDSisSCC.dbo.PuntoVenta SET PVENT_DireccionIP = 'SCC-HP\SQL12', PVENT_DireccionIPAC = 'SCC-HP\SQL12' 

--SELECT * FROM BDSAdmin..Empresas

UPDATE BDSisSCC.dbo.tipos SET TIPOS_Items = 11 WHERE TIPOS_Codigo IN ('CPD03', 'CPD01')

SELECT * FROM dbo.Parametros

UPDATE BDSisSCC..Parametros SET PARMT_Valor = '\\Scc-hp\epson lx-350 facturas' WHERE PARMT_Id IN ('pg_ImpDefault', 'pg_ImpOrden')

---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------



