USE BDJAYVIC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_REPOSS_Ventas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_REPOSS_Ventas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_REPOSS_Ventas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Int
)
As
Select Case Ent.ENTID_NroDocumento When '11000000000' 
			Then IsNull(Ven.DOCVE_DescripcionCliente, '-')
			Else ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial)
		End
		As ENTID_Cliente
	,(Case Ent.ENTID_NroDocumento When '11000000000' Then '-' Else Ent.ENTID_NroDocumento End) As ENTID_NroDocumento
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TDoc.TIPOS_Desc2 As TIPOS_TipoDocCorta
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_ImporteVenta
		Else Ven.DOCVE_ImporteVenta * TCam.TIPOC_VentaSunat
	  End As ImporteSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_ImporteIgv
		Else Ven.DOCVE_ImporteIgv * TCam.TIPOC_VentaSunat
	  End As IGVSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalVenta
		Else Ven.DOCVE_TotalVenta * TCam.TIPOC_VentaSunat
	  End As TotalVenta
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalPagar
		Else Ven.DOCVE_TotalPagar * TCam.TIPOC_VentaSunat
	  End As TotalSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Null
		Else Ven.DOCVE_TotalPagar
	  End As TotalDolares
		, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalPagar
		Else Ven.DOCVE_TotalPagar * TCam.TIPOC_VentaSunat
	  End As DOCVE_TotalPagar
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then TCam.TIPOC_VentaSunat Else 1 End As TIPOC_VentaSunat
	,  Ven.DOCVE_Codigo             , Ven.ZONAS_Codigo             , Ven.SUCUR_Id                 , Ven.PEDID_Codigo             
, Ven.PVENT_Id                 , Ven.ENTID_CodigoCliente      , Ven.ENTID_CodigoVendedor     , Ven.TIPOS_CodTipoMoneda      
, Ven.TIPOS_CodTipoDocumento   , Ven.TIPOS_CodCondicionPago   , Ven.TIPOS_CodTipoMotivo      , Ven.DOCVE_Id                 
, Ven.DOCVE_Serie              , Ven.DOCVE_Numero             , Ven.DOCVE_DireccionCliente   , Ven.DOCVE_DescripcionCliente 
, Ven.DOCVE_FechaDocumento     , Ven.DOCVE_FechaTransaccion   , Ven.DOCVE_OrdenCompra        , Ven.DOCVE_ImporteVenta       
, Ven.DOCVE_PorcentajeIGV      , Ven.DOCVE_ImporteIgv         , Ven.DOCVE_TotalVenta         , Ven.DOCVE_Referencia         
, Ven.DOCVE_AfectoPercepcion   , Ven.DOCVE_AfectoPercepcionSoles, Ven.DOCVE_PorcentajePercepcion, Ven.DOCVE_ImportePercepcion  
, Ven.DOCVE_ImportePercepcionSoles, Ven.DOCVE_TotalPagar         , Ven.DOCVE_TotalPagado        , Ven.DOCVE_TotalPeso          
, Ven.DOCVE_DocumentoPercepcion, Ven.DOCVE_TipoCambio         , Ven.DOCVE_TipoCambioSunat    , Ven.DOCVE_EstEntrega         
, Ven.DOCVE_Observaciones      , Ven.DOCVE_NotaPie            , Ven.DOCVE_Estado             , Ven.DOCVE_Guias              
, Ven.DOCVE_IncIGV             , Ven.DOCVE_Plazo              , Ven.DOCVE_PlazoFecha         , Ven.DOCVE_Dirigida           
, Ven.DOCVE_NroTelefono        , Ven.DOCVE_AnuladoCaja        , Ven.DOCVE_PrecIncIVG         , Ven.DOCVE_FecAnulacion       
, Ven.DOCVE_Motivo             , Ven.DOCVE_StockDevuelto      , Ven.DOCVE_MotivoAnulacion    , Ven.DOCVE_UsrCrea            
, Ven.DOCVE_FecCrea            , Ven.DOCVE_UsrMod             , Ven.DOCVE_FecMod             , Ven.ENTID_CodigoCotizador    
, Ven.DOCVE_NCAceptada         , Ven.DOCVE_NCPendienteCaja    , Ven.DOCVE_NCPendienteDespachos, Ven.DOCVE_RCRevisado         
, Ven.DOCVE_RCFecha            , Ven.DOCVE_RCUsrMod           , Ven.DOCVE_FechaPago          , Ven.DOCVE_FPUsrMod           
, Ven.RCTCT_Id                 , Ven.DOCVE_PerGenGuia        -- , Ven.DOCVE_Sunat              
From Data.VENT_DocsVenta As Ven 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento 
	Left Join dbo.TipoCambio As TCam On TCam.TIPOC_Fecha = Convert(varchar,Ven.DOCVE_FechaDocumento, 112)
WHERE  Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni AND @FecFin 
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.TIPOS_CodTipoDocumento IN ('CPDLE', 'CPD08')
	And CONVERT(Date, Ven.DOCVE_FechaDocumento) < '08-19-2013'
