GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_FLETESS_ConsultaFletes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_FLETESS_ConsultaFletes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/06/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_FLETESS_ConsultaFletes]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
	,@OpFecha SmallInt
	,@FecIni DateTime
	,@FecFin DateTime
)
As


Select 
	Via.VIAJE_Id
	,Fle.FLETE_Id
	,Via.VIAJE_Descripcion
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, 'Fle.' + Right('000' + RTrim(Fle.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Fle.FLETE_Id), 7))  As Documento
	,Ent.ENTID_RazonSocial
	,'Viaje ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, '')
	,Via.VIAJE_FecSalida
	,Via.VIAJE_FecLlegada
	,Fle.FLETE_FecSalida
	,Fle.*
	--,* 
From Transportes.TRAN_Fletes As Fle
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Left Join Transportes.TRAN_ViajesVentas As VVen On VVen.VIAJE_Id = Fle.VIAJE_Id
			And VVen.FLETE_Id = Fle.FLETE_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = VVen.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
		--And Ven.DOCVE_FechaDocumento <= @FecFin
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
Where Case @Opcion 
		When 0 Then RTrim(Fle.FLETE_Id)
		When 1 Then Ent.ENTID_RazonSocial
		When 2 Then IsNUll(Via.VIAJE_Descripcion, 'Viaje ' + RTrim(Via.VIAJE_IdxConductor) + ' / ' + IsNull(Cond.CONDU_Sigla, ''))
	 End Like '%' + @Cadena + '%'
	And Case 0 
			When @OpFecha Then Convert(Date, Fle.FLETE_FecSalida) 
			Else Convert(Date, Fle.FLETE_FecLlegada) 
		End
		Between @FecIni And @FecFin

GO 
/***************************************************************************************************************************************/ 

