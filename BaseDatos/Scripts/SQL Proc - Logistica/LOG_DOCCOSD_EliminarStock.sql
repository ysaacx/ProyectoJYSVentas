USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSD_EliminarStock]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[LOG_DOCCOSD_EliminarStock] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 05/06/2017
-- Descripcion         : Eliminar Stock Ingresado
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_DOCCOSD_EliminarStock]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 
    
   DELETE  
     FROM Logistica.LOG_Stocks 
    WHERE INGCO_Id IN (SELECT INGCO_Id 
                         FROM Logistica.ABAS_IngresosCompra 
                        WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor)

   DECLARE @ALMAC_Id SMALLINT
         , @INGCO_Id INTEGER
   
   SELECT @ALMAC_Id = ALMAC_Id
        , @INGCO_Id = INGCO_Id
     FROM Logistica.ABAS_IngresosCompra 
    WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

    PRINT 'DELETE Logistica.ABAS_IngresosCompraDetalle'
   DELETE FROM Logistica.ABAS_IngresosCompraDetalle
    WHERE ALMAC_Id = @ALMAC_Id AND  INGCO_Id = @INGCO_Id

    PRINT 'DELETE Logistica.ABAS_IngresosCompra'
   DELETE FROM Logistica.ABAS_IngresosCompra 
    WHERE ALMAC_Id = @ALMAC_Id AND  INGCO_Id = @INGCO_Id

    PRINT 'DELETE Logistica.ABAS_DocsCompraDetalle'
    DELETE FROM Logistica.ABAS_DocsCompraDetalle 
     WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

END 

GO

BEGIN TRAN x

EXEC LOG_DOCCOSD_EliminarStock '010060051615', '20454166311'

ROLLBACK TRAN x

--SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo = '010060051615'
--SELECT * FROM Logistica.ABAS_IngresosCompra WHERE DOCCO_Codigo = '010060051615'
--SELECT * FROM Logistica.LOG_Stocks WHERE DOCCO_Codigo = '010060051615' 
