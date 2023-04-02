GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_CuadreCaja_IngEgre]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_IngEgre] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_IngEgre]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
)
As

Print 'Hola Mundo Cruel'
Print @FecIni
Print @FecFin

/* Otros Ingresos */
/* Ingresos en Efectivo */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,CAJA_Fecha As Fecha
	,'' As ENTID_NroDocumento
	,Caj.CAJA_Glosa As ENTID_RazonSocial
	,'RC ' + CAJA_Serie + '-' + Right('0000000' + RTrim(CAJA_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0 As FLETE_Id,0 As VIAJE_Id,'' As ENTID_Codigo,'' As DOCVE_Codigo,'' As FLETE_Glosa,0 As Pendiente
	,Caj.CAJA_FechaPago As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,0 As OInterno
Into #OtrosIngresos
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
		And Rec.TIPOS_CodTipoRecibo = 'RCT1'
Where TIPOS_CodTipoOrigen In ('ORI06', 'ORI05')
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo = 'RCT1'
	And Not Caj.CAJA_Id In (2785)
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
Union All 
/* Transferencias de Viajes */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,CAJA_Fecha As Fecha
	,'V: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') As ENTID_NroDocumento
	,Rec.RECIB_Concepto + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') --+ ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') 
		As ENTID_RazonSocial
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0 As FLETE_Id,Via.VIAJE_Id,'' As ENTID_Codigo,'' As DOCVE_Codigo,'' As FLETE_Glosa,0 As Pendiente
	,Caj.CAJA_FechaPago As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,2 As OInterno
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
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
Union All /* Recibos de Pagos Anulados de Caja */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,Caj.CAJA_Fecha As Fecha
	,Ent.ENTID_Codigo As ENTID_NroDocumento
	,Ent.ENTID_RazonSocial + ' - Recibo de Ingreso por Anulación de Pago de ' 
						   + TDoc.TIPOS_Descripcion 
						   + ' Con ' + TPag.TIPOS_Descripcion
						   + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
						   + ' /  Anulada el ' 
						   + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
	,0 As FLETE_Id
	,0 As VIAJE_Id
	,'' As ENTID_Codigo
	,'' As RECIB_Codigo
	,' - Recibo de Ingreso por Anulación de Pago de ' 
						   + TDoc.TIPOS_Descripcion 
						   + ' Con ' + TPag.TIPOS_Descripcion
						   + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
						   + ' /  Anulada el ' 
						   + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As FLETE_Glosa
	,0 As Pendiente
	,Caj.CAJA_FechaAnulado As DOCVE_FechaDocumento
	,0 As Pago
	,Caj.CAJA_Serie
	,Caj.CAJA_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,'' As Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,1 As OInterno
From Tesoreria.TESO_Caja As Caj
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
Where Caj.CAJA_AnuladoCaja = 1
	And Convert(Date, Caj.CAJA_FechaAnulado) Between @FecIni And @FecFin
	And Caj.PVENT_Id = @PVENT_Id
	

/* Recibos de Egreso */
/* Egresos en Efectivo */
Select 3 As Orden
	,'Recibo de Egresos' As Titulo
	,'03.- Recibo de Egresos' As Title
	,Rec.RECIB_Fecha As Fecha
	,'' As ENTID_NroDocumento
	,Rec.RECIB_Concepto As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
	,0 As FLETE_Id
	,Rec.VIAJE_Id
	,'' As ENTID_Codigo
	,Rec.RECIB_Codigo
	,Via.VIAJE_Descripcion As FLETE_Glosa
	,0 As Pendiente
	,Rec.RECIB_Fecha As DOCVE_FechaDocumento
	,0 As Pago
	,Rec.RECIB_Serie
	,Rec.RECIB_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,Rec.TIPOS_CodTipoRecibo As Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,1 As OInterno
