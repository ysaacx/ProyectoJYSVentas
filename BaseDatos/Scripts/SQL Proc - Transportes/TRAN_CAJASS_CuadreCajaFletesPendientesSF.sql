GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaFletesPendientesSF]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaFletesPendientesSF] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/10/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaFletesPendientesSF]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_Codigo VarChar(14) = Null
)
As

Select Sum(Fle.FLETE_TotIngreso) As Ingreso, 0.00 As Egreso, ' Ingresos' As Glosa
Into #Saldos
From Transportes.TRAN_Fletes As Fle
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
Where Convert(Date, Fle.FLETE_FecSalida) < @FecIni
	And Not Fle.ENTID_Codigo In ('20100241022')
	And Fle.ENTID_Codigo = IsNull(@ENTID_Codigo, Fle.ENTID_Codigo)
Union
Select 0.00, Sum(CAJA_Importe),'Egresos'
From Tesoreria.TESO_Caja As Caj
Where TIPOS_CodTipoOrigen = 'ORI01'
	And Not Caj.TIPOS_CodTransaccion = 'TPG01'
	And Convert(Date, CAJA_Fecha) < @FecIni

Select Sum(Ingreso) - Sum(Egreso) As  FLETE_TotIngreso From #Saldos

Select 0 As Orden
	,Fle.FLETE_Id					,Fle.VIAJE_Id						,Fle.ENTID_Codigo
	,Ent.ENTID_NroDocumento			,Ent.ENTID_RazonSocial				,Null As DOCVE_Codigo
	,Fle.FLETE_TotIngreso
	,IsNull(Via.VIAJE_Descripcion, '') + ' || ' + IsNull(Fle.FLETE_Glosa, '') As FLETE_Glosa	
	,Null As Documento
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	 ), 0)) As Pendiente
	,Fle.FLETE_FecSalida As DOCVE_FechaDocumento
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	 ), 0)
	 As Pago
	,Fle.FLETE_FecSalida
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
Where Not Fle.ENTID_Codigo In ('20100241022')
	And Convert(Date, Fle.FLETE_FecSalida) Between @FecIni And @FecFin
	And Fle.ENTID_Codigo = IsNull(@ENTID_Codigo, Fle.ENTID_Codigo)
	And Not Fle.FLETE_Id In (Select FLETE_Id From Transportes.TRAN_ViajesVentas As VV Where VV.VIAVE_Estado <> 'X')
	And Fle.FLETE_Estado <> 'X'
Order By Fle.FLETE_Id 

Select * From #Saldos



GO 
/***************************************************************************************************************************************/ 

