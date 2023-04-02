USE BDSisSCC
GO
-- =============================================================== --
-- CREAR PERIODO 2018
-- =============================================================== --
--SELECT * FROM dbo.Periodos
  
   UPDATE dbo.Periodos SET PERIO_Activo = 0 WHERE PERIO_Activo = 1
   UPDATE dbo.Periodos SET PERIO_Activo = 0, PERIO_StockActivo = 0 WHERE PERIO_Activo = 1

   INSERT INTO dbo.Periodos
        ( PERIO_Codigo ,
          PERIO_Descripcion ,
          PERIO_StockActivo ,
          PERIO_Lock ,
          PERIO_UsrCrea ,
          PERIO_FecCrea ,
          PERIO_Activo        )
   VALUES  ( '2020' , -- PERIO_Codigo - CodigoTipo
          'Periodo 2020' , -- PERIO_Descripcion - Descripcion
          1 , -- PERIO_StockActivo - Boolean
          NULL , -- PERIO_Lock - Boolean
          'SISTEMAS' , -- PERIO_UsrCrea - Usuario
          GETDATE() , -- PERIO_FecCrea - Fecha
          1  -- PERIO_Activo - Boolean
        )
-- =============================================================== --
   --SELECT * FROM 


   USE BDSisCARLO

   INSERT INTO UsuariosPorPuntoVenta
   SELECT * FROM BDSisSCC..UsuariosPorPuntoVenta WHERE ENTID_Codigo = '00000000'

   use BDSisSCC
   SELECT * FROM Ventas.VENT_PVentDocumento
   
-- =============================================================== --
-- STOCK A LA FECHA
-- =============================================================== --

   --SELECT * FROM dbo.Almacenes
   CREATE TABLE #StockFecha(
     Codigo varchar(7)
	, LINEA_Codigo VARCHAR(10)
	, Linea VARCHAR(80)
	, SubLinea VARCHAR(80)
	, Descripcion VARCHAR(120)
	, Orden INT 
	, TIPOS_CodCategoria VARCHAR(6)
	, TIPOS_CodUnidadMedida VARCHAR(6)
	, TIPOS_CodTipoProducto VARCHAR(10)
	, ARTIC_Percepcion bit 
	, ARTIC_Peso DECIMAL(10, 4)
	, Stock DECIMAL(14, 4)
	, TIPOS_CodTipoMoneda VARCHAR(6)
   )

   INSERT INTO #StockFecha
   EXEC dbo.LOG_STOCKSS_StockALaFecha @PERIO_Codigo = '2017', -- varchar(6)
    @ALMAC_Id = 1, -- CodAlmacen
    @ZONAS_Codigo = '83.00', -- CodigoZona
    @Linea = NULL , -- varchar(10)
    @SubLinea = NULL , -- varchar(10)
    @Fecha = '2018-12-31' -- datetime

   SELECT * FROM #StockFecha

-- =============================================================== --

--SELECT * FROM Logistica.LOG_StockIniciales WHERE PERIO_Codigo = '2017'
INSERT INTO Logistica.LOG_StockIniciales
        ( PERIO_Codigo ,
          ARTIC_Codigo ,
          ALMAC_Id ,
          STINI_Cantidad ,
          STINI_Fecha ,
          STINI_UsrCrea ,
          STINI_FecCrea 
        )
   SELECT PERIO_Codigo = '2018',
          ARTIC_Codigo = Codigo,
          ALMAC_Id = 1,
          STINI_Cantidad = ISNULL(Stock, 0),
          STINI_Fecha = '2017-12-31',
          STINI_UsrCrea = 'SISTEMAS' ,
          STINI_FecCrea = GETDATE()
     FROM #StockFecha
-- =============================================================== --
   --SELECT * FROM Logistica.LOG_Stocks 
   -- WHERE CONVERT(DATE, STOCK_Fecha) >= '2018-01-01' AND PERIO_Codigo = '2017'
   GO
   DISABLE TRIGGER Logistica.TRIGD_LOG_Stocks ON Logistica.LOG_Stocks
   GO
   UPDATE Logistica.LOG_Stocks 
      SET PERIO_Codigo = '2018'
    WHERE CONVERT(DATE, STOCK_Fecha) >= '2018-01-01' AND PERIO_Codigo = '2017'
   
   GO
   ENABLE TRIGGER Logistica.TRIGD_LOG_Stocks ON Logistica.LOG_Stocks
   GO
-- =============================================================== --
   SELECT * FROM dbo.Stocks
-- =============================================================== --
-- =============================================================== --

--sp_helptext LOG_STOCKSS_StockALaFecha

SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'

--SELECT * FROM Ventas.VENT_PVentDocumento

--UPDATE Ventas.VENT_PVentDocumento SET PVDOCU_TipoImpresion = 'K' WHERE TIPOS_CodTipoDocumento = 'CPD03'




delete FROM dbo.Periodos WHERE PERIO_Codigo NOT IN ('2017', '2019', '2018')