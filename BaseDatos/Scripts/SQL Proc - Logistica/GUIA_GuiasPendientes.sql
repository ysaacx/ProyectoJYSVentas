GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIA_GuiasPendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIA_GuiasPendientes] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 03/08/2013
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIA_GuiasPendientes]
	@FecIni DateTime
	,@FecFin DateTime
	,@TRANS_Id VarChar(14) = Null
AS

select GUIAR_FechaEmision, ENTID_CodigoConductor, GUIAR_DescripcionConductor 
	,Sum(GUIAR_TotalPeso) As Peso
from Logistica.DIST_GuiasRemision
where Convert(Date, GUIAR_FechaEmision) Between @FecIni And @FecFin
	And ENTID_CodigoTransportista = IsNull(@TRANS_Id, 1)
	And GUIAR_Estado <> 'X'
Group By GUIAR_DescripcionConductor, ENTID_CodigoConductor, GUIAR_FechaEmision





GO 
/***************************************************************************************************************************************/ 

