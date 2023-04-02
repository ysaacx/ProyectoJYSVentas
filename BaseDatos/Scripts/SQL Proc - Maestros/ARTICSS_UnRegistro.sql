USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_UnRegistro]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_UnRegistro] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_UnRegistro]
(
	  @ARTIC_Codigo CodArticulo
	 ,@ZONAS_Codigo CodigoZona
)
As
Select
	IsNull(Pre.PRECI_Precio, 0.00) As PRECI_Precio
	,IsNull(Pre.TIPOS_CodTipoMoneda, 'MND1') As TIPOS_CodTipoMoneda
	,IsNull(Pre.PRECI_TipoCambio, 0.00) As PRECI_TipoCambio
	,Art.*
From Articulos As Art
	Left Join Precios As Pre On Pre.ARTIC_Codigo = Art.ARTIC_Codigo
Where Pre.ZONAS_Codigo = @ZONAS_Codigo
	And Art.ARTIC_Codigo = @ARTIC_Codigo


GO 
/***************************************************************************************************************************************/ 

