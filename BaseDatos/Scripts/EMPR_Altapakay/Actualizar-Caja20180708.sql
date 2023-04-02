
SELECT *  FROM Tesoreria.TESO_Recibos WHERE CONVERT(DATE, RECIB_Fecha) = '2018-07-05'

--8727047.84
UPDATE Tesoreria.TESO_Recibos SET RECIB_Estado = 'I', RECIB_Fecha = '2018-07-04', RECIB_MotivoAnulacion = NULL, RECIB_Importe = 8686453.07 WHERE RECIB_Codigo = 'RE0010000022'

UPDATE Tesoreria.TESO_Recibos Set  RECIB_Codigo = 'RE0010000035'
,RECIB_Estado = 'X'
,RECIB_Efectivo = 0
,RECIB_AnuladoCaja = 1
,RECIB_MotivoAnulacion = 'Usuario: SISTEMAS 
 - Fecha: 08/07/2018 20:44 
 Motivo: ERROR EN INGRESO 
 Maquina: YSAACX-LP-169.254.17.49'
,RECIB_UsrMod = '00000000'
,RECIB_FecMod = '2018-07-08 20:44:28.027'
 Where   ISNULL(RECIB_Codigo, '') = 'RE0010000035'

 INSERT INTO Tesoreria.TESO_Recibos( RECIB_Codigo
,RECIB_Fecha
,TIPOS_CodTipoMoneda
,TIPOS_CodTipoRecibo
,PVENT_Id
,RECIB_Importe
,RECIB_Concepto
,ENTID_Codigo
,RECIB_Serie
,RECIB_Numero
,RECIB_Efectivo
,RECIB_AnuladoCaja
,RECIB_UsrCrea
,RECIB_FecCrea
) VALUES ( 'RE0010000036'
,'2018-07-05 20:58:30.000'
,'MND1'
,'CPDRE'
,1
,63545.3
,'ENTREGA DE EFECTIVO DECAJA'
,'41615854'
,'001'
,36
,0
,0
,'00000000'
,'2018-07-08 21:00:32.323'
)


GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_REPOSS_MovimientoEfectivo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As


--Declare @FecIni DateTime Set @FecIni = '2013-06-24 00:00:00'
--Declare @FecFin DateTime Set @FecFin = '2013-06-26 00:00:00'

/* Ingreso de Efectivo Por Cancelación de Documento de venta */
Select TPag.TIPOS_DescCorta + ' ' + Right('000' + RTRIM(Doc.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Doc.DPAGO_Id), 7) As DocCaja
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Doc.TIPOS_CodTipoMoneda
	,Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	,Convert(Decimal(14, 4), 0.00) As EImpDolares
	,Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles	
	,Convert(Decimal(14, 4), 0.00) As EImpSoles
	,'Cancelación de Documento de Venta : '
	   + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
	   + ' / Fecha Fac.: ' + Convert(VarChar(10), Ven.DOCVE_FechaDocumento, 103)	 
	   + ' / ' + TMonVen.TIPOS_DescCorta + ' ' + Convert(VarChar(20), CONVERT(money, Ven.DOCVE_TotalPagar), 1)
	   + ' / R.U.C. o D.N.I.: ' + Ven.ENTID_CodigoCliente
	   + ' / Raz. Soc.: ' 
	   + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) 
	 As DPAGO_Glosa
	,Convert(Date, Doc.DPAGO_Fecha) As DPAGO_Fecha
	,TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As DocVenta
	,Ven.ENTID_CodigoCliente 
	,IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
from Tesoreria.TESO_DocsPagos As Doc
	Inner Join Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND CAJ.CAJA_Estado <> 'X'
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
	Left Join Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
Where Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01')-- = 'DPG01'
	--And Convert(Date, Doc.DPAGO_Fecha) Between @FecIni And @FecFin
   And Convert(Date, Caj.CAJA_Fecha) Between @FecIni And @FecFin
	And Doc.PVENT_Id = @PVENT_Id
Union All /* Egreso en Efectivo por Cancelacion de Documentos */
Select TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
	,Mon.TIPOS_DescCorta 
	,Rec.TIPOS_CodTipoMoneda
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then 'Egreso en Efectivo Para Cancelación de Documento' Else 'Ingreso en Efectivo' End + '  / Responsable: ' 
	 + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
	 + ' / Glosa: ' + Rec.RECIB_Concepto
	 + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
				+ ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
		, '')
	 As Detalle
	,Rec.RECIB_Fecha
	,'' As DocVenta
	,'' As ENTID_CodigoCliente 
	,'' As ENTID_RazonSocial
From Tesoreria.TESO_Recibos As Rec
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha)  Between @FecIni And @FecFin
	--And TIPOS_CodTipoRecibo In 'CPDRE'
	And Rec.RECIB_Estado <> 'X'	
