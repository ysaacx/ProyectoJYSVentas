GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_COMCOSS_ObtConCombustible]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_COMCOSS_ObtConCombustible] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/09/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_COMCOSS_ObtConCombustible]
(
	 @COMCO_Id BigInt
)
As

Select Ent.ENTID_RazonSocial As ENTID_RazonSocial
	,Ent.ENTID_NroDocumento As ENTID_NroDocProveedor
	,Cond.ENTID_RazonSocial As Conductor
	,Cond.ENTID_NroDocumento As ENTID_NroDocConductor
	,Vehic.VEHIC_Placa As VEHIC_Placa
	,Rec.RECIB_Codigo
	,Caj.CAJA_Id
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,m_tran_combustibleconsumo.*
From Transportes.TRAN_CombustibleConsumo As m_tran_combustibleconsumo 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = m_tran_combustibleconsumo.ENTID_CodigoProveedor
	Left Join dbo.Entidades As Cond On Cond.ENTID_Codigo = m_tran_combustibleconsumo.ENTID_CodigoConductor
	Inner Join Transportes.TRAN_Vehiculos As Vehic On Vehic.VEHIC_Id = m_tran_combustibleconsumo.VEHIC_Id 
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.VIAJE_Id = m_tran_combustibleconsumo.VIAJE_Id
		And Rec.RECIB_CodReferencia = m_tran_combustibleconsumo.COMCO_Id
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = m_tran_combustibleconsumo.TIPOS_CodTipoMoneda
WHERE   m_TRAN_CombustibleConsumo.COMCO_Id = @COMCO_Id


GO 
/***************************************************************************************************************************************/ 

