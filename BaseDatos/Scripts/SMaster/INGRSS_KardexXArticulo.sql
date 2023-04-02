USE BDMaster
go
-- =============================================
-- Autor - Fecha Crea  : Generador - 17/10/2011
-- Descripcion         : Procedimiento de Selección según primary foregin keys de la tabla CONT_Deposito
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
ALTER PROCEDURE [dbo].[INGRSS_KardexXArticulo]
(    @Id_Producto VarChar(11)
	, @FecIni DateTime
	, @FecFin DATETIME
   , @EMPR_Codigo CHAR(5)
)
As

 SELECT IsNull(V.Fecha_Documento, C.Fecha) As Fecha
		, C.Id_Documento
		, C.Descripcion
		, ISNULL(D.Cantidad_Producto, 0) AS Cantidad_Producto
      , ISNULL(ROUND(D.Costo * C.Tipo_Cambio, 2), 0) AS Importe
      , C.Registro
      , D.Id_Producto
      , C.Anulada
      , C.Id_CliPro
      , Documento = LEFT(TDoc.Descripcion, 1) + ' ' + IsNull(Serie_Documento,Right(Left(C.Id_Documento, 5), 3))  
		 	         + '-' + IsNull(Right('0000000' + RTrim(Numero_Documento), 7), Right(C.Id_Documento, 7)) 
		, IsNull(Costo, 0) As Costo
		, TDoc.Descripcion As D
		, IsNull(Serie_Documento, Right(Left(C.Id_Documento, 5), 3)) As Serie_Documento
		, Numero_Documento
   FROM dbo.Movimientos As C
  INNER JOIN dbo.Movimientos_Detalle As D ON D.Registro = C.Registro AND D.EMPR_Codigo = C.EMPR_Codigo
	 AND D.Id_Documento = C.Id_Documento --And C.Id_Documento Like '%0060433'
	 AND D.Id_CliPro = C.Id_CliPro
    AND D.EMPR_Codigo = C.EMPR_Codigo
	LEFT JOIN Compras As V On V.Id_Compra = C.Id_Documento And V.Id_Proveedor = C.Id_CliPro AND V.EMPR_Codigo = C.EMPR_Codigo
	LEFT JOIN Tipo_Documento As TDoc On TDoc.ID_Tipo_Documento = IsNull(V.ID_Tipo_Documento, Left(C.Id_Documento, 2))
  WHERE C.Anulada = 0 And C.Fecha Between @FecIni And @FecFin
	 AND D.Id_producto = @Id_Producto
	 AND C.Registro = 'RC'
    AND C.EMPR_Codigo = @EMPR_Codigo
  UNION All
 SELECT V.Fecha
		, C.Id_Documento
		, C.Descripcion
		, ISNULL(D.Cantidad_Producto, 0) AS Cantidad_Producto
      , ISNULL(ROUND(D.Costo * C.Tipo_Cambio, 2), 0) AS Importe
      , C.Registro
      , D.Id_Producto
      , C.Anulada
      , C.Id_CliPro
      , Left(TDoc.Descripcion, 1) + ' ' + Nro_Serie + '-' + Right('0000000' + RTrim(Nro_Venta), 7) As Documento
      , IsNull(Costo, 0) As Costo
      , TDoc.Descripcion
      , Nro_Serie
		, Nro_Venta
   FROM dbo.Movimientos As C
  INNER JOIN dbo.Movimientos_Detalle As D ON D.Registro = C.Registro AND D.EMPR_Codigo = C.EMPR_Codigo
	 AND D.Id_Documento = C.Id_Documento 
	 AND D.EMPR_Codigo = C.EMPR_Codigo
	LEFT JOIN Ventas As V On V.Id_Venta = C.Id_Documento AND V.EMPR_Codigo = C.EMPR_Codigo
	LEFT JOIN Tipo_Documento As TDoc On TDoc.ID_Tipo_Documento = V.ID_Tipo_Documento
  WHERE C.Anulada = 0 And Convert(Date, C.Fecha) Between @FecIni And @FecFin
 	 AND D.Id_producto = @Id_Producto
	 AND C.Registro = 'RV'
    AND C.EMPR_Codigo = @EMPR_Codigo
Order By Fecha, C.Registro, C.Id_Documento 


go

exec INGRSS_KardexXArticulo @Id_Producto=N'0101005',@FecIni='2019-01-01 00:00:00',@FecFin='2019-05-11 00:00:00',@EMPR_Codigo=N'FISUR'

--EXEC INGRSS_KardexXArticulo @Id_Producto=N'0801007',@FecIni='2018-01-01 00:00:00',@FecFin='2018-07-31 00:00:00'
--exec INGRSS_KardexXArticulo @Id_Producto=N'0101010',@FecIni='2019-01-01 00:00:00',@FecFin='2019-05-04 00:00:00',@EMPR_Codigo = 'FISUR'
--exec INGRSS_KardexXArticulo @Id_Producto=N'0101004',@FecIni='2019-01-01 00:00:00',@FecFin='2019-05-04 00:00:00',@EMPR_Codigo=N'FISUR'

--SELECT * FROM dbo.Movimientos WHERE Id_Documento LIKE '03002%000063'
--SELECT * FROM dbo.Movimientos_Detalle WHERE Id_Documento LIKE '03002%000063'

--SELECT Tipo_Cambio, * FROM Movimientos WHERE Id_Documento = '01F0010011713'

