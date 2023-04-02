GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCSS_TodosConSaldo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCSS_TodosConSaldo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 31/01/2012
-- Descripcion         : Obtener los saldos de los documentos de ventas
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCSS_TodosConSaldo]
	@ENTID_Codigo VarChar(12)
AS

Select Ven.ENTID_CodigoCliente
	,Vend.ENTID_RazonSocial As ENTID_Vendedor
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TPag.TIPOS_DescCorta As TIPOS_TipoPago
	,TCon.TIPOS_DescCorta As TIPOS_CondicionPago
	,Us.ENTID_RazonSocial As Usuario
	,(IsNull((Select sum(IsNull(CAJA_Importe, 0)) From Tesoreria.TESO_Caja 
			Where ENTID_Codigo = Ven.ENTID_CodigoCliente 
				And CAJA_NroDocumento = DOCVE_Codigo
		), 0)
	) As DOCVE_TotalPagado
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,Ven.DOCVE_TotalPagar
	,Ven.DOCVE_TipoCambio
	,Ven.DOCVE_TipoCambioSunat
	,ven.DOCVE_Estado
	,Ven.DOCVE_FechaDocumento
	,Ven.DOCVE_Codigo
	,Ven.TIPOS_CodTipoMoneda
	--,Ven.*
From Ventas.VENT_DocsVenta As Ven 
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join dbo.Tipos As TPag On TPag.TIPOS_Codigo = Ven.TIPOS_CodTipoPago
	Left Join dbo.Tipos As TCon On TCon.TIPOS_Codigo = Ven.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ven.DOCVE_UsrCrea 
WHERE   Ven.ENTID_CodigoCliente = @ENTID_Codigo
	AND  ISNULL(Ven.DOCVE_Estado, '') <> 'X'
	And IsNull(Ven.DOCVE_TotalPagar - IsNull(
	(
		(Select sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where ENTID_Codigo = Ven.ENTID_CodigoCliente 
				And CAJA_NroDocumento = DOCVE_Codigo
		)
	), 0), 0) > 0
Order By Ven.DOCVE_FechaDocumento


GO 
/***************************************************************************************************************************************/ 

