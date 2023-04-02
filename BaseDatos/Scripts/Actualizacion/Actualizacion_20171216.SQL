
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_DocumentosRelacionados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_DocumentosRelacionados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/04/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_DocumentosRelacionados]
(
	@DOCVE_Codigo VarChar(13)
)

AS

Select 
	Doc.DOCVE_Codigo
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Doc.DOCVE_Numero
	,Doc.DOCVE_Serie
	,Doc.DOCVE_FechaDocumento
	,Doc.ENTID_CodigoCliente
	,Doc.DOCVE_DescripcionCliente
	,Doc.DOCVE_TotalPagar
	,Doc.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Doc
	Inner Join Ventas.VENT_DocsRelacion As Rel On Rel.DOCVE_CodReferencia = Doc.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
Where Rel.DOCVE_Codigo = @DOCVE_Codigo



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_CajaPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_DOCVESS_CajaPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 05/03/2013
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_CajaPagos]
(
    @DOCVE_Codigo VarChar(13)
)

AS

 SELECT  Caj.CAJA_Id
       , Caj.CAJA_Serie + '-' + Right('0000000' + RTrim(CAJA_Numero), 7) As Documento
       , CAJA_OrdenDocumento
       , CAJA_Fecha
       , CAJA_Hora
       , CAJA_FechaPago
       , Case TIPOS_CodMonedaPago 
                When 'MND1' Then CAJA_Importe / 
                    (Case IsNull(CAJA_TCambio, 1) When 0 Then TCam.TIPOC_VentaSunat Else CAJA_TCambio End)
                When 'MND2' Then CAJA_Importe 
         End As CAJA_ImporteDolares
       , Case TIPOS_CodMonedaPago 
                When 'MND1' Then CAJA_Importe
                When 'MND2' Then CAJA_Importe * CAJA_TCambio
         End As CAJA_ImporteSoles
       , CAJA_Importe
       , TDoc.TIPOS_Descripcion As TIPOS_Transaccion
       , TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , TPag.TIPOS_Descripcion
       , IsNull('Cod: ' + RTrim(DPag.DPAGO_Id) +' - Op/Num: ' + RTrim(DPag.DPAGO_Numero) 
           + IsNull(' - Banco: ' + Ban.BANCO_Descripcion, '')
           + ' - ' + TDoc.TIPOS_Descripcion
           , 'Cancelación en Efectivo')
         AS Glosa
       --,DPag.DPAGO_Fecha
       , IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
       , DPag.DPAGO_Id
       , DPag.DPAGO_Numero
       , DPag.DPAGO_FechaVenc As DPAGO_Fecha
       , Ven.ENTID_CodigoCliente
       , Ven.DOCVE_Codigo
       , Caj.CAJA_Codigo
         --,*
   FROM Ventas.VENT_DocsVenta As Ven
  INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.DOCVE_Codigo = Ven.DOCVE_Codigo 
    AND Caj.CAJA_Estado <> 'X'  And Caj.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tesoreria.TESO_CajaDocsPago As TC On TC.CAJA_Codigo = Caj.CAJA_Codigo And TC.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = TC.DPAGO_Id And DPag.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
   LEFT JOIN Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
   LEFT JOIN Tipos As TMon On TMon.TIPOS_Codigo = IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
   LEFT JOIN Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
   LEFT JOIN TipoCambio As TCam On Convert(VarChar, TCam.TIPOC_FechaC, 113) = Convert(VarChar, Caj.CAJA_Fecha, 113)
Where Ven.DOCVE_Codigo = @DOCVE_Codigo


GO
/*====================================================================================================*/
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
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_DocumentosXNotaDebito]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_DocumentosXNotaDebito] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/04/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_DocumentosXNotaDebito]
(
	@DOCVE_Codigo VarChar(13)
)

AS

Select 
	Doc.DOCVE_Codigo
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Doc.DOCVE_Numero
	,Doc.DOCVE_Serie
	,Doc.DOCVE_FechaDocumento
	,Doc.ENTID_CodigoCliente
	,Doc.DOCVE_DescripcionCliente
	,Doc.DOCVE_TotalPagar
