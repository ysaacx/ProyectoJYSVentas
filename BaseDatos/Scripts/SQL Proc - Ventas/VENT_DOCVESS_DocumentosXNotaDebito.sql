USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_DocumentosXNotaDebito]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_DocumentosXNotaDebito] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/04/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_DocumentosXNotaDebito]
(
	@DOCVE_Codigo VarChar(13)
)

AS

Select 
	Doc.DOCVE_Codigo
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Doc.DOCVE_Numero
	,Doc.DOCVE_Serie
	,Doc.DOCVE_FechaDocumento
	,Doc.ENTID_CodigoCliente
	,Doc.DOCVE_DescripcionCliente
	,Doc.DOCVE_TotalPagar
From Ventas.VENT_DocsVenta As Doc
	Inner Join Ventas.VENT_DocsRelacion As Rel On Rel.DOCVE_CodReferencia = Doc.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
Where Rel.DOCVE_Codigo = @DOCVE_Codigo



GO 
/***************************************************************************************************************************************/ 

