GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_ObtenerPedidoReposicion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_ObtenerPedidoReposicion] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 30/01/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_ObtenerPedidoReposicion]
(
	 @FecFin DateTime
	,@ZONAS_Codigo VarChar(5)
	,@PVENT_Id BigInt
	,@SUCUR_Id SmallInt
	,@PEDID_Tipo Char(1)
	,@Opcion SmallInt
	,@Cadena VarChar(50)	
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
	,TDVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As DocVenta
	,PRel.PVENT_Descripcion As PVtaRelacionado
	,PDes.PVENT_Descripcion As PVtaDestino	
	,Ped.PEDID_FechaDocumento
	,Ped.PEDID_FechaEntrega As PEDID_FechaEntrega_Old
	,Ped.PEDID_FechaEntrega
	,Ped.PEDID_DescripcionCliente
	,Ped.ENTID_CodigoCliente
	,Ped.PVENT_IdOrigenPReposicion
	,Ped.PEDID_Estado
	,Ped.PEDID_Codigo
	,ped.PEDID_CodRelacionado
	--,Ped.PEDID_DescripcionCliente
	
Into #Pedidos
From Ventas.VENT_Pedidos As Ped 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ped.TIPOS_CodTipoMoneda
	Inner Join dbo.Tipos As TCond On TCond.TIPOS_Codigo = Ped.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ped.PEDID_UsrCrea 
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.PEDID_Codigo = Ped.PEDID_Codigo
	Left Join Tipos As TDVen On TDVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join PuntoVenta As PRel On PRel.PVENT_Id = Ped.PVENT_IdRelacionado
	Left Join PuntoVenta As PDes On PDes.PVENT_Id = Ped.PVENT_IdDestinoPReposicion
WHERE   Ped.PVENT_Id = @PVENT_Id 
	AND  Ped.SUCUR_Id = @SUCUR_Id 
	AND (Case @Opcion When 0 Then IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
					  When 1 Then RTrim(Ped.PEDID_Codigo)
					  When 2 Then Ped.PEDID_OrdenCompra
					  Else IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
					  End) Like '%' + @Cadena + '%'
	AND  Convert(Date, Ped.PEDID_FechaEntrega) <= @FecFin 
	AND  Ped.ZONAS_Codigo = @ZONAS_Codigo
	AND Ped.PEDID_Tipo = @PEDID_Tipo
	


Select * From #Pedidos Where PVENT_IdOrigenPReposicion <> @PVENT_Id And Not PEDID_Estado In  ('X', 'C') Order By PEDID_FechaDocumento Desc


GO 
/***************************************************************************************************************************************/ 

