
---------------------------------------==========================================================---------------------------------------
USE BDInkasFerro_Almudena
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
      VALUES ('10000000001', 'DID1', NULL,  @ID , 'J', 'CLIENTE EN BLANCO', '10000000001', '- -', 'CLIENTE EN BLANCO', '04-13-2012 09:14:50', NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '40975980' , '04-13-2012 09:15:26' , NULL , NULL )

      INSERT INTO dbo.[Entidades](ENTID_Codigo, TIPOS_CodTipoDocumento, UBIGO_Codigo, ENTID_Id, ENTID_TipoEntidadPDT, ENTID_Nombres, ENTID_NroDocumento, ENTID_RazonSocial, ENTID_NombreComercial, ENTID_FecNacimiento, ENTID_PtrApeMaterno, ENTID_PtrNombre1, ENTID_PtrNombre2, ENTID_EMail, ENTID_Estado, ENTID_Direccion, ENTID_Telefono1, ENTID_Telefono2, ENTID_Fax, USUAR_Codigo, ENTID_CodUsuario, ENTID_CodBusqueda, ENTID_UsrCrea, ENTID_FecCrea, ENTID_UsrMod, ENTID_FecMod) 
      VALUES ('11000000000', 'DID1', NULL,  @ID , 'J', 'CLIENTE EN BLANCO', '10000000001', '- -', 'CLIENTE EN BLANCO', '04-13-2012 09:14:50', NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '40975980' , '04-13-2012 09:15:26' , NULL , NULL )
   END 

UPDATE dbo.Entidades SET TIPOS_CodTipoDocumento = 'DID1' WHERE ENTID_Codigo = '10000000001'
UPDATE dbo.Entidades SET TIPOS_CodTipoDocumento = 'DID1' WHERE ENTID_Codigo = '11000000000'
   --SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '10000000001'
   --SELECT * FROM dbo.Entidades WHERE ENTID_Nombres LIKE '%BLANCO%'
   --SELECT * FROM TIPOS WHERE TIPOS_Codigo LIKE 'DID%'

---------------------------------------==========================================================---------------------------------------
--UPDATE Parametros SET PARMT_Valor = '\\Scc-hp\epson lx-350 facturas' WHERE PARMT_Id IN ('pg_ImpDefault', 'pg_ImpOrden')
---------------------------------------==========================================================---------------------------------------

UPDATE Logistica.ABAS_DocsCompra SET DOCCO_TipoRegistro = 'I' WHERE DOCCO_TipoRegistro IS NULL 
UPDATE dbo.Parametros SET PARMT_Valor = '3.3.1.5' WHERE PARMT_Id = 'pg_Version'

---------------------------------------==========================================================---------------------------------------

DECLARE @ENTID_ID BIGINT
   SET @ENTID_ID = ISNULL((SELECT MAX(ENTID_Id) FROM ENTIDADES), 0) + 1 

INSERT INTO dbo.Entidades
     ( ENTID_Codigo ,          TIPOS_CodTipoDocumento ,          UBIGO_Codigo ,          ENTID_Id ,                 ENTID_TipoEntidadPDT ,
       ENTID_Nombres ,         ENTID_NroDocumento ,              ENTID_RazonSocial ,     ENTID_NombreComercial ,    ENTID_FecNacimiento ,
       ENTID_PtrApeMaterno ,   ENTID_PtrNombre1 ,                ENTID_PtrNombre2 ,      ENTID_EMail ,              ENTID_Estado ,
       ENTID_Direccion ,       USUAR_Codigo ,                    ENTID_UsrCrea ,         ENTID_FecCrea ,            ENTID_UsrMod ,
       ENTID_FecMod ,          ENTID_CodUsuario ,                ENTID_CodBusqueda)
SELECT ENTID_Codigo ,          TIPOS_CodTipoDocumento ,          UBIGO_Codigo ,          ENTID_Id ,                 ENTID_TipoEntidadPDT ,
       ENTID_Nombres ,         ENTID_NroDocumento ,              ENTID_RazonSocial ,     ENTID_NombreComercial ,    ENTID_FecNacimiento ,
       ENTID_PtrApeMaterno ,   ENTID_PtrNombre1 ,                ENTID_PtrNombre2 ,      ENTID_EMail ,              ENTID_Estado ,
       ENTID_Direccion ,       USUAR_Codigo ,                    ENTID_UsrCrea ,         ENTID_FecCrea ,            ENTID_UsrMod ,
       ENTID_FecMod ,          ENTID_CodUsuario ,                ENTID_CodBusqueda
FROM (
SELECT ENTID_Codigo = '11000000000',          TIPOS_CodTipoDocumento = 'DID6',          UBIGO_Codigo = NULL ,          
       ENTID_Id = @ENTID_ID ,
       ENTID_TipoEntidadPDT = 'N',
       ENTID_Nombres = 'CLIENTE EN BLANCO',         ENTID_NroDocumento = '11000000000',              ENTID_RazonSocial = 'CLIENTE EN BLANCO',     ENTID_NombreComercial = NULL ,    ENTID_FecNacimiento = '2013-05-03 12:51:03.960' ,
       ENTID_PtrApeMaterno = 8,   ENTID_PtrNombre1 = 11,                ENTID_PtrNombre2 = NULL ,      ENTID_EMail = NULL ,              ENTID_Estado = 'A',
       ENTID_Direccion = NULL ,       USUAR_Codigo = '11000000000' ,                    ENTID_UsrCrea = '40975980',         ENTID_FecCrea = GETDATE(),            ENTID_UsrMod = NULL ,
       ENTID_FecMod = NULL ,          ENTID_CodUsuario = NULL ,                ENTID_CodBusqueda = NULL )
    ENTIDAD
 WHERE NOT ENTIDAD.ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades)

---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------
---------------------------------------==========================================================---------------------------------------



