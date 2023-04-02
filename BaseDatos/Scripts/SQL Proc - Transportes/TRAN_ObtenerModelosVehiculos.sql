GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_ObtenerModelosVehiculos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_ObtenerModelosVehiculos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/01/2013
-- Descripcion         : Obtener todos los modelos de los vehiculos Ingresados
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_ObtenerModelosVehiculos]
	@PVENT_Id Id = Null
As

Select Mar.TIPOS_Descripcion + ' - ' + IsNull(VEHIC_Modelo, 'S/M') As VEHIC_Modelo, COUNT(*) As Contador
From Transportes.TRAN_Vehiculos As Veh
	Inner Join Tipos As Mar On Mar.TIPOS_Codigo = Veh.TIPOS_CodMarca
Group by VEHIC_Modelo
	,Mar.TIPOS_Descripcion


GO 
/***************************************************************************************************************************************/ 

