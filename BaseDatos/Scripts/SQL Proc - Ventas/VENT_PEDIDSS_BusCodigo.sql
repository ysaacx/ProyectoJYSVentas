GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_BusCodigo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_BusCodigo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_BusCodigo]
(
	 @Codigo VarChar(14)
	,@Opcion Bit
	,@ZONAS_Codigo CodigoZona
	,@SUCUR_Id CodSucursal
	,@PVENT_Id Id	
)
As

Select Ped.* , Ent.ENTID_RazonSocial As ENTID_Cliente
	, Vend.ENTID_RazonSocial As ENTID_Vendedor
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, TCon.TIPOS_DescCorta As TIPOS_CondicionPago
	, Us.ENTID_RazonSocial As Usuario
	, Ent.ENTID_NroDocumento
	--,(Case LEFT(Ped.PEDID_Codigo, 2) When 'CT' Then 'Cotización' Else 'Pedido' End) As TipoCotizacion
From Ventas.VENT_Pedidos As Ped 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ped.TIPOS_CodTipoMoneda
	Left Join dbo.Tipos As TCon On TCon.TIPOS_Codigo = Ped.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ped.PEDID_UsrCrea 
WHERE IsNull(Ped.PEDID_ParaFacturar, 1) = (Case @Opcion When 1 Then 1 Else Ped.PEDID_ParaFacturar End)
	And ZONAS_Codigo = @ZONAS_Codigo
	And SUCUR_Id = @SUCUR_Id
	And PVENT_Id = @PVENT_Id
	And PEDID_Estado = 'I'
	And Ped.PEDID_Codigo Like '%' + @Codigo
	


GO 
/***************************************************************************************************************************************/ 

