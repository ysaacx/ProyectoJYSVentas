GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_FLETESS_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_FLETESS_UnReg] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_FLETESS_UnReg]
(
	@ENTID_Codigo CodEntidad
)

AS

	Select Ven.DOCVE_Codigo
		,Fle.FLETE_TotIngreso
		,(Select Sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where CAJA_NroDocumento = Right('0000000'+RTrim(Fle.FLETE_Id), 7)
		) As TotalPagado	
		,Ent.ENTID_RazonSocial
		,Ent.ENTID_NroDocumento
		,Rut.RUTAS_Nombre
		,Dep.UBIGO_Descripcion + ' / ' + Pro.UBIGO_Descripcion + ' / ' + Dis.UBIGO_Descripcion As Salida
		,LDep.UBIGO_Descripcion + ' / ' + LPro.UBIGO_Descripcion + ' / ' + LDis.UBIGO_Descripcion As Llegada
		,IsNull(Vi.VIAJE_Descripcion, '') As VIAJE_Descripcion
		,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
		,Usr.ENTID_RazonSocial As Usuario
		,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right(('0000000' + RTrim(Ven.DOCVE_Numero)), 7) As Factura
		,IsNull(Ven.TIPOS_CodTipoDocumento, 'CPDFL') As TIPOS_CodTipoDocumento
		,TDoc.TIPOS_Descripcion As TIPOS_DocPago
		,Fle.*
	From Transportes.TRAN_Fletes As Fle
		Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
		Left Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
		Left Join Ubigeos As Dep On Dep.UBIGO_Codigo = SubString(Rut.UBIGO_CodOrigen, 1,2)
		Left Join Ubigeos As Pro On Pro.UBIGO_Codigo = SubString(Rut.UBIGO_CodOrigen, 1,5)
		Left Join Ubigeos As Dis On Dis.UBIGO_Codigo = Rut.UBIGO_CodOrigen
		Left Join Ubigeos As LDep On LDep.UBIGO_Codigo = SubString(Rut.UBIGO_CodDestino, 1,2)
		Left Join Ubigeos As LPro On LPro.UBIGO_Codigo = SubString(Rut.UBIGO_CodDestino, 1,5)
		Left Join Ubigeos As LDis On LDis.UBIGO_Codigo = Rut.UBIGO_CodDestino
		Inner Join Transportes.TRAN_Viajes As Vi On Vi.VIAJE_Id = Fle.VIAJE_Id
		Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Fle.tipos_CodTipoMoneda
		Left Join Entidades As Usr On Usr.ENTID_NroDocumento = Fle.FLETE_UsrCrea
		Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
		Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo
		Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = IsNull(Ven.TIPOS_CodTipoDocumento, 'CPDFL')
	Where Fle.ENTID_Codigo = @ENTID_Codigo
		And Abs(IsNull((Select Sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where CAJA_NroDocumento = Right('0000000' + RTrim(Fle.FLETE_Id), 7)
		), 0) - IsNull(FLETE_TotIngreso, 0)) <> 0
	Order By Ven.DOCVE_Codigo

GO 
/***************************************************************************************************************************************/ 

