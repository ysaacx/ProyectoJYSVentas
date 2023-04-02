GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_GastosViajeVerificados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_GastosViajeVerificados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_GastosViajeVerificados]
(
	@VIAJE_Id As BigInt
)
As

Select TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7) As Documento
	,Ent.ENTID_RazonSocial
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TInc.TIPOS_Descripcion As TIPOS_TipoGasto
	,Caj.CAJA_Id
	,Rec.RECIB_Codigo
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Recibo
	,TRef.TIPOS_DescCorta + ' ' + Ref.RECIB_Serie + '-' + Right('0000000' + RTrim(Ref.RECIB_Numero), 7) As Referencia
	,Inc.* 
From Transportes.TRAN_ViajesGastos As Inc
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Inc.DOCUS_Codigo And Doc.ENTID_Codigo = Inc.ENTID_CodigoProveedor
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Inc.TIPOS_CodTipoMoneda
	Inner Join Tipos As TInc On TInc.TIPOS_Codigo = Inc.TIPOS_CodTipoGasto
	Inner Join Transportes.TRAN_Recibos as Rec On 
		Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Inc.VGAST_Id
		And Rec.VIAJE_Id = Inc.VIAJE_Id
		--And Rec.VGAST_Id = Inc.VGAST_Id
		And Rec.TIPOS_CodTipoRecibo In ('RCT4', 'RCT6')
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Left Join Transportes.TRAN_Recibos as Ref On Ref.RECIB_Codigo = Rec.RECIB_CodRecRef
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join Tipos As TRef On TRef.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
Where Inc.VIAJE_Id = @VIAJE_Id


GO 
/***************************************************************************************************************************************/ 

