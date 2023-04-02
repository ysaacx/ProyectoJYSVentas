USE bdinvzeg_zegarra
GO

--SELECT * FROM dbo.Cliente
--SELECT * FROM dbo.Proveedor

BEGIN TRAN x


 DECLARE @ENTID_Id INT
 SET @ENTID_Id = (SELECT MAX(ENTID_Id) FROM BDImportacionesZegarra..Entidades) + 1

    SELECT ENTID_Codigo = ID_Cliente   
        , TIPOS_CodTipoDocumento       = 'DID' + CASE WHEN Id_Documento IN ('03') THEN '6' ELSE RIGHT(Id_Documento, 1) END 
        , UBIGO_Codigo                 = null 
        , ENTID_Id                     = ROW_NUMBER() OVER(ORDER BY ID_Cliente) + @ENTID_Id
        , ENTID_TipoEntidadPDT         = CASE ID_Tipo_Tributario WHEN 0 THEN 'N' ELSE 'J' END
        , ENTID_Nombres                = Razon_Social_Cliente
        , ENTID_NroDocumento           = ID_Cliente
        , ENTID_RazonSocial            = Razon_Social_Cliente
        , ENTID_NombreComercial        = Razon_Social_Cliente
        , ENTID_FecNacimiento          = NULL
        , ENTID_PtrApeMaterno          = LEN(Paterno_Cliente)
        , ENTID_PtrNombre1             = LEN(Paterno_Cliente) + LEN(Materno_Cliente) + 1
        , ENTID_PtrNombre2             = NULL
        , ENTID_EMail                  = NULL
        , ENTID_Estado                 = 'A'
        , ENTID_Direccion              = Direccion
        , ENTID_Telefono1              = Telefono
        , ENTID_Telefono2              = Celular
        , ENTID_Fax                    = Fax
        , USUAR_Codigo                 = NULL
        , ENTID_UsrCrea                = 'SISTEMAS'
        , ENTID_FecCrea                = GETDATE()
        , ENTID_UsrMod                 = NULL
        , ENTID_FecMod                 = NULL
        , ENTID_CodUsuario             = NULL
        , ENTID_CodBusqueda            = NULL  
     INTO #Clientes
     FROM dbo.Cliente
     WHERE LEN(ID_Cliente) > 0 AND ID_Cliente NOT IN (SELECT ENTID_Codigo FROM BDImportacionesZegarra..Entidades)

   INSERT INTO BDImportacionesZegarra..Entidades
       (  ENTID_Codigo                 , TIPOS_CodTipoDocumento       , UBIGO_Codigo                 , ENTID_Id                     
        , ENTID_TipoEntidadPDT         , ENTID_Nombres                , ENTID_NroDocumento           , ENTID_RazonSocial            
        , ENTID_NombreComercial        , ENTID_FecNacimiento          , ENTID_PtrApeMaterno          , ENTID_PtrNombre1             
        , ENTID_PtrNombre2             , ENTID_EMail                  , ENTID_Estado                 , ENTID_Direccion              
        , ENTID_Telefono1              , ENTID_Telefono2              , ENTID_Fax                    , USUAR_Codigo                 
        , ENTID_UsrCrea                , ENTID_FecCrea                , ENTID_UsrMod                 , ENTID_FecMod                 
        , ENTID_CodUsuario             , ENTID_CodBusqueda                    )
   SELECT * FROM #Clientes

       INSERT INTO BDImportacionesZegarra..Clientes
           (  ENTID_Codigo                 , ENTID_CodigoVendedor         , ZONAS_Codigo                 , SUCUR_Id                     
            , LPREC_Id                     , TIPOS_CodTipoPercepcion      , CLIEN_Percepcion             , CLIEN_PrecioEspecial         
            , CLIEN_PorcPrecEspecial       , CLIEN_Credito                , CLIEN_PlazoCredito           , CLIEN_LimCredito             
            , CLIEN_UsrCrea                , CLIEN_FecCrea                , CLIEN_UsrMod                 , CLIEN_FecMod                 )
       SELECT ENTID_Codigo                 
            , ENTID_CodigoVendedor         = '00000000000'
            , ZONAS_Codigo                 = '54.00'
            , SUCUR_Id                     = 1
            , LPREC_Id                     = CLI.Id_Lista_Precio
            , TIPOS_CodTipoPercepcion      = NULL
            , CLIEN_Percepcion             = NULL
            , CLIEN_PrecioEspecial         = NULL
            , CLIEN_PorcPrecEspecial       = NULL
            , CLIEN_Credito                = 0
            , CLIEN_PlazoCredito           = PLAZO
            , CLIEN_LimCredito             = NULL
            , CLIEN_UsrCrea                = 'SISTEMAS'
            , CLIEN_FecCrea                = GETDATE()
            , CLIEN_UsrMod                 = NULL
            , CLIEN_FecMod                 = NULL
         FROM #Clientes ENTC
        INNER JOIN dbo.Cliente CLI ON CLI.ID_Cliente = ENTC.ENTID_Codigo

    DROP TABLE #Clientes
