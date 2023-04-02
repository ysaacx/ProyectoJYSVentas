--USE BDInkasFerro_Almudena
USE BDSisSCC
go

INSERT INTO dbo.Parametros
        ( PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General)
   SELECT PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General
    FROM (SELECT PARMT_Id = 'pg_USeriePrint', APLIC_Codigo = 'VTA',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '0' ,          PARMT_Descripcion = 'Parametro indica si se usara en la impresion',     
                 PARMT_TipoDato = 'Boolean',  PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_FFechaHora', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = 'dd/MM/yyyy hh:mm tt' ,          PARMT_Descripcion = 'Formato de Fecha Hora',
                 PARMT_TipoDato = 'String',  PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_FormatoFecha', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = 'dd/MM/yyy' ,          PARMT_Descripcion = 'Formato Fecha',
                 PARMT_TipoDato = 'String',  PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_LongTexAyuda', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '3' ,          PARMT_Descripcion = 'Longitud para activar la ayuda de las busquedas',
                 PARMT_TipoDato = 'Integer',  PARMT_General = 1
    UNION SELECT PARMT_Id = 'pg_NotCredCuot', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = 'CPD07' ,          PARMT_Descripcion = 'Codigo de la nota de credito para el control de cu',
                 PARMT_TipoDato = 'String',  PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ChangeColor', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '1' ,          PARMT_Descripcion = 'Cambiar el Color por la Configuracion definida',
                 PARMT_TipoDato = 'String',  PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorTitle', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '57,51,51' ,          PARMT_Descripcion = 'Color de Titulo',
                 PARMT_TipoDato = 'String',  PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorDegred', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '186,176,177' ,          PARMT_Descripcion = 'Color Degrade',
                 PARMT_TipoDato = 'String',  PARMT_General = NULL
    UNION SELECT PARMT_Id = 'pg_ColorBack', APLIC_Codigo = 'LOG',          ZONAS_Codigo = '83.00',          SUCUR_Id = 1,
                 PARMT_Valor = '211,211,211' ,          PARMT_Descripcion = 'Color de Fondo',
                 PARMT_TipoDato = 'String',  PARMT_General = NULL
    ) AS PARA
WHERE NOT PARA.PARMT_Id + '-' + PARA.APLIC_Codigo + '-' + RTRIM(PARA.SUCUR_Id) 
  IN (SELECT PARMT_Id + '-' + APLIC_Codigo + '-' + RTRIM(SUCUR_Id) FROM dbo.Parametros)


SELECT * FROM Parametros WHERE PARMT_Id = 'pg_ColorBack'
--SELECT  * FROM  Parametros WHERE APLIC_Codigo = 'LOG' AND SUCUR_Id = 1
--SELECT  * FROM  BDACNet.dbo.Parametros WHERE APLIC_Codigo = 'LOG' AND SUCUR_Id = 1 ,