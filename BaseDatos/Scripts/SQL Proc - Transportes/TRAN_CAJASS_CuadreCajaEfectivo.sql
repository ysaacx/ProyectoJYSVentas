GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaEfectivo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaEfectivo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaEfectivo]
(
	 @FecIni As DateTime
	,@FecFin As DateTime
	--,@ENTID_Codigo VarChar(14) = Null
)
As

-- Anterior
Select Sum(IsNull(Rec.RECIB_Monto, 0)) As Egreso, Convert(Decimal, 0.00) As Ingreso, 'Gastos Viaje' As Obs
Into #Anterior
From Transportes.TRAN_Recibos As Rec 
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X'
Where CONVERT(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.TIPOS_CodTipoRecibo = 'RCT3'
	And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
	And Rec.RECIB_Efectivo = 0
	And IsNull(Rec.RECIB_Estado, 'I') <> 'X'
Union All
Select 0.00, Sum(IsNull(Rec.RECIB_Monto, 0)), 'Ingresos/Egresos Efectivo'
From Transportes.TRAN_Recibos  As Rec
Where CONVERT(Date, Rec.RECIB_Fecha) < @FecIni
	And TIPOS_CodTipoRecibo = 'RCT1'
	And Rec.RECIB_Efectivo = 0
	And IsNull(Rec.RECIB_Estado, 'I') <> 'X'
Union All
Select Sum(Case TIPOS_CodTipoDocumento When 'CPDEG' Then IsNull(CAJA_Importe, 0) Else Convert(Decimal, 0.00) End)
	,Sum(Case TIPOS_CodTipoDocumento When 'CPDIN' Then IsNull(CAJA_Importe, 0) Else Convert(Decimal, 0.00) End)
	,'Caja'
From Tesoreria.TESO_Caja As Caj
	Left Join Tipos As T On T.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento And Rec.RECIB_CodReferencia = Caj.CAJA_Id
		And Rec.RECIB_Efectivo = 0
		And IsNull(Rec.RECIB_Estado, 'I') <> 'X'
Where TIPOS_CodTipoOrigen = 'ORI05'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Caj.CAJA_Estado <> 'X'
Union All
Select 0.00
	,Sum(CAJA_Importe)
	,'Cancelación de Fletes'
From Tesoreria.TESO_Caja As Caj
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Inner Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = VVen.FLETE_Id
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Fle.ENTID_Codigo
Where TIPOS_CodTipoOrigen In ('ORI01', 'ORI03')
	And Caj.TIPOS_CodTransaccion = 'TPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Caj.CAJA_Estado <> 'X'
	And CAJA_Serie <> '000'
Union All
Select PCAJA_Importe
	,0.00
	,'Prestamos de Caja'
From Tesoreria.TESO_PendientesCaja As Caj
Where Convert(Date, PCAJA_Fecha) < @FecIni
	And Caj.PCAJA_Estado <> 'X'
	And Caj.PCAJA_Efectivo = 1
Union All
Select 
	0.00
	,PCCAJ_Importe
	,'Cancelacion de Caja'
From Tesoreria.TESO_PendientesCancelacion As Caj
Where Caj.PCCAJ_Estado <> 'X'
	And Caj.PCCAJ_Efectivo = 1
	And Convert(Date, Caj.PCCAJ_Fecha) < @FecIni

	
Select SUM(IsNull(Egreso, 0)) As Egreso
	, SUM(IsNull(Ingreso, 0)) As Ingreso
	, SUM(IsNull(Ingreso, 0)) - SUM(IsNull(Egreso, 0)) As VGAST_Monto 
From #Anterior

/*********************************************************************************************************************/

Select Rec.VIAJE_Id
	,Rec.RECIB_Fecha As VGAST_FechaViaje
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') As TIPOS_Moneda
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,'Gastos de Viaje / Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') + ' / '
		As VGAST_Descripcion
	,Rec.RECIB_Concepto As VIAJE_Descripcion
	,Convert(Decimal, 0.00) As Ingreso
	,Rec.RECIB_Monto As Egreso
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Rec.RECIB_Monto As VGAST_Monto
	,'' As ENTID_NroDocumento
	,'' As ENTID_RazonSocial
	,'' As FLETE_Glosa
