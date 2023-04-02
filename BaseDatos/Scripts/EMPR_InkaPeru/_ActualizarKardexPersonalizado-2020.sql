USE BDMaster
GO


DECLARE @CantidaLimite DECIMAL(15, 2) = 232
DECLARE @Signo VARCHAR(1)             = '-'
DECLARE @Partes INT                   = 23
DECLARE @Cantidad DECIMAL(15, 2)      = round(@CantidaLimite / @Partes, 0)
DECLARE @CantidadPlus DECIMAL(15, 2)  = @CantidaLimite - (@Cantidad*@Partes)
DECLARE @sqlCommand NVARCHAR(MAX)
DECLARE @Id_Producto VARCHAR(11)      = '0829005'
DECLARE @CantidaPermitida INT         = 5
DECLARE @CantidaPermitidaMin INT      = 0
DECLARE @AÑO VARCHAR(4)               = '2020'

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
     AND CONVERT(DATE, Fecha) >= ''01-01-' + @AÑO + ''' AND CONVERT(DATE, Fecha) <= ''12-31-' + @AÑO + ''' AND id_producto = @Id_Producto
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
     AND CONVERT(DATE, Fecha) >= ''01-01-' + @AÑO + ''' AND CONVERT(DATE, Fecha) <= ''12-31-' + @AÑO + ''' AND id_producto = @Id_Producto
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


