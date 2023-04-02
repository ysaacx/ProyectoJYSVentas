GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPOSS_ViajesFletes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPOSS_ViajesFletes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPOSS_ViajesFletes]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As

Select Via.VIAJE_Id
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + Cond.CONDU_Sigla As Documento
	,Via.VIAJE_Descripcion
	,Via.VIAJE_FecSalida As FLETE_FecSalida
	,Via.VIAJE_FecLlegada As FLETE_FecLlegada
	,Fle.FLETE_Id
	,Fle.FLETE_Glosa
	,Fle.FLETE_MontoPorTM
	,Fle.FLETE_ImporteIgv
	,Fle.FLETE_PesoEnTM
	,Fle.FLETE_TotIngreso	
	,R1.RUTAS_Nombre
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		Where CAJA_NroDocumento = IsNull(Fle.FLETE_Id, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
			And Convert(Date, CAJA_Fecha) < @FecFin
	 ), 0)
	 As Pago
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_Fletes As Fle On Fle.VIAJE_Id = Via.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_Rutas As R1 On R1.RUTAS_Id = Fle.RUTAS_Id
Where Via.VIAJE_FecLlegada Between @FecIni And @FecFin
Order By Via.VIAJE_Id, Fle.FLETE_Id


GO 
/***************************************************************************************************************************************/ 