Union All
Select Case Ent.ENTID_NroDocumento When '11000000000' 
			Then IsNull(Ven.DOCVE_DescripcionCliente, '-')
			Else ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial)
		End
		As ENTID_Cliente
	,(Case Ent.ENTID_NroDocumento When '11000000000' Then '-' Else Ent.ENTID_NroDocumento End) As ENTID_NroDocumento
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TDoc.TIPOS_Desc2 As TIPOS_TipoDocCorta
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_ImporteVenta
		Else Ven.DOCVE_ImporteVenta * TCam.TIPOC_VentaSunat
	  End As ImporteSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_ImporteIgv
		Else Ven.DOCVE_ImporteIgv * TCam.TIPOC_VentaSunat
	  End As IGVSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalVenta
		Else Ven.DOCVE_TotalVenta * TCam.TIPOC_VentaSunat
	  End As TotalVenta
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalPagar
		Else Ven.DOCVE_TotalPagar * TCam.TIPOC_VentaSunat
	  End As TotalSoles
	, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Null
		Else Ven.DOCVE_TotalPagar
	  End As TotalDolares
		, Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
		Then Ven.DOCVE_TotalPagar
		Else Ven.DOCVE_TotalPagar * TCam.TIPOC_VentaSunat
	  End As DOCVE_TotalPagar
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then TCam.TIPOC_VentaSunat Else 1 End As TIPOC_VentaSunat
	, Ven.DOCVE_Codigo             , Ven.ZONAS_Codigo             , Ven.SUCUR_Id                 , Ven.PEDID_Codigo             
, Ven.PVENT_Id                 , Ven.ENTID_CodigoCliente      , Ven.ENTID_CodigoVendedor     , Ven.TIPOS_CodTipoMoneda      
, Ven.TIPOS_CodTipoDocumento   , Ven.TIPOS_CodCondicionPago   , Ven.TIPOS_CodTipoMotivo      , Ven.DOCVE_Id                 
, Ven.DOCVE_Serie              , Ven.DOCVE_Numero             , Ven.DOCVE_DireccionCliente   , Ven.DOCVE_DescripcionCliente 
, Ven.DOCVE_FechaDocumento     , Ven.DOCVE_FechaTransaccion   , Ven.DOCVE_OrdenCompra        , Ven.DOCVE_ImporteVenta       
, Ven.DOCVE_PorcentajeIGV      , Ven.DOCVE_ImporteIgv         , Ven.DOCVE_TotalVenta         , Ven.DOCVE_Referencia         
, Ven.DOCVE_AfectoPercepcion   , Ven.DOCVE_AfectoPercepcionSoles, Ven.DOCVE_PorcentajePercepcion, Ven.DOCVE_ImportePercepcion  
, Ven.DOCVE_ImportePercepcionSoles, Ven.DOCVE_TotalPagar         , Ven.DOCVE_TotalPagado        , Ven.DOCVE_TotalPeso          
, Ven.DOCVE_DocumentoPercepcion, Ven.DOCVE_TipoCambio         , Ven.DOCVE_TipoCambioSunat    , Ven.DOCVE_EstEntrega         
, Ven.DOCVE_Observaciones      , Ven.DOCVE_NotaPie            , Ven.DOCVE_Estado             , Ven.DOCVE_Guias              
, Ven.DOCVE_IncIGV             , Ven.DOCVE_Plazo              , Ven.DOCVE_PlazoFecha         , Ven.DOCVE_Dirigida           
, Ven.DOCVE_NroTelefono        , Ven.DOCVE_AnuladoCaja        , Ven.DOCVE_PrecIncIVG         , Ven.DOCVE_FecAnulacion       
, Ven.DOCVE_Motivo             , Ven.DOCVE_StockDevuelto      , Ven.DOCVE_MotivoAnulacion    , Ven.DOCVE_UsrCrea            
, Ven.DOCVE_FecCrea            , Ven.DOCVE_UsrMod             , Ven.DOCVE_FecMod             , Ven.ENTID_CodigoCotizador    
, Ven.DOCVE_NCAceptada         , Ven.DOCVE_NCPendienteCaja    , Ven.DOCVE_NCPendienteDespachos, Ven.DOCVE_RCRevisado         
, Ven.DOCVE_RCFecha            , Ven.DOCVE_RCUsrMod           , Ven.DOCVE_FechaPago          , Ven.DOCVE_FPUsrMod           
, Ven.RCTCT_Id                 , Ven.DOCVE_PerGenGuia         --, Ven.DOCVE_Sunat              
From Ventas.VENT_DocsVenta As Ven 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento 
	Left Join dbo.TipoCambio As TCam On TCam.TIPOC_Fecha = Convert(varchar,Ven.DOCVE_FechaDocumento, 112)
WHERE  Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni AND @FecFin
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.TIPOS_CodTipoDocumento IN ('CPDLE', 'CPD08')
	And CONVERT(Date, Ven.DOCVE_FechaDocumento) > '08-18-2013'
Order By TIPOS_TipoDocumento Desc, Ven.DOCVE_Serie, Ven.DOCVE_Numero


GO 
/***************************************************************************************************************************************/ 
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'

/***************************************************************************************************************************************/ 

exec VENT_REPOSS_Ventas @FecIni='2022-04-05 00:00:00',@FecFin='2022-04-08 00:00:00',@PVENT_Id=1

