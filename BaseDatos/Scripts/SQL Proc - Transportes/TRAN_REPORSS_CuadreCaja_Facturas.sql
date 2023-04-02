GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_CuadreCaja_Facturas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_Facturas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_Facturas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor From Parametros Where PARMT_Id = 'Empresa')


/* Facturas Disponibles */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial --+ ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
		--+ ' - ' + Via.VIAJE_Descripcion
		As ENTID_RazonSocial
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As Glosa
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, 'Fle.' + Right('000' + RTrim(Fle.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Fle.FLETE_Id), 7))  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case IsNull((Case Fle.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else Convert(Decimal(14, 2), 0.00) End), 0)
		When 0 Then (Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 2), 0.00) End)
		Else (Case Fle.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else Convert(Decimal(14, 2), 0.00) End)
	 End
	 As ImpDolares
	,Case IsNull((Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End), 0)
		When 0 Then (Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat End)
		Else (Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End)
	 End
	 As ImpSoles
	,Fle.FLETE_Id
	,Fle.VIAJE_Id
	,Fle.ENTID_Codigo
	,Ven.DOCVE_Codigo
	,IsNull(Via.VIAJE_Descripcion, '') + ' || ' + IsNull(Fle.FLETE_Glosa, '') As FLETE_Glosa	
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
		And CAJA_Estado <> 'X'
	 ), 0)) As Pendiente
	,Ven.DOCVE_FechaDocumento
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
		And CAJA_Estado <> 'X'
	 ), 0)
	 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,'' Recibo
	,Ven.TIPOS_CodTipoDocumento
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,Fle.FLETE_Fecha
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
Where Not Ven.ENTID_CodigoCliente In (@RUC)
	And Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
Union All /* factura Anulada en otro Tiempo */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial --+ ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
		--+ ' - ' + Via.VIAJE_Descripcion
		As ENTID_RazonSocial
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor)
		+ ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' / ' + Rut.RUTAS_Nombre
	 As Glosa
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, 'Fle.' + Right('000' + RTrim(Fle.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Fle.FLETE_Id), 7))  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case IsNull((Case Fle.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else Convert(Decimal(14, 2), 0.00) End), 0)
		When 0 Then (Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 2), 0.00) End)
		Else (Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 2), 0.00) End)
	 End
	 As ImpDolares
	,Case IsNull((Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TC.TIPOC_VentaSunat End), 0)
		When 0 Then (Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat End)
		Else (Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat End)
	 End
	 As ImpSoles
	,Fle.FLETE_Id
	,Fle.VIAJE_Id
	,Fle.ENTID_Codigo
	,Ven.DOCVE_Codigo
	,IsNull(Via.VIAJE_Descripcion, '') + ' || ' + IsNull(Fle.FLETE_Glosa, '') As FLETE_Glosa	
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
		And CAJA_Estado <> 'X'
	 ), 0)) As Pendiente
	,Ven.DOCVE_FechaDocumento
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
		And CAJA_Estado <> 'X'
	 ), 0)
	 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,'' Recibo
	,Ven.TIPOS_CodTipoDocumento
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,Fle.FLETE_Fecha
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
Where Not Ven.ENTID_CodigoCliente In (@RUC)
	And Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni And Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
Union /* Facturas Anuladas */
Select 1 As Orden
	,Convert(VarChar(50), '') As Titulo
	,Convert(VarChar(50), '01.- Facturas') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,' - ' As ENTID_NroDocumento
	,'ANULADO' As ENTID_RazonSocial
	,'ANULADO' As Glosa
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		  As Documento
	,'' As Moneda
	,0.00 As TCambioVenta
	,0.00 As ImpDolares
	,0.00 As ImpSoles
	,0 As FLETE_Id
	,0 As VIAJE_Id
	,'' As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,'ANULADO' As FLETE_Glosa	
	,0.00 As Pendiente
	,Ven.DOCVE_FechaDocumento
	,0.00 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,'' Recibo
	,Ven.TIPOS_CodTipoDocumento
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,Null As FechaFlete
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
/* Actualizar la Numeración de Fletes */
Update #Fletes
Set Titulo = (Select #Fletes.TIPOS_Descripcion + ' - (' + #Fletes.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
				   From #Fletes As Fle Where DOCVE_Serie = #Fletes.DOCVE_Serie
						And TIPOS_CodTipoDocumento = #Fletes.TIPOS_CodTipoDocumento
				  )
Update #Fletes Set Title = '01.- ' + Titulo 



Select * From #Fletes 
Order By DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

