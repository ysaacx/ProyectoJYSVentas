GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_ObtenerGuiaTransf]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_ObtenerGuiaTransf] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/01/2013
-- Descripcion         : Obtener la Guia de remision para su impresion
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_ObtenerGuiaTransf]
(
	 @GUIAR_Codigo VarChar(14)
)
As

select Guia.GUIAR_Codigo
	,Convert(Integer, Right(Guia.TIPOS_CodMotivoTraslado, 2)) As MotivoTraslado
	,GETDATE() As FechaImpresion
	,Guia.*
	,Us.ENTID_CodUsuario
From Logistica.DIST_GuiasRemision As Guia
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Guia.ENTID_CodigoCliente
	Inner Join Entidades As Us On Us.ENTID_Codigo = Guia.GUIAR_UsrCrea
Where Guia.GUIAR_Codigo = @GUIAR_Codigo

Select Art.ARTIC_Descripcion
	,Art.ARTIC_Codigo
	,Und.TIPOS_DescCorta As TIPOS_UnidadMedidaCorta
	,Und.TIPOS_Descripcion As TIPOS_UnidadMedida
	,GDet.GUIRD_Item
	,GDet.GUIRD_ItemDocumento
	,GDet.GUIRD_PesoUnitario
	,GDet.GUIRD_Cantidad
	,Art.TIPOS_CodUnidadMedida
From Logistica.DIST_GuiasRemisionDetalle As GDet
	Inner Join Articulos As Art On Art.ARTIC_Codigo = GDet.ARTIC_Codigo
	Inner Join Tipos As Und On Und.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where GDet.GUIAR_Codigo = @GUIAR_Codigo


GO 
/***************************************************************************************************************************************/ 

