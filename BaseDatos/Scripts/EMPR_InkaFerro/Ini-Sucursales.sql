--USE BDInkasFerro_Almudena
USE BDInkasFerro
GO
/* ======================================================================================================================================== */
--SELECT * FROM BDSAdmin..Empresas
--SELECT * FROM dbo.Zonas
--SELECT * FROM dbo.Ubigeos WHERE LEN(UBIGO_Codigo) = 2
--SELECT * FROM dbo.Ubigeos WHERE UBIGO_Codigo LIKE '08%'
--DELETE FROM dbo.Zonas WHERE ZONAS_Codigo = '84.00'
--SELECT * FROM dbo.Sucursales
--SELECT * FROM PuntoVenta
--SELECT * FROM Almacenes
--SELECT * FROM dbo.Usuarios
--SELECT * FROM dbo.UsuariosProcesos WHERE apli_codigo = 'ADM'
--SELECT * FROM dbo.UsuariosProcesos WHERE USER_IdUser = 104
--SELECT *  FROM dbo.Empresas
--SELECT *  FROM ACAdmin..Empresas
--SELECT * FROM dbo.Aplicaciones WHERE APLI_Codigo = 'VTA'
/* ======================================================================================================================================== */
USE BDSAdmin
GO
UPDATE dbo.Aplicaciones SET APLI_BaseDatos = NULL WHERE APLI_Codigo = 'VTA'
/* ======================================================================================================================================== */
INSERT INTO dbo.Empresas( EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea )
 SELECT EMPR_Codigo ,        EMPR_Desc ,          EMPR_Direc ,          
        EMPR_RUC ,           EMPR_Servidor ,      EMPR_BaseDatos ,
        EMPR_BDFija ,        EMPR_Isolation ,     EMPR_UsrCrea ,         
        EMPR_FecCrea 
 FROM (  SELECT EMPR_Codigo = 'EBASE',  EMPR_Desc = 'Base',   EMPR_Direc = 'Base',          
                EMPR_RUC = 'Base',      EMPR_Servidor = '' ,  EMPR_BaseDatos = '',
                EMPR_BDFija = 0,        EMPR_Isolation = 1,   EMPR_UsrCrea = 'SISTEMAS',
                EMPR_FecCrea = GETDATE()
      ) AS EMPRE
  WHERE NOT EMPRE.EMPR_Codigo IN (SELECT EMPR_Codigo FROM dbo.Empresas)

insert into UsuariosProcesos(USER_IdUser,APLI_Codigo,EMPR_Codigo,PROC_Codigo,PTPR_Fecha,PTPR_UsrCrea,PTPR_FecCrea)
values(104, 'ADM', 'EBASE', 'ACSUC', GETDATE(), 'SISTEMAS', GETDATE())

UPDATE dbo.Empresas SET EMPR_Activo = 0
UPDATE dbo.Empresas SET EMPR_Activo = 1 WHERE EMPR_Codigo = 'IFERR'

DELETE FROM dbo.Sucursales
INSERT INTO dbo.Sucursales
        ( ZONAS_Codigo ,          SUCUR_Id ,          UBIGO_Codigo ,          EMPRE_Codigo ,
          SUCUR_Nombre ,          SUCUR_Direccion ,          SUCUR_Telefono ,          SUCUR_DireccionIP ,
          SUCUR_BaseDatos ,          SUCUR_Activo ,          SUCUR_UsrCrea ,          SUCUR_FecCrea 
        )
 SELECT ZONAS_Codigo ,          SUCUR_Id ,              UBIGO_Codigo ,            EMPRE_Codigo ,
        SUCUR_Nombre ,          SUCUR_Direccion ,       SUCUR_Telefono ,          SUCUR_DireccionIP ,
        SUCUR_BaseDatos ,       SUCUR_Activo ,          SUCUR_UsrCrea ,           SUCUR_FecCrea 
   FROM (
 SELECT ZONAS_Codigo = '83.00', SUCUR_Id = 1,        UBIGO_Codigo = NULL,      EMPRE_Codigo = 'IFERR',
        SUCUR_Nombre = 'Sucursal Almudena',          SUCUR_Direccion = 'ALMUDENA S/N - CUSCO / CUSCO / SAN JERONIMO',       
        SUCUR_Telefono = NULL,                       SUCUR_DireccionIP = 'SERVERIF02\SQL12',
        SUCUR_BaseDatos = 'BDSAdmin',                SUCUR_Activo = 1,          
        SUCUR_UsrCrea = 'SISTEMAS',                  SUCUR_FecCrea = GETDATE()
  UNION
 SELECT ZONAS_Codigo = '83.00', SUCUR_Id = 2,        UBIGO_Codigo = NULL,      EMPRE_Codigo = 'IFERR',
        SUCUR_Nombre = 'Sucursal Parusttacca',          SUCUR_Direccion = 'PARUSTTACCA - CUSCO / CUSCO / SAN JERONIMO',
        SUCUR_Telefono = NULL,                       SUCUR_DireccionIP = 'SERVERIF\SQL12',
        SUCUR_BaseDatos = 'BDSAdmin',                SUCUR_Activo = 1,          
        SUCUR_UsrCrea = 'SISTEMAS',                  SUCUR_FecCrea = GETDATE()
      ) SUCUR
