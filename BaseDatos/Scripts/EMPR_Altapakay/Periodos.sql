USE BDInkaPeru
GO


SELECT * FROM dbo.Periodos

UPDATE dbo.Periodos SET PERIO_Activo = 0, PERIO_StockActivo = 0 WHERE PERIO_Activo = 1

INSERT INTO dbo.Periodos
        ( PERIO_Codigo ,
          PERIO_Descripcion ,
          PERIO_StockActivo ,
          PERIO_Lock ,
          PERIO_UsrCrea ,
          PERIO_FecCrea ,
          PERIO_Activo
        )
VALUES  ( '2018' , -- PERIO_Codigo - CodigoTipo
          'Periodo 2018' , -- PERIO_Descripcion - Descripcion
          1 , -- PERIO_StockActivo - Boolean
          NULL , -- PERIO_Lock - Boolean
          'SISTEMAS' , -- PERIO_UsrCrea - Usuario
          GETDATE() , -- PERIO_FecCrea - Fecha
          1  -- PERIO_Activo - Boolean
        )

/*==============================================================================================================================*/

SELECT * FROM dbo.Stocks
SELECT * FROM Logistica.LOG_StockIniciales
SELECT * FROM Logistica.LOG_Stocks

SELECT * FROM Contabilidad.CONT_Cuentas
SELECT * FROM dbo.Cuentas

SELECT * FROM tipos WHERE TIPOS_Codigo LIKE ''
SELECT * FROM dbo.Bancos

--6	BANCO CONTINENTAL DEL PERU	BBVA	44274911	2011-04-08 10:58:41.077	44274911	2011-04-08 11:03:21.140	NULL	3

