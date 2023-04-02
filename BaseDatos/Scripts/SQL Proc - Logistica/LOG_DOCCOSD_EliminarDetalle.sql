GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSD_EliminarDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 10/12/2017
-- Descripcion         : Eliminar detalle de los documentos de compra
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 

    PRINT 'DELETE Logistica.ABAS_DocsCompraDetalle'
    DELETE FROM Logistica.ABAS_DocsCompraDetalle 
     WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

END 

GO 
/***************************************************************************************************************************************/ 
