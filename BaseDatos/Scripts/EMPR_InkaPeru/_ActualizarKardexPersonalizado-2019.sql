USE BDMaster
GO

--SELECT * FROM dbo.Movimientos_Detalle
--SELECT * FROM dbo.Total_Valorado WHERE EMPR_Codigo = 'INKAP' AND Id_Producto = '0829002'

--EXEC ARTISS_Consulta @Periodo=2019,@TipoConsulta=1,@EMPR_Codigo=N'INKAP'
--exec MG_STOCKSS_Todos @Periodo=N'2019',@EMPR_Codigo=N'INKAP'


--SELECT * FROM StockInicial WHERE EMPR_Codigo = 'INKAP' AND Id_Producto = '0829002' AND Periodo = '2019'

--Select * From V_MOVIMIENTOS_DETALLE Where Anulada = 0 And 
--Convert(Date, Fecha) >= '01-01-2019' And Convert(Date, Fecha) <= '12-31-2019' and id_producto = '0829002'
-- AND EMPR_Codigo = 'INKAP'Order By Fecha , Registro

--Select Registro, SUM(Cantidad_Producto) From V_MOVIMIENTOS_DETALLE Where Anulada = 0 And 
--       CONVERT(Date, Fecha) >= '01-01-2019' And Convert(Date, Fecha) <= '12-31-2019' and id_producto = '0829002'
--   AND EMPR_Codigo = 'INKAP' --ORDER By Fecha , Registro
--  GROUP BY Registro


--Select * From V_MOVIMIENTOS_DETALLE Where Anulada = 0 And 
--Convert(Date, Fecha) >= '01-01-2019' And Convert(Date, Fecha) <= '12-31-2019' and id_producto = '0829002'
-- AND EMPR_Codigo = 'INKAP'
-- ORDER By Fecha , Registro

-- sp_helptext V_MOVIMIENTOS_DETALLE

DECLARE @CantidaLimite DECIMAL(15, 2) = 2
DECLARE @Signo VARCHAR(1)             = '-'
DECLARE @Partes INT                   = 5
DECLARE @Cantidad DECIMAL(15, 2)      = round(@CantidaLimite / @Partes, 0)
DECLARE @CantidadPlus DECIMAL(15, 2)  = @CantidaLimite - (@Cantidad*@Partes)
DECLARE @sqlCommand NVARCHAR(MAX)
DECLARE @Id_Producto VARCHAR(11)      = '1309011'
DECLARE @CantidaPermitida INT         = 5
DECLARE @CantidaPermitidaMin INT      = 0

SELECT CantidaLimite = @CantidaLimite, Partes = @Partes, Cantidad = @Cantidad, CantidadPlus = @CantidadPlus, Resultado = @Cantidad*@Partes + @CantidadPlus

SET @sqlCommand = '
  SELECT TOP ' + RTRIM(@Partes) + ' cab.Id_Documento, cab.Id_CliPro, det.Id_Producto
       , cab.Registro, Cantidad_Producto
       , Cantidad = convert(decimal(12,2), ' + RTRIM(@Cantidad) + ')
       , sql = ''UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto ' + @Signo + ' ' + RTRIM(@Cantidad) + ' WHERE Id_Documento = '''''' + det.Id_Documento + '''''' AND Id_CliPro = '''''' + det.Id_CliPro + '''''' AND Id_Producto =  '''''' + det.Id_Producto + ''''''''
    INTO ##TMP_UPDATE
    FROM dbo.Movimientos_Detalle det
   INNER JOIN dbo.Movimientos cab ON cab.EMPR_Codigo = det.EMPR_Codigo AND cab.Registro = det.Registro AND cab.Id_Documento = det.Id_Documento AND cab.Id_CliPro = det.Id_CliPro
   WHERE Anulada = 0 
     AND CONVERT(DATE, Fecha) >= ''01-01-2019'' AND CONVERT(DATE, Fecha) <= ''12-31-2019'' AND id_producto = @Id_Producto
     AND cab.EMPR_Codigo = ''INKAP'' AND cab.Registro = ''RV'' AND left(cab.Id_Documento, 2) = ''03''
     AND det.Cantidad_Producto > ' + RTRIM(@CantidaPermitida) + '
   ORDER BY newid()
   
   INSERT INTO ##TMP_UPDATE
   SELECT TOP 1 cab.Id_Documento, cab.Id_CliPro, det.Id_Producto
       , cab.Registro, Cantidad_Producto
       , Cantidad = convert(decimal(12,2),' + convert(VARCHAR(10),@CantidadPlus) + ')
       , sql = ''UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto ' + @Signo + ' ' + convert(VARCHAR(10), @CantidadPlus) + ' WHERE Id_Documento = '''''' + det.Id_Documento + '''''' AND Id_CliPro = '''''' + det.Id_CliPro + '''''' AND Id_Producto =  '''''' + det.Id_Producto + ''''''''
    FROM dbo.Movimientos_Detalle det
   INNER JOIN dbo.Movimientos cab ON cab.EMPR_Codigo = det.EMPR_Codigo AND cab.Registro = det.Registro AND cab.Id_Documento = det.Id_Documento AND cab.Id_CliPro = det.Id_CliPro
   WHERE Anulada = 0 
     AND CONVERT(DATE, Fecha) >= ''01-01-2019'' AND CONVERT(DATE, Fecha) <= ''12-31-2019'' AND id_producto = @Id_Producto
     AND cab.EMPR_Codigo = ''INKAP'' AND cab.Registro = ''RV'' AND left(cab.Id_Documento, 2) = ''03''
     AND det.Cantidad_Producto between ' + RTRIM(@CantidaPermitidaMin) + ' and ' + RTRIM(@CantidaPermitida - 1) + '
   ORDER BY newid()
   
   --SELECT * FROM #TMP_UPDATE
   --SELECT count(*) FROM #TMP_UPDATE group by Id_Documento, Id_CliPro, id_producto having count(*) > 1
   --SELECT sum(Cantidad) FROM #TMP_UPDATE'