Into #Recibos
From Transportes.TRAN_Recibos As Rec
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X' And Caj.PVENT_Id = @PVENT_Id
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where TIPOS_CodTipoRecibo = 'RCT2'
	And Convert(Date, RECIB_Fecha) Between @FecIni And @FecFin
	
Union All /* Otros Gastos de Viaje */
Select 3 As Orden
	,'Recibo de Egresos'  As TIPOS_Descripcion
	,'03.- Recibo de Egresos' As Title
	,Via.VIAJE_FecLlegada
	,'' As ENTID_NroDocumento
	,TInc.TIPOS_Descripcion + ' / Viaje Nro:' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
		As RECIB_Concepto
	,(Case Inc.TIPOS_CodTipoGasto When 'GTO05' Then 'Peajes' Else 'Rel. Recibos' End)As Documento		
	,'' As TIPOS_DescCorta
	,Convert(Decimal(14, 2), 0.00) As TIPOC_VentaSunat
	,Convert(Decimal(14, 2), 0.00) --Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Monto Else 0.00 End 
		As ImpDolares
	,Sum(Convert(Decimal(12, 4), Inc.VGAST_Monto)) As ImpSoles --Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Monto Else 0.00 End ImpSoles
	,0 As FLETE_Id
	,Via.VIAJE_Id
	,'' As ENTID_Codigo
	,'' As RECIB_Codigo
	,'' As FLETE_Glosa
	,0 As Pendiente
	,Via.VIAJE_FecLlegada As Fecha
	,0 As Pago
	,'' As RECIB_Serie
	,0 As RECIB_Numero
	,(
		IsNull((Select Top 1 TDoc.TIPOS_DescCorta 
		From Transportes.TRAN_Documentos As Doc
			Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
		Where Doc.DOCUS_Codigo = Inc.DOCUS_Codigo), 'Rel. Recibos')
	 ) As TipoDocumento
	,'' TIPOS_CodTipoRecibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,2 As OInterno
From Transportes.TRAN_ViajesGastos As Inc
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Inc.DOCUS_Codigo And Doc.ENTID_Codigo = Inc.ENTID_CodigoProveedor
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Inc.TIPOS_CodTipoMoneda
	Inner Join Tipos As TInc On TInc.TIPOS_Codigo = Inc.TIPOS_CodTipoGasto
	Inner Join Transportes.TRAN_Recibos as Rec On Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Inc.VGAST_Id
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	--Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Left Join Transportes.TRAN_Recibos as Ref On Ref.RECIB_Codigo = Rec.RECIB_CodRecRef
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join Tipos As TRef On TRef.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
		And Caj.CAJA_Estado <> 'X'
		And Caj.PVENT_Id = @PVENT_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Convert(Date, Via.VIAJE_FecLlegada) Between @FecIni And @FecFin
	And Doc.DOCUS_Codigo Is Null
Group By Via.VIAJE_Id, Via.VIAJE_IdxConductor, Cond.CONDU_Sigla, Via.VIAJE_Descripcion, TInc.TIPOS_Descripcion
	,Inc.DOCUS_Codigo,Via.VIAJE_FecLlegada, Inc.TIPOS_CodTipoGasto
Union All /* Gastos de Viaje */
Select 3  As Orden
	,'Recibo de Egresos' As TIPOS_Descripcion
	,'03.- Recibo de Egresos' As Title
	,Rec.RECIB_Fecha
	,Ent.ENTID_NroDocumento
	,IsNull(Ent.ENTID_RazonSocial, Inc.VGAST_Descripcion) + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
		As RECIB_Concepto
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7), 
		TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)) As Documento
	,TMon.TIPOS_DescCorta
	,TC.TIPOC_VentaSunat
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0 As FLETE_Id
	,Via.VIAJE_Id
	,'' As ENTID_Codigo
	,Rec.RECIB_Codigo
	,Via.VIAJE_Descripcion As FLETE_Glosa
	,0 As Pendiente
	,Rec.RECIB_Fecha As Fecha
	,0 As Pago
	,Rec.RECIB_Serie
	,Rec.RECIB_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,Rec.TIPOS_CodTipoRecibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,3 As OInterno
