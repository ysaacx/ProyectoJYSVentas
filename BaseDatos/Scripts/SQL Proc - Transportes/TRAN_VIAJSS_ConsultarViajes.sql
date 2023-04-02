GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VIAJSS_ConsultarViajes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VIAJSS_ConsultarViajes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : @Opcion = 1 -> Descripcion // @Opcion = 2 -> Viaje // @Opcion = 3 -> Placa
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VIAJSS_ConsultarViajes]
(
	 @Opcion SmallInt
	,@FecIni DateTime
	,@FecFin DateTime
	,@Cadena VarChar(80)
)
As

Select VCond.ENTID_Codigo As ENTID_Codigo
	, Vehi.VEHIC_Placa As VEHIC_Placa
	, Vehi.VEHIC_Placa As TIPOS_Marca
	, Vehi.VEHIC_Certificado As VEHIC_Certificado
	, Cond.ENTID_RazonSocial As ENTID_Nombres
	, VRan.VEHRN_FecAsignacion As VEHRN_FecAsignacion
	, Ran.RANFL_Placa As RANFL_Placa
	, m_tran_viajes.* 
From Transportes.TRAN_Viajes As m_tran_viajes 
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = m_tran_viajes.VHCON_Id
	Inner Join Transportes.TRAN_Vehiculos As Vehi On Vehi.VEHIC_Id = VCond.VEHIC_Id
	Inner Join dbo.Entidades As Cond On Cond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Transportes.TRAN_VehiculosRanflas As VRan On VRan.VEHIC_Id = VCond.VEHIC_Id
	Inner Join Transportes.TRAN_Ranflas As Ran On Ran.RANFL_Id = VRan.RANFL_Id 
WHERE   Convert(Date, m_TRAN_Viajes.VIAJE_FecLlegada) Between @FecIni AND @FecFin
	AND (Case @Opcion When 1 Then m_TRAN_Viajes.VIAJE_Descripcion 
		 When 2 Then Vehi.VEHIC_Placa
		 Else RTrim(m_TRAN_Viajes.VIAJE_Id) End) Like '%' + @Cadena + '%' 
	--AND  ISNULL(VRan.VEHRN_Estado, '') = 'A'


GO 
/***************************************************************************************************************************************/ 

