GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIAR_UnRegActGuiaRemision]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIAR_UnRegActGuiaRemision] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Generador - 04/08/2013
-- Descripcion         : Procedimiento de Actualización de la tabla Guia_Remision
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIAR_UnRegActGuiaRemision]
(	@ID_Guia_Remision varchar(12)
	,@Hora Fecha = null
	,@Opcion Bit
	,@Usuario Usuario
)

AS


If @Opcion = 1 
Begin
	UPDATE Logistica.DIST_GuiasRemision
	SET 
		[GUIAR_HoraLlegada] = @Hora
	  , [GUIAR_UsrMod] = @Usuario
	  , [GUIAR_FecMod] = GetDate()
	WHERE
		GUIAR_Codigo = @ID_Guia_Remision
	 
	End
Else
Begin
	UPDATE Logistica.DIST_GuiasRemision
	SET 
		[GUIAR_HoraSalida] = @Hora
	  , [GUIAR_UsrMod] = @Usuario
	  , [GUIAR_FecMod] = GetDate()
	WHERE
		GUIAR_Codigo = @ID_Guia_Remision
	End



GO 
/***************************************************************************************************************************************/ 

