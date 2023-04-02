use BDInkaPeru
GO

--SELECT * FROM dbo.Periodos

SELECT ST.STOCK_CantidadSalida, ST.STOCK_CantidadIngreso, * FROM Logistica.LOG_Stocks ST
  INNER JOIN ventas.VENT_DocsVenta DOCV ON DOCV.DOCVE_Codigo = ST.DOCVE_Codigo
 WHERE YEAR(STOCK_Fecha) = 2020 AND PERIO_Codigo = '2019' AND ST.ARTIC_Codigo = '0829002'

--SELECT * FROM Logistica.LOG_Stocks ST WHERE YEAR(STOCK_Fecha) = 2020 AND PERIO_Codigo = '2019'
--SELECT COUNT(*) FROM ventas.VENT_DocsVenta


GO
   DISABLE TRIGGER Logistica.TRIGD_LOG_Stocks ON Logistica.LOG_Stocks
GO 
   DISABLE TRIGGER Logistica.TRIGU_LOG_Stocks ON Logistica.LOG_Stocks
GO

BEGIN TRAN X

   UPDATE ST
      SET PERIO_Codigo = '2020'
     FROM Logistica.LOG_Stocks ST
    INNER JOIN ventas.VENT_DocsVenta DOCV ON DOCV.DOCVE_Codigo = ST.DOCVE_Codigo
    WHERE YEAR(STOCK_Fecha) = 2020 AND PERIO_Codigo = '2019'
   
ROLLBACK TRAN X

GO
   ENABLE TRIGGER Logistica.TRIGD_LOG_Stocks ON Logistica.LOG_Stocks
GO
   ENABLE TRIGGER Logistica.TRIGU_LOG_Stocks ON Logistica.LOG_Stocks
GO 
