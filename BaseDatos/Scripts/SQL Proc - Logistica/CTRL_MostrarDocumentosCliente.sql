GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRL_MostrarDocumentosCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRL_MostrarDocumentosCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 13/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRL_MostrarDocumentosCliente]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ALMAC_Id BigInt = Null
	,@ENTID_Codigo VarChar(14) = Null
	,@Fecha Bit = Null
)
As

--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '12-31-2013'

Print @Fecha
Print Convert(Date, '01-01-2000')
Print @FecIni
If @Fecha = 0
	Set @FecIni = Convert(Date, '01-01-2000')


Select Ven.DOCVE_Codigo
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	,DOCVE_DescripcionCliente
	,DOCVE_FechaDocumento
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,DOCVE_ImporteVenta
	,DOCVE_ImporteIgv
	,DOCVE_TotalVenta
	,DOCVE_ImportePercepcion
	,DOCVE_TotalPagar
	,Guia.GUIAR_Codigo
	,TGuia.TIPOS_DescCorta + ' ' + Guia.GUIAR_Serie + '-' + Right(Guia.GUIAR_Codigo, 7) As DocGuia
	,TMot.TIPOS_Descripcion As TIPOS_MotivoTraslado
	,Guia.GUIAR_DireccOrigen
	,Guia.GUIAR_DireccDestino
	,Guia.GUIAR_DescripcionConductor
	,Guia.GUIAR_DescripcionTransportista
	,Guia.GUIAR_DescripcionVehiculo
	,Guia.GUIAR_FechaEmision
	,Guia.GUIAR_TotalPeso
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Logistica.DIST_GuiasRemision As Guia On Guia.DOCVE_Codigo = Ven.DOCVE_Codigo
	Left Join Tipos As TMot On TMot.TIPOS_Codigo = Guia.TIPOS_CodMotivoTraslado
	Left Join Tipos As TGuia On TGuia.TIPOS_Codigo = Guia.TIPOS_CodTipoDocumento
Where Ven.ENTID_CodigoCliente = @ENTID_Codigo
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
Order By DOCVE_Codigo
	,GUIAR_Codigo


GO 
/***************************************************************************************************************************************/ 

