GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIASU_ActualizarGuiaRSalidas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIASU_ActualizarGuiaRSalidas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/12/2011
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIASU_ActualizarGuiaRSalidas]
	@SALID_Id Integer
	,@VEHIC_Id BigInt
	,@GUISA_Numero SmallInt
	,@GUISA_HoraSalida DateTime
	,@GUISA_HoraLlegada DateTime
	,@Usuario VarChar(20)
AS


Update Logistica.DESP_GuiaRSalidas
Set GUISA_UsrMod = @Usuario
	,GUISA_FecMod = GetDate()
	,GUISA_HoraSalida = @GUISA_HoraSalida
	,GUISA_HoraLlegada = @GUISA_HoraLlegada
Where GUIAR_Codigo Is Null
	And SALID_Id = @SALID_Id
	And VEHIC_Id = @VEHIC_Id
	And GUISA_Numero = @GUISA_Numero
	



GO 
/***************************************************************************************************************************************/ 