From Transportes.TRAN_ViajesGastos As Inc
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Inc.DOCUS_Codigo And Doc.ENTID_Codigo = Inc.ENTID_CodigoProveedor
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Inc.TIPOS_CodTipoMoneda
	Inner Join Tipos As TInc On TInc.TIPOS_Codigo = Inc.TIPOS_CodTipoGasto
	Inner Join Transportes.TRAN_Recibos as Rec On Convert(Integer, IsNull(Rec.RECIB_CodReferencia, 0)) = Inc.VGAST_Id
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Left Join Transportes.TRAN_Recibos as Ref On Ref.RECIB_Codigo = Rec.RECIB_CodRecRef
		And Rec.VIAJE_Id = Inc.VIAJE_Id
	Left Join Tipos As TRef On TRef.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo
		And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
		And Caj.CAJA_Pase = 'G'
		And Caj.CAJA_Estado <> 'X'
		And Caj.PVENT_Id = @PVENT_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Convert(Date, Via.VIAJE_FecLlegada) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo = 'RCT6' 
Union All /* A Cuenta de Sueldo */
Select 3 As Orden
	,'Recibo de Egresos' As TIPOS_Descripcion
	,'03.- Recibo de Egresos' As Title
	,Rec.RECIB_Fecha
	,'' As ENTID_NroDocumento
	,RTrim(Rec.RECIB_Concepto) + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
	,TDoc.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta
	,IsNull(TC.TIPOC_VentaSunat, Convert(Decimal(14, 2), 0.00)) As TIPOC_VentaSunat
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Monto Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0 As FLETE_Id
	,Via.VIAJE_Id
	,'' As ENTID_Codigo
	,Rec.RECIB_Codigo
	,Via.VIAJE_Descripcion As FLETE_Glosa
	,0 As Pendiente
	,Rec.RECIB_Fecha As Fecha
	,0 As Pago
	,Rec.RECIB_Serie
	,Rec.RECIB_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,Rec.TIPOS_CodTipoRecibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,4 As OInterno
From Transportes.TRAN_Recibos As Rec
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X' And Caj.PVENT_Id = @PVENT_Id
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where TIPOS_CodTipoRecibo = 'RCT5'
	And Convert(Date, RECIB_Fecha) Between @FecIni And @FecFin
Union All /* Consumo de Combustible */
Select 3 As Orden
	,'Recibo de Egresos' As TIPOS_Descripcion
	,'03.- Recibo de Egresos' As Title
	,CCom.COMCO_Fecha As Fecha
	,Ent.ENTID_NroDocumento 
	,'C.C. / ' + Ent.ENTID_RazonSocial + ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') 
		As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case CCom.TIPOS_CodTipoMoneda When 'MND2' Then CCom.COMCO_Total Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case CCom.TIPOS_CodTipoMoneda When 'MND1' Then CCom.COMCO_Total Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,0 As FLETE_Id,Via.VIAJE_Id As VIAJE_Id,'' As ENTID_Codigo,'' As DOCVE_Codigo,'' As FLETE_Glosa,0 As Pendiente
	,CCom.COMCO_Fecha As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,5 As OInterno
From Transportes.TRAN_CombustibleConsumo As CCom
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = CCom.VIAJE_Id 
		And Via.VIAJE_Estado <> 'X'
		And Via.PVENT_Id = @PVENT_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = CCom.ENTID_CodigoProveedor
	Inner Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = CCom.DOCUS_Codigo And Doc.ENTID_Codigo = CCom.ENTID_CodigoProveedor
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCom.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, CCom.COMCO_Fecha, 112)
Where Convert(Date, Via.VIAJE_FecLlegada) Between @FecIni And @FecFin
	And CCom.COMCO_CCaja = 1
	And CCom.COMCO_Estado <> 'X'