From Ventas.VENT_DocsVenta As Doc
	Inner Join Ventas.VENT_DocsRelacion As Rel On Rel.DOCVE_CodReferencia = Doc.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
Where Rel.DOCVE_Codigo = @DOCVE_Codigo



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_VENTSS_RomperRelacionDocsVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas]
(
	 @DOCVE_Codigo VarChar(13)
	,@PVENT_Id BigInt
	,@XPago Bit
)
As

Begin Tran x

Update Logistica.DIST_GuiasRemision
Set DOCVE_Codigo = Null
Where DOCVE_Codigo = @DOCVE_Codigo
	And PVENT_Id = @PVENT_Id

Update Logistica.DIST_Ordenes
Set DOCVE_Codigo = Null
Where DOCVE_Codigo = @DOCVE_Codigo
	And PVENT_Id = @PVENT_Id
	
-- Eliminar Pago

If @XPago = 1
Begin 
	Declare @CAJA_Codigo VarChar(14)
	Declare @DPAGO_Id BigInt
	Set @CAJA_Codigo = (Select CAJA_Codigo From Tesoreria.TESO_Caja Where DOCVE_Codigo = @DOCVE_Codigo)
	Set @DPAGO_Id = (Select DPAGO_Id From Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo)
	
	Update Tesoreria.TESO_DocsPagos
	Set DPAGO_Estado = 'X'
	Where DPAGO_Id = @DPAGO_Id And PVENT_Id = @PVENT_Id
End

Delete From Tesoreria.TESO_Caja
Where DOCVE_Codigo = @DOCVE_Codigo
	And PVENT_Id = @PVENT_Id
	
Commit Tran x



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_UnDocumento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_UnDocumento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_UnDocumento]
(
	 @DOCVE_Codigo VarChar(13)
)
As

Select Ent.ENTID_RazonSocial As ENTID_Cliente
	,(Case Ent.ENTID_NroDocumento When '11000000000' Then '' Else Ent.ENTID_NroDocumento End) As ENTID_NroDocumento
	,Vend.ENTID_RazonSocial As ENTID_Vendedor
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Doc.DOCVE_Serie
	,Doc.DOCVE_Numero
	,IsNull(Doc.DOCVE_DireccionCliente, '') As DOCVE_DireccionCliente
	,Doc.DOCVE_DescripcionCliente
	,Doc.DOCVE_FechaDocumento
	,Doc.DOCVE_ImporteVenta
	,Doc.DOCVE_ImporteIgv
	,Doc.DOCVE_TotalVenta
	,Doc.DOCVE_AfectoPercepcion	
	,Doc.DOCVE_AfectoPercepcionSoles
	,Doc.DOCVE_ImportePercepcion
	,Doc.DOCVE_ImportePercepcionSoles
	,Doc.DOCVE_TotalPeso
	,Doc.DOCVE_TotalPagar
	,Doc.TIPOS_CodTipoDocumento
	--,IsNull(Ent.ENTID_CodUsuario, '-') As Cotizador
	,IsNull(Cotiz.ENTID_CodUsuario, Cotiz.ENTID_RazonSocial) As Cotizador
	,Doc.TIPOS_CodTipoMoneda
	,Doc.DOCVE_EstEntrega
	,TCon.TIPOS_Descripcion As TIPOS_CondicionPagoCorto
	,Doc.DOCVE_OrdenCompra
	,Doc.DOCVE_PorcentajePercepcion
	,Doc.DOCVE_PorcentajeIGV
	,Doc.DOCVE_Codigo
	--,TIPOS_CodCondicionPago
	--,Doc.* 
From Ventas.VENT_DocsVenta As Doc 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_CodigoCliente
	Left Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Doc.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda 
	Left Join Ventas.VENT_Pedidos As Ped On Ped.PEDID_Codigo = Doc.PEDID_Codigo
	Left Join dbo.Entidades As Cotiz On Cotiz.ENTID_Codigo = Doc.ENTID_CodigoCotizador
	Left Join Tipos As TCon On TCon.TIPOS_Codigo = Doc.TIPOS_CodCondicionPago
