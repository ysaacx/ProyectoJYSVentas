GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadrePendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadrePendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadrePendientes]
(
	@FecFin DateTime
	,@PVENT_Id Id
)
As

Select Fle.FLETE_Id					,Fle.VIAJE_Id						,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ent.ENTID_NroDocumento			,Ent.ENTID_RazonSocial				,Ven.DOCVE_Codigo
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As FLETE_Glosa	
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Fle.FLETE_TotIngreso
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pendiente
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pago
	,Ven.DOCVE_FechaDocumento
	,Fle.FLETE_FecSalida
	,Fle.FLETE_FecLlegada
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else 0 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND2' Then (ISNULL(Fle.FLETE_TotIngreso, Ven.DOCVE_TotalPagar)
							- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
										Where CAJA_NroDocumento = Ven.DOCVE_Codigo
											And CAJA_Estado <> 'X'
											And Convert(Date, CAJA_Fecha) <= @FecFin
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0)) * TC.TIPOC_VentaSunat
		 Else (ISNULL(Fle.FLETE_TotIngreso, Ven.DOCVE_TotalPagar)
				- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
										Where CAJA_NroDocumento = Ven.DOCVE_Codigo
											And Convert(Date, CAJA_Fecha) <= @FecFin
											And CAJA_Estado <> 'X'
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0))
		 End
	 As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
										Where CAJA_NroDocumento = Ven.DOCVE_Codigo
											And Convert(Date, CAJA_Fecha) <= @FecFin
											And CAJA_Estado <> 'X'								 
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0) As TotalPagado
Into #Fletes
From Ventas.VENT_DocsVenta As Ven 
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Left Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = VVen.FLETE_Id	
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
Where Not Ven.ENTID_CodigoCliente In ('20100241022')
	And Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	--And Ven.DOCVE_AnuladoCaja = 0 And Ven.DOCVE_FecAnulacion < @FecFin
Union All /* Facturas Anuladas */
Select Fle.FLETE_Id					,Fle.VIAJE_Id						,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ent.ENTID_NroDocumento			,Ent.ENTID_RazonSocial				,Ven.DOCVE_Codigo
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As FLETE_Glosa	
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Fle.FLETE_TotIngreso
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pendiente
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
			And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As Pago
	,Ven.DOCVE_FechaDocumento
	,Fle.FLETE_FecSalida
	,Fle.FLETE_FecLlegada
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else 0 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda 
		When 'MND2' Then (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
							- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
										Where CAJA_NroDocumento = Ven.DOCVE_Codigo
											And CAJA_Estado <> 'X'
											And Convert(Date, CAJA_Fecha) <= @FecFin									 
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0)) * TC.TIPOC_VentaSunat
		 Else (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
				- IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
										Where CAJA_NroDocumento = Ven.DOCVE_Codigo
											And Convert(Date, CAJA_Fecha) <= @FecFin
											And CAJA_Estado <> 'X'
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0))
		 End
	 As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,IsNull(((Select SUM(CAJA_Importe) 
				From Tesoreria.TESO_Caja
					Where CAJA_NroDocumento = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado <> 'X'								 
									) / 
										(
											Case 
												IsNull((Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo), 0) When 0
											Then 1
											Else
												(Select Count(*) From Transportes.TRAN_Fletes As Fle
													Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
												 Where VVen.DOCVE_Codigo = Ven.DOCVE_Codigo)
											End 
										)
									), 0) As TotalPagado
From Ventas.VENT_DocsVenta As Ven 
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Left Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = VVen.FLETE_Id	
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
Where Not Ven.ENTID_CodigoCliente In ('20100241022')
	And Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Ven.DOCVE_AnuladoCaja = 1 And Convert(Date, DateAdd(Day, -1, Ven.DOCVE_FecAnulacion)) >= @FecFin
	And Ven.PVENT_Id = @PVENT_Id
Order By Ent.ENTID_NroDocumento, Fle.FLETE_FecLlegada, Ven.DOCVE_Codigo 

Select Rec.VIAJE_Id
	,Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End As Pendiente
	,Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
Into #Pendiente
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Left Join Transportes.TRAN_CombustibleConsumo As CC On CC.COMCO_Id = COnvert(Integer, Rec.RECIB_CodReferencia)
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
	And Convert(Date,Caj.CAJA_Fecha) <= @FecFin
	And Caj.CAJA_Estado <> 'X'
	And IsNull(CC.COMCO_CCaja, 1) = 1
	And Caj.PVENT_Id = @PVENT_Id
Order By VIAJE_id

