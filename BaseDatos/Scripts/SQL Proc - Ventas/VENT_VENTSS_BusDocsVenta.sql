GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_VENTSS_BusDocsVenta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_VENTSS_BusDocsVenta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_VENTSS_BusDocsVenta]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ZONAS_Codigo VarChar(5)
	,@PVENT_Id BigInt
	,@SUCUR_Id SmallInt
	,@Opcion SmallInt
	,@Cadena VarChar(50)	
	,@Todos Bit
)
As


Select ISNULL(Ven.DOCVE_DescripcionCliente, Cli.ENTID_RazonSocial) As ENTID_Cliente
	,Cli.ENTID_NroDocumento As ENTID_NroDocumento
	,Vend.ENTID_RazonSocial As ENTID_Vendedor
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TCon.TIPOS_DescCorta As TIPOS_CondicionPago
	,Us.ENTID_RazonSocial As Usuario
	,Ven.* 
Into #Ventas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join dbo.Entidades As Cli On Cli.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join dbo.Tipos As TCon On TCon.TIPOS_Codigo = Ven.TIPOS_CodCondicionPago
	Left Join dbo.Entidades As Us On Us.USUAR_Codigo = Ven.DOCVE_UsrCrea 
WHERE   Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni AND @FecFin
	AND ISNULL(Ven.DOCVE_DescripcionCliente, Cli.ENTID_RazonSocial) Like '%' + @Cadena + '%' 
	AND Ven.PVENT_Id = @PVENT_Id 
	--AND ISNULL(Ven.DOCVE_Estado, '') <> 'X'

If @Todos = 1
	Select * From #Ventas
Else
	Select * From #Ventas Where DOCVE_Estado <> 'X'



GO 
/***************************************************************************************************************************************/ 

