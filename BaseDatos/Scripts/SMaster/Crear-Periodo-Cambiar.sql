USE BDInkaPeru
GO

SELECT * FROM dbo.Periodos

UPDATE Periodos SET PERIO_StockActivo = 0, PERIO_Activo = 0 WHERE PERIO_Activo = 1

INSERT INTO dbo.Periodos
        ( PERIO_Codigo ,
          PERIO_Descripcion ,
          PERIO_StockActivo ,
          PERIO_Lock ,
          PERIO_UsrCrea ,
          PERIO_FecCrea ,
          PERIO_UsrMod ,
          PERIO_FecMod ,
          PERIO_Activo
        )
VALUES  ( '2021' , -- PERIO_Codigo - CodigoTipo
          'Periodo 2021' , -- PERIO_Descripcion - Descripcion
          1 , -- PERIO_StockActivo - Boolean
          NULL , -- PERIO_Lock - Boolean
          'SISTEMA' , -- PERIO_UsrCrea - Usuario
          '2021-01-01' , -- PERIO_FecCrea - Fecha
          NULL , -- PERIO_UsrMod - Usuario
          NULL , -- PERIO_FecMod - Fecha
          1 -- PERIO_Activo - Boolean
        )

UPDATE Logistica.LOG_Stocks SET PERIO_Codigo = '2021' WHERE YEAR(STOCK_Fecha) = 2021

--SELECT * FROM Logistica.LOG_Stocks WHERE YEAR(STOCK_Fecha) = 2021
--SELECT * FROM Ventas.VENT_DocsVenta WHERE YEAR(DOCVE_FechaDocumento) = 2021


