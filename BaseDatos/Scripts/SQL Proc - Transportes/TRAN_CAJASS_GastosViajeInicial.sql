GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_GastosViajeInicial]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_GastosViajeInicial] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_GastosViajeInicial]
(
	@VIAJE_Id As BigInt
)
As

Select Rec.VIAJE_Id
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TGas.TIPOS_Descripcion As TIPOS_TipoDocumento
	,Caj.CAJA_Importe
	,Caj.CAJA_Glosa + ' - S/. ' + RTRIM(Caj.CAJA_Importe) As CAJA_GlosaImporte
	,Caj.CAJA_Glosa
	,Caj.CAJA_Fecha
	,Caj.CAJA_Id
	,Rec.RECIB_Codigo
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	--,Caj.* 
	,Rec.*
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TGas On TGas.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
	And CAJA_Pase = 'P'
	And Rec.VIAJE_Id = @VIAJE_Id


GO 
/***************************************************************************************************************************************/ 

