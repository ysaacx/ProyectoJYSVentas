GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_GUIASS_TodosGuiasRemisionDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_GUIASS_TodosGuiasRemisionDetalle] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/11/2012
-- Descripcion         : Para un reporte de todas las guias de remision que han recogido Cemento
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_GUIASS_TodosGuiasRemisionDetalle]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As


Select TDComp.TIPOS_DescCorta + ' ' + Comp.DOCCO_Serie + '-' + Right('0000000' + RTRIM(Comp.DOCCO_Numero), 7) As Documento
	,(Select SUM(DOCCD_Cantidad) From Logistica.ABAS_DocsCompraDetalle As CDet Where CDet.DOCCO_Codigo = Comp.DOCCO_Codigo) As TotalFactura
	,Guia.GTRAN_NroComprobantePago
	,Comp.DOCCO_FechaDocumento
	
	,Guia.GTRAN_NroPedido
	,Guia.TIPOS_CodTipoDocumento
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	
	,GTRAN_Codigo
	,Guia.GTRAN_Fecha
		
	,Guia.GTRAN_RucProveedor
	,Ori.ENTID_RazonSocial As ENTID_RazonSocialProveedor
	,Guia.GTRAN_DireccionProveedor
	
	,Guia.ENTID_CodigoDestinatario
	,Dest.ENTID_RazonSocial As ENTID_RazonSocialDestinatario
	,Guia.GTRAN_DireccionDestinatario
	
	,Guia.ENTID_CodigoTransportista
	,Trans.ENTID_RazonSocial As ENTID_RazonSocialTransportista
	,Guia.ENTID_CodigoConductor
	,Cond.ENTID_RazonSocial As ENTID_RazonSocialConductor
	,Guia.GTRAN_DescripcionVehiculo
	,IsNull(Guia.GTRAN_CertificadosVehiculo
		,(Select Vehi.VEHIC_Certificado From Transportes.TRAN_Vehiculos As Vehi Where Vehi.VEHIC_Id = Guia.VEHIC_Id)
	 ) As GTRAN_CertificadosVehiculo
	,GTRAN_PesoTotal
	,(Select SUM(Det.GTDET_Cantidad) From Transportes.TRAN_GuiasTransportistaDetalles As Det Where Det.GTRAN_Codigo = Guia.GTRAN_Codigo) As Cantidad
	--,Guia.ENTID_Di
	--,Guia.*
From Transportes.TRAN_GuiasTransportista As Guia
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join Entidades As Dest ON Dest.ENTID_Codigo = Guia.ENTID_CodigoDestinatario
	Inner Join Entidades As Trans ON Trans.ENTID_Codigo = Guia.ENTID_CodigoTransportista
	Inner Join Entidades As Cond ON Cond.ENTID_Codigo = Guia.ENTID_CodigoConductor
	Inner Join Logistica.ABAS_DocsCompra As Comp On Comp.DOCCO_Codigo = Guia.GTRAN_NroComprobantePago
	Inner Join Tipos As TDComp On TDComp.TIPOS_Codigo = Comp.TIPOS_CodTipoDocumento
	Left Join Entidades As Ori ON Ori.ENTID_Codigo = Guia.GTRAN_RucProveedor
Where Guia.GTRAN_Fecha Between @FecIni And @FecFin
Order By Guia.GTRAN_NroComprobantePago


GO 
/***************************************************************************************************************************************/ 

