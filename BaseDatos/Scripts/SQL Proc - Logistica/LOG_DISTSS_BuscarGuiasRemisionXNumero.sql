GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_BuscarGuiasRemisionXNumero]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_BuscarGuiasRemisionXNumero] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/11/2012
-- Descripcion         : Obtener la Guia de remision para su impresion
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_BuscarGuiasRemisionXNumero]
(
	  @Numero VarChar(7)
	 ,@Serie VarChar(4)
	 ,@PVENT_Id BigInt
	 ,@TIPOS_CodMotivoTraslado VarChar(6)
	 ,@TIPOS_CodTipoDocumento VarChar(6)
	 ,@Todos Bit
)
As

Select Alma.ALMAC_Descripcion As ALMAC_Origen
	,PVenD.PVENT_Descripcion As PVENT_Destino
	,PVenO.PVENT_Descripcion As PVENT_Origen
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMot.TIPOS_Descripcion As TIPOS_MotivoTraslado
	,IsNull(Convert(VarChar(45), TFDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + RIGHT('0000000' + Rtrim(Ven.DOCVE_Numero), 7))
		,'OR' + ' ' + Left(Right(Guia.ORDEN_Codigo, 10), 3) + '-' + Right(Guia.ORDEN_Codigo, 7) 
		 + IsNull(' / ' + TDOrd.TIPOS_DescCorta + ' ' + Left(Right(Ord.DOCVE_Codigo, 10), 3) + '-' + Right(Ord.DOCVE_Codigo, 7), '')  )
	 
	 As DocVenta
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
	,Convert(VarChar(14), Ord.ORDEN_Codigo) As ORDEN_Codigo
	,Convert(VarChar(14), Ord.DOCVE_Codigo) As DOCVE_Codigo
Into #Guias
From Logistica.DIST_GuiasRemision As Guia 
	Left Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Guia.ALMAC_IdOrigen
	Left Join dbo.PuntoVenta As PVenD On PVenD.PVENT_Id = Guia.PVENT_IdDestino
	Left Join dbo.PuntoVenta As PVenO On PVenO.PVENT_Id = Guia.PVENT_IdOrigen
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMot On TMot.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado 
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Guia.ENTID_CodigoCliente
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Guia.DOCVE_Codigo
	Left Join Tipos As TFDoc On TFDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Entidades As Us On Us.ENTID_Codigo = Guia.GUIAR_UsrCrea
	Left Join Logistica.DIST_Ordenes As Ord On Ord.ORDEN_Codigo = Guia.ORDEN_Codigo
	Left Join Tipos As TDOrd ON TDOrd.TIPOS_Codigo = 'CPD' + Left(Ord.DOCVE_Codigo, 2)
WHERE  
	(Case @TIPOS_CodTipoDocumento When 'CPD09' Then RTrim(Guia.GUIAR_Serie)
		 When 'CPDOR' Then IsNull(Guia.ORDEN_Codigo, '')
		 Else RTrim(Ven.DOCVE_Serie)
	 End) Like '%' + IsNull(@Serie, '') + '%'
	And (Case @TIPOS_CodTipoDocumento When 'CPD09' Then RTrim(Guia.GUIAR_Numero)
		 When 'CPDOR' Then IsNull(RTrim(Ord.ORDEN_Numero), Guia.ORDEN_Codigo)
		 Else RTrim(Ven.DOCVE_Numero)
	 End) Like '%' + RTrim(@Numero) + '%'
	AND  Guia.PVENT_Id = @PVENT_Id
	AND Guia.TIPOS_CodMotivoTraslado = @TIPOS_CodMotivoTraslado
	
If @Todos = 1
Begin 
	Select * From #Guias  Order By GUIAR_Codigo
End
Else
Begin 
	Select * From #Guias Where GUIAR_Estado <> 'X' Order By GUIAR_Codigo
End



GO 
/***************************************************************************************************************************************/ 

