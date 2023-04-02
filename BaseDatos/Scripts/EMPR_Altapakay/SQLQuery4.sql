CREATE TABLE #Kardex(
DOCVE_FechaDocumento DATETIME
, ALMAC_Id int 
, ALMAC_Descripcion VARCHAR(100)
, ARTIC_Codigo VARCHAR(15) 
, Ingreso DECIMAL(15,5)
, Salida DECIMAL(15,5)
, Stock DECIMAL(15,5)
, Documento VARCHAR(100)
, DOCVE_DescripcionCliente VARCHAR(100)
, DOCVE_Estado CHAR(1)
, STOCK_Id INT 
, Movimiento INT )

CREATE TABLE #KGenerado(
  Fecha DATETIME
, Id_Documento VARCHAR(100)
, Descripcion VARCHAR(100)
, Cantidad_Producto DECIMAL(15, 5)
, Importe DECIMAL(15, 5)
, Registro VARCHAR(10)
, Id_Producto VARCHAR(10)
, Anulada SMALLINT
, Id_CliPro VARCHAR(15)
, Documento VARCHAR(15)
, Costo DECIMAL(15, 5)
, D VARCHAR(20)
, Serie_Documento VARCHAR(10)
, Numero_Documento INT)


INSERT INTO #Kardex
exec CTRL_STOCKSS_KardexXArticulo @ARTIC_Codigo=N'0701020',@ALMAC_Id=1,@PERIO_Codigo=N'2019',@ZONAS_Codigo=N'84.00',@FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00'

INSERT INTO #KGenerado
EXEC BDMaster..INGRSS_KardexXArticulo @Id_Producto=N'0701020',@FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00',@EMPR_Codigo=N'INKAP'

SELECT * FROM #Kardex
SELECT * FROM #KGenerado

SELECT Entrada = (CASE WHEN Registro = 'RC' THEN Cantidad_Producto ELSE 0 END)
     , Salida = (CASE WHEN Registro = 'RV' THEN Cantidad_Producto ELSE 0 END)
     , 'V'
  FROM #KGenerado

SELECT Ingreso = SUM(Ingreso), Salida = SUM(Salida), 'K' --INTO #TMP 
  FROM #Kardex
union
SELECT SUM(CASE WHEN Registro = 'RC' THEN Cantidad_Producto ELSE 0 END)
     , SUM(CASE WHEN Registro = 'RV' THEN Cantidad_Producto ELSE 0 END)
     , 'V'
  FROM #KGenerado

--SELECT Ingreso = SUM(Ingreso), Salida = SUM(Salida) FROM #TMP

