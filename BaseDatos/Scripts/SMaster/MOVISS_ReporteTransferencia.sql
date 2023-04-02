GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ReporteTransferencia]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[MOVISS_ReporteTransferencia] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/01/2012
-- Descripcion         : Procedimiento de Inserción de la tabla Departamento
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ReporteTransferencia]
(   
     @FecIni DateTime
    ,@FecFin DateTime
)

AS

Select V.Id_Sucursal As ID, A.Descripcion, 'Registro Venta' As Tipo,Count(*) As Registro 
    ,(Select Count(*) From Ventas_Detalle As D 
        Where D.Id_Sucursal = V.Id_Sucursal
        And Id_Venta In (Select Id_Venta From Ventas Where Fecha Between @FecIni And @FecFin)
    ) As Detalle
    ,Convert(bit, 0) As Sel
From Ventas As V
    Left Join Almacenes As A On V.Id_Sucursal = A.Id_Sucursal
Where Fecha Between @FecIni And @FecFin
Group By V.Id_Sucursal, A.Descripcion
Union All
Select V.Id_Sucursal, A.Descripcion, 'Registro Compra' As Tipo,Count(*) As Registro 
    ,(Select Count(*) From Compras_Detalle As D 
        Where D.Id_Sucursal = V.Id_Sucursal
        And D.Id_Compra+D.Id_Proveedor In (Select Id_Compra+Id_Proveedor 
                                        From Compras 
                                        Where Fecha_Documento Between @FecIni And @FecFin)
    ) As Detalle
    ,Convert(bit, 0) As Seleccion
From Compras As V
    Inner Join Almacenes As A On V.Id_Sucursal = A.Id_Sucursal
Where Fecha_Documento Between @FecIni And @FecFin
Group By V.Id_Sucursal, A.Descripcion
Order By V.Id_Sucursal, Tipo



GO 
/***************************************************************************************************************************************/ 
