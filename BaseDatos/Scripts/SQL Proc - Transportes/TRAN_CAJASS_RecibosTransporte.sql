GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_RecibosTransporte]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_RecibosTransporte] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_RecibosTransporte]
(
	@VIAJE_Id As BigInt
)
As

Select Rec.* , TDoc.TIPOS_Descripcion As TIPOS_TipoRecibo
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Caj.CAJA_Id
	,Caj.CAJA_Pase
From Transportes.TRAN_Recibos As Rec 
	 Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	 Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda 
	 Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
WHERE   Rec.VIAJE_Id = @VIAJE_Id
	And TIPOS_CodTipoRecibo In ('RCT5', 'RCT1', 'RCT2')


GO 
/***************************************************************************************************************************************/ 