WHERE NOT SUCUR.ZONAS_Codigo + '-' + RTRIM(SUCUR.SUCUR_Id) + '-' + SUCUR.EMPRE_Codigo 
   IN (SELECT ZONAS_Codigo + '-' + RTRIM(SUCUR_Id) + '-' + EMPRE_Codigo FROM dbo.Sucursales)


SELECT * FROM dbo.Sucursales

--SELECT * FROM BDInkasFerro_Almudena..Zonas
--SELECT * FROM BDInkasFerro_Almudena..PuntoVenta
--SELECT * FROM BDInkasFerro_Almudena..Sucursales
/* ======================================================================================================================================== */
USE BDInkasFerro
GO


/* ======================================================================================================================================== */
/* SUCURSALES */

INSERT INTO dbo.Sucursales
     ( ZONAS_Codigo ,SUCUR_Id ,UBIGO_Codigo ,EMPRE_Codigo ,SUCUR_Nombre ,SUCUR_Direccion ,SUCUR_UsrCrea ,SUCUR_FecCrea )
SELECT ZONAS_Codigo ,SUCUR_Id ,UBIGO_Codigo ,EMPRE_Codigo ,SUCUR_Nombre ,SUCUR_Direccion ,SUCUR_UsrCrea ,SUCUR_FecCrea 
  FROM (SELECT ZONAS_Codigo = '83.00' ,SUCUR_Id = '1',UBIGO_Codigo = '03.01.01',EMPRE_Codigo = 'IFERR',SUCUR_Nombre = 'Sucursal Parusttacca'
				, SUCUR_Direccion = 'PARUSTTACCA - CUSCO / CUSCO / SAN JERONIMO',SUCUR_UsrCrea = 'SISTEMAS',SUCUR_FecCrea = GETDATE()
  UNION SELECT ZONAS_Codigo = '83.00' ,SUCUR_Id = '2',UBIGO_Codigo = '03.01.01',EMPRE_Codigo = 'IFERR',SUCUR_Nombre = 'Sucursal Almudena'
				, SUCUR_Direccion = 'ALMUDENA S/N - CUSCO / CUSCO / SAN JERONIMO',SUCUR_UsrCrea = 'SISTEMAS',SUCUR_FecCrea = GETDATE()
	 ) SUCR
 WHERE NOT SUCR.ZONAS_Codigo + '-' + RTRIM(SUCR.SUCUR_Id) IN (SELECT ZONAS_Codigo + '-' + RTRIM(SUCUR_Id) FROM	SUCURSALES)

/* ======================================================================================================================================== */
/* ALMACEN */
INSERT INTO dbo.Almacenes
	 ( ALMAC_Id ,ZONAS_Codigo ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea,ALMAC_Activo ,ALMAC_DescCorta)

SELECT  ALMAC_Id ,ZONAS_Codigo ,SUCUR_Id ,TIPOS_CodTipoAlmacen ,ALMAC_Descripcion ,ALMAC_Direccion ,ALMAC_UsrCrea ,ALMAC_FecCrea,ALMAC_Activo ,ALMAC_DescCorta
  FROM (SELECT ALMAC_Id = 1,ZONAS_Codigo = '83.00' ,SUCUR_Id = 1 ,TIPOS_CodTipoAlmacen = 'ALM01',ALMAC_Descripcion = 'Almacen Parusttacca' ,
			   ALMAC_Direccion = 'PARUSTTACCA - CUSCO / CUSCO / SAN JERONIMO',ALMAC_UsrCrea = 'SISTEMAS' ,ALMAC_FecCrea = GETDATE(),ALMAC_Activo = 1,ALMAC_DescCorta = 'PARUSTTACCA'
  UNION SELECT ALMAC_Id = 2,ZONAS_Codigo = '83.00' ,SUCUR_Id = 2 ,TIPOS_CodTipoAlmacen = 'ALM01',ALMAC_Descripcion = 'Almacen Almudena' ,
			   ALMAC_Direccion = 'ALMUDENA S/N - CUSCO / CUSCO / SAN JERONIMO',ALMAC_UsrCrea = 'SISTEMAS' ,ALMAC_FecCrea = GETDATE(),ALMAC_Activo = 1,ALMAC_DescCorta = 'ALMUDENA'
      ) ALMA
 WHERE NOT ALMA.ALMAC_Id IN (SELECT ALMAC_Id FROM dbo.Almacenes)