WHERE   Doc.DOCVE_Codigo = @DOCVE_Codigo


Select Alm.ALMAC_Descripcion As ALMAC_Descripcion
	,Det.DOCVD_Cantidad
	,TUni.TIPOS_DescCorta As DOCVD_Unidad
	,Art.ARTIC_Descripcion As ARTIC_Descripcion
	,Det.DOCVD_PrecioUnitario
	,Det.DOCVD_SubImporteVenta	
	--,Det.DOCVD_PesoUnitario
	,Art.ARTIC_Peso As DOCVD_PesoUnitario
	,Det.DOCVD_PesoUnitario * Det.DOCVD_Cantidad
	,IsNull(Det.DOCVD_Detalle, Art.ARTIC_Descripcion) As DOCVD_Detalle
	,Det.DOCVE_Codigo
From Ventas.VENT_DocsVentaDetalle As Det 
	Left Join dbo.Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	Left Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Left Join dbo.Almacenes As Alm On Alm.ALMAC_Id = Det.ALMAC_Id 
WHERE   Det.DOCVE_Codigo = @DOCVE_Codigo


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_GetDocsPago]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_GetDocsPago] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_GetDocsPago]
(
	 @DOCVE_Codigo CodDocVentaNew
)
As

Select 
	Pag.PVENT_Id
	,Pag.DPAGO_Fecha
	,Pag.DPAGO_Id
	,Pag.BANCO_Id
	,Ban.BANCO_Descripcion
	,Pag.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Pag.DPAGO_Numero
	,Pag.DPAGO_Importe
	,TDoc.TIPOS_DescCorta + ' ' + DVen.DOCVE_Serie + '-' + Right('0000000' + RTRIM(DVen.DOCVE_Numero), 7) As DocVenta
From Tesoreria.TESO_DocsPagos As Pag
	Inner Join Ventas.VENT_DocsVentaPagos As Ven On Ven.PVENT_Id = Pag.PVENT_Id And Ven.DPAGO_Id = Pag.DPAGO_Id And Ven.DVEPG_Estado <> 'X'
	Inner Join Ventas.VENT_DocsVenta As DVen On DVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = DVen.TIPOS_CodTipoDocumento
	Inner Join Bancos As Ban On Ban.BANCO_Id = Pag.BANCO_Id
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Pag.TIPOS_CodTipoMoneda
Where Ven.DOCVE_Codigo = @DOCVE_Codigo
	


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_FletesXFacturas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_FletesXFacturas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/07/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_FletesXFacturas]
(
	@DOCVE_Codigo VarChar(13)
)
As

--Declare @DOCVE_Codigo VarChar(12)
--Set @DOCVE_Codigo = 'BI0010000015'

Select n_tran_rutas.RUTAS_Nombre As RUTAS_Nombre
	, n_entidades.ENTID_RazonSocial As ENTID_RazonSocial
	, n_entidades.ENTID_NroDocumento As ENTID_NroDocumento
	, n_tran_cotizaciones.COTIZ_Carga As COTIZ_Carga
	,Fle.FLETE_MontoPorTM + Fle.FLETE_ImporteIgv As FLETE_MontoPorTM
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + ISNULL(Veh.VEHIC_Placa, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As VIAJE_Descripcion
	--,Via.VIAJE_Descripcion
	,Fle.* 
From Transportes.TRAN_Fletes As Fle
	Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id And VVen.DOCVE_Codigo = @DOCVE_Codigo
		And VVen.VIAVE_Estado <> 'X'
	Left Join Transportes.TRAN_Rutas As n_tran_rutas On n_tran_rutas.RUTAS_Id = Fle.RUTAS_Id
	Inner Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_Cotizaciones As n_tran_cotizaciones On n_tran_cotizaciones.COTIZ_Codigo = Fle.COTIZ_Codigo 
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
	Left Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
	

GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSD_EliminarDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 10/12/2017
-- Descripcion         : Eliminar detalle de los documentos de compra
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 

    PRINT 'DELETE Logistica.ABAS_DocsCompraDetalle'
    DELETE FROM Logistica.ABAS_DocsCompraDetalle 
     WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

END 

GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_GetSaldoArticulo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_GetSaldoArticulo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_GetSaldoArticulo]
(
	 @DOCVE_Codigo VarChar(13)
	,@ARTIC_Codigo VarChar(7)
	,@Orden Bit = Null
)
As

