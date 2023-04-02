GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VEHISS_CargarVehiculo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VEHISS_CargarVehiculo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VEHISS_CargarVehiculo]
(
	 @VIAJE_Id Id
)
As

Select Ent.ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,Cond.CONDU_Sigla
	,Cond.CONDU_Licencia
	,Ent.ENTID_FecNacimiento
	,Veh.VEHIC_Id
	,Veh.VEHIC_Placa
	,Veh.TIPOS_CodTipoVehiculo
	,Veh.TIPOS_CodMarca 
	,Veh.VEHIC_Certificado
	,Ran.RANFL_Id
	,Ran.RANFL_Placa
	,Ran.RANFL_Certificado
	,Ran.TIPOS_CodMarca
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = Ent.ENTID_Codigo
	Inner Join Transportes.TRAN_VehiculosRanflas As VRan On VRan.VEHRN_Id = Via.VEHRN_Id
	Inner Join Transportes.TRAN_Ranflas As Ran On Ran.RANFL_Id = VRan.RANFL_Id
Where Via.VIAJE_Id = @VIAJE_Id


GO 
/***************************************************************************************************************************************/ 

