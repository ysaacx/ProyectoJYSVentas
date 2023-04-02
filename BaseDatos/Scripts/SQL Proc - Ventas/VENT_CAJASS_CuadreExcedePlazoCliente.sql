GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_CuadreExcedePlazoCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_CuadreExcedePlazoCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : SR - 05/03/2013
-- Descripcion         : Facturas pendientes con fecha exceden el plazo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
create PROCEDURE [dbo].[VENT_CAJASS_CuadreExcedePlazoCliente]
(
	@FecFin DateTime
	,@PVENT_Id Id
	,@Orden Tinyint
	,@ENTID_CodigoCliente CodEntidad
)
As

Select 
	 LTrim(RTRim(Ven.ENTID_CodigoCliente)) As ENTID_Codigo
	,Ent.ENTID_RazonSocial As Titulo
	,Ent.ENTID_RazonSocial
	,Ven.DOCVE_Codigo
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
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
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
					 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
																	Else Ven.DOCVE_TipoCambio
							   End)
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
					 ), 0))
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
			Then (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
						  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
						 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
																		Else Ven.DOCVE_TipoCambio
								   End)
		 Else (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
						  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
						 ), 0))
		 End
	 As Pago
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
	,IsNull(DOCVE_Plazo,0) as SDOCVE_Plazo
	,IsNull(DOCVE_PlazoFecha ,'') as SDOCVE_PlazoFecha
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) <= @FecFin

	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And LTrim(RTRim(Ven.ENTID_CodigoCliente)) = @ENTID_CodigoCliente  --filtroCliente
	--And Ven.DOCVE_AnuladoCaja = 0 And Ven.DOCVE_FecAnulacion < @FecFin
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All /* Facturas Anuladas */
Select LTrim(RTrim(Ven.ENTID_CodigoCliente)) As ENTID_Codigo
	,Ent.ENTID_RazonSocial As Titulo
	,Ent.ENTID_RazonSocial				
	,Ven.DOCVE_Codigo
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND2'	Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
						Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
					), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
					 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
																	Else Ven.DOCVE_TipoCambio
							   End)
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
						Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
					), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) >= @FecFin
					 ), 0))
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
	,IsNull(Ven.DOCVE_Plazo ,0) as SDOCVE_Plazo
	,IsNull(Ven.DOCVE_PlazoFecha ,'') as SDOCVE_PlazoFecha
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) <= @FecFin
    
	And Ven.DOCVE_Estado = 'X'
	And Ven.DOCVE_AnuladoCaja = 1 And Convert(Date, DateAdd(Day, -1, Ven.DOCVE_FecAnulacion)) >= @FecFin
	And Ven.PVENT_Id = @PVENT_Id
	And LTrim(RTRim(Ven.ENTID_CodigoCliente)) = @ENTID_CodigoCliente   --filtro cliente
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All
Select LTrim(RTrim(Se.ENTID_Codigo)) As ENTID_Codigo
	,Ent.ENTID_RazonSocial As Titulo
	,'Sencillo de Caja - ' + PVen.PVENT_Descripcion
	,'SE' + Right('000' + RTrim(Se.PVENT_Id), 3) + Right('0000000' + RTrim(SENCI_Id), 7)
	,'Sen' As TipoDocumento
	,'SE ' + Right('000' + RTrim(Se.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(SENCI_Id), 7) As Documento
	,SENCI_Fecha
	,'MND1'
	,'S/.' As TIPOS_TipoMoneda
	,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As PendienteSoles
	,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As PendienteDolares
	,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As Pago
	,Case TIPOS_CodTipoMoneda When 'MND2' Then SENCI_Importe Else 0.00 End As ImpDolares
	,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As ImpSoles
	,SENCI_TipoCambio As TCambioVenta
	,'10000000' As ENTID_CodigoVendedor
	,'Efectivo' As ENTID_RazonSocialVendedor
	,'' As TIPOS_CodTipoDocumento
	,'' As SDOCVE_Plazo 
	,'' As SDOCVE_PlazoFecha 
From Tesoreria.TESO_Sencillo As Se
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Se.ENTID_Codigo
	Inner Join PuntoVenta As PVen On PVen.PVENT_Id = Se.PVENT_Id
Where Convert(Date, SENCI_Fecha) = @FecFin
	And Se.PVENT_Id = @PVENT_Id

If @Orden = 0
Begin 
	Select * From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07' 
		And PendienteSoles > 0
		And SDOCVE_PlazoFecha <=@FecFin 
	Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo
End
If @Orden = 1
Begin 
	Select * From #Facturas 
	Where TIPOS_CodTipoDocumento <> 'CPD07'  
		And PendienteSoles > 0
		And SDOCVE_PlazoFecha <=@FecFin 
	Order By ENTID_RazonSocialVendedor, DOCVE_FechaDocumento, DOCVE_Codigo
	
End


Select Titulo As ENTID_RazonSocial, RTrim(ENTID_Codigo) As ENTID_CodigoCliente , Count(*) as Cantidad, SUM(PendienteSoles) as PendienteSoles,SUM(PendienteDolares) as PendienteDolares
From #Facturas 
Where TIPOS_CodTipoDocumento <> 'CPD07'  
		And PendienteSoles > 0
		And SDOCVE_PlazoFecha <=@FecFin 
Group By Titulo, ENTID_Codigo Order By Titulo



GO 
/***************************************************************************************************************************************/ 

