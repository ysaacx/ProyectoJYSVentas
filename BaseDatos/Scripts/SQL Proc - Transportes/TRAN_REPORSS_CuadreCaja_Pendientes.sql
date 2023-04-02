GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_CuadreCaja_Pendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_Pendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_Pendientes]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

/* Pendientes */

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
Order By VIAJE_id

Select 4 As Orden
	,'Gastos Pendientes' As Titulo
	,'04.- Gastos Pendientes' As Title
	,Via.VIAJE_FecSalida As Fecha
	,'' As ENTID_NroDocumento
	,'Pendientes del Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') 
		As ENTID_RazonSocial
	,Right('0000000' + RTrim(Via.VIAJE_Id), 7) As Documento
	,'S/.' As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Convert(Decimal(14, 2), 0.00) ImpDolares
	,(Select Sum(Pendiente) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) As ImpSoles
	,0 As FLETE_Id,Via.VIAJE_Id As VIAJE_Id,'' As ENTID_Codigo,'' As DOCVE_Codigo,'' As FLETE_Glosa,0 As Pendiente
	,Via.VIAJE_FecSalida As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
Into #Pendientes
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Via.VIAJE_FecSalida, 112)
Where Convert(Date, Via.VIAJE_FecLlegada) > @FecFin
	And Via.VIAJE_Id In (Select VIAJE_Id From #Pendiente)
	And (Select Abs(Sum(Pendiente)) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) > 0
Union All
Select 4 As Orden
	,'Gastos Pendientes' As Titulo
	,'04.- Gastos Pendientes' As Title
	,Pen.PENDI_Fecha As Fecha
	,'' As ENTID_NroDocumento
	,'Pendientes del Viaje: ' + Pen.PENDI_Concepto 
		As ENTID_RazonSocial
	,'Pen: ' + RTrim(PENDI_Id) + ' / ' + IsNull(RTrim(Pen.PENDI_Numero), '')  As Documento
	,'S/.' As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Convert(Decimal(14, 2), 0.00) ImpDolares
	,Pen.PENDI_Importe As Pendiente
	,0 As FLETE_Id,0 As VIAJE_Id,'' As ENTID_Codigo,'' As DOCVE_Codigo,'' As FLETE_Glosa,0 As Pendiente
	,Pen.PENDI_Fecha As DOCVE_FechaDocumento
	,0 As Pago
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
From RRHH.PLAN_Pendientes As Pen
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Pen.PENDI_Fecha, 112)

--/* Fletes Pendientes por Facturar */	
--Declare @FecIniFPF DateTime
--Set @FecIniFPF = (Select PARMT_Valor From Parametros Where PARMT_Id = 'pg_FecIniFletes'
--				And APLIC_Codigo = 'TRA' And SUCUR_Id = 1)

Select * From #Pendientes
Order By Orden, VIAJE_Id, Fecha

/* Cargar Saldo Inicial */
Exec TRAN_REPORSS_SaldoInicial @FecIni, @PVENT_Id


GO 
/***************************************************************************************************************************************/ 

