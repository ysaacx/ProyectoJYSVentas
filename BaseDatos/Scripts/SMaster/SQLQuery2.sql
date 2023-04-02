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
    @Periodo Smallint
)
AS

Select 
    Id_Producto
    ,Nombre_Producto
    ,(Select Top 1 (Sub_Importe/Cantidad_Producto)*Ven_Dol_Sunat
        From Compras_Detalle As D
        Inner Join Compras As C On C.Id_Compra = D.Id_Compra 
            And Year(C.Fecha_Documento) = @Periodo
            And D.Id_Producto = Pro.Id_Producto
            And C.Fecha_Documento = (Select MAX(Fecha_Documento) From Compras As CC 
                                        Inner Join Compras_Detalle As DD On DD.Id_Compra = CC.Id_Compra And DD.Id_Producto = Pro.Id_Producto)
     ) UltimoCosto
     ,*
from Productos As Pro
Where Imprimir = 1
    --And Id_Producto = 'P0202019000'
Order By Pro.Id_Producto

GO 

EXEC dbo.ARTISS_Consulta @Periodo = 2019 -- smallint