From Transportes.TRAN_Recibos As Rec 
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Rec.RECIB_Codigo And Caj.CAJA_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where CONVERT(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo = 'RCT3'
	And Caj.TIPOS_CodTipoDocumento = 'CPDGV'
	And Rec.RECIB_Efectivo = 0
Union All -- Vueltos
Select Rec.VIAJE_Id
	,Rec.RECIB_Fecha
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') As TIPOS_Moneda
	,TRec.TIPOS_DescCorta + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,'Ingresos / Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
	,Rec.RECIB_Concepto
	,Rec.RECIB_Monto
	,Convert(Decimal, 0.00)
	,Via.VIAJE_IdxConductor
	,Cond.CONDU_Sigla
	,Convert(Decimal, 0.00) As VGAST_Monto
	,'' 
	,''
	,'' 
From Transportes.TRAN_Recibos  As Rec
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
Where CONVERT(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And TIPOS_CodTipoRecibo = 'RCT1'
	And Rec.RECIB_Efectivo = 0
Union All
Select 0
	,CAJA_Fecha
	,T.TIPOS_Descripcion
	,RTrim(CAJA_Id)
	,Caj.CAJA_Glosa
	,'Proceso en Caja'
	,Case TIPOS_CodTipoDocumento When 'CPDIN' Then IsNull(CAJA_Importe, 0) Else 0.00 End
	,Case TIPOS_CodTipoDocumento When 'CPDEG' Then IsNull(CAJA_Importe, 0) Else 0.00 End
	,Convert(Decimal, 0.00)
	,'CAJA'
	,Convert(Decimal, 0.00) As VGAST_Monto
	,''
	,''
	,''
From Tesoreria.TESO_Caja As Caj
	Left Join Tipos As T On T.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
Where TIPOS_CodTipoOrigen = 'ORI05'
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
Union All
Select Via.VIAJE_Id
	,CAJA_Fecha
	,'Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '') As TIPOS_Moneda
	,RTrim(CAJA_Id)
	,Caj.CAJA_Glosa
	,'Cancelación en Caja / Viaje Nro: ' + RTrim(Via.VIAJE_IdxConductor) + ' ' + IsNull(Cond.CONDU_Sigla, '')
	,CAJA_Importe
	,0.00
	,Convert(Decimal, 0.00)
	,'CAJA'
	,Convert(Decimal, 0.00) As VGAST_Monto
	,Cli.ENTID_NroDocumento
	,Cli.ENTID_RazonSocial
	,Fle.FLETE_Glosa
From Tesoreria.TESO_Caja As Caj
	Left Join Tipos As T On T.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_ViajesVentas As VVen On VVen.DOCVE_Codigo = Ven.DOCVE_Codigo
	Inner Join Transportes.TRAN_Fletes As Fle On Fle.FLETE_Id = VVen.FLETE_Id
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id And Via.VIAJE_Estado <> 'X'
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Fle.ENTID_Codigo
Where TIPOS_CodTipoOrigen In ('ORI01', 'ORI03')
	And Caj.TIPOS_CodTransaccion = 'TPG01'
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
	And CAJA_Serie <> '000'
Union All
Select 0
	,PCAJA_Fecha
	,'Egreso en Efectivo'
	,RTrim(PCAJA_Id)
	,Caj.PCAJA_Glosa
	,'Prestamo de Caja'	
	,0.00
	,PCAJA_Importe
	,Convert(Decimal, 0.00)
	,'CAJA'
	,Convert(Decimal, 0.00) As VGAST_Monto
	,Null
	,Null
	,Null
From Tesoreria.TESO_PendientesCaja As Caj
Where Convert(Date, PCAJA_Fecha) Between @FecIni And @FecFin
	And Caj.PCAJA_Estado <> 'X'
	And Caj.PCAJA_Efectivo = 1
Union All
Select 0
	,Caj.PCCAJ_Fecha
	,'Ingreso en Efectivo'
	,RTrim(PCAJA_Id)
	,Caj.PCCAJ_Glosa
	,'Pagos de Prestamos de Caja'	
	,PCCAJ_Importe
	,0.00
	,Convert(Decimal, 0.00)
	,'CAJA'
	,Convert(Decimal, 0.00) As VGAST_Monto
	,Null
	,Null
	,Null
From Tesoreria.TESO_PendientesCancelacion As Caj
Where Convert(Date, PCCAJ_Fecha) Between @FecIni And @FecFin
	And Caj.PCCAJ_Estado <> 'X'
	And Caj.PCCAJ_Efectivo = 1
Order By VIAJE_Id , VIAJE_IdxConductor, TIPOS_Moneda
/*==============================================================================================*/
--Select * From #Gastos

--Select SUM(IsNull(Egreso, 0)) As Egreso
--	, SUM(IsNull(Ingreso, 0)) As Ingreso
--	, SUM(IsNull(Ingreso, 0)) - SUM(IsNull(Egreso, 0))
--From #Gastos

Select * From #Anterior


GO 
/***************************************************************************************************************************************/ 