If IsNull(@Orden, 0) = 0
Begin

	Select 
		DOCVD_Cantidad - IsNull((Select Sum(Det.GUIRD_Cantidad) From Logistica.DIST_GuiasRemisionDetalle As Det
									Inner Join Logistica.DIST_GuiasRemision As Cab On Cab.GUIAR_Codigo = Det.GUIAR_Codigo
									Where Cab.DOCVE_Codigo = VDet.DOCVE_Codigo And Det.ARTIC_Codigo = VDet.ARTIC_Codigo
										And Cab.GUIAR_Estado <> 'X'
		  ), 0) As Saldo
	From Ventas.VENT_DocsVentaDetalle As VDet
	Where DOCVE_Codigo = @DOCVE_Codigo
		And ARTIC_Codigo = @ARTIC_Codigo
		
--DOCVE_Serie = '001' And TIPOS_CodTipoDocumento = 'CPD01'
End
Else
Begin
	Select 
		ORDET_Cantidad - IsNull((Select Sum(Det.GUIRD_Cantidad) From Logistica.DIST_GuiasRemisionDetalle As Det
			Inner Join Logistica.DIST_GuiasRemision As Cab On Cab.GUIAR_Codigo = Det.GUIAR_Codigo
		  Where Cab.DOCVE_Codigo = VDet.ORDEN_Codigo And Det.ARTIC_Codigo = VDet.ARTIC_Codigo And Cab.GUIAR_Estado <> 'X'), 0) As Saldo
	From Logistica.DIST_OrdenesDetalle As VDet
	Where ORDEN_Codigo = @DOCVE_Codigo
		And ARTIC_Codigo = @ARTIC_Codigo
End



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ABASSD_EliminarStockIngresoMerc]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 05/06/2017
-- Descripcion         : Eliminar Stock Ingresado
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 
    
   DELETE  
     FROM Logistica.LOG_Stocks 
    WHERE INGCO_Id IN (SELECT INGCO_Id 
                         FROM Logistica.ABAS_IngresosCompra 
                        WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor)

   DECLARE @ALMAC_Id SMALLINT
         , @INGCO_Id INTEGER
   
   SELECT @ALMAC_Id = ALMAC_Id
        , @INGCO_Id = INGCO_Id
     FROM Logistica.ABAS_IngresosCompra 
    WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

    PRINT 'DELETE Logistica.ABAS_IngresosCompraDetalle'
   DELETE FROM Logistica.ABAS_IngresosCompraDetalle
    WHERE ALMAC_Id = @ALMAC_Id AND  INGCO_Id = @INGCO_Id

    PRINT '=================================='
    PRINT '@ALMAC_Id = ' + ISNULL(RTRIM(@ALMAC_Id), '*')
    PRINT '@INGCO_Id = ' + ISNULL(RTRIM(@INGCO_Id), '*')
    PRINT '=================================='
