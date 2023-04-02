GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaIngresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaIngresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaIngresos]
(
	@FecFin As DateTime
	,@ENTID_Codigo VarChar(14) = Null
)
As

-- Ingresos

Select 0 As Orden
	,Fle.FLETE_Id					,Fle.VIAJE_Id						,Fle.ENTID_Codigo
	,Ent.ENTID_NroDocumento			,Ent.ENTID_RazonSocial				,Ven.DOCVE_Codigo
	,Fle.FLETE_TotIngreso
	,Via.VIAJE_Descripcion + ' || ' + Fle.FLETE_Glosa As FLETE_Glosa	
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
		And Convert(VarChar, CAJA_Fecha) Between '01-29-2012' And @FecFin
	 ), 0)) As Pendiente
	,Ven.DOCVE_FechaDocumento
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
Where Convert(Date, IsNull(Ven.DOCVE_FechaDocumento, Fle.FLETE_FecSalida)) Between '01-29-2012' And @FecFin
	And Not Fle.ENTID_Codigo In ('620100241022', '620191731434')
	And Fle.ENTID_Codigo = IsNull(@ENTID_Codigo, Fle.ENTID_Codigo)
--Order By Ven.DOCVE_Codigo
Union
Select 1 As Orden
	,0, Caj.CAJA_Id, ENTID_Codigo, '', CAJA_Glosa, '', CAJA_Importe,CAJA_Glosa, '', 0
	,Caj.CAJA_Fecha
From Tesoreria.TESO_Caja As Caj Where Caj.TIPOS_CodTipoDocumento = 'CPDIN'
	And Convert(Date, Caj.CAJA_Fecha) Between '01-29-2012' And @FecFin
Union 
Select 2 As Orden
	,0, 0, ENTID_Codigo, '', CAJA_Glosa, '', CAJA_Importe
	,Via.VIAJE_Descripcion 
	, ''
	,(Case When (			
		Select Sum(Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End) 
		From Tesoreria.TESO_Caja As Caj
			Inner Join Transportes.TRAN_Recibos As RRec On RRec.RECIB_Codigo = Caj.CAJA_NroDocumento
			Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
			Inner Join Transportes.TRAN_Viajes As VVia On VVia.VIAJE_Id = RRec.VIAJE_Id
			Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
			Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
			Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
			Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
		Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
			And Convert(Date,Caj.CAJA_Fecha) Between '01-29-2012' And @FecFin
			And VVia.Viaje_Id = Rec.Viaje_Id
		Group By RRec.VIAJE_Id	
	) > 0 Then 0 Else CAJA_Importe End) As Pendiente
	,Caj.CAJA_Fecha
From Tesoreria.TESO_Caja As Caj 
	Inner Join Transportes.TRAN_Recibos As Rec On Rec.RECIB_Codigo = Caj.CAJA_NroDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Rec.VIAJE_Id
Where Caj.TIPOS_CodTipoDocumento = 'CPDTR'
	And Convert(Date, Caj.CAJA_Fecha) Between '01-29-2012' And @FecFin
	And (Case When (			
		Select Sum(Case CAJA_Pase When 'P' Then Caj.CAJA_Importe Else (Caj.CAJA_Importe*-1) End) 
		From Tesoreria.TESO_Caja As Caj
			Inner Join Transportes.TRAN_Recibos As RRec On RRec.RECIB_Codigo = Caj.CAJA_NroDocumento
			Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
			Inner Join Transportes.TRAN_Viajes As VVia On VVia.VIAJE_Id = RRec.VIAJE_Id
			Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
			Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
			Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
			Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = VCond.VEHIC_Id
		Where Caj.TIPOS_CodTipoDocumento In ('CPDGV', 'CPDTR')
			And Convert(Date,Caj.CAJA_Fecha) Between '01-29-2012' And @FecFin
			And VVia.Viaje_Id = Rec.Viaje_Id
		Group By RRec.VIAJE_Id	
	) > 0 Then 0 Else CAJA_Importe End) > 0
Order By Orden, DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

