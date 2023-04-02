GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PEDIDSS_BusCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PEDIDSS_BusCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PEDIDSS_BusCliente]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@TConsulta SmallInt
	,@Cadena VarChar(50)
	,@Opcion Bit
	,@ZONAS_Codigo CodigoZona
	,@SUCUR_Id CodSucursal
	,@PVENT_Id Id	
)
As

Select IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_Cliente
	, Vend.ENTID_RazonSocial As ENTID_Vendedor
	, TDoc.TIPOS_DescCorta As TIPOS_TipoDocumento
	, TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	, TCon.TIPOS_DescCorta As TIPOS_CondicionPago
	, Us.ENTID_CodUsuario As Usuario
	, Ent.ENTID_NroDocumento
	,(Case LEFT(Ped.PEDID_Codigo, 2) 
			When 'CT' Then 'Cot.' 
			When 'PD' Then 'Ped.' 
			When 'PI' Then 'P.Int.' 
			When 'PR' Then 'P.Rep.' 
			Else 'Ped.' End) As TipoDeCotizacion
	, Ped.* 
From Ventas.VENT_Pedidos As Ped 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ped.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ped.TIPOS_CodTipoMoneda
	Left Join dbo.Tipos As TCon On TCon.TIPOS_Codigo = Ped.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ped.PEDID_UsrCrea 
WHERE CONVERT(Date, Ped.PEDID_FechaDocumento) Between @FecIni And @FecFin
	And IsNull(Ped.PEDID_ParaFacturar, 1) = (Case @Opcion When 1 Then 1 Else Ped.PEDID_ParaFacturar End)
	And ZONAS_Codigo = @ZONAS_Codigo
	And SUCUR_Id = @SUCUR_Id
	And PVENT_Id = @PVENT_Id
	And PEDID_Estado = 'I'
	--And
	And (Case @TConsulta 
			When 0 Then IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
			When 1 Then Ent.ENTID_NroDocumento
			When 2 Then Us.ENTID_RazonSocial
			Else IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial)
		 End
		) Like '%' + @Cadena + '%'
	And Ped.TIPOS_CodTipoDocumento <> 'CPDPR'


GO 
/***************************************************************************************************************************************/ 

