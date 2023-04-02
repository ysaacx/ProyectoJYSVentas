GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VIAJSS_SueldoConductor]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VIAJSS_SueldoConductor] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VIAJSS_SueldoConductor]
(
	 @FecIni As DateTime
	,@FecFin As DateTime
	--,@ENTID_Codigo VarChar(14) = Null
)
As

Select Via.VIAJE_Id  
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,IsNull(Via.VIAJE_PagoConductor, 0) As VIAJE_PagoConductor
	,IsNull(Via.VIAJE_SaldoConductor, 0) As VIAJE_SaldoConductor
	,IsNull(Via.VIAJE_PagoConductor, 0) - IsNull(Via.VIAJE_SaldoConductor, 0) As Pendiente
	,Via.VIAJE_FecSalida
	,Via.VIAJE_FecLlegada
	,Via.VIAJE_Descripcion
	--,Via.* 
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = VCond.ENTID_Codigo
	Inner join Conductores As Cond On Cond.ENTID_Codigo = Ent.ENTID_Codigo
Where Convert(Date, VIAJE_FecLlegada) Between @FecIni And  @FecFin
	And Not Ent.ENTID_NroDocumento = '29511796'
	And Via.VIAJE_IdxConductor > 0
Order By ENTID_RazonSocial, Via.VIAJE_IdxConductor
--Where 



GO 
/***************************************************************************************************************************************/ 