Union All /* Egresos por Prestamo de Efectivo */
Select 'PCaj ' + Right('000' + RTRIM(CCI.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CCI.CAJAC_Id), 7)
	,Mon.TIPOS_DescCorta 
	,CCI.TIPOS_CodTipoMoneda
	,0.00
	,Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	,0.00
	,Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	,'Pendiente de Caja Chica ' 
	 + ' / Responsable: ' + Ent.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial
	 + ' / Glosa: ' + CCI.CAJAC_Detalle
	 As Detalle
	,CCI.CAJAC_Fecha
	,'' As DocVenta
	,'' As ENTID_CodigoCliente 
	,'' As ENTID_RazonSocial
From Tesoreria.TESO_CajaChicaIngreso As CCI
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
	Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where Convert(Date, CCI.CAJAC_Fecha)  Between @FecIni And @FecFin
	And CCI.CAJAC_Estado <> 'X'
Union All /* Ingreso de las devoluciones en Efectivo */
Select 'VCaj ' + Right('000' + RTRIM(CCP.PVENT_Id), 3) + '-' + Right('00000' + RTrim(CCP.CAJAC_Id), 4) + Right('00' + RTrim(CCP.CAJAP_Item), 2)
	,Mon.TIPOS_DescCorta
	,CCI.TIPOS_CodTipoMoneda
	,0.00
	,0.00
	,CCP.CAJAP_Importe
	,0.00
	,'Devolución de Efectivo a Caja Chica'
	 --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
	 + IsNull(' / Glosa: ' + CCP.CAJAP_Descripcion, '')
	 + IsNull(' / Devolución de: ' + CCI.CAJAC_Detalle, '')
	 + IsNull(' / Responsable: ' + Ent.ENTID_RazonSocial, '')
	 As Detalle
	,CCP.CAJAP_Fecha
	,'' As DocVenta
	,'' As ENTID_CodigoCliente 
	,'' As ENTID_RazonSocial
From Tesoreria.TESO_CajaChicaPagos As CCP
	Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
	Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where CCP.TIPOS_CodTipoPago = 'TPC02'
	And Convert(Date, CCP.CAJAP_Fecha)  Between @FecIni And @FecFin
	And CCP.CAJAP_Estado <> 'X'
ORDER By DPAGO_Fecha, DocVenta
--UNION
--Select 'SENC ' + Right('000' + RTRIM(SENC.SENCI_Id), 3)
--	, 'S/'
--   , 'MND1'	
--	,0.00
--	,0.00
--	,SENC.SENCI_Importe
--	,0.00
--	,'Sencillo de Caja'
--	 --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
--	 + 'Glosa: Sencillo de Caja'
--	 As Detalle
--	, SENC.SENCI_Fecha
--	,'' As DocVenta
--	,'' As ENTID_CodigoCliente 
--	,'' As ENTID_RazonSocial
--From Tesoreria.TESO_Sencillo As SENC
--Where Convert(Date, SENC.SENCI_Fecha) Between @FecIni And @FecFin AND SENC.PVENT_Id = @PVENT_Id
--ORDER By DPAGO_Fecha, DocVenta


/*##########################################################################################################################*/
/* Calculo de Sencillo Inicial */
/* Ingreso de Efectivo por Cancelación de Facturas */
Select Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	,CONVERT(Decimal(14, 4), 0.00) As EImpDolares
	,Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	,CONVERT(Decimal(14, 4), 0.00) As EImpSoles
	,'Ingreso de Efectivo por Cancelación de Facturas' As Glosa
Into #Inicial
from Tesoreria.TESO_DocsPagos As Doc
	Inner Join Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND CAJ.CAJA_Estado <> 'X'
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
	Left Join Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
Where Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01') --Doc.TIPOS_CodTipoDocumento = 'DPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni
	And Doc.PVENT_Id = @PVENT_Id
Union All /* Egreso en Efectivo por Cancelacion de Documentos */
Select 
	 Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
	,'Egreso en Efectivo por Cancelacion de Documentos' As Glosa
From Tesoreria.TESO_Recibos As Rec
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And Rec.RECIB_Estado <> 'X'	
Union All /* Egresos por Prestamo de Efectivo */
Select 0.00
	,Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	,0.00
	,Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	,'Egresos por Prestamo de Efectivo' As Glosa
From Tesoreria.TESO_CajaChicaIngreso As CCI
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
	Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where Convert(Date, CCI.CAJAC_Fecha) < @FecIni
	And CCI.CAJAC_Estado <> 'X'
Union All /* Ingreso de las devoluciones en Efectivo */
Select 0.00
	,0.00
	,CCP.CAJAP_Importe
	,0.00
	,'Ingreso de las devoluciones en Efectivo' As Glosa
From Tesoreria.TESO_CajaChicaPagos As CCP
	Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
	Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where CCP.TIPOS_CodTipoPago = 'TPC02'
	And Convert(Date, CCP.CAJAP_Fecha) < @FecIni
	And CCP.CAJAP_Estado <> 'X'
Union All /* Saldo Inicial */
Select Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
	,0.00
	,Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
	,0.00
	,'Saldo Inicial ' As Glosa
From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

--Select * From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial From #Inicial

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa From #Inicial Group By Glosa



GO 