GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GUIA_SalidasPendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[GUIA_SalidasPendientes] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/08/2013
-- Descripcion         : Obtener los conductores y vehiculos que estan por salir
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[GUIA_SalidasPendientes]
	@FecIni DateTime
	,@FecFin DateTime
	,@TRANS_Id VarChar(14) = Null
AS

select Convert(Date, GUIAR_FechaEmision) As GUIAR_FechaEmision
	,ENTID_CodigoConductor
	,GUIAR_DescripcionConductor
	,VEHIC_Id
	,Sum(GUIAR_TotalPeso) As GUIAR_TotalPeso
Into #Guia
from Logistica.DIST_GuiasRemision
where Convert(Date, GUIAR_FechaEmision) Between @FecIni And @FecFin
	And ENTID_CodigoTransportista = IsNull(RTrim(@TRANS_Id), '20100241022')
	And Not GUIAR_Codigo In (Select IsNull(GUIAR_Codigo,'') From Logistica.DESP_GuiaRSalidas)
	And GUIAR_Estado <> 'X'
Group By GUIAR_DescripcionConductor, VEHIC_Id, ENTID_CodigoConductor, Convert(Date, GUIAR_FechaEmision)


Select G.*
	,IsNull((VM.TIPOS_Descripcion + ' / ' + VC.TIPOS_Descripcion + ' / ' + VEHIC_Placa), G.VEHIC_Id) As GUIAR_DescripcionVehiculo
	,IsNull(G.VEHIC_Id, '1')
From #Guia As G
	Left Join Transportes.TRAN_Vehiculos As V On V.VEHIC_Id = G.VEHIC_Id
	Left Join Tipos As VM On VM.TIPOS_Codigo = V.TIPOS_CodMarca
	Left Join Tipos As VC On VC.TIPOS_Codigo = V.TIPOS_CodTipoVehiculo
Where IsNull(G.VEHIC_Id,  '1') <> 0




GO 
/***************************************************************************************************************************************/ 

