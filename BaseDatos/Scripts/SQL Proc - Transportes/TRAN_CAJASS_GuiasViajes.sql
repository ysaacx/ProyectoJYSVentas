GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_GuiasViajes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_GuiasViajes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_GuiasViajes]
(
	@VIAJE_Id Id
)

AS

 SELECT TDoc.TIPOS_Descripcion As TIPOS_CodTipoDocumento_Text
	,EntFle.ENTID_RazonSocial As FLETE_Id_Text
	,(Case GR.VEGRE_Condicion When 'I' Then 'Ida' Else 'Vuelta' End) As VEGRE_Condicion_Text	
	,Ent.ENTID_RazonSocial	
	,GR.* 
 FROM Transportes.TRAN_ViajesGuiasRemision As GR
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = GR.TIPOS_CodTipoDocumento
	Left Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = GR.FLETE_Id
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Gr.ENTID_Codigo
	Left Join Entidades As EntFle On EntFle.ENTID_Codigo = Fle.ENTID_Codigo
 WHERE 
	GR.VIAJE_Id = @VIAJE_Id


GO 
/***************************************************************************************************************************************/ 

