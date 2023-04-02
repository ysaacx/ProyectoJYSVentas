GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_PendienteFletes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_PendienteFletes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_PendienteFletes]
(
	@FecIni As DateTime
	,@FecFin As DateTime
	,@ENTID_Codigo VarChar(14) = Null
)
As

Select Fle.FLETE_Id
	,Fle.VIAJE_Id
	,Fle.ENTID_Codigo
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial
	,Via.VIAJE_Descripcion + ' || ' + Fle.FLETE_Glosa As FLETE_Glosa
	,Fle.FLETE_TotIngreso
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
		Where CAJA_NroDocumento = IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
			And Convert(Date, CAJA_Fecha) < @FecFin
			And CAJA_Estado <> 'X'
	 ), 0)
	 As Pago
	,IsNull((Select Top 1 TPag.TIPOS_Descripcion From Tesoreria.TESO_Caja As Caj
		Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	  Where CAJA_NroDocumento = IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
		And Convert(Date, CAJA_Fecha) < @FecFin
		And CAJA_Estado <> 'X'
	 ), '')
	 As TipoTransaccion
	,(Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	  Where CAJA_NroDocumento = IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
		And CAJA_Estado <> 'X'
	 ), 0)) As Pendiente
	,Via.VIAJE_FecSalida As FecLlegada
	,Via.VIAJE_FecLlegada As FecSalida
	,Fle.FLETE_FecSalida
	,Fle.FLETE_FecLlegada
	,IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7)) As DOCVE_Codigo
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Fle.FLETE_PesoEnTM
	--,*
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
Where Convert(Date, Via.VIAJE_FecLlegada) Between @FecIni And @FecFin
	And Not Fle.ENTID_Codigo = '620100241022'
	And Fle.ENTID_Codigo = IsNull(@ENTID_Codigo, Fle.ENTID_Codigo)
	--And (Fle.FLETE_TotIngreso - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	--  Where CAJA_NroDocumento = IsNull(Ven.DOCVE_Codigo, Right('0000000'+RTrim(Fle.FLETE_Id), 7))
	-- ), 0)) <> 0
Order By VIAJE_Id -- Fle.FLETE_FecLlegada


GO 
/***************************************************************************************************************************************/ 

