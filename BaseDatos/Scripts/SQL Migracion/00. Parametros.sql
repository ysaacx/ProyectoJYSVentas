USE BDAmbientaDecora
go

SELECT * FROM dbo.Parametros WHERE PARMT_Id ='pg_FMondo2d'

delete FROM dbo.Parametros WHERE PARMT_Id IN ('pg_SetMoneda', 'pg_BloqueoMND', 'pg_BusqAutoma', 'pg_CotizNuevo', 'pg_BusqEntAll', 'pg_TDODefault', 'pg_IngArtMVC')
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'MND%'
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE '%'
--SELECT * FROM dbo.Tipos WHERE TIPOS_Descripcion LIKE 'Fact%'

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
  UNION SELECT 'pg_TDODefault' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, 'CPD01' AS PARMT_Valor, 'Tipo de documento de facturacion por defa ' AS PARMT_Descripcion, 'String' AS PARMT_TipoDato, NULL AS PARMT_General 
  UNION SELECT 'pg_IngArtMVC' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Ingresar articulos repetidos en cotizaciones' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
  --UNION SELECT 'pg_PerAplDesc' AS PARMT_Id,'VTA' AS APLIC_Codigo,'54.00' AS ZONAS_Codigo, 1 AS SUCUR_Id, '1' AS PARMT_Valor, 'Permite Aplicar % Descuentos' AS PARMT_Descripcion, 'Boolean' AS PARMT_TipoDato, NULL AS PARMT_General 
 ) PARAM
WHERE RTRIM(PARMT_Id) + RTRIM(APLIC_Codigo) + RTRIM(SUCUR_Id)
    NOT IN (SELECT RTRIM(PARMT_Id) + RTRIM(APLIC_Codigo) + RTRIM(SUCUR_Id) FROM dbo.Parametros)


--SELECT * FROM dbo.Parametros WHERE PARMT_Id = 'pg_LongTexAyuda' --AND APLIC_Codigo = 'VTA'
UPDATE dbo.Parametros SET PARMT_Valor = 0 WHERE PARMT_Id = 'pg_LongTexAyuda'




