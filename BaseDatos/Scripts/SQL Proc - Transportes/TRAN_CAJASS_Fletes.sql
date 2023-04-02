GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_Fletes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_Fletes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_Fletes]
(
	@VIAJE_Id Id
)
As

Select n_tran_rutas.RUTAS_Nombre As RUTAS_Nombre
	, n_entidades.ENTID_RazonSocial As ENTID_Nombres
	, n_entidades.ENTID_NroDocumento As ENTID_NroDocumento
	, n_tran_cotizaciones.COTIZ_Carga As COTIZ_Carga
	,Case Ven.DOCVE_TotalPagar -
	 IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
			Where CAJA_NroDocumento = Ven.DOCVE_Codigo	
				And ENTID_Codigo = m_tran_fletes.ENTID_Codigo
		 ), 0)
	 When 0 Then m_tran_fletes.FLETE_TotIngreso
		Else (
			IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
			Where CAJA_NroDocumento = Ven.DOCVE_Codigo
				And ENTID_Codigo = m_tran_fletes.ENTID_Codigo
			), 0)
		)
	 End
		 As Pago
	,m_tran_fletes.FLETE_MontoPorTM + m_tran_fletes.FLETE_ImporteIgv As FLETE_MontoPorTM
	,Ven.DOCVE_Codigo
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, ISNULL((Select Top 1 'Cot ' + Left(Right(Coti.COTIZ_Codigo, 10), 3) + '-' + Right(Coti.COTIZ_Codigo, 7) From Transportes.TRAN_Cotizaciones As Coti
					Inner Join Transportes.TRAN_CotizacionesFletes As CFle On Coti.COTIZ_Codigo = CFle.COTIZ_Codigo
				  Where CFle.FLETE_Id = m_tran_fletes.FLETE_Id
				  Order By Coti.COTIZ_Codigo
				),''))  As Documento
	,Ven.DOCVE_Codigo
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,m_tran_fletes.*
From Transportes.TRAN_Fletes As m_tran_fletes 
 Left Join Transportes.TRAN_Rutas As n_tran_rutas On n_tran_rutas.RUTAS_Id = m_tran_fletes.RUTAS_Id
 Inner Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = m_tran_fletes.ENTID_Codigo
 Left Join Transportes.TRAN_Cotizaciones As n_tran_cotizaciones On n_tran_cotizaciones.COTIZ_Codigo = m_tran_fletes.COTIZ_Codigo 
 Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = m_tran_fletes.VIAJE_Id
			And VVen.FLETE_Id = m_tran_fletes.FLETE_Id
			And IsNull(VVen.VIAVE_Estado, 'I') <> 'X'
 Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
 Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
 Inner Join Tipos As TMon On TMon.TIPOS_Codigo = m_tran_fletes.TIPOS_CodTipoMoneda
WHERE   ISNULL(m_TRAN_Fletes.VIAJE_Id, '') = @VIAJE_Id
	And m_tran_fletes.FLETE_Estado <> 'X'

GO 
/***************************************************************************************************************************************/ 

