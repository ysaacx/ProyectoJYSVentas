GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VIAJESU_AnularViaje]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VIAJESU_AnularViaje] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VIAJESU_AnularViaje]
(
	 @VIAJE_Id BigInt
)
As
	Declare @Fecha DateTime
	Declare @FechaViaje DateTime

	Select @FechaViaje = VIAJE_FecCrea From Transportes.TRAN_Viajes
	Where VIAJE_Id = @VIAJE_Id 
	
	If Convert(Varchar, @Fecha, 112) = Convert(Varchar, @FechaViaje, 112)
	Begin 
		Print 'Igual'
		Update Transportes.TRAN_Viajes 
		Set VIAJE_Estado = 'X'
		Where VIAJE_Id = @VIAJE_Id
	End
	Else
	Begin
		Update Transportes.TRAN_Viajes 
		Set VIAJE_Anulado = 1
			,VIAJE_Estado = 'X'
			,VIAJE_FecAnulado = GETDATE()
		Where VIAJE_Id = @VIAJE_Id
		Print 'Diferente'
	End

GO 
/***************************************************************************************************************************************/ 

