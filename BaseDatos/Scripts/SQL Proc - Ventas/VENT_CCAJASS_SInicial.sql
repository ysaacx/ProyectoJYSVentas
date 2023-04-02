GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_SInicial]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_SInicial] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_SInicial]
(
	 @FecIni DateTime
	,@PVENT_Id BigInt
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor from Parametros Where PARMT_Id = 'Empresa')

Declare @Excepcion1 VarChar(14) Set @Excepcion1 = '20100241022'
Declare @Excepcion2 VarChar(14) Set @Excepcion2 = '20191731434'
Declare @Excepcion3 VarChar(14) Set @Excepcion3 = '20133207482'

Declare @Fec DateTime
Declare @SIni Decimal(14, 4)
Select @Fec = SINIC_Fecha, @SIni = SINIC_Importe From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'C'

/* Ingresos */
/* Documentos de Venta ============================================================================================================*/
Select Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 4), 0.00) End As Ingreso
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 4), 0.00) End As IngresoDol
	,0.00 As Egreso
	,0.00 As EgresoDol
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End As TotalSoles
	,'Ingresos de Facturas - Normal' As Glosa
Into #Saldos
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* FACTURAS ANULADAS */
Select Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 4), 0.00) End As Ingreso
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else Convert(Decimal(14, 4), 0.00) End As IngresoDol
	,0.00 As Egreso
	,0.00 As EgresoDol
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End As TotalSoles
	,'Ingresos de Facturas - Despues de la fecha' As Glosa
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
	And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* FACTURAS ANULADAS ANTES DE LA FECHA */
Select 0.00 As Ingreso
	,0.00 As IngresoDol
	,0.00 As Egreso
	,0.00 As EgresoDol
	,0.00 As TotalSoles
	,'Ingresos de Facturas - Anuladas Antes de la Fecha' As Glosa
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id	
Union All /* Ingresos en Efectivo ================================================================================================= */
Select Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End 
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End 
	,0.00
	,0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Rec.RECIB_Importe * TC.TIPOC_VentaSunat End 
	,'Ingresos en Efectivo'
From Tesoreria.TESO_Recibos As Rec
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo = 'CPDRI'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
/* Egresos */
Union All /* Egresos en efectivo =================================================================================================== */
Select 0.00
	,0.00
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End 
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End 
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Rec.RECIB_Importe * TC.TIPOC_VentaSunat End 
	,'Egresos en Efectivo'
From Tesoreria.TESO_Recibos As Rec
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo = 'CPDRE'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* Deposito ============================================================================================================= */
Select 0.00
	,0.00
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else 0.00 End
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Caj.CAJA_Importe Else 0.00 End
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
	)) End
	,'Depositos'
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
	Left Join Entidades As Ent on Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	And Caj.TIPOS_CodTransaccion <> 'TPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
	And Not Caj.ENTID_Codigo In (@Excepcion1, @Excepcion2, @Excepcion3)
Union All /* Recibos de Facturas Anuladas ==========================================================================================*/
Select 0.00
	,0.00
	,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0 End 
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat Else 0 End
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

Select Sum(Ingreso) As Ingreso
	,Sum(IngresoDol) As IngresoDol
	, Sum(Egreso) As Egreso 
	, Sum(EgresoDol) As EgresoDol 
	--,'Saldo Total' As Glosas 
Into #Total 
From #Saldos
Union All
Select @SIni, 0.00, 0.00, 0.00 --, 'Saldo Inicial' 

Select Sum(IsNull(Ingreso, 0)) - Sum(IsNull(Egreso, 0)) As SaldoInicial
	,Sum(IsNull(IngresoDol, 0)) - Sum(IsNull(EgresoDol, 0)) As SaldoInicialDol
	,Sum(Ingreso) As Ingreso
	,Sum(IngresoDol) As IngresoDol
	,Sum(Egreso) As Egreso
	,Sum(EgresoDol) As EgresoDol
From #Total

Select SUM(Ingreso), SUM(IngresoDol), SUM(Egreso), SUM(EgresoDol), Glosa From #Saldos Group By Glosa
Union All
Select @SIni, 0.00, 0.00, 0.00, 'Saldo Inicial' 

Drop Table #Saldos
	


GO 
/***************************************************************************************************************************************/ 

