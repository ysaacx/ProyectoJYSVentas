GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PADROSS_ConsultarRUC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[PADROSS_ConsultarRUC]
GO 
CREATE PROC PADROSS_ConsultarRUC
@Ruc VARCHAR(15)
AS

    SELECT ENTID_NroDocumento = Ruc
         , ENTID_RazonSocial = RazonSocial
         --, Estado
         --, Condicion
         , Ubigeo = Ubigeo
         , ENTID_Direccion = Direccion 
      FROM TablaRUC 
     WHERE Ruc = @Ruc

GO 
/***************************************************************************************************************************************/ 


--SELECT TOP 10  * FROM dbo.Entidades