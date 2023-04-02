USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_SaldoInicial]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_SaldoInicial] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJASS_SaldoInicial]
(
	 @FecIni DateTime
	 ,@PVENT_Id BigInt
)
As

Declare @Fec DateTime
Declare @SIni Decimal(14, 4)
Select @Fec = SINIC_Fecha, @SIni = SINIC_Importe From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'C'

Print @SIni
/* Ingresos */
/* Documentos de Venta ============================================================================================================ */
Select Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End As Ingreso
	,0.00 As Egreso
	,'Ingresos de Facturas - Normal' As Glosa
Into #Saldos
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaTransaccion) < @FecIni
	And Ven.DOCVE_Estado <> 'X'
	--And Ven.TIPOS_CodTipoDocumento <> 'CPD07'
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1 And PVENT_Id = @PVENT_Id)
Union All /* FACTURAS ANULADAS */
Select Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End As Ingreso
	,0.00 As Egreso
	,'Ingresos de Facturas Anuladas - Despues de la fecha Creacion' As Glosa
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And Ven.DOCVE_Estado = 'X'
	--And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni 
	And Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1 And PVENT_Id = @PVENT_Id)
Union All /* FACTURAS ANULADAS ANTES DE LA FECHA */
Select 0.00 As Ingreso
	,0.00 As Egreso
	,'Ingresos de Facturas - Anuladas Antes de la Fecha' As Glosa
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id	
Union All /* Ingresos en Efectivo ================================================================================================= */
Select 
	 Case Rec.TIPOS_CodTipoMoneda 
		When 'MND1' Then Rec.RECIB_Importe 
		Else Rec.RECIB_Importe * TC.TIPOC_VentaSunat
	 End ImpSoles
	,0.00
	,'Ingresos en Efectivo'
From Tesoreria.TESO_Recibos As Rec
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDRA')
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
/* Egresos */
Union All /* EGRESOS EN EFECTIVO =================================================================================================== */
Select 0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,'Egresos en Efectivo'
From Tesoreria.TESO_Recibos As Rec
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo = 'CPDRE'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* DEPOSITO ============================================================================================================= */
Select 0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End ImpSoles
	,'Depositos'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo And CDPag.PVENT_Id = @PVENT_Id
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id And DPag.PVENT_Id = @PVENT_Id 
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	--And Not DPag.TIPOS_CodTipoDocumento In ('DPG03')
	And Not Caj.TIPOS_CodTransaccion In ('TPG01', 'TPG03', 'TPG05')
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
	And Not Caj.ENTID_Codigo In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1 And PVENT_Id = @PVENT_Id)
Union All  /* DEPOSITOS ANULADOS Antes de la Fecha de Anulacion*/
Select 0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End ImpSoles
	,'Depositos Anulado - Anulados'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	And Not Caj.TIPOS_CodTransaccion In ('TPG01', 'TPG05')
	And Caj.CAJA_Estado = 'X'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_FechaAnulado) >= @FecIni
	And Caj.CAJA_AnuladoCaja = 1
	And Caj.PVENT_Id = @PVENT_Id
Union All
Select 0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else  Rec.RECIB_Importe * TC.TIPOC_VentaSunat End ImpSoles
	,'Parte del Deposito'
From Tesoreria.TESO_Recibos As Rec
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.PVENT_Id = Rec.PVENT_Id And DPag.DPAGO_Id = Rec.DPAGO_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDDE', 'CPDRA')
	And IsNull(Rec.TIPOS_CodTransaccion, '') = 'TRE02'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
	
	--And Not Caj.ENTID_Codigo In (@Excepcion1, @Excepcion2, @Excepcion3)
Union All /* RECIBOS DE FACTURAS ANULADAS ==========================================================================================*/
Select 0.00
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat) Else Convert(Decimal(14, 4), Ven.DOCVE_TotalPagar) End ImpSoles
	,' Recibos de Facturas Anuladas '
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
		And Ven.PVENT_Id = @PVENT_Id
Where Ven.DOCVE_AnuladoCaja = 1
	And Convert(Date, Ven.DOCVE_FecAnulacion) < @FecIni
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All
Select 0.00
	,Case CCh.TIPOS_CodTipoMoneda When 'MND1' Then CCp.CAJAP_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,'Recibos de Pago de Caja Chica'
From Tesoreria.TESO_CajaChicaPagos As CCp
	Inner Join Tesoreria.TESO_CajaChicaIngreso As CCh On CCh.CAJAC_Id = CCp.CAJAC_Id And CCh.PVENT_Id = @PVENT_Id
	Left Join Entidades As EntR On EntR.ENTID_Codigo = CCh.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = CCp.TIPOS_CodTipoPago
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCh.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = CCp.DOCUS_Codigo 
		And Doc.ENTID_Codigo = CCp.ENTID_Codigo
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = CCp.ENTID_Codigo
	Left Join Tipos As EntTDoc On EntTDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
where TIPOS_CodTipoPago = 'TPC01'
	And Convert(Date, CCp.CAJAP_Fecha) < @FecIni
	And CCp.PVENT_Id = @PVENT_Id
	And CCh.CAJAC_Estado <> 'X'
	And CCp.CAJAP_Estado <> 'X'

Select Sum(Ingreso) As Ingreso, Sum(Egreso) As Egreso --,'Saldo Total' As Glosas 
Into #Total From #Saldos
Union All
Select @SIni, 0.00 --, 'Saldo Inicial' 

Select Sum(IsNull(Ingreso, 0)) - Sum(IsNull(Egreso, 0)) As SaldoInicial, Sum(Ingreso) As Ingreso, Sum(Egreso) As Egreso From #Total

Select SUM(Ingreso) As Ingreso, SUM(Egreso) As Egreso, Glosa From #Saldos Group By Glosa
Union All
Select @SIni, 0.00, 'Saldo Inicial' 
Order By Glosa

Drop Table #Saldos
/**/
Select 0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End ImpSoles
	,'Depositos Anulado - Anulados'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	And Not Caj.TIPOS_CodTransaccion In ('TPG01')
	And Caj.CAJA_Estado = 'X'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Convert(Date, CAJA_FechaAnulado) >= @FecIni
	And Caj.CAJA_AnuladoCaja = 1
	And Caj.PVENT_Id = @PVENT_Id
	/**/

GO 
/***************************************************************************************************************************************/ 

exec VENT_CAJASS_SaldoInicial @FecIni='2018-01-20 00:00:00',@PVENT_Id=2