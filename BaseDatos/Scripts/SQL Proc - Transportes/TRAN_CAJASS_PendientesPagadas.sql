GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_PendientesPagadas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_PendientesPagadas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_PendientesPagadas]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As

Select Fle.FLETE_Id
	,Fle.VIAJE_Id						
	,Fle.ENTID_Codigo
	,Ent.ENTID_NroDocumento			,Ent.ENTID_RazonSocial
	,Fle.FLETE_TotIngreso
	,Sum(CAJA_Importe) As Pago
	,Fle.FLETE_TotIngreso - Sum(CAJA_Importe) As Pendiente
	,IsNull(Via.VIAJE_Descripcion, '') + ' || ' + IsNull(Fle.FLETE_Glosa, '') As FLETE_Glosa	
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Fle.FLETE_FecSalida
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
Where TIPOS_CodTipoOrigen = 'ORI01'
	And Not Caj.TIPOS_CodTransaccion = 'TPG01'
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
Group By Fle.FLETE_Id,Fle.VIAJE_Id,Fle.ENTID_Codigo,Fle.FLETE_TotIngreso
	,Via.VIAJE_Descripcion, Fle.FLETE_Glosa,Fle.FLETE_FecSalida
	,TDoc.TIPOS_DescCorta, Ven.DOCVE_Serie, Ven.DOCVE_Numero
	,Ent.ENTID_NroDocumento, Ent.ENTID_RazonSocial
--Select * From Tipos Where TIPOS_Codigo like '%TPG%'


GO 
/***************************************************************************************************************************************/ 

