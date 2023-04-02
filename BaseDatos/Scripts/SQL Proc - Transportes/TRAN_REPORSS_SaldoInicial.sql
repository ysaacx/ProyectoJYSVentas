GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_SaldoInicial]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_SaldoInicial] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_SaldoInicial]
(
	 @FecIni DateTime
	 ,@PVENT_Id BigInt
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor from Parametros Where PARMT_Id = 'Empresa')

Select VIAJE_Id Into #Viajes From Transportes.TRAN_Fletes WHere ENTID_Codigo = @RUC
Declare @Fec DateTime									Declare @SIni Decimal(14, 4)
Select @Fec = SINIC_Fecha, @SIni = SINIC_Importe From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id

/* Facturas y Fletes */
Select Sum(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then Ven.DOCVE_TotalPagar 
			Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat 
		   End) As Ingreso
	, 0.00 As Egreso
	, 'Ingresos de Facturas - Sin Saldo Inicial' As Glosa
Into #Saldos
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Not Ven.ENTID_CodigoCliente In (@RUC)
	And Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And Convert(Date, Ven.DOCVE_FechaDocumento) >= @Fec
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
Union All
Select Sum(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then Ven.DOCVE_TotalPagar 
			Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat 
		   End) As Ingreso
	, 0.00 As Egreso
	, 'Ingresos de Facturas - Anuladas' As Glosa
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Not Ven.ENTID_CodigoCliente In (@RUC)
	And Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And Convert(Date, Ven.DOCVE_FechaDocumento) >= @Fec
	And Ven.DOCVE_Estado = 'X'
	And Convert(Date, Ven.DOCVE_FecAnulacion) >= @FecIni 
	And Ven.DOCVE_AnuladoCaja = 1	
	And Ven.PVENT_Id = @PVENT_Id
Union All 
Select @SIni, 0.00, 'Saldo Inicial' 
Union All
/* Cancelacion de Facturas - Antes de la Fecha del Saldo Inicial */
Select Case TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
						Where CAJA_NroDocumento = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) < @Fec
						And CAJA_Estado <> 'X'
			), 0)) * TC.TIPOC_VentaSunat
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) < @Fec
						And CAJA_Estado <> 'X'
		 ), 0))
		 End
	 As E
	,0.00
	, 'Pendientes de Documentos' 
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
Where Not Ven.ENTID_CodigoCliente In (@RUC)
	And Convert(Date, Ven.DOCVE_FechaDocumento) < @Fec
			And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
Union All
/* Egresos - Gastos de Viajes */
/* Egreso en Efectivo */
Select 0.00
	,Sum(Caj.CAJA_Importe)
	,'Recibo de Egresos - En Efectivo + ' As TIPOS_Descripcion
From Transportes.TRAN_Recibos As Rec
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X'
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
Where TIPOS_CodTipoRecibo = 'RCT2'
	And Convert(Date, RECIB_Fecha) < @FecIni
Union All /* Ingresos en Efectivo */
Select Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0.00
	,'Ingresos en Efectivo' 
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
		And Rec.TIPOS_CodTipoRecibo = 'RCT1'
Where TIPOS_CodTipoOrigen In ('ORI06', 'ORI05')
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_Fecha) >= @Fec
	And Rec.TIPOS_CodTipoRecibo = 'RCT1'
	And Not Caj.CAJA_Id In (2785)
	And Caj.CAJA_Estado <> 'X'
Union All /* Transferencias */
Select Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0.00
	,'Ingresos por Transferencias'
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As TD On TD.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where TIPOS_CodTipoOrigen In ('ORI02')
	And Caj.TIPOS_CodTipoDocumento = 'CPDTR'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_Fecha) >= @Fec
	And Caj.CAJA_Estado <> 'X'
Union All /* Otros Gastos de Viaje */
Select 0.00
	,Sum(Inc.VGAST_Monto) As ImpSoles
	,'Otros Gastos de Viaje'
From Transportes.TRAN_ViajesGastos As Inc
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Inc.DOCUS_Codigo And Doc.ENTID_Codigo = Inc.ENTID_CodigoProveedor
	Inner Join Transportes.TRAN_Recibos as Rec On Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Inc.VGAST_Id
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
		And Caj.CAJA_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Convert(Date, Via.VIAJE_FecLlegada) < @FecIni
	And Doc.DOCUS_Codigo Is Null
Union All /* Gastos de Viaje */
Select 0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,'Gastos de Viaje'
From Transportes.TRAN_ViajesGastos As Inc
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Inc.DOCUS_Codigo And Doc.ENTID_Codigo = Inc.ENTID_CodigoProveedor
	Inner Join Transportes.TRAN_Recibos as Rec On Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Inc.VGAST_Id
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
		And Caj.CAJA_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Convert(Date, Via.VIAJE_FecLlegada) < @FecIni 
	And Rec.TIPOS_CodTipoRecibo = 'RCT6' 
Union All /* A Cuenta de Sueldo */
Select 0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,'A Cuenta de Sueldo'
From Transportes.TRAN_Recibos As Rec
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X'
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where TIPOS_CodTipoRecibo = 'RCT5'
	And Convert(Date, RECIB_Fecha) < @FecIni
Union All /* Consumo de Combustibible */
Select 0.00
	,Case CCom.TIPOS_CodTipoMoneda When 'MND1' Then CCom.COMCO_Total Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,'Consumo de Combustibible'
From Transportes.TRAN_CombustibleConsumo As CCom
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = CCom.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = CCom.ENTID_CodigoProveedor
	Inner Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = CCom.DOCUS_Codigo  And Doc.ENTID_Codigo = CCom.ENTID_CodigoProveedor
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCom.TIPOS_CodTipoMoneda
Where Convert(Date, Via.VIAJE_FecLlegada) < @FecIni 
	And CCom.COMCO_CCaja = 1
	And CCom.COMCO_Estado <> 'X'
Union All /* Deposito */
Select 0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 1 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End ImpSoles
	,'Depositos'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	Inner Join Entidades As Ent on Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI01', 'ORI03')
	And Caj.TIPOS_CodTransaccion <> 'TPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_Fecha) >= @Fec
	And Caj.CAJA_Estado <> 'X'
Union All
Select 0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 1 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End ImpSoles
	,'Depositos Anulados'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	Inner Join Entidades As Ent on Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI01', 'ORI03')
	And Caj.TIPOS_CodTransaccion <> 'TPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_Fecha) >= @Fec
	And Caj.CAJA_Estado = 'X'
	And Not Caj.CAJA_FechaAnulado Is Null
	And Convert(Date, Caj.CAJA_FechaAnulado) >= @FecIni 
	And Caj.CAJA_AnuladoCaja = 1


Select Sum(IsNull(Ingreso, 0)) - Sum(IsNull(Egreso, 0)) As SaldoInicial, Sum(Ingreso) As Ingreso, Sum(Egreso) As Egreso From #Saldos

Select SUM(Ingreso), SUM(Egreso), Glosa From #Saldos Group By Glosa

Drop Table #Saldos
Drop Table #Viajes


GO 
/***************************************************************************************************************************************/ 

