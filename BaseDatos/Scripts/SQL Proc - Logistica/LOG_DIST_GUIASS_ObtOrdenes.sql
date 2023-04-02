GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_GUIASS_ObtOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 02/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_GUIASS_ObtOrdenes]
(
	 @TConsulta SmallInt
	,@Cadena VarChar(50)
	,@ALMAC_Id SmallInt
	,@PVENT_Id Id
	,@FecIni DateTime
	,@FecFin DateTime
	,@DesBloqueo Bit = Null
)
As

Declare @Tiempo Integer 
Select @Tiempo = (-1 * PARMT_Valor) From Parametros Where PARMT_Id = 'pg_TPendiente'

Select
	Case When (Select Count(*) From Logistica.DIST_GuiasRemision 
				Where ORDEN_Codigo = Doc.ORDEN_Codigo 
				And Left(GUIAR_Codigo, 2) = 'GR') > 0 
			Then Convert(Bit, 1) 
			Else Convert(Bit, 0) 
	 End As Guias
	,Convert(Bit, 0)  Notas
	,Case When (Select Count(*) From Logistica.DIST_GuiasRemision 
					Where ORDEN_Codigo = Doc.ORDEN_Codigo 
						And Left(GUIAR_Codigo, 2) = 'OR') > 0 
				Then Convert(Bit, 1) 
				Else Convert(Bit, 0) 
	 End As Orden
	,Convert(Bit, 1) As Pendiente
	,Case When ORDEN_Estado = 'X' Then Convert(Bit, 1) Else Convert(Bit, 0) End As Anulada
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Left(Right(Doc.DOCVE_Codigo, 10), 3) As DOCVE_Serie 
	,Right(Doc.DOCVE_Codigo, 7) As DOCVE_Numero
	,Cli.ENTID_RazonSocial As ENTID_Cliente
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Us.ENTID_RazonSocial As Usuario
	,Doc.ENTID_CodigoCliente
	,Doc.ORDEN_FechaDocumento As DOCVE_FechaDocumento
	,'OR' + ' ' + Left(Right(Doc.ORDEN_Codigo, 10), 3) + '-' + Right(Doc.ORDEN_Codigo, 7) As Codigo
	,ORDEN_Codigo 
	,DOCVE_Codigo
	,Doc.ORDEN_FecCrea As DOCVE_FecCrea
	,Doc.ORDEN_UsrCrea As DOCVE_UsrCrea
	,Doc.ORDEN_PerGenGuia As DOCVE_PerGenGuia
Into #Ordenes
From Logistica.DIST_Ordenes As Doc
	Left Join dbo.Entidades As Cli On Cli.ENTID_Codigo = Doc.ENTID_CodigoCliente
	Left Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Doc.ORDEN_UsrCrea
	Left Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = 'CPD' + Left(Doc.DOCVE_Codigo, 2)
Where   ISNULL(ORDEN_Estado, '') = 'I' 	And 
	(Case @TConsulta 
			When 0 Then Cli.ENTID_RazonSocial 
			When 1 Then Doc.DOCVE_Codigo
			When 2 Then Us.ENTID_RazonSocial
			Else Cli.ENTID_RazonSocial 
		 End
		) Like '%' + @Cadena + '%'
	AND  Convert(Date, ORDEN_FechaDocumento) Between @FecIni AND @FecFin
	AND  ISNULL(PVENT_IdDestino, '') = @PVENT_Id
	And (Select Sum(IsNull(DetOrd.ORDET_Cantidad, 0) - IsNull(Det.DDTRA_Cantidad, 0)) As Cantidad
						From Logistica.DIST_OrdenesDetalle As DetOrd
							Inner Join Logistica.DIST_Ordenes As Cab On Cab.ORDEN_Codigo = DetOrd.ORDEN_Codigo
							Left Join (
								Select ARTIC_Codigo, Sum(Det.GUIRD_Cantidad) As DDTRA_Cantidad, ALMAC_IdOrigen
									from Logistica.DIST_GuiasRemision As Ing
										Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
											On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
												And Not GUIAR_Estado = 'X'
									Where Ing.ORDEN_Codigo = Doc.ORDEN_Codigo
										And Ing.ALMAC_IdOrigen = @ALMAC_Id
								Group By ARTIC_Codigo, ALMAC_IdOrigen
							) As Det 
								On Det.ARTIC_Codigo = DetOrd.ARTIC_Codigo And Det.ALMAC_IdOrigen = Cab.ALMAC_IdDestino
							Inner Join Articulos As Art
								On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
							Inner Join Tipos As TUni
								On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
						Where DetOrd.ORDEN_Codigo = Doc.ORDEN_Codigo
								And Cab.ALMAC_IdDestino = @ALMAC_Id) > 0
	
If IsNull(@DesBloqueo, 0) = 1
	Select * From #Ordenes As Doc
else
	Select * From #Ordenes As Doc
	Where CONVERT(Date, Doc.DOCVE_FechaDocumento) > DATEADD(Month, @Tiempo, Convert(Date, GETDATE()))



GO 
/***************************************************************************************************************************************/ 

