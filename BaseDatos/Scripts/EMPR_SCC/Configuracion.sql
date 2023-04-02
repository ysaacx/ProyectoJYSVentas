USE BDSisSCC
go



SELECT *  FROM dbo.Tipos WHERE TIPOS_Codigo = 'CPD03'

SELECT * FROM dbo.Periodos

USE BDSisSCC
go

UPDATE dbo.Periodos SET PERIO_Activo = 0, PERIO_StockActivo = 0 WHERE PERIO_Codigo <> '2017'
UPDATE dbo.Parametros SET PARMT_Valor = '3.1.1.2' WHERE PARMT_Id = 'pg_Version'

--SELECT * FROM dbo.Stocks


