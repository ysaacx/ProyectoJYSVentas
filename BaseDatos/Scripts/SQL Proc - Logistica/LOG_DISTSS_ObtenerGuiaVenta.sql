--USE BDInkasFerro_Almudena
--USE BDInkaPeru
--USE BDInkasFerro_Parusttacca
--USE BDInkaPeru
--USE BDInkaPeru
USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_ObtenerGuiaVenta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_ObtenerGuiaVenta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/11/2012
-- Descripcion         : Obtener la Guia de remision para su impresion
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_ObtenerGuiaVenta]
(
	 @GUIAR_Codigo VarChar(14)
)
As

select Guia.GUIAR_Codigo
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + RIGHT('0000000' + Rtrim(Ven.DOCVE_Numero), 7),
	 TDoc2.TIPOS_DescCorta + ' ' + Left(Right(Guia.DOCVE_Codigo, 10), 3) + '-' + Right(Guia.DOCVE_Codigo, 7))
	 As DocVenta
	,Convert(Integer, Right(Guia.TIPOS_CodMotivoTraslado, 2)) As MotivoTraslado
    , MotivoTrasladoDesc = TMOT.TIPOS_Descripcion
	,GETDATE() As FechaImpresion
	,Guia.DOCVE_Codigo
	,Guia.GUIAR_Serie
	,Guia.GUIAR_Numero
	,Guia.ENTID_CodigoCliente
	,Guia.ENTID_CodigoConductor
	,Guia.ENTID_CodigoTransportista
	,Guia.GUIAR_DireccOrigen
	,Guia.GUIAR_DireccDestino
	,Guia.GUIAR_Descripcioncliente
	,Guia.GUIAR_DescripcionConductor
	,Guia.GUIAR_LicenciaConductor
	,Guia.GUIAR_DescripcionTransportista
	,Guia.GUIAR_DescripcionVehiculo
	,Guia.GUIAR_CertificadoVehiculo
	,Guia.GUIAR_FechaEmision
	,Guia.GUIAR_FechaTraslado	
	,Guia.TIPOS_CodTipoDocumento
	,Guia.GUIAR_TotalPeso
	,Us.ENTID_CodUsuario
From Logistica.DIST_GuiasRemision As Guia
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Guia.ENTID_CodigoCliente
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TDoc2 On TDoc2.TIPOS_Codigo = ('CPD' + LEFT(Guia.DOCVE_Codigo, 2))
	Inner Join Entidades As Us On Us.ENTID_Codigo = Guia.GUIAR_UsrCrea
    LEFT JOIN dbo.Tipos TMOT ON TMOT.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado
Where Guia.GUIAR_Codigo = @GUIAR_Codigo

Select Art.ARTIC_Descripcion
    , Art.ARTIC_Codigo
	,Und.TIPOS_DescCorta As TIPOS_UnidadMedidaCorta
	,Und.TIPOS_Descripcion As TIPOS_UnidadMedida
	,GDet.GUIRD_Item
	,GDet.GUIRD_ItemDocumento
	,GDet.GUIRD_PesoUnitario
	,GDet.GUIRD_Cantidad
    ,GUIRD_PesoTotal = GDet.GUIRD_PesoUnitario  * GDet.GUIRD_Cantidad 
From Logistica.DIST_GuiasRemisionDetalle As GDet
	Inner Join Articulos As Art On Art.ARTIC_Codigo = GDet.ARTIC_Codigo
	Inner Join Tipos As Und On Und.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where GDet.GUIAR_Codigo = @GUIAR_Codigo


GO 
/***************************************************************************************************************************************/ 


--EXEC LOG_DISTSS_ObtenerGuiaVenta '090030000001'

--SELECT * FROM Logistica.DIST_GuiasRemision


--exec LOG_DISTSS_ObtenerGuiaVenta @GUIAR_Codigo=N'0900010000001'
exec LOG_DISTSS_ObtenerGuiaVenta @GUIAR_Codigo=N'090010000001'
