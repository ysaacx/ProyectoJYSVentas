GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaEgresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaEgresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaEgresos]
(
	@FecIni DateTime
	,@FecFin As DateTime
	,@VIAJE_Id BigInt = Null
)
As

Select VIAJE_Id Into #Viajes From Transportes.TRAN_Fletes WHere ENTID_Codigo = '620191731434'
-- Fletes
Select Gas.VIAJE_Id
	,(
		IsNull((Select Top 1 TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-'  + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
		From Transportes.TRAN_Documentos As Doc
			Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
		Where Doc.DOCUS_Codigo = Gas.DOCUS_Codigo), 'Rel. Recibos')
	 )As Documento		
	,case When DOCUS_Codigo Is Null Then T.TIPOS_Descripcion Else  
		(Select Top 1 ENTID_RazonSocial From Entidades EDoc 
			Inner join Transportes.TRAN_Documentos as Doc On Doc.ENTID_Codigo = EDoc.ENTID_Codigo
			Where Doc.DOCUS_Codigo = Gas.DOCUS_Codigo)
	 End
		+ ' / Viaje Nro:' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') As VGAST_Descripcion
	,Via.VIAJE_Descripcion
	,Sum(Gas.VGAST_Monto) As Importe
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Via.VIAJE_FecSalida As VGAST_Fecha
From Transportes.TRAN_ViajesGastos As Gas
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Gas.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Tipos As T On T.TIPOS_Codigo = Gas.TIPOS_CodTipoGasto
Where Convert(Date, Gas.VGAST_FechaViaje) Between @FecIni	 And @FecFin
	And Gas.VIAJE_Id = ISNULL(@VIAJE_Id, Gas.VIAJE_Id)
	And Not Gas.VIAJE_Id In (Select VIAJE_Id From #Viajes)
Group By Gas.VIAJE_Id, Via.VIAJE_IdxConductor, Cond.CONDU_Sigla, Via.VIAJE_Descripcion, T.TIPOS_Descripcion
	,Gas.DOCUS_Codigo,Via.VIAJE_FecSalida
Union -- Combustible
--Select CC.VIAJE_Id
--	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-'  + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
--	,'Consumo de Combustible / Viaje Nro:' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
--	,Ent.ENTID_RazonSocial
--	,CC.COMCO_Total
--	,Via.VIAJE_IdxConductor
--	,Cond.CONDU_Sigla
--From Transportes.TRAN_CombustibleConsumo As CC
--	Inner Join Entidades As Ent on Ent.ENTID_Codigo = CC.ENTID_CodigoProveedor
--	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = CC.VIAJE_Id
--	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
--	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
--	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
--	Inner Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = CC.DOCUS_Codigo
--	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
--Where CONVERT(Date, CC.COMCO_FechaViaje) Between @FecIni And @FecFin
--	And CC.VIAJE_Id = ISNULL(@VIAJE_Id, CC.VIAJE_Id)
--	And Not CC.VIAJE_Id In (Select VIAJE_Id From #Viajes)
--Union -- Gastos de Viaje
Select Rec.VIAJE_Id
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)  As Numero
	,'A Cta. de Sueldo / Viaje Nro:' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
	,Rec.RECIB_Concepto
	,Rec.RECIB_Monto
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Rec.RECIB_Fecha
From Transportes.TRAN_Recibos  As Rec
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where CONVERT(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And TIPOS_CodTipoRecibo = 'RCT5'
	And Rec.VIAJE_Id = ISNULL(@VIAJE_Id, Rec.VIAJE_Id)
	And Not Rec.VIAJE_Id In (Select VIAJE_Id From #Viajes)
Union
Select Caj.CAJA_Id
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)  As Numero
	,CAJA_Glosa
	, ''
	,CAJA_Importe
	,0
	,''
	,Caj.CAJA_Fecha
From Tesoreria.TESO_Caja As Caj 
	Inner Join Transportes.Tran_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where Caj.TIPOS_CodTipoDocumento = 'CPDEG'
	And Convert(Date, Caj.CAJA_Fecha) Between @FecIni And @FecFin
Order By VIAJE_IdxConductor


GO 
/***************************************************************************************************************************************/ 

