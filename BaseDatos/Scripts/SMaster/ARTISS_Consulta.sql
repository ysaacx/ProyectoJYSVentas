USE BDMaster
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTISS_Consulta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[ARTISS_Consulta] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTISS_Consulta]
(
    @Periodo      SMALLINT
  , @TipoConsulta BIT 
  , @EMPR_Codigo  VARCHAR(5)
)
AS

    IF @TipoConsulta = 1
        BEGIN 
            PRINT ' ------------------  '
            DECLARE @FecIni DATETIME = RTRIM(@Periodo) + '-01-01'
            DECLARE @FecFin DATETIME = RTRIM(@Periodo) + '-12-31'

            SELECT DISTINCT PROD.Id_Producto, PROD.Nombre_Producto 
              INTO #PROD
              FROM Movimientos_Detalle MOVD
             INNER JOIN Movimientos MOVI ON MOVI.EMPR_Codigo = MOVD.EMPR_Codigo AND MOVI.Registro = MOVD.Registro 
               AND MOVI.Id_Documento = MOVD.Id_Documento AND MOVI.Id_CliPro = MOVD.Id_CliPro
             INNER JOIN Productos PROD ON PROD.EMPR_Codigo = MOVI.EMPR_Codigo AND PROD.Id_Producto = MOVD.Id_Producto
             WHERE MOVI.EMPR_Codigo = @EMPR_Codigo 
               AND CONVERT(DATE, Fecha) BETWEEN CONVERT(DATE, @FecIni) AND CONVERT(DATE, @FecFin)

            SELECT PRO.*
              FROM #PROD TMP
             INNER JOIN dbo.Productos PRO ON PRO.Id_Producto = TMP.Id_Producto
        END 
    ELSE
        BEGIN 
          SELECT Id_Producto
               , Nombre_Producto
               , (Select Top 1 (Sub_Importe/Cantidad_Producto)*Ven_Dol_Sunat
                     From Compras_Detalle As D
                     Inner Join Compras As C On C.Id_Compra = D.Id_Compra 
                         And Year(C.Fecha_Documento) = @Periodo
                         And D.Id_Producto = Pro.Id_Producto
                         And C.Fecha_Documento = (Select MAX(Fecha_Documento) From Compras As CC 
                                                     Inner Join Compras_Detalle As DD On DD.Id_Compra = CC.Id_Compra And DD.Id_Producto = Pro.Id_Producto)
                  ) UltimoCosto
               , Pro.*
            from Productos As Pro
            Where Imprimir = 1
              AND EMPR_Codigo = @EMPR_Codigo 
                --And Id_Producto = 'P0202019000'
            Order By Pro.Id_Producto
        END 
GO 
/***************************************************************************************************************************************/ 
exec ARTISS_Consulta @Periodo=2019, @TipoConsulta = 1, @EMPR_Codigo = 'INKAP'

--SELECT * FROM Productos