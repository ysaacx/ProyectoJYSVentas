GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_FLETESS_Ayuda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_FLETESS_Ayuda] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección de todos de la tabla TRAN_CombustibleConsumo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_FLETESS_Ayuda]
(
	@Cadena VarChar(80)
	,@Opcion SmallInt
	,@FecIni DateTime
	,@FecFin DateTime
)
AS

Select Fle.FLETE_Id
	,Ent.ENTID_RazonSocial
	--,Fle.VIAJE_Id 
	, 'Viaje Nº ' + RTrim(Via.VIAJE_IdxVehiculo) + ' ' + IsNull(Cond.CONDU_Sigla, '') + ' / ' + Rut.RUTAS_Nombre
		As Glosa
	,Via.VIAJE_Descripcion
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Fle.FLETE_TotIngreso 
	,Fle.FLETE_FecSalida
	,Fle.FLETE_FecLlegada
	--,*
	,Fle.FLETE_Glosa
	,Fle.VIAJE_Id
	,Rut.RUTAS_Nombre
From Transportes.TRAN_Fletes As Fle
	Inner Join Entidades As Ent on Ent.ENTID_Codigo = Fle.ENTID_Codigo
	Inner Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Fle.VIAJE_Id
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Fle.TIPOS_CodTipoMoneda
	Inner Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Inner Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Inner Join Transportes.TRAN_Rutas As Rut On Rut.RUTAS_Id = Fle.RUTAS_Id
Where 
	(Case @Opcion 
		When 0 Then Ent.ENTID_RazonSocial 
		When 1 Then Ent.ENTID_NroDocumento 
		When 2 Then Via.VIAJE_Descripcion 
		Else Via.VIAJE_Descripcion
	End) Like '%' + @Cadena + '%'
	And Convert(Date, Fle.FLETE_FecProgramada) Between @FecIni And @FecFin
	And FLETE_Estado <> 'C'
	


GO 
/***************************************************************************************************************************************/ 

