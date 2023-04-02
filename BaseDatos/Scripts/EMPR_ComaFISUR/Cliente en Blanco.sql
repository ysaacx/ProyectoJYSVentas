
SELECT * FROM dbo.Entidades

SELECT * FROM dbo.Roles

--DELETE FROM dbo.EntidadesRoles WHERE ROLES_Id = 1 AND ENTID_Codigo <> '00000000'

Select m_Ent.* , IsNUll(ENTID_Direccion,'') + ' - ' + IsNull(Dis.UBIGO_Descripcion + ' / ' + Pro.UBIGO_Descripcion + ' / ' + Dep.UBIGO_Descripcion, '') As Direccion
			From dbo.Entidades As m_Ent 
				Left Join Ubigeos As Dep On Dep.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 2)
				Left Join Ubigeos As Pro On Pro.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 5)
				Left Join Ubigeos As Dis On Dis.UBIGO_Codigo = m_Ent.UBIGO_Codigo
			WHERE   m_Ent.ENTID_NroDocumento = '11000000000'
      

      

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
   END 

IF NOT EXISTS(SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '11000000000')
   BEGIN 
      INSERT INTO dbo.[Entidades](ENTID_Codigo, TIPOS_CodTipoDocumento, UBIGO_Codigo, ENTID_Id, ENTID_TipoEntidadPDT, ENTID_Nombres, ENTID_NroDocumento, ENTID_RazonSocial, ENTID_NombreComercial, ENTID_FecNacimiento, ENTID_PtrApeMaterno, ENTID_PtrNombre1, ENTID_PtrNombre2, ENTID_EMail, ENTID_Estado, ENTID_Direccion, ENTID_Telefono1, ENTID_Telefono2, ENTID_Fax, USUAR_Codigo, ENTID_CodUsuario, ENTID_CodBusqueda, ENTID_UsrCrea, ENTID_FecCrea, ENTID_UsrMod, ENTID_FecMod) 
      VALUES ('11000000000', 'DID1', NULL,  @ID , 'N', 'CLIENTE EN BLANCO', '11000000', '- -', 'CLIENTE EN BLANCO', '04-13-2012 09:14:50', NULL, NULL, NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '40975980' , '04-13-2012 09:15:26' , NULL , NULL )
   END


UPDATE dbo.Entidades SET ENTID_NroDocumento = '11000000000', TIPOS_CodTipoDocumento = 'DID1', ENTID_TipoEntidadPDT = 'N' WHERE ENTID_Codigo = '11000000000'
 



delete FROM dbo.EntidadesRoles WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192')
delete FROM dbo.EntidadRelacion WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192')
delete FROM dbo.Clientes WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192')
delete FROM dbo.Conductores WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192')
delete FROM dbo.Proveedores WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192', '00000000000')
delete FROM Contabilidad.CONT_RelCuentasVentasDetalle WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192', '00000000000')
delete FROM dbo.Direcciones WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192', '00000000000')
delete FROM dbo.Entidades WHERE NOT ENTID_Codigo IN ('11000000000', '00000000', '41314104', '70524192', '00000000000')


