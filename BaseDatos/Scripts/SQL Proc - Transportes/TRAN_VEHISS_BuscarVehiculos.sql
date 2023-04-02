GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VEHISS_BuscarVehiculos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VEHISS_BuscarVehiculos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VEHISS_BuscarVehiculos]
(
	 @PVENT_Id BigInt
	,@Cadena VarChar(100)
	,@Campo SmallInt
)
As

Select Distinct TMar.TIPOS_Descripcion As TIPOS_Marca
	, TVehi.TIPOS_Descripcion As TIPOS_Vehiculo
	, TCmb.TIPOS_Descripcion As TIPOS_TipoCombustible
	, n_entidades.ENTID_RazonSocial As ENTID_RazonSocial
	, Cond.ENTID_RazonSocial As Conductor
	,Ran.RANFL_Placa
	,Vehic.VEHIC_Placa
	,Vehic.VEHIC_Id
	,Vehic.VEHIC_Codigo
	,Vehic.VEHIC_FecAdquisicion
	--, Vehic.*
From Transportes.TRAN_Vehiculos As Vehic 
	Inner Join dbo.Tipos As TMar On TMar.TIPOS_Codigo = Vehic.TIPOS_CodMarca
	Inner Join dbo.Tipos As TVehi On TVehi.TIPOS_Codigo = Vehic.TIPOS_CodTipoVehiculo
	Inner Join dbo.Tipos As TCmb On TCmb.TIPOS_Codigo = Vehic.TIPOS_CodTipoCombustible
	Left Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = Vehic.ENTID_CodigoTransportista
	Left Join Transportes.TRAN_VehiculosRanflas As Relac On Relac.VEHIC_Id = Vehic.VEHIC_Id And Relac.VEHRN_Estado = 'A'
	Left Join Transportes.TRAN_Ranflas As Ran On Ran.RANFL_Id = Relac.RANFL_Id 
	Left Join Transportes.TRAN_VehiculosConductores As VehCond On VehCond.VEHIC_Id = Vehic.VEHIC_Id
	And VehCond.VHCON_Estado = 'A'
	Left Join dbo.Entidades As Cond On Cond.ENTID_Codigo = VehCond.ENTID_Codigo 
WHERE   ISNULL(Vehic.VEHIC_Estado, '') <> 'X' 
	AND  ( Case @Campo When 0 Then Vehic.VEHIC_Placa 
					   When 1 Then RTrim(Vehic.VEHIC_Id)
					   Else Vehic.VEHIC_Placa End
		) Like '%' + @Cadena + '%' 
	AND  Vehic.PVENT_Id = @PVENT_Id

GO 
/***************************************************************************************************************************************/ 

