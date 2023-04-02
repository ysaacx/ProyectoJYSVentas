GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ABASSD_EliminarStockIngresoMerc]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 05/06/2017
-- Descripcion         : Eliminar Stock Ingresado
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc]
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

    PRINT '=================================='
    PRINT '@ALMAC_Id = ' + ISNULL(RTRIM(@ALMAC_Id), '*')
    PRINT '@INGCO_Id = ' + ISNULL(RTRIM(@INGCO_Id), '*')
    PRINT '=================================='
END 


GO 
/***************************************************************************************************************************************/ 
BEGIN TRAN x

exec LOG_ABASSD_EliminarStockIngresoMerc @DOCCO_Codigo=N'010010000010',@ENTID_CodigoProveedor=N'20100241022'

ROLLBACK TRAN x
