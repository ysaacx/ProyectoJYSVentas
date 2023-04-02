GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreFletesPendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreFletesPendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/07/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreFletesPendientes]
(
	@FecFin DateTime
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
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0))
		 End
	 As Pendiente
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0))
		 End
	 As Pago
	,Ven.DOCVE_FechaDocumento
	,Fle.FLETE_FecSalida
	,Fle.FLETE_FecLlegada
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Fle.FLETE_TotIngreso Else 0 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (ISNULL(Fle.FLETE_TotIngreso, Ven.DOCVE_TotalPagar)
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0)) * TC.TIPOC_VentaSunat
		 Else (ISNULL(Fle.FLETE_TotIngreso, Ven.DOCVE_TotalPagar)
			- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
			And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0))
		 End
	 As ImpSoles
	,TC.TIPOC_VentaSunat As TCambioVenta
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
Where Not Ven.ENTID_CodigoCliente In ('620100241022')
	And Convert(Date, Ven.DOCVE_FechaDocumento) <= @FecFin
	And Ven.DOCVE_Estado <> 'X'
Order By Ent.ENTID_NroDocumento, Fle.FLETE_FecLlegada, Ven.DOCVE_Codigo 

Select Rec.VIAJE_Id
	,Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End As Pendiente
	,Via.VIAJE_FecSalida, Via.VIAJE_FecLlegada
Into #Pendiente
From Tesoreria.TESO_Caja As Caj
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
	And Convert(Date,Caj.CAJA_Fecha) <= @FecFin
	And Caj.CAJA_Estado <> 'X'
Order By VIAJE_id

Select 0 As FLETE_Id			,0 As VIAJE_Id					
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes de Gastos de Viaje' As ENTID_RazonSocial		
	,'' As DOCVE_Codigo
	,'Pendientes del Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '') 
		As FLETE_Glosa
	,'Fle' As TipoDocumento
	,'Viaje: ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')  As Documento
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
Into #Pendientes
From Transportes.TRAN_Viajes As Via
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Via.VIAJE_FecSalida, 112)
Where Convert(Date, Via.VIAJE_FecLlegada) > @FecFin
	And Via.VIAJE_Id In (Select VIAJE_Id From #Pendiente)
	And (Select Sum(Pendiente) From #Pendiente Where VIAJE_Id = Via.VIAJE_Id) > 0
	
/* Fletes Pendientes por Facturar */	
Declare @FecIniFPF DateTime
Set @FecIniFPF = (Select PARMT_Valor From Parametros Where PARMT_Id = 'pg_FecIniFletes'
				And APLIC_Codigo = 'TRA' And SUCUR_Id = 1)

Select * From #Fletes
Where Pendiente > 0
Union All
Select * From #Pendientes 
Union All
Select 0 As FLETE_Id			,0 As VIAJE_Id					
	,'00000000000' As ENTID_Codigo
	,'00000000000' As ENTID_NroDocumento	
	,'Pendientes de Gastos de Viaje' As ENTID_RazonSocial		
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
From RRHH.PLAN_Pendientes As Pen
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Pen.PENDI_Fecha, 112)


Order By ENTID_RazonSocial, DOCVE_Codigo

--Select SUM(ImpSoles), ENTID_NroDocumento, ENTID_RazonSocial From #Fletes 
--Where Pendiente > 0
--Group By ENTID_NroDocumento, ENTID_RazonSocial

--Select SUM(ImpSoles) From #Fletes 
--Where Pendiente > 0




GO 
/***************************************************************************************************************************************/ 

