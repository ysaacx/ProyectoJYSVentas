GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_PendientePorViaje]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_PendientePorViaje] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_PendientePorViaje]
(
	@FecIni As DateTime
	,@FecFin As DateTime
)
As

Select Rec.VIAJE_Id
	,Sum(Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End) As Pendiente
	,Via.VIAJE_Descripcion
	,ECond.ENTID_RazonSocial + ' /' + Cond.CONDU_Sigla As Conductor
	,Veh.VEHIC_Placa
	,Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
Into #Pendientes
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Left Join Transportes.TRAN_CombustibleConsumo As CC On CC.COMCO_Id = Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0))
		And CC.COMCO_CCaja = 1
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
	And Convert(Date,Caj.CAJA_Fecha) <= @FecFin
Group By Rec.VIAJE_Id, Via.VIAJE_Descripcion, Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
	,ECond.ENTID_RazonSocial, Cond.CONDU_Sigla, Veh.VEHIC_Placa

Select * From #Pendientes
Where Convert(Date, VIAJE_FecLlegada) Between @FecIni And @FecFin


GO 
/***************************************************************************************************************************************/ 

