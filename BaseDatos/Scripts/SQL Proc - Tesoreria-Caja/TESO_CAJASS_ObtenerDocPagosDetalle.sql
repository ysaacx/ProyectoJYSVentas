USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_CAJASS_ObtenerDocPagosDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_CAJASS_ObtenerDocPagosDetalle] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/11/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_CAJASS_ObtenerDocPagosDetalle]
(
	 @DPAGO_Id BigInt
)
As

Select 
	Caj.CAJA_Id
	,TDocv.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTRIM(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	--,Caj.CAJA_Glosa
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	--,TTran.TIPOS_Descripcion
	--,TDoc.TIPOS_Descripcion
	,Caj.CAJA_Importe
	,CDoc.CDEPO_Importe
	,Caj.CAJA_NroDocumento
	--,CDoc.CDEPO_Numero
	--,Caj.CAJA_Estado
From Tesoreria.TESO_Caja As Caj
	Inner Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	--Inner Join Tipos As TTran On TTran.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	--Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Left Join Tipos As TDocv On TDocv.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where CDoc.DPAGO_Id = @DPAGO_Id
	And Caj.CAJA_Estado <> 'X'



GO 
/***************************************************************************************************************************************/ 

