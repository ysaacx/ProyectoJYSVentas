GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_GuiasXDocumentoOrden]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_GuiasXDocumentoOrden] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/08/2013
-- Descripcion         : Obtener la Guia de remision por documento de venta
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_GuiasXDocumentoOrden]
(	
	 @ORDEN_Codigo VarChar(14)	
	 ,@PVENT_Id BigInt
)
As

Select Alma.ALMAC_Descripcion As ALMAC_Origen
	, PVenD.PVENT_Descripcion As PVENT_Destino
	, PVenO.PVENT_Descripcion As PVENT_Origen
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	, TMot.TIPOS_Descripcion As TIPOS_MotivoTraslado
	,Guia.DOCVE_Codigo
	,TFDoc.TIPOS_DescCorta
	,TFDoc.TIPOS_DescCorta + ' ' + IsNull(ord.ORDEN_Serie, Right(LEFT(Guia.ORDEN_Codigo, 5), 3)) + '-' + RIGHT('0000000' + Rtrim(IsNull(Ord.ORDEN_Numero, Right(Guia.DOCVE_Codigo, 7))), 7) As DocVenta
	,GETDATE() As FechaImpresion
	,Guia.GUIAR_Serie
	,Guia.GUIAR_Numero
	,Guia.ENTID_CodigoCliente
	,Guia.ENTID_CodigoConductor
	,Guia.ENTID_CodigoTransportista
	,Guia.GUIAR_DireccOrigen
	,Guia.GUIAR_DireccDestino
	--,Guia.GUIAR_Descripcioncliente
	,Guia.GUIAR_DescripcionConductor
	,Guia.GUIAR_LicenciaConductor
	,Guia.GUIAR_DescripcionTransportista
	,Guia.GUIAR_DescripcionVehiculo
	,Guia.GUIAR_CertificadoVehiculo
	,Guia.GUIAR_FechaEmision
	,Guia.GUIAR_FechaTraslado	
	,Guia.TIPOS_CodTipoDocumento
	,Guia.GUIAR_Estado
	,Guia.GUIAR_Codigo
	,Guia.GUIAR_TotalPeso
	,Us.ENTID_CodUsuario
From Logistica.DIST_GuiasRemision As Guia 
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Guia.ALMAC_IdOrigen
	Left Join dbo.PuntoVenta As PVenD On PVenD.PVENT_Id = Guia.PVENT_IdDestino
	Left Join dbo.PuntoVenta As PVenO On PVenO.PVENT_Id = Guia.PVENT_IdOrigen
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMot On TMot.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado 
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = ENTID_CodigoCliente
	Left Join Logistica.DIST_Ordenes As Ord On Ord.ORDEN_Codigo = Guia.ORDEN_Codigo
	Left Join Tipos As TFDoc On TFDoc.TIPOS_Codigo = IsNull(Ord.TIPOS_CodTipoOrden, 'CPD' + LEFT(Guia.ORDEN_Codigo, 2))
	Left Join Entidades As Us On Us.ENTID_Codigo = Guia.GUIAR_UsrCrea
WHERE Guia.PVENT_Id = @PVENT_Id
	And Guia.ORDEN_Codigo = @ORDEN_Codigo
	
--Select * From Logistica.DIST_GuiasRemision where DOCVE_Codigo = @DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

