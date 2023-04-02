GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VIAJESS_ObtenerViajes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VIAJESS_ObtenerViajes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VIAJESS_ObtenerViajes]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Cadenas VarChar(100)
	,@Campo SmallInt
	,@CampoFecha Bit
	,@Liquidados Bit
	,@PVENT_Id Id
)
As
Select Via.* , VCond.ENTID_Codigo As ENTID_Codigo
	,Vehi.VEHIC_Placa As VEHIC_Placa
	,Vehi.VEHIC_Placa As TIPOS_Marca
	,Vehi.VEHIC_Certificado As VEHIC_Certificado
	,Cond.ENTID_RazonSocial As ENTID_Nombres
	,VRan.VEHRN_FecAsignacion As VEHRN_FecAsignacion
	,Ran.RANFL_Placa As RANFL_Placa
	,Usu.ENTID_RazonSocial As Usuario
Into #Viajes
From Transportes.TRAN_Viajes As Via 
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Transportes.TRAN_Vehiculos As Vehi On Vehi.VEHIC_Id = VCond.VEHIC_Id
	Left Join dbo.Entidades As Cond On Cond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Transportes.TRAN_VehiculosRanflas As VRan On VRan.VEHRN_Id = Via.VEHRN_Id 
	Left Join Transportes.TRAN_Ranflas As Ran On Ran.RANFL_Id = VRan.RANFL_Id
	Left Join dbo.Entidades As Usu On Usu.ENTID_NroDocumento = Via.VIAJE_UsrCrea 
WHERE   --ISNULL(Via.VIAJE_Estado, '') <> 'X' --In  (Case @Liquidados When 1 Then ('A', 'L') Else ('X') End)
	ISNULL(CONVERT(VARCHAR(100), Via.VIAJE_Descripcion), '') Like '%%' 
	AND Case @Campo 
			When 0 Then RTrim(Via.VIAJE_Id)
			When 1 Then Via.VIAJE_Descripcion
			When 2 Then VEHIC_Placa
			Else RTrim(Via.VIAJE_Id)
		End Like '%' + @Cadenas + '%'
	And Via.PVENT_Id = @PVENT_Id
Order By Via.viaje_id

If @Campo = 0
Begin
	If @Liquidados = 0
	Begin 
		Select * From #Viajes Where VIAJE_Estado In ('A')
	End 
	Else
	Begin
		Select * From #Viajes --Where VIAJE_Estado In ('X', 'L')
	End
	Print 'Exito'
End
Else
Begin
	If @Liquidados = 0
	Begin 
		Select * From #Viajes 
		Where VIAJE_Estado In ('A')
			AND Case @CampoFecha 
				When 0 Then VIAJE_FecLlegada
				When 1 Then VIAJE_FecSalida
				Else VIAJE_FecLlegada
			End Between @FecIni AND @FecFin
	End 
	Else
	Begin
		Select * From #Viajes --Where VIAJE_Estado In ('X', 'L')
			Where Case @CampoFecha 
				When 0 Then VIAJE_FecLlegada
				When 1 Then VIAJE_FecSalida
				Else VIAJE_FecLlegada
			End Between @FecIni AND @FecFin
	End
End


GO 
/***************************************************************************************************************************************/ 

