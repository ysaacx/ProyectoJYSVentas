GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_GuiasTraslado]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_GuiasTraslado] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_GuiasTraslado]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

Select Guia.GUIAR_FechaEmision
	,Guia.GUIAR_FechaTraslado
	,TDoc.TIPOS_DescCorta + ' ' + Guia.GUIAR_Serie  + '-' + Right('0000000' + RTrim(Guia.GUIAR_Numero), 7) As Documento
	,Ori.ALMAC_Descripcion As ALMA_Origen
	,Dest.ALMAC_Descripcion As ALMA_Destino
	,Guia.GUIAR_Estado
From Logistica.DIST_GuiasRemision As Guia
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join Almacenes As Ori On Ori.ALMAC_Id = Guia.ALMAC_IdOrigen
	Inner Join Almacenes As Dest On Dest.ALMAC_Id = Guia.ALMAC_IdDestino
Where TIPOS_CodMotivoTraslado = 'MTG06'
Order By GUIAR_FechaEmision



GO 
/***************************************************************************************************************************************/ 

