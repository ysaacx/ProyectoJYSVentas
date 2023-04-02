GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VEN_DOCVSS_ObtenerUltimaFecha]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VEN_DOCVSS_ObtenerUltimaFecha] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/11/2012
-- Descripcion         : Obtiene la ultima fecha 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VEN_DOCVSS_ObtenerUltimaFecha]
(
	 @TIPOS_CodTipoDocumento VarChar(6)
)
As

Select Top 1 DOCVE_FechaDocumento, DOCVE_Codigo, DOCVE_Serie, DOCVE_Numero, TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(date, Ven.DOCVE_FechaDocumento) = Convert(date,(Select Max(DOCVE_FechaDocumento) 
															  From Ventas.VENT_DocsVenta Where DOCVE_Estado <> 'X' And TIPOS_CodTipoDocumento = 'CPD01'))
	And DOCVE_Estado <> 'X'
	And TIPOS_CodTipoDocumento = @TIPOS_CodTipoDocumento
Order By DOCVE_Codigo Desc


GO 
/***************************************************************************************************************************************/ 

