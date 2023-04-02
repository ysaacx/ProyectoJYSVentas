GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_GuiasXCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_GuiasXCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 03/08/2013
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_GuiasXCliente]
	 @FecIni DateTime
	,@FecFin DateTime
	,@Id_Cliente VarChar(12)
AS

Select --top 1000 
	GR.GUIAR_Codigo
	,GR.GUIAR_Serie
	,GR.GUIAR_Numero
	,GUIAR_DireccDestino
	,GUIAR_FechaEmision
	,GUIAR_TotalPeso
	,GUIAR_HoraSalida
	,GUIAR_HoraLlegada
	,GS.SALID_Id
	,ENTID_CodigoCliente
	,GUIAR_Descripcioncliente
	,'' As Venta
	,SALID_HoraSalida
	,SALID_HoraLlegada
	--,Convert(VarChar, S.SALID_HoraSalida, 103) 
	--,* 
From Logistica.DIST_GuiasRemision As GR
	Inner Join Logistica.DESP_GuiaRSalidas As GS On GS.GUIAR_Codigo = GR.GUIAR_Codigo
	Inner Join Logistica.DESP_Salidas As S On S.SALID_Id = GS.SALID_Id And S.VEHIC_Id = GR.VEHIC_Id
	Left Join Conductores As Cond On Cond.ENTID_Codigo = GR.ENTID_CodigoConductor
Where GR.ENTID_CodigoCliente = @Id_Cliente
	And Convert(Date, S.SALID_HoraSalida, 103) Between @FecIni And @FecFin
Order By GUIAR_FechaEmision




GO 
/***************************************************************************************************************************************/ 

