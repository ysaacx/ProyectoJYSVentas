GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_ReportePendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_ReportePendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_ReportePendientes]
(
	@FecFin DateTime
	,@PVENT_Id Id
	,@ENTID_CodigoCliente VarChar(14) = Null
	,@DOCVE_Codigo VarChar(14) = Null
	,@Orden Tinyint = Null
)
As

--Declare @FecFin DateTime Set @FecFin = '08-31-2013'
--Declare @PVENT_Id Id Set @PVENT_Id = 5
--Declare @Orden Tinyint = Null Set @Orden = 0

Select 
	RTRim(Ven.ENTID_CodigoCliente) As ENTID_Codigo
	,Ent.ENTID_RazonSocial As Titulo
	,Ent.ENTID_RazonSocial
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TIPOS_TipoDocCorta
	--,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Ven.DOCVE_ImportePercepcion
	,Ven.DOCVE_ImportePercepcionSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
		Then (Ven.DOCVE_TotalPagar
			- IsNull(IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
						Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
						Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
						And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0) + 
					 IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0)
					 , 0)) * (TC.TIPOC_VentaSunat)
		 Else (Ven.DOCVE_TotalPagar
			- IsNull(IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
						Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
						Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
						And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0) + 
					 IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0)
					 , 0))
		 End
	 As PendienteSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And Convert(Date, CAJA_FechaAnulado) >= @FecFin
					 ), 0))
			
		 Else 0.00
		 End
	 As PendienteDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull(IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
						Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
						Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
						And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0) + 
					 IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0)
					 , 0)) * (TC.TIPOC_VentaSunat)
		 Else (IsNull(IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
						Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
						Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
						And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0) + 
					 IsNull((Select SUM(ABS(CAJA_Importe)) 
					  From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
						And CAJA_Estado <> 'X'
					 ), 0)
					 , 0))
		 End
	 As TotalPagado
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImporteDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImporteSoles
	,(Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End) As TIPOC_VentaSunat
	,Ven.ENTID_CodigoVendedor
	,Vend.ENTID_RazonSocial As ENTID_RazonSocialVendedor
	,Ven.TIPOS_CodTipoDocumento
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) <= @FecFin
	And Ven.DOCVE_Codigo = IsNull(@DOCVE_Codigo, Ven.DOCVE_Codigo)
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	--And Ven.DOCVE_AnuladoCaja = 0 And Ven.DOCVE_FecAnulacion < @FecFin
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
	And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Ven.ENTID_CodigoCliente)
	And Not Ven.ENTID_CodigoCliente In ('20100241022', '20191731434')
	
If IsNull(@Orden, 0) = 0
Begin 
	Select * 
		,Case When TotalPagado > IsNull(DOCVE_ImportePercepcionSoles, 0)
			Then PendienteSoles 
			Else ImporteSoles - TotalPagado - IsNull(DOCVE_ImportePercepcionSoles, 0)
		 End As ImportePendiente
		,Case When TotalPagado > IsNull(DOCVE_ImportePercepcionSoles, 0)
			Then 0
			Else IsNull(DOCVE_ImportePercepcionSoles, 0)
		 End As PercepcionPendiente
		,ImporteSoles As TotalPendiente
	From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07'
		And PendienteSoles > 0
	Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo
End
If IsNull(@Orden, 0) = 1
Begin 
	Select * From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07'
		And PendienteSoles > 0
	Order By ENTID_RazonSocialVendedor, DOCVE_FechaDocumento, DOCVE_Codigo
	
End

/*========================================================================================================*
Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = '030210051984'
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
*========================================================================================================*/
	--Select * From #Facturas Where PendienteSoles < 0 And ENTID_CodigoVendedor = '29452467'

If ISNULL(@DOCVE_Codigo, '') <> ''
Begin 

	Select CAJA_Importe, Caj.*
	From Tesoreria.TESO_Caja As Caj
		Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
		Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	Where Caj.DOCVE_Codigo = IsNull(@DOCVE_Codigo, Caj.DOCVE_Codigo)
		And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
		And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
		And CAJA_Estado <> 'X'
	Union All
	Select CAJA_Importe, Caj.*
	From Tesoreria.TESO_Caja As Caj
	Where Caj.DOCVE_Codigo = IsNull(@DOCVE_Codigo, Caj.DOCVE_Codigo)
		And Convert(Date, CAJA_Fecha) <= @FecFin
		And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
		And CAJA_Estado <> 'X'

	Select (Select SUM(ABS(CAJA_Importe)) 
	  From Tesoreria.TESO_Caja As Caj
		Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
		Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	  Where Caj.DOCVE_Codigo = IsNull(@DOCVE_Codigo, Caj.DOCVE_Codigo)
		And Convert(Date, DPag.DPAGO_FechaVenc) <= @FecFin
		And Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
		And CAJA_Estado <> 'X'
	 ) + 
	 IsNull((Select SUM(ABS(CAJA_Importe)) 
	  From Tesoreria.TESO_Caja As Caj
	  Where Caj.DOCVE_Codigo = IsNull(@DOCVE_Codigo, Caj.DOCVE_Codigo)
		And Convert(Date, CAJA_Fecha) <= @FecFin
		And Not Caj.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
		And CAJA_Estado <> 'X'
	 ), 0)
 
End
							   
--Select SUM(ImpSoles), ENTID_NroDocumento, ENTID_RazonSocial From #Fletes 
--Where Pendiente > 0
--Group By ENTID_NroDocumento, ENTID_RazonSocial

--Select SUM(ImpSoles) From #Fletes 
--Where Pendiente > 0

GO 
/***************************************************************************************************************************************/ 

