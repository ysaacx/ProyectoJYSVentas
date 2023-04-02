GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_Recibos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_Recibos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_Recibos]
(
	 @FecIni As DateTime
	,@FecFin As DateTime
	--,@ENTID_Codigo VarChar(14) = Null
)
As

Select Rec.VIAJE_Id
	,Rec.RECIB_Fecha
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') As TIPOS_Moneda
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,'Ingresos / Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
	,Rec.RECIB_Concepto
	,Rec.RECIB_Monto
	,Convert(Decimal, 0.00)
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Convert(Decimal, 0.00) As VGAST_Monto
From Transportes.TRAN_Recibos  As Rec
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where CONVERT(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And TIPOS_CodTipoRecibo = 'RCT1'
	
Select 0
	,CAJA_Fecha
	,T.TIPOS_Descripcion
	,RTrim(CAJA_Id)
	,Caj.CAJA_Glosa
	,'Proceso en Caja'
	,Case TIPOS_CodTipoDocumento When 'CPDIN' Then IsNull(CAJA_Importe, 0) Else 0.00 End
	,Case TIPOS_CodTipoDocumento When 'CPDEG' Then IsNull(CAJA_Importe, 0) Else 0.00 End
	,Convert(Decimal, 0.00)
	,'CAJA'
	,Convert(Decimal, 0.00) As VGAST_Monto
	,Rec.RECIB_Codigo, Caj.CAJA_NroDocumento
	,Rec.*
From Tesoreria.TESO_Caja As Caj
	Left Join Tipos As T On T.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento -- Rec.RECIB_CodReferencia = Caj.CAJA_Id
Where TIPOS_CodTipoOrigen = 'ORI05'
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
Order By CAJA_Fecha


GO 
/***************************************************************************************************************************************/ 

