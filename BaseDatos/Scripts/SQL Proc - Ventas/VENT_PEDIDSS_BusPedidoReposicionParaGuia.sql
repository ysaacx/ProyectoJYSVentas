GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_BusPedidoReposicionParaGuia]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_BusPedidoReposicionParaGuia] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/07/2013
-- Descripcion         : Buscar pedidos de reposicioin que tienen pendiente de guia
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_BusPedidoReposicionParaGuia]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ZONAS_Codigo VarChar(5)
	,@PVENT_Id BigInt
	,@SUCUR_Id SmallInt
	,@PEDID_Tipo Char(1)
	,@Opcion SmallInt
	,@Cadena VarChar(50)	
	,@Todos Bit
)
As

Select IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_Cliente
	, Ent.ENTID_NroDocumento As ENTID_NroDocumento
	, Vend.ENTID_RazonSocial As ENTID_Vendedor
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, TCond.TIPOS_Descripcion As TIPOS_CondicionPago
	, Us.ENTID_RazonSocial As Usuario
	, Case Ped.PEDID_EstEntrega When 'E' Then 'Entrega Directa' 
								When 'P' Then 'Adjuntar Guia'
								Else 'Otro'
	 End As Entrega
	,IsNull(Abs((Select SUM(DDTRA_Cantidad)
		From (
				Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) As DDTRA_Cantidad
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.PEDID_Codigo = Ped.PEDID_Codigo
						--And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Union All
				Select 1 * SUM(IsNull(DetOrd.PDDET_Cantidad, 0))
				From Ventas.VENT_PedidosDetalle As DetOrd
					Inner Join Ventas.VENT_Pedidos As Cab On Cab.PEDID_Codigo = DetOrd.PEDID_Codigo
				Where DetOrd.PEDID_Codigo = Ped.PEDID_Codigo
					--And DetOrd.ALMAC_Id = @ALMAC_Id
			) As DetOrd
		)), 0) SaldoArticulos
	,Ped.*
From Ventas.VENT_Pedidos As Ped 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ped.TIPOS_CodTipoMoneda
	Inner Join dbo.Tipos As TCond On TCond.TIPOS_Codigo = Ped.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ped.PEDID_UsrCrea 
WHERE Ped.PVENT_Id = @PVENT_Id 
	AND  Ped.SUCUR_Id = @SUCUR_Id 
	AND (Case @Opcion When 0 Then IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
					  When 1 Then RTrim(PEDID_Codigo)
					  Else IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
					  End) Like '%' + @Cadena + '%'
	AND  Convert(Date, Ped.PEDID_FechaDocumento) Between @FecIni AND @FecFin 
	AND Ped.ZONAS_Codigo = @ZONAS_Codigo
	AND Ped.PEDID_Tipo = @PEDID_Tipo
	AND IsNull(Abs((Select SUM(DDTRA_Cantidad)
		From (
				Select Sum(IsNull(Det.GUIRD_Cantidad, 0)) As DDTRA_Cantidad
					from Logistica.DIST_GuiasRemision As Ing
						Inner Join Logistica.DIST_GuiasRemisionDetalle As Det
							On Det.GUIAR_Codigo = Ing.GUIAR_Codigo
								And Not GUIAR_Estado = 'X'
					Where Ing.PEDID_Codigo = Ped.PEDID_Codigo
						--And Ing.ALMAC_IdOrigen = @ALMAC_Id
				Union All
				Select -1 * SUM(IsNull(DetOrd.PDDET_Cantidad, 0))
				From Ventas.VENT_PedidosDetalle As DetOrd
					Inner Join Ventas.VENT_Pedidos As Cab On Cab.PEDID_Codigo = DetOrd.PEDID_Codigo
				Where DetOrd.PEDID_Codigo = Ped.PEDID_Codigo
					--And DetOrd.ALMAC_Id = @ALMAC_Id
			) As DetOrd
		)), 0) > 0


GO 
/***************************************************************************************************************************************/ 