END 



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSS_TodosDocCompra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Documentos de Compra
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra]
(
     @ZONAS_Codigo VarChar(5)
    ,@SUCUR_Id SmallInt
    ,@Cadena VarChar(50)
    ,@Opcion SmallInt
    ,@Todos Bit
    ,@FecIni DateTime
    ,@FecFin DATETIME
    ,@TipoRegistro CHAR(1) = NULL 
)
As

   SELECT Ent.ENTID_RazonSocial As ENTID_Proveedor
        , Alma.ALMAC_Descripcion As ALMAC_Descripcion
        , TDoc.TIPOS_DescCorta As TIPOS_Documento
        , TMone.TIPOS_DescCorta As TIPOS_TipoMoneda
        , TPag.TIPOS_Descripcion As TIPOS_TipoPago
        , RTrim(DocCo.DOCCO_Numero) As DOCCO_Numero
        , EstadoCosteo = CASE WHEN (SELECT COUNT(*) FROM Logistica.ABAS_Costeos COST 
                                     WHERE COST.DOCCO_Codigo = DocCo.DOCCO_Codigo
                                       AND COST.ENTID_CodigoProveedor = DocCo.ENTID_CodigoProveedor) > 0
                              THEN 'C' 
                              ELSE 'N' 
                         END 
        , CASE DocCo.DOCCO_TipoRegistro 
			   WHEN 'I' THEN 'Registro e Ingreso'
               WHEN 'R' THEN 'Solo Registro'
               ELSE ''
          END AS DOCCO_TipoRegistro_Text
        , CASE WHEN exists(SELECT * FROM Logistica.ABAS_IngresosCompra INGCO WHERE INGCO.DOCCO_Codigo = DocCo.DOCCO_Codigo AND INGCO.ENTID_CodigoProveedor = DocCo.ENTID_CodigoProveedor)
               THEN CONVERT(BIT, 1)
               ELSE CONVERT(BIT, 0)
          END AS RegistroCompra
        , DocCo.*
     FROM Logistica.ABAS_DocsCompra As DocCo 
    INNER JOIN dbo.Entidades As Ent On Ent.ENTID_Codigo = DocCo.ENTID_CodigoProveedor
    INNER JOIN dbo.Almacenes As Alma On Alma.ALMAC_Id = DocCo.ALMAC_Id
    INNER JOIN dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = DocCo.TIPOS_CodTipoDocumento
    INNER JOIN dbo.Tipos As TMone On TMone.TIPOS_Codigo = DocCo.TIPOS_CodTipoMoneda
    INNER JOIN dbo.Tipos As TPag On TPag.TIPOS_Codigo = DocCo.TIPOS_CodTipoPago 
    WHERE Alma.SUCUR_Id = @SUCUR_Id
      AND Alma.ZONAS_Codigo = @ZONAS_Codigo
      AND Convert(Date, DocCo.DOCCO_FechaDocumento) Between @FecIni AND @FecFin
      AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
                      When 1 Then DocCo.DOCCO_Codigo
                      Else Ent.ENTID_RazonSocial 
           END) Like '%' + @Cadena + '%' 
      AND DocCo.DOCCO_Estado In (Case @Todos When 1 Then (DocCo.DOCCO_Estado) Else ('I') End) 
      AND ISNULL(DocCo.DOCCO_TipoRegistro, '-') = isnull(@TipoRegistro, ISNULL(DocCo.DOCCO_TipoRegistro, '-'))
    ORDER By DOCCO_Codigo ASC



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de SelecciÃ³n segÃºn las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPagos]
(
	@DOCVE_Codigo VarChar(13)
)

AS

Select Caj.CAJA_Id
	,Caj.CAJA_Serie + '-' + Right('0000000' + RTrim(CAJA_Numero), 7) As Documento
	,CAJA_OrdenDocumento
	,CAJA_Fecha
	,CAJA_Hora
	,CAJA_FechaPago
	,CAJA_Importe
	,TDoc.TIPOS_Descripcion As TIPOS_Transaccion
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TPag.TIPOS_Descripcion
	,IsNull('Cod: ' + RTrim(DPag.DPAGO_Id) +' - Op/Num: ' + RTrim(DPag.DPAGO_Numero) 
		+ IsNull(' - Banco: ' + Ban.BANCO_Descripcion, '')
		+ ' - ' + TDoc.TIPOS_Descripcion
		, 'CancelaciÃ³n en Efectivo')
	As Glosa
	--,DPag.DPAGO_Fecha
	,IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
	,DPag.DPAGO_Id
	,DPag.DPAGO_Numero
	,DPag.DPAGO_FechaVenc As DPAGO_Fecha
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tesoreria.TESO_Caja As Caj On CAJA_NroDocumento = Ven.DOCVE_Codigo 
		And Caj.CAJA_Estado <> 'X'
	Left Join Tesoreria.TESO_CajaDocsPago As TC On TC.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = TC.DPAGO_Id
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
	Left Join Tipos As TMon On TMon.TIPOS_Codigo = IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
	Left Join Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
