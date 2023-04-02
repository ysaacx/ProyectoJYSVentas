GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_Busqueda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_Busqueda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_Busqueda]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Opcion Bit
	,@ZONAS_Codigo CodigoZona
	,@SUCUR_Id CodSucursal
	,@PVENT_Id Id	
)
As

Select Ped.* , Ent.ENTID_RazonSocial As ENTID_Cliente
	, Vend.ENTID_RazonSocial As ENTID_Vendedor
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TMon.TIPOS_Descripcion As TIPOS_TipoMoneda
	, TCon.TIPOS_DescCorta As TIPOS_CondicionPago
	, Us.ENTID_RazonSocial As Usuario
	, Ent.ENTID_NroDocumento
Into #Ventas
From Ventas.VENT_Pedidos As Ped 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ped.TIPOS_CodTipoMoneda
	Left Join dbo.Tipos As TCon On TCon.TIPOS_Codigo = Ped.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ped.PEDID_UsrCrea 
WHERE CONVERT(Date, Ped.PEDID_FechaDocumento) Between @FecIni And @FecFin
	And IsNull(Ped.PEDID_ParaFacturar, 0) = @Opcion
	And ZONAS_Codigo = @ZONAS_Codigo
	And SUCUR_Id = @SUCUR_Id
	And PVENT_Id = @PVENT_Id
	And PEDID_Estado = 'I'

Select * from #Ventas

Select Peddetalle.* , Art.ARTIC_Descripcion As ARTIC_Descripcion
	, Art.ARTIC_Codigo As ARTIC_Codigo
	, Alm.ALMAC_Descripcion As ALMAC_Descripcion
From Ventas.VENT_PedidosDetalle As Peddetalle 
	Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = Peddetalle.ARTIC_Codigo
	Inner Join dbo.Almacenes As Alm On Alm.ALMAC_Id = Peddetalle.ALMAC_Id 
WHERE 
	ISNULL(PedDetalle.PEDID_Codigo, '') In (Select PEDID_Codigo From #Ventas)
	
Drop Table #Ventas


GO 
/***************************************************************************************************************************************/ 

