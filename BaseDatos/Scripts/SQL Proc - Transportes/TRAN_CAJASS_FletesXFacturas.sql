USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_FletesXFacturas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_FletesXFacturas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/07/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_FletesXFacturas]
(
	@DOCVE_Codigo VarChar(13)
)
As

--Declare @DOCVE_Codigo VarChar(12)
--Set @DOCVE_Codigo = 'BI0010000015'

Select n_tran_rutas.RUTAS_Nombre As RUTAS_Nombre
	, n_entidades.ENTID_RazonSocial As ENTID_RazonSocial
	, n_entidades.ENTID_NroDocumento As ENTID_NroDocumento
	, n_tran_cotizaciones.COTIZ_Carga As COTIZ_Carga
	,Fle.FLETE_MontoPorTM + Fle.FLETE_ImporteIgv As FLETE_MontoPorTM
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + ISNULL(Veh.VEHIC_Placa, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As VIAJE_Descripcion
	--,Via.VIAJE_Descripcion
	,Fle.* 
From Transportes.TRAN_Fletes As Fle
	Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id And VVen.DOCVE_Codigo = @DOCVE_Codigo
		And VVen.VIAVE_Estado <> 'X'
	Left Join Transportes.TRAN_Rutas As n_tran_rutas On n_tran_rutas.RUTAS_Id = Fle.RUTAS_Id
	Inner Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_Cotizaciones As n_tran_cotizaciones On n_tran_cotizaciones.COTIZ_Codigo = Fle.COTIZ_Codigo 
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
	Left Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
	

GO 
/***************************************************************************************************************************************/ 