PRINT @sqlCommand
EXECUTE sp_executesql @sqlCommand, N'@Id_Producto nvarchar(11), @Cantidad DECIMAL(12,2)', @Id_Producto = @Id_Producto,@Cantidad = @Cantidad


SELECT * FROM ##TMP_UPDATE ORDER BY Cantidad
--SELECT sum(Cantidad) FROM ##TMP_UPDATE

DROP TABLE ##TMP_UPDATE



UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010003916' AND Id_CliPro = '24007098' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010004374' AND Id_CliPro = '23924096' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010005370' AND Id_CliPro = '41868047' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010006434' AND Id_CliPro = '20025412' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010014346' AND Id_CliPro = '42962424' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + -1.00 WHERE Id_Documento = '03B0010016667' AND Id_CliPro = '23988591' AND Id_Producto =  '0801001'



SELECT Cantidad_Producto, * FROM dbo.Movimientos_Detalle WHERE Id_Documento IN ('03B0010003916','03B0010004374','03B0010005370','03B0010006434','03B0010014346','03B0010016667') AND Id_Producto = '0801001'
SELECT DOCVD_Cantidad, * FROM BDInkaPeru.Ventas.VENT_DocsVentaDetalle WHERE DOCVE_Codigo IN ('03B0010003916','03B0010004374','03B0010005370','03B0010006434','03B0010014346','03B0010016667') AND ARTIC_Codigo = '0801001'


SELECT Cantidad_Producto , PROD.DOCVD_Cantidad,  Cantidad_Producto - PROD.DOCVD_Cantidad
      , * FROM dbo.Movimientos_Detalle DET
 INNER JOIN dbo.Movimientos MOV ON MOV.EMPR_Codigo = DET.EMPR_Codigo AND MOV.Registro = DET.Registro AND MOV.Id_Documento = DET.Id_Documento AND MOV.Id_CliPro = DET.Id_CliPro
 INNER JOIN BDInkaPeru.Ventas.VENT_DocsVentaDetalle PROD ON PROD.DOCVE_Codigo = DET.Id_Documento AND PROD.ARTIC_Codigo = DET.Id_Producto
 WHERE MOV.EMPR_Codigo = 'INKAP' AND DET.Id_Producto = '0801001' AND DET.Registro = 'RV'
  AND DET.Cantidad_Producto <> PROD.DOCVD_Cantidad


--UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 2.00 WHERE Id_Documento = '03B0010007130' AND Id_CliPro = '10438991' AND Id_Producto =  '0801004'
--UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 2.00 WHERE Id_Documento = '03B0010012600' AND Id_CliPro = '25182482' AND Id_Producto =  '0801004'
--UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 1.00 WHERE Id_Documento = '03B0010017763' AND Id_CliPro = '23897838' AND Id_Producto =  '0801004'
--UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 2.00 WHERE Id_Documento = '03B0010017899' AND Id_CliPro = '40118115' AND Id_Producto =  '0801004'


BEGIN TRAN X

 UPDATE DET
    SET Cantidad_Producto = PROD.DOCVD_Cantidad
   FROM dbo.Movimientos_Detalle DET
  INNER JOIN dbo.Movimientos MOV ON MOV.EMPR_Codigo = DET.EMPR_Codigo AND MOV.Registro = DET.Registro AND MOV.Id_Documento = DET.Id_Documento AND MOV.Id_CliPro = DET.Id_CliPro
  INNER JOIN BDInkaPeru.Ventas.VENT_DocsVentaDetalle PROD ON PROD.DOCVE_Codigo = DET.Id_Documento AND PROD.ARTIC_Codigo = DET.Id_Producto
  WHERE MOV.EMPR_Codigo = 'INKAP' AND DET.Id_Producto = '0801001' AND DET.Registro = 'RV'
    AND DET.Cantidad_Producto <> PROD.DOCVD_Cantidad


UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010003916' AND Id_CliPro = '24007098' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010004374' AND Id_CliPro = '23924096' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010005370' AND Id_CliPro = '41868047' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010006434' AND Id_CliPro = '20025412' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + 10.00 WHERE Id_Documento = '03B0010014346' AND Id_CliPro = '42962424' AND Id_Producto =  '0801001'
UPDATE Movimientos_Detalle SET Cantidad_Producto = Cantidad_Producto + -1.00 WHERE Id_Documento = '03B0010016667' AND Id_CliPro = '23988591' AND Id_Producto =  '0801001'

SELECT Cantidad_Producto , PROD.DOCVD_Cantidad,  Cantidad_Producto - PROD.DOCVD_Cantidad
      , * FROM dbo.Movimientos_Detalle DET
 INNER JOIN dbo.Movimientos MOV ON MOV.EMPR_Codigo = DET.EMPR_Codigo AND MOV.Registro = DET.Registro AND MOV.Id_Documento = DET.Id_Documento AND MOV.Id_CliPro = DET.Id_CliPro
 INNER JOIN BDInkaPeru.Ventas.VENT_DocsVentaDetalle PROD ON PROD.DOCVE_Codigo = DET.Id_Documento AND PROD.ARTIC_Codigo = DET.Id_Producto
 WHERE MOV.EMPR_Codigo = 'INKAP' AND DET.Id_Producto = '0801001' AND DET.Registro = 'RV'
  AND DET.Cantidad_Producto <> PROD.DOCVD_Cantidad

ROLLBACK TRAN X