/* ======================================================================================================================================== */
/* PUNTO DE VENTA */

INSERT INTO dbo.PuntoVenta
    ( PVENT_Id ,ZONAS_Codigo ,SUCUR_Id ,ALMAC_Id ,PVENT_Descripcion ,PVENT_Principal ,PVENT_DireccionIP ,PVENT_BaseDatos ,
	  PVENT_DireccionIPAC ,PVENT_BaseDatosAC ,PVENT_Activo ,PVENT_BDAdmin ,PVENT_User ,PVENT_Password ,PVENT_DireccionIPDesc ,
	  PVENT_Glosa ,PVENT_Impresion ,PVENT_Direccion ,PVENT_ZonaContable ,PVENT_ActivoDespachos
    )

SELECT PVENT_Id ,ZONAS_Codigo ,SUCUR_Id ,ALMAC_Id ,PVENT_Descripcion ,PVENT_Principal ,PVENT_DireccionIP ,PVENT_BaseDatos ,
	   PVENT_DireccionIPAC ,PVENT_BaseDatosAC ,PVENT_Activo ,PVENT_BDAdmin ,PVENT_User ,PVENT_Password ,PVENT_DireccionIPDesc ,
	   PVENT_Glosa ,PVENT_Impresion ,PVENT_Direccion ,PVENT_ZonaContable ,PVENT_ActivoDespachos
FROM (  SELECT PVENT_Id = 1 ,ZONAS_Codigo = '83.00' ,SUCUR_Id = 1 ,ALMAC_Id = 1 ,PVENT_Descripcion = 'Punto de Parusttacca' ,PVENT_Principal = 1 ,PVENT_DireccionIP = 'SERVERIF\SQL12' ,
			   PVENT_BaseDatos = 'BDInkasFerro' ,PVENT_DireccionIPAC = '(Local)\SQL12' ,PVENT_BaseDatosAC = 'BDInkasFerro',PVENT_Activo = 1,PVENT_BDAdmin = 'BDSAdmin' ,
			   PVENT_User = NULL , PVENT_Password = NULL,PVENT_DireccionIPDesc = NULL , PVENT_Glosa = 'CUSCO - PERU' ,PVENT_Impresion = 1 ,
			   PVENT_Direccion = 'URB LA CANTUTA A-9 CALLE KANTU VERSALLES - CUSCO / CUSCO / SAN JERONIMO' ,PVENT_ZonaContable = 'DOl' ,PVENT_ActivoDespachos = 1
  UNION SELECT PVENT_Id = 2 ,ZONAS_Codigo = '83.00' ,SUCUR_Id = 2 ,ALMAC_Id = 2 ,PVENT_Descripcion = 'Punto de Parusttacca' ,PVENT_Principal = 1 ,PVENT_DireccionIP = 'SERVERIF\SQL12' ,
			   PVENT_BaseDatos = 'BDInkasFerro' ,PVENT_DireccionIPAC = '(Local)\SQL12' ,PVENT_BaseDatosAC = 'BDInkasFerro',PVENT_Activo = 1,PVENT_BDAdmin = 'BDSAdmin' ,
			   PVENT_User = NULL , PVENT_Password = NULL,PVENT_DireccionIPDesc = NULL , PVENT_Glosa = 'CUSCO - PERU' ,PVENT_Impresion = 1 ,
			   PVENT_Direccion = 'URB LA CANTUTA A-9 CALLE KANTU VERSALLES - CUSCO / CUSCO / SAN JERONIMO' ,PVENT_ZonaContable = 'DOl' ,PVENT_ActivoDespachos = 1
	  ) PVENTA
	WHERE NOT PVENTA.PVENT_Id IN (SELECT PVENT_Id FROM dbo.PuntoVenta)

UPDATE PuntoVenta SET PVENT_DireccionIP = 'SERVERIF\SQL12', PVENT_Descripcion = 'Punto de Parusttacca' WHERE PVENT_Id = 1
UPDATE PuntoVenta SET PVENT_DireccionIP = 'SERVERIF02\SQL12', PVENT_Descripcion = 'Punto de Almudena' WHERE PVENT_Id = 2

SELECT * FROM dbo.PuntoVenta
/* ======================================================================================================================================== */
/* PARA SUCURSAL ALMUDENA */
/*
SELECT * FROM dbo.Parametros WHERE SUCUR_Id = 1
UPDATE dbo.Parametros SET SUCUR_Id = 2 WHERE SUCUR_Id = 1

SELECT * FROM dbo.UsuariosPorPuntoVenta WHERE ENTID_Codigo = '00000000'
SELECT * INTO #tmp FROM dbo.UsuariosPorPuntoVenta WHERE ENTID_Codigo = '00000000'
UPDATE #tmp SET PVENT_Id = 2, SUCUR_Id = 2
INSERT INTO UsuariosPorPuntoVenta
SELECT * FROM #tmp
*/