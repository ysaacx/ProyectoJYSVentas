GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_COMCOSS_Consumos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_COMCOSS_Consumos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/06/2012
-- Descripcion         : Consumo de Combustible
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_COMCOSS_Consumos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Cadena VarChar(50)
	,@Opcion SmallInt
)
As

Select TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,EPro.ENTID_RazonSocial
	,Veh.VEHIC_Placa
	,IsNull(ECon.ENTID_RazonSocial, ECond.ENTID_RazonSocial) As Conductor
	,IsNull(ECon.ENTID_Codigo, ECond.ENTID_Codigo) As ENTID_CodigoConductor
	,IsNull(Con.COMCO_FechaConsumo, COMCO_Fecha) As COMCO_FechaConsumo
	,Con.* 
From Transportes.TRAN_CombustibleConsumo As Con
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Con.TIPOS_CodTipoMoneda
	Inner Join Entidades As EPro On EPro.ENTID_Codigo = Con.ENTID_CodigoProveedor
	Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = Con.VEHIC_Id
	Left Join Entidades As ECon On ECon.ENTID_Codigo = Con.ENTID_CodigoConductor
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Con.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Convert(Date, IsNull(Con.COMCO_FechaConsumo, COMCO_Fecha)) Between @FecIni And @FecFin
	And (Case @Opcion When 0 Then ISNULL(ECon.ENTID_RazonSocial, ECond.ENTID_RazonSocial)
					  When 1 Then Veh.VEHIC_Placa
					  When 2 Then EPro.ENTID_RazonSocial
					  End) Like '%' + @Cadena + '%'
	--And VEHIC_Estado <> 'X'
	And Con.COMCO_Estado <> 'X'
Order By COMCO_Fecha Desc


GO 
/***************************************************************************************************************************************/ 

