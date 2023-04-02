GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaPendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPendientes]
(
	@FecIni As DateTime
	,@FecFin As DateTime
)
As

Select Rec.VIAJE_Id
	,Sum(Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End) As Pendiente
	,Via.VIAJE_Descripcion 
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) As Documento
	,ECond.ENTID_RazonSocial + ' /' + Cond.CONDU_Sigla As Conductor
	,Veh.VEHIC_Placa 
	,Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
	--,TDoc.TIPOS_DescCorta  + ' ' + Rec.RECIB_Serie + '-' + RIGHT('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
Into #Pendientes
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
	And Convert(Date, Caj.CAJA_Fecha) <= @FecFin
Group By Rec.VIAJE_Id, Via.VIAJE_Descripcion, Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
	,ECond.ENTID_RazonSocial, Cond.CONDU_Sigla, Veh.VEHIC_Placa
	,Via.VIAJE_IdxConductor

Select * From #Pendientes Where Pendiente <> 0

--Select * From Transportes.TRAN_Fletes 
--Where VIAJE_Id In (Select VIAJE_Id From #Pendientes Where Pendiente <> 0)
--	And Not ENTID_Codigo In ('620100241022') --, '620191731434')


GO 
/***************************************************************************************************************************************/ 

