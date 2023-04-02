GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Pendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_Pendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Pendientes]
(
	@FecFin DateTime
	,@PVENT_Id Id
	,@Orden Tinyint
)
As

Select 
	Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,Ven.DOCVE_Codigo
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND1'
			Then (Ven.DOCVE_TotalPagar
				- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
							Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
								And Convert(Date, CAJA_Fecha) <= @FecFin
								And CAJA_Estado <> 'X'
						 ), 0))
		 Else Convert(Decimal(14, 2), 0.00)
		 End
	 As PendienteSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 Else 0.00
		 End
	 As PendienteDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End)
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Soles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End)
		 Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pago
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(
							Case TIPOS_CodMonedaPago When 'MND2' Then CAJA_Importe Else CAJA_Importe 
								* (Case IsNull(Caj.CAJA_TCambio, 0) When 0 Then TCD.TIPOC_VentaSunat Else Caj.CAJA_TCambio End)
								 End
							) From Tesoreria.TESO_Caja As Caj
								Left Join TipoCambio As TCD On Convert(VarChar, TCD.TIPOC_Fecha, 112) = Convert(VarChar, Caj.CAJA_Fecha, 112)
							Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
								And Convert(Date, CAJA_Fecha) <= @FecFin
								And CAJA_Estado <> 'X'
						), 0)) 
		 Else 0.00
		 End
	 As PagoDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImpSoles
	,(Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End) As TCambioVenta
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
Where Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	--And Ven.TIPOS_CodTipoMoneda = 'MND2'
	--And Ven.DOCVE_AnuladoCaja = 0 And Ven.DOCVE_FecAnulacion < @FecFin
Union All /* Facturas Anuladas */
Select Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ent.ENTID_RazonSocial				
	,Ven.DOCVE_Codigo
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND1'	Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
						Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
					), 0))
		 Else 0.00
		 End
	 As PendienteSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) 
		 Else 0.00
		 End
	 As PendienteDolares
	,0.00
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pago
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
		  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End)
		 Else 0.00
		 End
	 As Pago
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND2' Then (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
							- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
										Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
											And CAJA_Estado <> 'X'
											And Convert(Date, CAJA_Fecha) <= @FecFin									 
									) ), 0)) * TC.TIPOC_VentaSunat
		 Else (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
				- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
										Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
											And Convert(Date, CAJA_Fecha) <= @FecFin
											And CAJA_Estado <> 'X'
									)), 0))
		 End
	 As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Ven.ENTID_CodigoVendedor
	,Vend.ENTID_RazonSocial As ENTID_RazonSocialVendedor
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Ven.DOCVE_AnuladoCaja = 1 And Convert(Date, DateAdd(Day, -1, Ven.DOCVE_FecAnulacion)) >= @FecFin
	And Ven.PVENT_Id = @PVENT_Id
Union All /* PENDIENTES */
Select CCh.ENTID_Codigo
	,Ent.ENTID_RazonSocial + ' / ' + CCh.CAJAC_Detalle
	,'' As DOCVE_Codigo
	,'CCh' As TipoDocumento
	,'CCh ' + Right('000' + RTrim(CCh.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CCh.CAJAC_Id), 7) As Documento
	,CCh.CAJAC_Fecha As DOCVE_FechaDocumento
	,CCh.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case CCh.TIPOS_CodTipoMoneda 
		When 'MND1'
			Then (CCh.CAJAC_Importe
				- IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos As Caj
							Where Caj.CAJAC_Id = CCh.CAJAC_Id
								And Convert(Date, CAJAP_Fecha) <= @FecFin
								And CAJAP_Estado <> 'X'
						 ), 0))
		 Else Convert(Decimal(14, 2), 0.00)
		 End
	 As PendienteSoles
	,Case CCh.TIPOS_CodTipoMoneda 
		When 'MND2'
			Then (CCh.CAJAC_Importe
				- IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos As Caj
							Where Caj.CAJAC_Id = CCh.CAJAC_Id
								And Convert(Date, CAJAP_Fecha) <= @FecFin
								And CAJAP_Estado <> 'X'
						 ), 0))
		 Else Convert(Decimal(14, 2), 0.00)
		 End
	 As PendienteDolares
	,0.00
	 As Soles
	,Case CCh.TIPOS_CodTipoMoneda When 'MND1' 
		Then (IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos As Caj
		  Where Caj.CAJAC_Id = CCh.CAJAC_Id
			And Convert(Date, CAJAP_Fecha) <= @FecFin
			And CAJAP_Estado <> 'X'
		 ), 0))
		 Else 
			0.00
		 End
	 As Pago
	,Case CCh.TIPOS_CodTipoMoneda When 'MND2' 
		Then (IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos As Caj
		  Where Caj.CAJAC_Id = CCh.CAJAC_Id
			And Convert(Date, CAJAP_Fecha) <= @FecFin
			And CAJAP_Estado <> 'X'
		 ), 0))
		 Else 
			0.00
		 End
	 As PagoDolares
	,Case CCh.TIPOS_CodTipoMoneda When 'MND2' Then CCh.CAJAC_Importe Else 0.00 End As ImpDolares
	,Case CCh.TIPOS_CodTipoMoneda
		When 'MND2' Then  CCh.CAJAC_Importe * TC.TIPOC_VentaSunat
		 Else  CCh.CAJAC_Importe
		 End
	 As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,'0000000000' As ENTID_CodigoVendedor
	,'Pendientes' As ENTID_RazonSocialVendedor
	,'Doc' As TIPOS_CodTipoDocumento
From Tesoreria.TESO_CajaChicaIngreso As CCh
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = CCh.ENTID_Codigo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCh.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, CCh.CAJAC_Fecha, 112)
Where Convert(Date, CCh.CAJAC_Fecha) <= @FecFin

If @Orden = 0
Begin 
	Select * From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07'
		And (PendienteSoles > 0 Or PendienteDolares > 0)
		--And TIPOS_CodTipoMoneda = 'MND2'
	Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo
End
If @Orden = 1
Begin 
	Select * From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07'
		And (PendienteSoles > 0 Or PendienteDolares > 0)
	Order By ENTID_RazonSocialVendedor, DOCVE_FechaDocumento, DOCVE_Codigo
	
End




--Else
--Begin 
--	Select * From #Facturas 
--	Where TIPOS_CodTipoDocumento <> 'CPD07'
--		And PendienteSoles > 0
--	Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo
--End

	--Select * From #Facturas Where PendienteSoles < 0 And ENTID_CodigoVendedor = '29452467'


--Select SUM(ImpSoles), ENTID_NroDocumento, ENTID_RazonSocial From #Fletes 
--Where Pendiente > 0
--Group By ENTID_NroDocumento, ENTID_RazonSocial

--Select SUM(ImpSoles) From #Fletes 
--Where Pendiente > 0





GO 
/***************************************************************************************************************************************/ 