Select 0 As FLETE_Id			,Via.VIAJE_Id					
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes de Gastos de Viaje' As ENTID_RazonSocial		
	,'' As DOCVE_Codigo
	,'Pendientes del Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') 
		As FLETE_Glosa
	,'Fle' As TipoDocumento
	,'C. Viaje: ' + RTrim(Via.VIAJE_Id) As Documento
	,(Select Sum(Pendiente) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) As FLETE_TotIngreso	
	,(Select Sum(Pendiente) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) As Pendiente
	,0.00 As Pago
	,Via.VIAJE_FecSalida As DOCVE_FechaDocumento
	,Via.VIAJE_FecSalida As FLETE_FecSalida
	,Via.VIAJE_FecLlegada As FLETE_FecLlegada
	,'S/.' As TIPOS_TipoMoneda
	,0.00 As ImpDolares
	,(Select Sum(Pendiente) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,0 As Contador
Into #Pendientes
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Via.VIAJE_FecSalida, 112)
Where Convert(Date, IsNull(Via.VIAJE_FecLlegada, '01-01-2112')) > @FecFin
	And Via.VIAJE_Id In (Select VIAJE_Id From #Pendiente)
	And (Select Abs(Sum(Pendiente)) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) > 0
	And Via.PVENT_Id = @PVENT_Id

/* Pendientes No Rendidos*/
Select Sum(Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End) As Pendiente
	,Via.VIAJE_Id, Via.VHCON_Id, Via.VIAJE_FecSalida, Via.VIAJE_IdxConductor, Via.VIAJE_FecLlegada
Into #PRendir
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
	Left Join Transportes.TRAN_CombustibleConsumo As CC On CC.COMCO_Id = COnvert(Integer, Rec.RECIB_CodReferencia)
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR', 'CPDRI', 'CPDRE')
	And Caj.CAJA_Estado <> 'X'
	And Convert(Date, IsNull(Via.VIAJE_FecLlegada, '01-01-2112')) <= @FecFin
	And IsNull(CC.COMCO_CCaja, 1) = 1
	And Caj.PVENT_Id = @PVENT_Id
Group By Via.VIAJE_Id, Via.VHCON_Id, Via.VIAJE_FecSalida, Via.VIAJE_IdxConductor, Via.VIAJE_FecLlegada
	
/* Fletes Pendientes por Facturar */	
Declare @FecIniFPF DateTime
Set @FecIniFPF = (Select PARMT_Valor From Parametros Where PARMT_Id = 'pg_FecIniFletes'
				And APLIC_Codigo = 'TRA' And SUCUR_Id = 1)

Select * 
	,Case (Select COUNT(*) From #Fletes WHere Documento = Fle.Documento And Pendiente > 0) 
		When 1 Then IsNull(FLETE_Glosa, ENTID_RazonSocial)
		Else ENTID_RazonSocial
	 End 
	 As GlosaAgrupada
From #Fletes As Fle Where Pendiente > 0
Union All
Select *, FLETE_Glosa From #Pendientes 
Union All
Select 0 As FLETE_Id			,0 As VIAJE_Id					
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes' As ENTID_RazonSocial		
	,'' As DOCVE_Codigo
	,'Pendientes del Viaje: ' + Pen.PENDI_Concepto As FLETE_Glosa
	,'Fle' As TipoDocumento
	,'Pen: ' + RTrim(PENDI_Id) + ' / ' + IsNull(RTrim(Pen.PENDI_Numero), '')  As Documento
	,Pen.PENDI_Importe As FLETE_TotIngreso	
	,Pen.PENDI_Importe As Pendiente
	,0.00 As Pago
	,Pen.PENDI_Fecha As DOCVE_FechaDocumento
	,Pen.PENDI_Fecha As FLETE_FecSalida
	,Pen.PENDI_Fecha As FLETE_FecLlegada
	,'S/.' As TIPOS_TipoMoneda
	,0.00 As ImpDolares
	,Pen.PENDI_Importe
	,TC.TIPOC_VentaSunat As TCambioVenta
	,0 As Contador
	,'Pendientes del Viaje: ' + Pen.PENDI_Concepto
From RRHH.PLAN_Pendientes As Pen
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Pen.PENDI_Fecha, 112)
Where Pen.PVENT_Id = @PVENT_Id
Union All
Select 0 As FLETE_Id			,Pen.VIAJE_Id
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes' As ENTID_RazonSocial		
	,'' As DOCVE_Codigo
	,'Pendientes del Viaje: Gastos no Justificados' As FLETE_Glosa
	,'Pen' As TipoDocumento
	,'Viaje: ' + RTrim(Pen.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As Documento
	,Pen.Pendiente As FLETE_TotIngreso	
	,Pen.Pendiente As Pendiente
	,0.00 As Pago
	,Pen.VIAJE_FecSalida As DOCVE_FechaDocumento
	,Pen.VIAJE_FecSalida As FLETE_FecSalida
	,Pen.VIAJE_FecLlegada As FLETE_FecLlegada
	,'S/.' As TIPOS_TipoMoneda
	,0.00 As ImpDolares
	,Pen.Pendiente
	,TC.TIPOC_VentaSunat As TCambioVenta
	,0 As Contador
	,'Pendientes del Viaje: Gastos no Justificados'
From #PRendir As Pen
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Pen.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = (Select Top 1 RUTAS_Id From Transportes.TRAN_Fletes Where VIAJE_Id = Pen.VIAJE_Id)
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Pen.VIAJE_FecSalida, 112)
Where Pen.Pendiente > 0
Union All -- Pendientes de Caja
Select 0 As FLETE_Id			,0 As VIAJE_Id					
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes' As ENTID_RazonSocial		
	,'' As DOCVE_Codigo
	,'Pendientes de Caja: ' + Pen.PCAJA_Glosa As FLETE_Glosa
	,'PC' As TipoDocumento
	,'PC ' + Right('000' + RTrim(Pen.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Pen.PCAJA_Id), 7)  As Documento
	,Pen.PCAJA_Importe As FLETE_TotIngreso	
	,Pen.PCAJA_Importe - 
		IsNull((Select Sum(PCCAJ_Importe) From Tesoreria.TESO_PendientesCancelacion As Can
		 Where Can.PCAJA_Id = Pen.PCAJA_Id And Can.PCCAJ_Estado <> 'X'
				And Convert(Date, Can.PCCAJ_Fecha) <= @FecFin), 0)
	 As Pendiente
	,0.00 As Pago
	,Pen.PCAJA_Fecha As DOCVE_FechaDocumento
	,Pen.PCAJA_Fecha As FLETE_FecSalida
	,Pen.PCAJA_Fecha As FLETE_FecLlegada
	,TMOn.TIPOS_DescCorta As TIPOS_TipoMoneda
	,0.00 As ImpDolares
	,Pen.PCAJA_Importe
	,TC.TIPOC_VentaSunat As TCambioVenta
	,0 As Contador
	,'Pendientes de Caja: ' + Pen.PCAJA_Glosa
From Tesoreria.TESO_PendientesCaja As Pen
	Inner Join Tipos As TMOn On TMOn.TIPOS_Codigo = Pen.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Pen.PCAJA_Fecha, 112)
