GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIA_GuiasPorConductorFecha]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIA_GuiasPorConductorFecha] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/11/2011
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIA_GuiasPorConductorFecha]
	@CONDU_Id VarChar(14)
	,@VEHIC_Id BigInt
	,@FecIni DateTime
	,@FecFin DateTime
	,@TRANS_Id VarChar(14) = Null
AS

Select Convert(Bit, 1) Generar
	, * 
From Logistica.DIST_GuiasRemision
where CONVERT(Date, GUIAR_FechaEmision) Between @FecIni And @FecFin
	And ENTID_CodigoTransportista = IsNull(@TRANS_Id, '20100241022')
	And ENTID_CodigoConductor = @CONDU_Id
	And VEHIC_Id = @VEHIC_Id 
	And Not GUIAR_Codigo In (Select IsNull(GUIAR_Codigo, '') From Logistica.DESP_GuiaRSalidas)
	And GUIAR_Estado <> 'X'
Order By ENTID_CodigoConductor



GO 
/***************************************************************************************************************************************/ 

