USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_GUIASS_RepRecCemento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_GUIASS_RepRecCemento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 08/11/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_GUIASS_RepRecCemento]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Opcion SmallInt
)
As

SELECT GTRAN_Codigo = RTRIM(DINGC.INGCO_Id) --DOCCO.DOCCO_Codigo
	, GTRAN_Serie = INGCO.INGCO_Serie --DOCCO.DOCCO_Serie
	, GTRAN_Numero = INGCO.INGCO_Numero --DOCCO.DOCCO_Numero
	, TDoc.TIPOS_DescCorta + ' ' + DOCCO.DOCCO_Serie + '-' + Right('0000000' + RTrim(DOCCO.DOCCO_Numero), 7) As DocCompra
	--, CanComprada = (Select Sum(GDet.DOCCD_Cantidad) From Logistica.ABAS_DocsCompraDetalle As GDet Where DOCCO_Codigo = DOCCO.DOCCO_Codigo)
	, CanComprada = Sum(DDOCO.DOCCD_Cantidad) 
	, DOCCO_FechaDocumento = DOCCO.DOCCO_FechaDocumento
	, TDocC.TIPOS_DescCorta As TIPOS_TipoDocumentoCorta
	--,TDoc.TIPOS_DescCorta + ' ' + Guia.GTRAN_Serie + '-' + Right('0000000' + RTRIM(Guia.GTRAN_Numero), 7) As DocTraslado
	, GTRAN_Fecha = DOCCO.DOCCO_FechaDocumento
	--,GTRAN_NroComprobantePago
	--,Guia.GTRAN_NroPedido
	--,Guia.TIPOS_CodTipoDocumento
	, TDoc.TIPOS_Descripcion
	, GTRAN_RucProveedor = Ori.ENTID_NroDocumento
	, ISNULL(Ori.ENTID_RazonSocial, Ori.ENTID_RazonSocial) As ENTID_RazonSocialProveedor
	, GTRAN_DireccionProveedor = Ori.ENTID_Direccion
	, DINGC.INGCO_Id
	--,Guia.ENTID_CodigoDestinatario
	--,Dest.ENTID_RazonSocial As ENTID_RazonSocialDestinatario
	--,Guia.GTRAN_DireccionDestinatario
	
	--,Guia.ENTID_CodigoTransportista
	--,Trans.ENTID_RazonSocial As ENTID_RazonSocialTransportista
	--,Guia.ENTID_CodigoConductor
	--,Cond.ENTID_RazonSocial As ENTID_RazonSocialConductor
	--,Guia.GTRAN_DescripcionVehiculo
	--,IsNull(Guia.GTRAN_CertificadosVehiculo
	--	,(Select Vehi.VEHIC_Certificado From Transportes.TRAN_Vehiculos As Vehi Where Vehi.VEHIC_Id = Guia.VEHIC_Id)
	-- ) As GTRAN_CertificadosVehiculo
	----,Guia.ENTID_Di
	----,Guia.*
	--,(SELECT SUM(DINCG.INGCD_Cantidad) FROM Logistica.ABAS_IngresosCompra INGCO
	--   INNER JOIN Logistica.ABAS_IngresosCompraDetalle DINCG ON DINCG.ALMAC_Id = INGCO.ALMAC_Id AND DINCG.INGCO_Id = INGCO.INGCO_Id
	--   WHERE INGCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo)
		, SUM(DINGC.INGCD_Cantidad) AS Cantidad
	,GTRAN_PesoTotal = SUM(DINGC.INGCD_PesoUnitario * DINGC.INGCD_Cantidad)
	, ARTIC.ARTIC_Descripcion
 FROM Logistica.ABAS_DocsCompra As DOCCO ---On DOCCO.DOCCO_Codigo = Guia.GTRAN_NroComprobantePago
	INNER JOIN Tipos As TDoc On TDoc.TIPOS_Codigo = DOCCO.TIPOS_CodTipoDocumento
	INNER JOIN Logistica.ABAS_IngresosCompra INGCO ON INGCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo
	INNER JOIN Logistica.ABAS_IngresosCompraDetalle DINGC ON DINGC.ALMAC_Id = INGCO.ALMAC_Id AND DINGC.INGCO_Id = INGCO.INGCO_Id
	--Inner Join Entidades As Dest ON Dest.ENTID_Codigo = DOCCO.ENTID_CodigoDestinatario
	--Inner Join Entidades As Trans ON Trans.ENTID_Codigo = DOCCO.ENTID_CodigoTransportista
	--Inner Join Entidades As Cond ON Cond.ENTID_Codigo = DOCCO.ENTID_CodigoConductor
	INNER JOIN Logistica.ABAS_DocsCompraDetalle DDOCO ON DDOCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo 
	  AND DDOCO.ENTID_CodigoProveedor = DOCCO.ENTID_CodigoProveedor
	INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = DDOCO.ARTIC_Codigo AND ARTIC.ARTIC_Codigo = DINGC.ARTIC_Codigo
	Left Join Entidades As Ori ON Ori.ENTID_Codigo = DOCCO.ENTID_CodigoProveedor
	--Inner Join Logistica.ABAS_DocsCompra As DComp On DDOCCO.DOCCO_Codigo = Guia.GTRAN_NroComprobantePago
	Inner Join Tipos As TDocC On TDocC.TIPOS_Codigo = INGCO.TIPOS_CodTipoDocumento
Where Case @Opcion 
		When 0 Then CONVERT(DATE, DOCCO.DOCCO_FechaDocumento)
		When 1 Then CONVERT(DATE, DOCCO.DOCCO_FechaDocumento)
		Else DOCCO.DOCCO_FechaDocumento
	  End
	Between @FecIni And @FecFin
	And DOCCO.DOCCO_Estado <> 'X'
	--AND DOCCO.DOCCO_Codigo IN ('010010010002', '010010010001')
GROUP BY INGCO.INGCO_Id,  INGCO.INGCO_Serie, INGCO.INGCO_Numero, DOCCO.DOCCO_FechaDocumento, TDoc.TIPOS_DescCorta, DOCCO.DOCCO_FechaDocumento
	,TDoc.TIPOS_Descripcion, Ori.ENTID_NroDocumento, Ori.ENTID_RazonSocial, Ori.ENTID_Direccion
	, DINGC.INGCO_Id
	, DOCCO.DOCCO_Codigo, DOCCO.DOCCO_Serie, DOCCO.DOCCO_Numero
	, TDocC.TIPOS_DescCorta, ARTIC.ARTIC_Descripcion
HAVING SUM(DINGC.INGCD_Cantidad) <> Sum(DDOCO.DOCCD_Cantidad)  --(Select Sum(GDet.DOCCD_Cantidad) From Logistica.ABAS_DocsCompraDetalle As GDet Where DOCCO_Codigo = DOCCO.DOCCO_Codigo)
ORDER By  GTRAN_Serie, Ori.ENTID_NroDocumento

GO 
/***************************************************************************************************************************************/ 

--exec TRAN_GUIASS_RepRecCemento @FecIni='2017-01-01 00:00:00',@FecFin='2017-12-05 00:00:00',@Opcion=1
exec TRAN_GUIASS_RepRecCemento @FecIni='2017-01-07 00:00:00',@FecFin='2017-12-09 00:00:00',@Opcion=1


--SELECT * FROM LOGISTICA.ABAS_DocsCompra ORDER BY DOCCO_FecCrea DESC
