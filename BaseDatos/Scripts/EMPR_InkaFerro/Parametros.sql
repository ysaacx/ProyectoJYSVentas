USE BDInkasFerro
go

INSERT INTO dbo.Parametros
        ( PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General)
   SELECT PARMT_Id ,             APLIC_Codigo ,          ZONAS_Codigo ,          SUCUR_Id ,
          PARMT_Valor ,          PARMT_Descripcion ,     PARMT_TipoDato ,        PARMT_General
    FROM (
    SELECT PARMT_Id = 'pg_USeriePrint',      APLIC_Codigo = 'VTA',          ZONAS_Codigo = '83.00',          SUCUR_Id = 2,
          PARMT_Valor = '1' ,          PARMT_Descripcion = 'Parametro indica si se usara en la impresion',     
          PARMT_TipoDato = 'Boolean',        PARMT_General = null
    ) AS PARA


SELECT * FROM Parametros

SELECT * FROM sucur