GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VEHISS_BuscarVehiculo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VEHISS_BuscarVehiculo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 13/05/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VEHISS_BuscarVehiculo]
(
	 @TConsulta SmallInt
	,@Cadena VarChar(50)
)
As

Select Distinct TMar.TIPOS_Descripcion As TIPOS_Marca
	,TVehi.TIPOS_Descripcion As TIPOS_Vehiculo
	,TCmb.TIPOS_Descripcion As TIPOS_TipoCombustible
	,n_entidades.ENTID_RazonSocial As ENTID_RazonSocial
	,Cond.ENTID_RazonSocial As Conductor
	,Ranf.RANFL_Placa As RANFL_Placa
	,Vehic.* 
From Transportes.TRAN_Vehiculos As Vehic 
	Inner Join dbo.Tipos As TMar On TMar.TIPOS_Codigo = Vehic.TIPOS_CodMarca
	Inner Join dbo.Tipos As TVehi On TVehi.TIPOS_Codigo = Vehic.TIPOS_CodTipoVehiculo
	Left Join dbo.Tipos As TCmb On TCmb.TIPOS_Codigo = Vehic.TIPOS_CodTipoCombustible
	Left Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = Vehic.ENTID_CodigoTransportista
	Left Join Transportes.TRAN_VehiculosRanflas As Relac On Relac.VEHIC_Id = Vehic.VEHIC_Id AND  ISNULL(Relac.VEHRN_Estado, '') = 'A'
	Left Join Transportes.TRAN_VehiculosConductores As VehCond On VehCond.VEHIC_Id = Vehic.VEHIC_Id
	And VehCond.VHCON_Estado = 'A'
	Left Join dbo.Entidades As Cond On Cond.ENTID_Codigo = VehCond.ENTID_Codigo
	Left Join Transportes.TRAN_Ranflas As Ranf On Ranf.RANFL_Id = Relac.RANFL_Id 
WHERE (Case @TConsulta  When 0 Then RTrim(Vehic.VEHIC_Id)
						  When 1 Then VEHIC_Placa
						  When 2 Then TMar.TIPOS_Descripcion
						  Else VEHIC_Placa End) Like '%' + @Cadena + '%'
	AND  ISNULL(Vehic.VEHIC_Estado, '') <> 'X' 
	

GO 
/***************************************************************************************************************************************/ 

