USE BDMaster

GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ObtenerProductosUsados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[MOVISS_ObtenerProductosUsados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 1/11/2021
-- Descripcion         : Importar las Compras
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ObtenerProductosUsados]
(	  @FecIni DateTime
	, @FecFin DATETIME
    , @EMPR_Codigo  VARCHAR(5)
)
AS
BEGIN 

    SELECT DISTINCT PROD.Id_Producto, PROD.Nombre_Producto 
      FROM Movimientos_Detalle MOVD
     INNER JOIN Movimientos MOVI ON MOVI.EMPR_Codigo = MOVD.EMPR_Codigo AND MOVI.Registro = MOVD.Registro 
       AND MOVI.Id_Documento = MOVD.Id_Documento AND MOVI.Id_CliPro = MOVD.Id_CliPro
     INNER JOIN Productos PROD ON PROD.EMPR_Codigo = MOVI.EMPR_Codigo AND PROD.Id_Producto = MOVD.Id_Producto
     WHERE MOVI.EMPR_Codigo = @EMPR_Codigo 
       AND CONVERT(DATE, Fecha) BETWEEN CONVERT(DATE, @FecIni) AND CONVERT(DATE, @FecFin)
     UNION 
     SELECT STOCK.Id_Producto, PROD.Nombre_Producto FROM dbo.StockInicial STOCK
      INNER JOIN Productos PROD ON PROD.EMPR_Codigo = STOCK.EMPR_Codigo AND PROD.Id_Producto = STOCK.Id_Producto
      WHERE STOCK.EMPR_Codigo = @EMPR_Codigo AND STOCK.Periodo = YEAR(@FecFin)

END 
GO 

EXEC dbo.MOVISS_ObtenerProductosUsados @FecIni = '2019-01-01', -- datetime
    @FecFin = '2019-12-31', -- datetime
    @EMPR_Codigo = 'INKAP' -- varchar(5)


