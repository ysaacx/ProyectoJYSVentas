GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_GUIASS_ObtenerGuias]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_GUIASS_ObtenerGuias] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_GUIASS_ObtenerGuias]
(
	  @ALMAC_IdDestino SmallInt = Null
	 ,@FecIni Datetime
	 ,@FecFin Datetime
	 ,@TIPOS_CodMotivoTraslado VarChar(6)
	 ,@OpcionFecha SmallInt
	 ,@Opcion SmallInt
	 ,@Cadena VarChar(50)
	 ,@Todos Bit
)
As

Select 
	Guia.GUIAR_Codigo
	,Guia.GUIAR_FechaEmision
	,Guia.GUIAR_FechaTraslado
	,Guia.PVENT_Id
	,Guia.ALMAC_IdDestino
	,Guia.ALMAC_IdOrigen
	,Guia.TIPOS_CodMotivoTraslado
	,Guia.GUIAR_DireccOrigen
	,Guia.GUIAR_DireccDestino
	,Guia.ENTID_CodigoCliente
	,Guia.GUIAR_Descripcioncliente
	,Ent.ENTID_RazonSocial
	,Guia.ENTID_CodigoTransportista
	,Guia.GUIAR_DescripcionTransportista
	,Guia.ENTID_CodigoConductor 
	,Guia.GUIAR_DescripcionConductor
	,Guia.GUIAR_LicenciaConductor
	,Guia.GUIAR_DescripcionConductor
	,Guia.GUIAR_DescripcionVehiculo
	,Guia.GUIAR_CertificadoVehiculo
	,Guia.GUIAR_TotalPeso
	,Guia.GUIAR_Serie
	,Guia.GUIAR_Numero
	,Guia.TIPOS_CodTipoDocumento
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMot.TIPOS_Descripcion As TIPOS_MotivoTraslado
	,Alma.ALMAC_Descripcion As ALMAC_Origen
	,PVenD.PVENT_Descripcion As PVENT_Destino
	,PVenO.PVENT_Descripcion As PVENT_Origen
From Logistica.DIST_GuiasRemision As Guia
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Guia.ENTID_CodigoCliente
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMot On TMot.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado 
	Left Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Guia.ALMAC_IdOrigen
	Left Join dbo.PuntoVenta As PVenD On PVenD.PVENT_Id = Guia.PVENT_IdDestino
	Left Join dbo.PuntoVenta As PVenO On PVenO.PVENT_Id = Guia.PVENT_IdOrigen
Where ALMAC_IdDestino = IsNull(@ALMAC_IdDestino, ALMAC_IdDestino)
	And TIPOS_CodMotivoTraslado = @TIPOS_CodMotivoTraslado
	And (Case @Opcion When 0 Then Guia.GUIAR_Descripcioncliente
				  When 1 Then Guia.GUIAR_Codigo
				  Else Guia.GUIAR_Descripcioncliente
	 End) Like '%' + @Cadena + '%' 
	AND (Case @OpcionFecha When 0 Then Convert(Date, Guia.GUIAR_FechaEmision) 
						   When 1 Then Convert(Date, Guia.GUIAR_FechaTraslado) 
		 End)
		Between @FecIni AND @FecFin
	AND  Guia.GUIAR_Estado = 'I'
	AND Guia.TIPOS_CodMotivoTraslado = @TIPOS_CodMotivoTraslado


GO 
/***************************************************************************************************************************************/ 

