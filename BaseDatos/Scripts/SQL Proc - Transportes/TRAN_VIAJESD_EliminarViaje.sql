GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VIAJESD_EliminarViaje]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VIAJESD_EliminarViaje] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VIAJESD_EliminarViaje]
(
	 @VIAJE_Id BigInt
)
As

BEGIN TRAN x

delete from Transportes.TRAN_ViajesVentas Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_CotizacionesDetalle
	Where COTIZ_Codigo In (Select COTIZ_Codigo from Transportes.TRAN_Cotizaciones Where FLETE_Id In (Select FLETE_Id From Transportes.TRAN_Fletes Where VIAJE_Id = @VIAJE_Id))
delete from Transportes.TRAN_Cotizaciones Where FLETE_Id In (Select FLETE_Id From Transportes.TRAN_Fletes Where VIAJE_Id = @VIAJE_Id)
delete from Transportes.TRAN_Fletes Where VIAJE_Id = @VIAJE_Id
delete from Tesoreria.TESO_Caja Where CAJA_NroDocumento In (Select RECIB_Codigo from Transportes.TRAN_Recibos  Where VIAJE_Id = @VIAJE_Id)
delete from Transportes.TRAN_Recibos Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_ViajesIngresos  Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_ViajesVehiculos Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_ViajesNeumaticos Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_CombustibleConsumo Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_ViajesGastos Where VIAJE_Id = @VIAJE_Id
delete from Transportes.TRAN_Viajes Where VIAJE_Id = @VIAJE_Id


COMMIT TRAN x


GO 
/***************************************************************************************************************************************/ 

