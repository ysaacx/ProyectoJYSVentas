GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_REPORSS_CuadreCaja_FleFacturados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_FleFacturados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/05/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_REPORSS_CuadreCaja_FleFacturados]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As

/* Fletes Facturados */

Select 11 As Orden
	,Convert(VarChar(50), 'Fletes Facturados') As Titulo
	,Convert(VarChar(50), '11.- Fletes Facturados') As Title
	,Fle.FLETE_FecSalida As Fecha
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial --+ ' - Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
		+ ' - ' + Via.VIAJE_Descripcion
		As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, 'Fle.' + Right('000' + RTrim(Fle.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Fle.FLETE_Id), 7))  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Fle.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Fle.TIPOS_CodTipoMoneda When 'MND1' Then Fle.FLETE_TotIngreso Else Fle.FLETE_TotIngreso * TCam.TIPOC_VentaSunat End ImpSoles
	,Fle.FLETE_Id
	,Fle.VIAJE_Id
	,Fle.ENTID_Codigo
	,Ven.DOCVE_Codigo
	,IsNull(Via.VIAJE_Descripcion, '') + ' || ' + IsNull(Fle.FLETE_Glosa, '') As FLETE_Glosa	
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	 ), 0)) As Pendiente
	,Ven.DOCVE_FechaDocumento
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	 ), 0)
	 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,'' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
Into #FFacturados
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Fle.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Fle.FLETE_FecLlegada, 112)
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
		And Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TCam On Convert(VarChar, TCam.TIPOC_Fecha, 112) = Convert(VarChar, Fle.FLETE_FechaTransaccion, 112)
Where Not Fle.ENTID_Codigo In ('620100241022')
	And Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin	

Select 11 As Orden
	,Convert(VarChar(50), 'Fletes Facturados') As Titulo
	,Convert(VarChar(50), '11.- Fletes Facturados') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,'-' As ENTID_NroDocumento
	,'ANULADO' As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		  As Documento
	,'-' As Moneda
	,0.00 As TCambioVenta
	,0.00 As ImpDolares
	,0.00 As ImpSoles
	,0 As FLETE_Id
	,0 As VIAJE_Id
	,'-' As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,'ANULADO' As FLETE_Glosa	
	,0.00 As Pendiente
	,Ven.DOCVE_FechaDocumento
	,0.00 As Pago
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,'-' Recibo
	,Convert(Decimal(15, 4), 0.00) As SumImpDolares
	,Convert(Decimal(15, 4), 0.00) As SumImpSoles
Into #FletesX
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado = 'X'

Select * From #FFacturados
Union
Select * From #FletesX
Order By DOCVE_Codigo



GO 
/***************************************************************************************************************************************/ 

