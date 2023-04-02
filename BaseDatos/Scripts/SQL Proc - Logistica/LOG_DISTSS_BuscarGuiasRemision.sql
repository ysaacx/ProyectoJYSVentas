GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_BuscarGuiasRemision]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_BuscarGuiasRemision] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/11/2012
-- Descripcion         : Obtener la Guia de remision para su impresion
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_BuscarGuiasRemision]
(
	 @FecIni Datetime
	 ,@FecFin Datetime
	 ,@PVENT_Id BigInt
	 ,@TIPOS_CodMotivoTraslado VarChar(6)
	 ,@Opcion SmallInt
	 ,@Cadena VarChar(50)
	 ,@Todos Bit
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
	,TFDoc.TIPOS_DescCorta + ' ' + IsNull(Ven.DOCVE_Serie, Right(LEFT(Guia.DOCVE_Codigo, 5), 3)) + '-' + RIGHT('0000000' + Rtrim(IsNull(Ven.DOCVE_Numero, Right(Guia.DOCVE_Codigo, 7))), 7) As DocVenta
	,GETDATE() As FechaImpresion
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
	,Guia.GUIAR_Estado
	,Guia.GUIAR_Codigo
	,Guia.GUIAR_TotalPeso
	,Us.ENTID_CodUsuario
Into #Guias
From Logistica.DIST_GuiasRemision As Guia 
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Guia.ALMAC_IdOrigen
	Left Join dbo.PuntoVenta As PVenD On PVenD.PVENT_Id = Guia.PVENT_IdDestino
	Inner Join dbo.PuntoVenta As PVenO On PVenO.PVENT_Id = Guia.PVENT_IdOrigen
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMot On TMot.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado 
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = ENTID_CodigoCliente
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo
	Left Join Tipos As TFDoc On TFDoc.TIPOS_Codigo = IsNull(Ven.TIPOS_CodTipoDocumento, 'CPD' + LEFT(Guia.DOCVE_Codigo, 2))
	Inner Join Entidades As Us On Us.ENTID_Codigo = Guia.GUIAR_UsrCrea
WHERE  
	(Case @Opcion When 0 Then Guia.GUIAR_Descripcioncliente
				  When 1 Then Guia.ENTID_CodigoCliente
				  When 2 Then Guia.DOCVE_Codigo
				  When 3 Then Guia.GUIAR_DescripcionConductor
				  When 4 Then Guia.GUIAR_DescripcionVehiculo
				  Else Guia.GUIAR_Descripcioncliente
	 End) Like '%' + @Cadena + '%' 
	AND  Guia.PVENT_Id = @PVENT_Id
	AND  Convert(Date, Guia.GUIAR_FechaEmision) Between @FecIni AND @FecFin
	--AND  Guia.GUIAR_Estado = 'I'
	AND Guia.TIPOS_CodMotivoTraslado = @TIPOS_CodMotivoTraslado
	
If @Todos = 1
Begin 
	Select * From #Guias
End
Else
Begin 
	Select * From #Guias Where GUIAR_Estado <> 'X'
End


GO 
/***************************************************************************************************************************************/ 

