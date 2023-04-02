GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[V_MOVIMIENTOS_DETALLE]') AND OBJECTPROPERTY(id,N'IsView') = 1) 
    DROP VIEW [dbo].[V_MOVIMIENTOS_DETALLE] 
GO 
/* =============================================
 Autor - Fecha Crea  : Generador - 18/01/2012
 Descripcion         : Procedimiento de Selección de todos de la tabla Movimientos
 Autor - Fecha Modif : 
 Descripcion         : 
 =============================================*/
CREATE VIEW dbo.V_MOVIMIENTOS_DETALLE
AS
   SELECT dbo.Movimientos.Fecha, dbo.Movimientos_Detalle.Id_Documento
        , dbo.Movimientos.Descripcion
        , ISNULL(dbo.Movimientos_Detalle.Cantidad_Producto, 0) AS Cantidad_Producto
        , ISNULL(ROUND(dbo.Movimientos_Detalle.Costo * dbo.Movimientos.Tipo_Cambio, 2), 0) AS Importe
        , dbo.Movimientos.Registro
        , dbo.Movimientos_Detalle.Id_Producto
        , dbo.Movimientos.Anulada
        , dbo.Movimientos.Id_CliPro
        , dbo.Movimientos.Id_Documento AS Expr1
        , dbo.Movimientos.Id_Moneda
        , Movimientos.EMPR_Codigo
     FROM dbo.Movimientos 
    INNER JOIN dbo.Movimientos_Detalle ON dbo.Movimientos.Registro = dbo.Movimientos_Detalle.Registro 
      AND dbo.Movimientos.Id_Documento = dbo.Movimientos_Detalle.Id_Documento AND dbo.Movimientos.Id_CliPro = dbo.Movimientos_Detalle.Id_CliPro

GO 
/***************************************************************************************************************************************/ 
