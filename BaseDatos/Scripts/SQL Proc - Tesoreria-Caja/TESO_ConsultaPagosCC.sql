USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_ConsultaPagosCC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_ConsultaPagosCC] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/01/2012
-- Descripcion         : Buscar Los registros de caja Chica
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_ConsultaPagosCC]
(
	 @PVENT_Id Id
	 ,@CAJAC_Id Id
)
As


Select 
	PVENT_Id
	,CAJAC_Id
	,CAJAP_Item
	,Cp.ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,CP.CAJAP_Descripcion
	,CP.CAJAP_Importe
	,Doc.DOCUS_Codigo
	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7) As Documento
	,CAJAP_Fecha
From Tesoreria.TESO_CajaChicaPagos As CP
	Left Join Entidades As Ent On Ent.ENTID_Codigo = CP.ENTID_Codigo
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = CP.DOCUS_Codigo And Doc.ENTID_Codigo = CP.ENTID_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
Where CP.PVENT_Id = @PVENT_Id
	And CP.CAJAC_Id = @CAJAC_Id
	And CP.CAJAP_Estado <> 'X'


GO 
/***************************************************************************************************************************************/ 

