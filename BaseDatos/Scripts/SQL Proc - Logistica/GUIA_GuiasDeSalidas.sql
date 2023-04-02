GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIA_GuiasDeSalidas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIA_GuiasDeSalidas] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 03/08/2013
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIA_GuiasDeSalidas]
	@VEHIC_Id BigInt
	,@Fecha DateTime
	,@TRANS_Id VarChar(14) = Null
AS

select Convert(Bit, 1) Generar, * from Logistica.DIST_GuiasRemision
where convert(date, GUIAR_FechaEmision) = Convert(Date, @Fecha) 
	And ENTID_CodigoTransportista = IsNull(@TRANS_Id, '20100241022')
	And VEHIC_Id = @VEHIC_Id
	And GUIAR_Codigo In (Select IsNull(GUIAR_Codigo, '') From Logistica.DESP_GuiaRSalidas)
Order By ENTID_CodigoConductor




GO 
/***************************************************************************************************************************************/ 

