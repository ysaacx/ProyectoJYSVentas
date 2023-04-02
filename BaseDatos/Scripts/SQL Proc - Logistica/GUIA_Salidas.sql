GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIA_Salidas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIA_Salidas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 03/08/2013
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIA_Salidas]
	@Fecha DateTime
AS
	Select (C.ENTID_RazonSocial + ' / ' + Cond.CONDU_Licencia) As Conductor
		,V.VEHIC_Placa As Placa , V.VEHIC_Certificado As Certificado
		,RTrim(S.SALID_Id)+RTrim(S.VEHIC_Id) As CSalida
		,S.* 
	Into #tmp
	From Logistica.DESP_Salidas As S
		Inner Join Entidades As C On C.ENTID_Codigo = S.ENTID_CodigoConductor
		Left Join Conductores As Cond On Cond.ENTID_Codigo = S.ENTID_CodigoConductor
		Inner Join Transportes.TRAN_Vehiculos As V On V.VEHIC_Id = S.VEHIC_Id
	Where Convert(varchar, SALID_HoraSalida, 112) = Convert(varchar, @Fecha, 112)
		And SALID_HoraLlegada Is Null
	
	Select * From #tmp
	
	Select RTrim(S.SALID_Id)+RTrim(S.VEHIC_Id) As CSalida
		,S.SALID_Id
		,S.VEHIC_Id
		,Sal.GUIAR_Codigo
		,Sal.GUISA_Numero
		,IsNull(Sal.GUISA_Numero, 0) As GUISA_Numero
		,IsNull(Guia.GUIAR_DireccDestino, Sal.GUISA_Destino) As GUIAR_DireccDestino
		,IsNull(Guia.GUIAR_Codigo, '000000000000') As GUIAR_Codigo
		,IsNull(Guia.GUIAR_Serie, '000') As GUIAR_Serie
		,IsNull(Guia.GUIAR_Numero, 0) As GUIAR_Numero
		,IsNull(Guia.ENTID_CodigoCliente, '00000000000') As ENTID_CodigoCliente
		,IsNull(Guia.GUIAR_FecCrea, Sal.GUISA_FecCrea) As GUIAR_FecCrea
		,IsNull(Guia.GUIAR_Descripcioncliente, 'SIN CLIENTE - Generado por Usuario') As GUIAR_Descripcioncliente
		,IsNull(Guia.GUIAR_TotalPeso, 0.00) As GUIAR_TotalPeso
		,Case When Sal.GUIAR_Codigo Is Null Then GUISA_HoraSalida Else GUIAR_HoraSalida End As GUIAR_HoraSalida
		,Case When Sal.GUIAR_Codigo Is Null Then GUISA_HoraLlegada Else GUIAR_HoraLlegada End As GUIAR_HoraLlegada
	From Logistica.DESP_GuiaRSalidas As Sal
		Left Join Logistica.DIST_GuiasRemision As Guia On Sal.GUIAR_Codigo = Guia.GUIAR_Codigo
		Inner Join #tmp As S On S.SALID_Id = Sal.SALID_Id And S.VEHIC_Id = Sal.VEHIC_Id
	Order By GUIAR_HoraSalida, GUIAR_HoraLlegada



GO 
/***************************************************************************************************************************************/ 

