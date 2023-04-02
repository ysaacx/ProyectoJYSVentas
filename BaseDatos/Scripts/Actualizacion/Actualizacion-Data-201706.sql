
/*===========================================================-----------------------------------------------------===========================================================*/
USE BDSAdmin
GO

--delete FROM dbo.Procesos WHERE PROC_Codigo = 'PRBPI'

INSERT INTO dbo.Procesos( APLI_Codigo ,PROC_Codigo ,PROC_Descripcion ,PROC_UsrCrea ,PROC_FecCrea ,PROC_CopyDefault)
SELECT APLI_Codigo ,PROC_Codigo ,PROC_Descripcion ,PROC_UsrCrea ,PROC_FecCrea ,PROC_CopyDefault
FROM (
   SELECT APLI_Codigo = 'VTA' , PROC_Codigo = 'PRBPI' ,PROC_Descripcion =  'Cotización de Ventas - No Permitir busqueda de productos instantanea' , PROC_UsrCrea = 'SISTEMAS' ,PROC_FecCrea= GETDATE() , PROC_CopyDefault = 1 
) PRO
WHERE NOT PROC_Codigo IN (SELECT PROC_Codigo FROM dbo.Procesos)

GO

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

IF NOT EXISTS(SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '11000000000')
   BEGIN 
      SET @ID = @ID + 1
      INSERT INTO dbo.[Entidades](ENTID_Codigo, TIPOS_CodTipoDocumento, UBIGO_Codigo, ENTID_Id, ENTID_TipoEntidadPDT, ENTID_Nombres, ENTID_NroDocumento, ENTID_RazonSocial, ENTID_NombreComercial, ENTID_FecNacimiento, ENTID_PtrApeMaterno, ENTID_PtrNombre1, ENTID_PtrNombre2, ENTID_EMail, ENTID_Estado, ENTID_Direccion, ENTID_Telefono1, ENTID_Telefono2, ENTID_Fax, USUAR_Codigo, ENTID_CodUsuario, ENTID_CodBusqueda, ENTID_UsrCrea, ENTID_FecCrea, ENTID_UsrMod, ENTID_FecMod) 
      VALUES ('11000000000', 'DID6', NULL,  @ID , 'N', 'CLIENTE EN BLANCO', '11000000000', 'CLIENTE EN BLANCO', NULL, '05-03-2013 12:51:03',  8 ,  11 , NULL, NULL, 'A', NULL, NULL, NULL, NULL, '11000000000', NULL, NULL, '40975980' , '05-03-2013 12:51:52' , '44274911' , '11-19-2013 05:04:25' )
   END 

UPDATE dbo.Parametros SET PARMT_Valor = '3.3.0.6' WHERE PARMT_Id = 'pg_Version'

/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
/*===========================================================-----------------------------------------------------===========================================================*/