Union All /* Depositos */
Select 3 As Orden
	,'Recibo de Egresos' As TIPOS_Descripcion
	,'03.- Recibo de Egresos' As Title
	,CAJA_Fecha As Fecha
	,Ent.ENTID_NroDocumento
	,'Dep. / ' + TDoc.TIPOS_DescCorta + ' / ' 
		+ TEfe.TIPOS_DescCorta 
		+ ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') 
		+ ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
		+ ' / Fecha: ' + ISNULL(CONVERT(Varchar, DPag.DPAGO_FechaVenc, 103), '') 
		+ ' / Vje : ' + RTrim(IsNull(Via.VIAJE_IdxConductor, '')) + ' - ' + IsNull(Cond.CONDU_Sigla, '') 
		+ ' / C.Fle: ' + RTrim(IsNull(Fle.FLETE_Id, ''))
		+ ' / ' + (TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7))
		+ ' / ' + Ent.ENTID_RazonSocial
	 As ENTID_RazonSocial
	,(TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) + ' (' + RTRIM(DPag.DPAGO_Id) + ')') As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,(Case Caj.CAJA_TCPorUsuario When 1 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End) As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe)
			/ 
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
			 )
		Else Convert(Decimal(14, 2), 0.00) End 
	 ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe)
			 / 
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
			 )
			* (Case Caj.CAJA_TCPorUsuario When 1 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
			/ 
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
	)) End 
	 ImpSoles
	,IsNull(Fle.FLETE_Id, DPag.DPAGO_Id) As FLETE_Id 
	,0 As VIAJE_Id
	,'' As ENTID_Codigo,'' As DOCVE_Codigo
	,'Dep. / ' + TDoc.TIPOS_DescCorta + ' / ' 
		+ TEfe.TIPOS_DescCorta 
		+ ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') 
		+ ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
		+ ' / Vje : ' + RTrim(IsNull(Via.VIAJE_IdxConductor, '')) + ' - ' + IsNull(Cond.CONDU_Sigla, '') 
		+ ' / C.Fle: ' + RTrim(IsNull(Fle.FLETE_Id, ''))
		+ ' / ' + (TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7))
		+ ' / ' + Ent.ENTID_RazonSocial
	 As FLETE_Glosa
	,0 As Pendiente
	,Caj.CAJA_FechaPago As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,6 As OInterno
--Into #Depositos
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	--Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Left Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = VVen.FLETE_Id 
	Inner Join Entidades As Ent on Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI01', 'ORI03')
	And Caj.TIPOS_CodTransaccion <> 'TPG01'
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
Union All /* Recibos de Facturas Anuladas */
Select 3 As Orden
	,'Recibo de Egresos' As Titulo
	,'03.- Recibo de Egresos' As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_Codigo As ENTID_NroDocumento
	,Ent.ENTID_RazonSocial + ' - Recibo de Egreso por Anulación de Factura /  Anulada el ' + CONVERT(VarChar(12), Ven.DOCVE_FecAnulacion, 103)  As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat) Else Convert(Decimal(14, 4), Ven.DOCVE_TotalPagar) End ImpSoles
	,0 As FLETE_Id
	,0 As VIAJE_Id
	,'' As ENTID_Codigo
	,'' As RECIB_Codigo
	,'Recibo de Egreso por Anulación de Factura' As FLETE_Glosa
	,0 As Pendiente
	,Ven.DOCVE_FecAnulacion As DOCVE_FechaDocumento
	,0 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,'' As Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
	,1 As OInterno
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	And Ven.PVENT_Id = @PVENT_Id
Where Ven.DOCVE_AnuladoCaja = 1
	And Convert(Date, Ven.DOCVE_FecAnulacion) Between @FecIni And @FecFin
	
Select * From #OtrosIngresos
Order By Orden, OInterno
--Union All
Select * From #Recibos
Order By Orden, VIAJE_Id, DOCVE_FechaDocumento, OInterno
	


GO 
/***************************************************************************************************************************************/ 