/*===============================================================================================================================*/
    
    SET @ENTID_Id = (SELECT MAX(ENTID_Id) FROM BDImportacionesZegarra..Entidades) + 1

    SELECT ENTID_Codigo = ID_Proveedor
        , TIPOS_CodTipoDocumento       = 'DID6'
        , UBIGO_Codigo                 = null 
        , ENTID_Id                     = ROW_NUMBER() OVER(ORDER BY ID_Proveedor) + @ENTID_Id
        , ENTID_TipoEntidadPDT         = 'J'
        , ENTID_Nombres                = Nombre_Proveedor
        , ENTID_NroDocumento           = ID_Proveedor
        , ENTID_RazonSocial            = Nombre_Proveedor
        , ENTID_NombreComercial        = Nombre_Proveedor
        , ENTID_FecNacimiento          = NULL
        , ENTID_PtrApeMaterno          = NULL
        , ENTID_PtrNombre1             = NULL
        , ENTID_PtrNombre2             = NULL
        , ENTID_EMail                  = NULL
        , ENTID_Estado                 = 'A'
        , ENTID_Direccion              = Direccion
        , ENTID_Telefono1              = Telefono1
        , ENTID_Telefono2              = Telefono2
        , ENTID_Fax                    = Fax
        , USUAR_Codigo                 = NULL
        , ENTID_UsrCrea                = 'SISTEMAS'
        , ENTID_FecCrea                = GETDATE()
        , ENTID_UsrMod                 = NULL
        , ENTID_FecMod                 = NULL
        , ENTID_CodUsuario             = NULL
        , ENTID_CodBusqueda            = NULL  
     INTO #Proveedores
     FROM dbo.Proveedor
     WHERE ID_Proveedor NOT IN (SELECT ENTID_Codigo FROM BDImportacionesZegarra..Entidades)

     
   INSERT INTO BDImportacionesZegarra..Entidades
       (  ENTID_Codigo                 , TIPOS_CodTipoDocumento       , UBIGO_Codigo                 , ENTID_Id                     
        , ENTID_TipoEntidadPDT         , ENTID_Nombres                , ENTID_NroDocumento           , ENTID_RazonSocial            
        , ENTID_NombreComercial        , ENTID_FecNacimiento          , ENTID_PtrApeMaterno          , ENTID_PtrNombre1             
        , ENTID_PtrNombre2             , ENTID_EMail                  , ENTID_Estado                 , ENTID_Direccion              
        , ENTID_Telefono1              , ENTID_Telefono2              , ENTID_Fax                    , USUAR_Codigo                 
        , ENTID_UsrCrea                , ENTID_FecCrea                , ENTID_UsrMod                 , ENTID_FecMod                 
        , ENTID_CodUsuario             , ENTID_CodBusqueda                    )
   SELECT * FROM #Proveedores

         INSERT INTO BDImportacionesZegarra..Proveedores
             (  ENTID_Codigo                 , PROVE_Atencion               , PROVE_Contacto               , PROVE_UsrCrea                
              , PROVE_FecCrea                , PROVE_UsrMod                 , PROVE_FecMod                 
             )
       SELECT ENTID_Codigo                 
            , PROVE_Atencion               = NULL
            , PROVE_Contacto               = NULL 
            , PROVE_UsrCrea                = 'SISTEMAS'
            , PROVE_FecCrea                = GETDATE()
            , PROVE_UsrMod                 = NULL
            , PROVE_FecMod                 = NULL
         FROM #Proveedores ENTC

    DROP TABLE #Proveedores
/*===============================================================================================================================*/

ROLLBACK TRAN x

