

UPDATE dbo.Parametros SET PARMT_Valor = '2.0.1.1' WHERE PARMT_Id='pg_Version'

--SELECT * FROM dbo.Parametros WHERE PARMT_Id LIKE '%color%'
UPDATE dbo.Parametros SET PARMT_Valor = '211,211,211' WHERE PARMT_Id = 'pg_ColorBack'
UPDATE dbo.Parametros SET PARMT_Valor = '186,176,177' WHERE PARMT_Id = 'pg_ColorDegred'
UPDATE dbo.Parametros SET PARMT_Valor = '57,51,51' WHERE PARMT_Id = 'pg_ColorTitle'

--211,211,211
/*
PARMT_Id	    APLIC_Codigo	ZONAS_Codigo	SUCUR_Id	PARMT_Valor	PARMT_Descripcion	                            PARMT_TipoDato	PARMT_General
pg_ChangeColor	VTA         	54.00	        1	        1	        Cambiar el Color por la Configuracion definida 	Boolean	        NULL
pg_ColorBack	VTA         	54.00	        1	        211,211,211	Color de Fondo	                                String	        NULL
pg_ColorDegred	VTA         	54.00	        1	        205,92,92	Color en degraded	                            String	        NULL
pg_ColorTitle	VTA         	54.00	        1	        128,0,0	    Color de los Titulos	                        String	        NULL
*/