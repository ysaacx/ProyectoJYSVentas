USE BDSAdmin
GO

UPDATE dbo.Sucursales SET SUCUR_DireccionIP = '(Local)\SQL12', SUCUR_BaseDatos = 'BDSAdmin'
UPDATE dbo.Empresas SET EMPR_Servidor = '(Local)\SQL12' , EMPR_Activo = 1 WHERE EMPR_Codigo = 'EMPRE'

SELECT * INTO #PLANTILLA FROM dbo.PlantillasMenu WHERE EMPR_Codigo = 'ADECO' AND APLI_Codigo = 'VTA'

UPDATE #PLANTILLA SET EMPR_Codigo = 'EMPRE'

INSERT INTO dbo.PlantillasMenu
SELECT * FROM #PLANTILLA

--SELECT * FROM dbo.Usuarios
--SELECT * FROM dbo.Empresas
UPDATE dbo.Empresas SET EMPR_Activo = 0
UPDATE dbo.Empresas SET EMPR_Activo = 1 where EMPR_Codigo = '00001'

USE BDSVAlmacen
GO
UPDATE dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12' 
     , PVENT_BaseDatos = 'BDSVAlmacen'
     , PVENT_BDAdmin = 'BDSAdmin'

UPDATE Parametros SET PARMT_Valor = '20600704495' WHERE PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = 'SCC COMERCIO Y REPRESENTACIONES SRL' WHERE PARMT_Id = 'EmpresaRS'


INSERT INTO dbo.Parametros
( PARMT_Id , APLIC_Codigo , ZONAS_Codigo , SUCUR_Id , PARMT_Valor , PARMT_Descripcion , PARMT_TipoDato , PARMT_General)
 SELECT PARMT_Id , APLIC_Codigo , ZONAS_Codigo , SUCUR_Id , PARMT_Valor , PARMT_Descripcion , PARMT_TipoDato , PARMT_General
  FROM(
        SELECT 'pg_SetMoneda' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, 'MND1' AS PARMT_Valor, 'Moneda por Defecto' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_BloqueoMND' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Bloquear el campo moneda' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_BusqAutoma' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Busqueda en automatico para entidades/clientes' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_CotizNuevo' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Cargar la cotizacion para Ingresar un registro' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_BusqEntAll' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Busqueda de Todas las Entidades' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_DesCarPrec' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Desactiva mostrar los precios al entrar ' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 

  UNION SELECT 'pg_ColorBack' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '211,211,211' AS PARMT_Valor, 'Color de Fondo' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_ColorDegred' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '186,176,177' AS PARMT_Valor, 'Color Degrade' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_ColorTitle' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '57,51,51' AS PARMT_Valor, 'Color de Titulo' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_ChangeColor' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Cambiar el Color por la Configuracion definida ' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  --UNION SELECT 'pg_PerAplDesc' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Permite Aplicar % Descuentos' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
 ) PARAM
WHERE RTRIM(PARMT_Id) + RTRIM(APLIC_Codigo) + RTRIM(SUCUR_Id)
    NOT IN (SELECT RTRIM(PARMT_Id) + RTRIM(APLIC_Codigo) + RTRIM(SUCUR_Id) FROM dbo.Parametros)

UPDATE Almacenes SET ALMAC_Descripcion = 'Almacen 0' + RTRIM(ALMAC_Id)

--SELECT * FROM dbo.Almacenes


INSERT INTO dbo.Tipos
        ( TIPOS_Codigo ,TIPOS_Descripcion ,TIPOS_DescLarga ,TIPOS_DescCorta ,TIPOS_Desc2 ,TIPOS_Numero ,TIPOS_Estado ,
          TIPOS_Protegido ,TIPOS_UsrCrea ,TIPOS_FecCrea ,TIPOS_NVentas ,TIPOS_NLogistica ,TIPOS_LSerie ,TIPOS_LNumero ,
          TIPOS_Items
        )
VALUES  ( 'CPDNP' , -- TIPOS_Codigo - CodigoTipo
          'Nota de Pedido' , -- TIPOS_Descripcion - Descripcion80
          'Nota de Pedido' , -- TIPOS_DescLarga - DescL
          'NP' , -- TIPOS_DescCorta - DescCorta
          'NP' , -- TIPOS_Desc2 - varchar(10)
          2 , -- TIPOS_Numero - decimal
          NULL , -- TIPOS_Estado - Estado
          NULL , -- TIPOS_Protegido - bit
          'SISTEMAS' , -- TIPOS_UsrCrea - Usuario
          GETDATE() , -- TIPOS_FecCrea - Fecha
          5 , -- TIPOS_NVentas - smallint
          0 , -- TIPOS_NLogistica - smallint
          0 , -- TIPOS_LSerie - smallint
          0 , -- TIPOS_LNumero - smallint
          15  -- TIPOS_Items - CantSmall
        )


INSERT INTO dbo.[Parametros](PARMT_Id, APLIC_Codigo, ZONAS_Codigo, SUCUR_Id, PARMT_Valor, PARMT_Descripcion, PARMT_TipoDato, PARMT_General) VALUES ('pg_TDODefault', 'VTA', '54.00',  1 , 'CPD01', 'Tipo de documento de facturacion por defa ', 'String', NULL)


UPDATE dbo.Parametros SET PARMT_Valor = '211,211,211' WHERE PARMT_Id = 'pg_ColorBack'
UPDATE dbo.Parametros SET PARMT_Valor = '186,176,177' WHERE PARMT_Id = 'pg_ColorDegred'
UPDATE dbo.Parametros SET PARMT_Valor = '57,51,51' WHERE PARMT_Id = 'pg_ColorTitle'



SELECT * FROM dbo.Parametros WHERE PARMT_Id IN ('pg_TDODefault')
SELECT * FROM BDAmbientaDecora.dbo.Parametros

SELECT * FROM dbo.PuntoVenta
SELECT * FROM dbo.Almacenes
SELECT * FROM dbo.Sucursales

SELECT * FROM dbo.UsuariosPorPuntoVenta WHERE ENTID_Codigo = '00000000'

UPDATE dbo.UsuariosPorPuntoVenta SET ENTID_Codigo = '00000000' WHERE ENTID_Codigo = 0


SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '00000000'





--Select m_usuariosplantillas.* , Pla.PTLA_Key As PTLA_Key
--, Pla.PTLA_Relative As PTLA_Relative
--, Us.USER_DNI As USER_DNI
-- From dbo.UsuariosPlantillas As m_usuariosplantillas 
-- Inner Join dbo.PlantillasMenu As Pla On Pla.APLI_Codigo = m_usuariosplantillas.APLI_Codigo And Pla.EMPR_Codigo = m_usuariosplantillas.EMPR_Codigo And Pla.PTLA_Codigo = m_usuariosplantillas.PTLA_Codigo
-- Inner Join dbo.Usuarios As Us On Us.USER_IdUser = m_usuariosplantillas.USER_IdUser WHERE   ISNULL(Us.USER_DNI, '') = '40975980' AND  ISNULL(m_UsuariosPlantillas.APLI_Codigo, '') = 'VTA' AND  ISNULL(m_UsuariosPlantillas.EMPR_Codigo, '') = 'EMPRE'

--Select * from [dbo].[Empresas] Where   ISNULL(EMPR_Codigo, '') = 'EMPRE'





 SELECT  * 
 FROM dbo.Usuarios
 WHERE 
  ISNULL(USER_DNI, '') = '00000000'