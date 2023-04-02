--pg_USeriePrint

USE BDJYM
GO

--SELECT * FROM dbo.Parametros WHERE PARMT_Id = 'pg_USeriePrint'

UPDATE dbo.Parametros SET PARMT_Valor = '0' WHERE PARMT_Id = 'pg_USeriePrint'