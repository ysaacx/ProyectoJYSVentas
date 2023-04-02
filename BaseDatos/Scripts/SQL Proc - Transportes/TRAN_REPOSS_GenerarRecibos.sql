GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPOSS_GenerarRecibos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPOSS_GenerarRecibos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPOSS_GenerarRecibos]
(
	@FecIni DateTime
	,@FecFin DateTime
)
As

Select 'Otros Gastos' As FLETE_Glosa
	, Gas.VIAJE_Id
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)  As Documento		
	,Gas.VGAST_Descripcion
	,Via.VIAJE_Descripcion
	,Gas.VGAST_Monto As Importe
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Via.VIAJE_FecSalida As VGAST_Fecha
	,VIAJE_FecLlegada
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' /' + Cond.CONDU_Sigla As Recibo
From Transportes.TRAN_ViajesGastos As Gas
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Gas.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Tipos As T On T.TIPOS_Codigo = Gas.TIPOS_CodTipoGasto
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.VIAJE_Id = Gas.VIAJE_Id
		And Rec.RECIB_CodReferencia = Gas.VGAST_Id
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where Via.VIAJE_FecSalida Between @FecIni And @FecFin
	And Gas.DOCUS_Codigo Is Null
	And Not Gas.TIPOS_CodTipoGasto = 'GTO05'
	
Union 
Select TDoc.TIPOS_Descripcion + ' Rec: ' + Rec.RECIB_Serie + '-' + RTrim(Rec.RECIB_Numero) As FLETE_Glosa
	,Rec.VIAJE_Id
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)  As Numero
	,TDoc.TIPOS_Descripcion + ' / Viaje Nro:' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
	,Rec.RECIB_Concepto
	,Rec.RECIB_Monto
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Rec.RECIB_Fecha
	,VIAJE_FecLlegada
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' /' + Cond.CONDU_Sigla
From Transportes.TRAN_Recibos  As Rec
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where TIPOS_CodTipoRecibo In ('RCT5')
	And Via.VIAJE_FecSalida Between @FecIni And @FecFin
Order By VIAJE_FecLlegada, VIAJE_Id, FLETE_Glosa



GO 
/***************************************************************************************************************************************/ 

