USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ABAS_INGCOSD_UnRegStock]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ABAS_INGCOSD_UnRegStock] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/05/2016
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ABAS_INGCOSD_UnRegStock]
(	 @DOCCO_Codigo CodigoMax
  , @ENTID_CodigoProveedor Codigo14)
AS

   DECLARE @ALMAC_ID SMALLINT
   DECLARE @INGCO_ID BIGINT
    SELECT @ALMAC_ID = ALMAC_ID, @INGCO_ID = INGCO_ID 
      FROM Logistica.ABAS_IngresosCompra
     WHERE DOCCO_Codigo = @DOCCO_Codigo 
       AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

   DELETE FROM Logistica.ABAS_IngresosCompraDetalle WHERE ALMAC_Id = @ALMAC_Id AND INGCO_Id = @INGCO_ID
   DELETE FROM Logistica.ABAS_IngresosCompra WHERE ALMAC_Id = @ALMAC_Id AND INGCO_Id = @INGCO_ID

GO 
/***************************************************************************************************************************************/ 

BEGIN TRAN x

EXEC ABAS_INGCOSD_UnRegStock '010380024020', '20370146994'

ROLLBACK TRAN x