Where Ven.DOCVE_Codigo = @DOCVE_Codigo


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ORDCOSS_TodosOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Ordenes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes]
(
	 @ZONAS_Codigo VarChar(5)
	,@SUCUR_Id SmallInt
	,@Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime
)
As


Select Ent.ENTID_RazonSocial As ENTID_Proveedor
	,Alma.ALMAC_Descripcion As ALMAC_Descripcion
	,OrdCo.*
From Logistica.ABAS_OrdenesCompra As OrdCo 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = OrdCo.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = OrdCo.ALMAC_Id 
	
WHERE Alma.SUCUR_Id = @SUCUR_Id
	AND  Alma.ZONAS_Codigo = @ZONAS_Codigo
	AND  Convert(Date, OrdCo.ORDCO_FechaDocumento) Between @FecIni AND @FecFin
	AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
					  When 1 Then OrdCo.COTCO_Codigo
					  Else Ent.ENTID_RazonSocial 
		 End) Like '%' + @Cadena + '%' 
	AND OrdCo.ORDCO_Estado In (Case @Todos When 1 Then (OrdCo.ORDCO_Estado) Else ('I') End) 


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_INGSS_Consulta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_INGSS_Consulta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 28/12/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_INGSS_Consulta]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select  Ent.ENTID_RazonSocial As ENTID_Proveedor
	, Alma.ALMAC_Descripcion As ALMAC_Descripcion
	, TDoc.TIPOS_DescCorta As TIPOS_Documento
	, IsNull((TDocC.TIPOS_DescCorta + ' ' + DC.DOCCO_Serie + '-' + Right('0000000' + RTRIM(DC.DOCCO_Numero), 7))
		, (TDocC2.TIPOS_DescCorta + ' '+ Left(Right(IComp.DOCCO_Codigo, 10), 3)) + '-' + RIGHT(IComp.DOCCO_Codigo, 7)) As Compra
	,(Case When DC.DOCCO_Codigo Is Null 
	  Then CONVERT(Bit, 0) Else CONVERT(Bit, 1) End) As CompraReg
	, 'OC ' + OC.ORDCO_Serie + '-' + Right('0000000' + RTRIM(OC.ORDCO_Numero), 7) As Orden
	,IComp.DOCCO_Codigo
	,IComp.INGCO_Serie
	,IComp.INGCO_Numero
	,IComp.ENTID_CodigoProveedor
	,IComp.INGCO_FechaDocumento
	,IComp.ALMAC_Id
	,IComp.INGCO_Id
	,IComp.INGCO_Estado
	--,IComp.* 
Into #Ingresos
From Logistica.ABAS_IngresosCompra As IComp 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = IComp.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = IComp.ALMAC_Id
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = IComp.TIPOS_CodTipoDocumento
	Left Join Logistica.ABAS_OrdenesCompra As OC On OC.ORDCO_Codigo = IComp.ORDCO_Codigo
	Left Join Logistica.ABAS_DocsCompra As DC On DC.DOCCO_Codigo = IComp.DOCCO_Codigo
		And DC.ENTID_CodigoProveedor = IComp.ENTID_CodigoProveedor
	Left Join Tipos As TDocC On TDocC.TIPOS_Codigo = DC.TIPOS_CodTipoDocumento
	Left Join Tipos As TDocC2 On TDocC2.TIPOS_Codigo = 'CPD' + LEFT(IComp.DOCCO_Codigo, 2)
 WHERE Convert(date, IComp.INGCO_FechaDocumento) Between @FecIni AND @FecFin
		AND DC.DOCCO_TipoRegistro = 'R'
        AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
						  When 1 Then RTrim(IComp.INGCO_Id)
						  When 2 Then IComp.DOCCO_Codigo
						  When 3 Then IComp.INGCO_Codigo
						  Else Ent.ENTID_RazonSocial
			 End)
			Like '%' + @Cadena + '%' 
		
IF @Todos = 1
    BEGIN 
	    Select * From #Ingresos Order By INGCO_FechaDocumento Desc
    END
ELSE
    BEGIN
	    Select * From #Ingresos Where ISNULL(INGCO_Estado, '') = 'I' Order By INGCO_FechaDocumento DESC
    END

GO
/*====================================================================================================*/

