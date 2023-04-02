GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_ConsumoCombustible]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_ConsumoCombustible] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_ConsumoCombustible]
(
	@VIAJE_Id As BigInt
)
As

Select TCom.TIPOS_Descripcion As TIPOS_TipoCombustible
	, TMPag.TIPOS_Descripcion As TIPOS_ModoPago
	, Entid.ENTID_RazonSocial As ENTID_RazonSocial
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	, Doc.DOCUS_Serie As DOCUS_Serie
	, Doc.DOCUS_Numero As DOCUS_Numero
	, Doc.TIPOS_CodTipoDocumento As DOCUS_CodTipoDocumento
	, TipoDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TipoDoc.TIPOS_DescCorta As CompTipoDocumento
	, Caj.CAJA_Id
	, Rec.RECIB_Codigo
	, TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	, TRef.TIPOS_DescCorta + ' ' + Ref.RECIB_Serie + '-' + Right('0000000' + RTrim(Ref.RECIB_Numero), 7) As Referencia
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, Comb.* 
 From Transportes.TRAN_CombustibleConsumo As Comb 
	 Inner Join dbo.Tipos As TCom On TCom.TIPOS_Codigo = Comb.TIPOS_CodTipoCombustible
	 Inner Join dbo.Tipos As TMPag On TMPag.TIPOS_Codigo = Comb.TIPOS_CodModoPago
	 Inner Join dbo.Entidades As Entid On Entid.ENTID_Codigo = Comb.ENTID_CodigoProveedor
	 Left Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Comb.TIPOS_CodTipoDocumento
	 Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Comb.DOCUS_Codigo And Doc.ENTID_Codigo = Comb.ENTID_CodigoProveedor
	 Inner Join dbo.Tipos As TipoDoc On TipoDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	 Inner Join Transportes.TRAN_Recibos as Rec On Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Comb.COMCO_Id
		And Rec.VIAJE_Id = Comb.VIAJE_Id
		--And Rec.TIPOS_CodTipoRecibo = 'RCT6'
	 Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	 Left Join Transportes.TRAN_Recibos as Ref On Ref.RECIB_Codigo = Rec.RECIB_CodRecRef
		And Ref.VIAJE_Id = Comb.VIAJE_Id
		--And Ref.TIPOS_CodTipoRecibo = 'RCT3'
	 Left Join Tipos As TRef On TRef.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	 Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Comb.TIPOS_CodTipoMoneda
 WHERE   ISNULL(Comb.VIAJE_Id, '') = @VIAJE_Id
 

GO 
/***************************************************************************************************************************************/ 