Where Convert(Date, PCAJA_Fecha) <= Convert(Date, @FecFin) --> '05-31-2012' --Convert(Date, @FecFin)
	And PCAJA_Estado <> 'X'
	And Abs(Pen.PCAJA_Importe - 
		 IsNull((Select Sum(PCCAJ_Importe) From Tesoreria.TESO_PendientesCancelacion As Can
		 Where Can.PCAJA_Id = Pen.PCAJA_Id And Can.PCCAJ_Estado <> 'X'
				And Convert(Date, Can.PCCAJ_Fecha) <= @FecFin), 0)) > 0
	And Pen.PVENT_Id = @PVENT_Id
Union All
Select Fle.FLETE_Id			,Fle.VIAJE_Id
	,Ent.ENTID_Codigo
	,'00000000001' As ENTID_NroDocumento
	,'Fletes Pendientes por Rendir' As ENTID_RazonSocial
	,'' As DOCVE_Codigo
	,Ent.ENTID_RazonSocial + ' ' + FLETE_Glosa + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') + ' / '  + Rut.RUTAS_Nombre
	,'PC' As TipoDocumento
	,'Fle ' + Right('000' + RTrim(Fle.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Fle.FLETE_Id), 7)  As Documento
	,Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End As FLETE_TotIngreso
	,Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End As Pendiente
	,0.00 As Pago
	,Fle.FLETE_FecSalida As DOCVE_FechaDocumento
	,Fle.FLETE_FecSalida As FLETE_FecSalida
	,Fle.FLETE_FecLlegada As FLETE_FecLlegada
	,TMOn.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Fle.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
	,0 As Contador
	,Ent.ENTID_RazonSocial + ' ' + FLETE_Glosa + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') + ' / '  + Rut.RUTAS_Nombre
From Transportes.TRAN_Fletes As Fle
	Inner Join Tipos As TMOn On TMOn.TIPOS_Codigo = Fle.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Fle.FLETE_FecSalida, 112)
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id And VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
Where Not Fle.FLETE_Id In (
		Select Fle.FLETE_Id From Transportes.TRAN_Fletes As Fle
			Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.FLETE_Id = Fle.FLETE_Id
			Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo And DOCVE_Estado <> 'X'
				And Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
		Where Fle.FLETE_Estado <> 'X'
	)
	And Not Fle.ENTID_Codigo = '20100241022'
	And Fle.FLETE_Estado <> 'X'
	And Convert(Date, FLETE_FecSalida) Between '08-01-2012' And @FecFin
	And Convert(Date, FLETE_FecSalida) >= '08-01-2012'
	And Fle.PVENT_Id = @PVENT_Id

Order By ENTID_RazonSocial, DOCVE_Codigo

--Select SUM(ImpSoles), ENTID_NroDocumento, ENTID_RazonSocial From #Fletes 
--Where Pendiente > 0
--Group By ENTID_NroDocumento, ENTID_RazonSocial

--Select SUM(ImpSoles) From #Fletes 
--Where Pendiente > 0




GO 
/***************************************************************************************************************************************/ 

