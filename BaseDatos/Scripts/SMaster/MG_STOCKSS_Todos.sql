GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MG_STOCKSS_Todos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[MG_STOCKSS_Todos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 27/07/2011
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MG_STOCKSS_Todos]
(     @Periodo VarChar(4)
    , @Id_Producto varchar(11) = NULL
    , @EMPR_Codigo CHAR(5)
)
AS

 SELECT Periodo, Id_Producto
      , Sum(IsNull(StockFisico, 0)) As StockFisico
      , Sum(IsNull(StockInicialContable, 0)) As StockInicialContable
      , avg(IsNull(CostoInicialContable, 0)) As CostoInicialContable  -- era suma
        --,0.00 As CostoInicialContable
      , Sum(IsNull(Pendiente_Inicial_Contable, 0)) As Pendiente_Inicial_Contable
   FROM StockInicial
  WHERE Periodo = @Periodo
    AND Id_Producto = IsNull(@Id_Producto, Id_Producto)
    AND EMPR_Codigo = @EMPR_Codigo
  GROUP BY Periodo, Id_Producto


GO 
/***************************************************************************************************************************************/ 

exec MG_STOCKSS_Todos @Periodo=N'2019',@Id_Producto=N'0101010', @EMPR_Codigo = 'FISUR'

SELECT * FROM dbo.StockInicial WHERE EMPR_Codigo = 'FISUR' AND Id_Producto = '0101010'
