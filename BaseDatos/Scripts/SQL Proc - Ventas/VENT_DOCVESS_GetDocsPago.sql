USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_GetDocsPago]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_GetDocsPago] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_GetDocsPago]
(
	 @DOCVE_Codigo CodDocVentaNew
)
As

Select 
	Pag.PVENT_Id
	,Pag.DPAGO_Fecha
	,Pag.DPAGO_Id
	,Pag.BANCO_Id
	,Ban.BANCO_Descripcion
	,Pag.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Pag.DPAGO_Numero
	,Pag.DPAGO_Importe
	,TDoc.TIPOS_DescCorta + ' ' + DVen.DOCVE_Serie + '-' + Right('0000000' + RTRIM(DVen.DOCVE_Numero), 7) As DocVenta
From Tesoreria.TESO_DocsPagos As Pag
	Inner Join Ventas.VENT_DocsVentaPagos As Ven On Ven.PVENT_Id = Pag.PVENT_Id And Ven.DPAGO_Id = Pag.DPAGO_Id And Ven.DVEPG_Estado <> 'X'
	Inner Join Ventas.VENT_DocsVenta As DVen On DVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = DVen.TIPOS_CodTipoDocumento
	Inner Join Bancos As Ban On Ban.BANCO_Id = Pag.BANCO_Id
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Pag.TIPOS_CodTipoMoneda
Where Ven.DOCVE_Codigo = @DOCVE_Codigo
	


GO 
/***************************************************************************************************************************************/ 

