GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ABASSS_ConsultaCompras]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ABASSS_ConsultaCompras] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/12/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ABASSS_ConsultaCompras]
(
	 @Cadena VarChar(50)
	,@OpcionTC SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select DC.DOCCO_Codigo
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_Documento
	,DC.DOCCO_Serie
	,DC.DOCCO_Numero	
	,DC.ENTID_CodigoProveedor
	,Ent.ENTID_RazonSocial As ENTID_Proveedor
	,DC.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,DC.DOCCO_TotalCompra
	,DC.DOCCO_FechaDocumento
	,DC.ORDCO_Codigo
	,OC.ORDCO_Serie
	,RTrim(OC.ORDCO_Numero) As ORDCO_Numero
	,DC.TIPOS_CodTipoDocumento
	,DC.DOCCO_Estado
From Logistica.ABAS_DocsCompra As DC
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = DC.ENTID_CodigoProveedor
	Inner join Tipos As TDoc On TDoc.TIPOS_Codigo = DC.TIPOS_CodTipoDocumento
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = DC.TIPOS_CodTipoMoneda
	Left Join Logistica.ABAS_OrdenesCompra As OC On OC.ORDCO_Codigo = DC.ORDCO_Codigo
Where DOCCO_Estado <> 'X'
	And Convert(Date, DC.DOCCO_FechaDocumento) Between @FecIni And @FecFin
	And (Case @OpcionTC When 0 Then Ent.ENTID_RazonSocial
						When 1 Then DC.DOCCO_Codigo
		 End
		) Like '%' + @Cadena + '%'
	And (
		Select SUM(ISNULL(DetCo.DOCCD_Cantidad, 0)) - SUM(ISNULL(Det.INGCD_Cantidad, 0))
		From Logistica.ABAS_DocsCompraDetalle As DetCo
			Left Join (
				Select ARTIC_Codigo, Sum(Det.INGCD_Cantidad) As INGCD_Cantidad
					from Logistica.ABAS_IngresosCompra As Ing
						Inner Join Logistica.ABAS_IngresosCompraDetalle As Det
							On Det.ALMAC_Id = Ing.ALMAC_Id
								And Det.INGCO_Id = Ing.INGCO_Id
								And Not INGCO_Estado = 'X'
					Where Ing.DOCCO_Codigo = DC.DOCCO_Codigo
						And Ing.ENTID_CodigoProveedor = DC.ENTID_CodigoProveedor
				Group By ARTIC_Codigo
			) As Det 
				On Det.ARTIC_Codigo = DetCo.ARTIC_Codigo
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetCo.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		 Where DetCo.DOCCO_Codigo = DC.DOCCO_Codigo
			And DetCo.ENTID_CodigoProveedor = DC.ENTID_CodigoProveedor
		) > 0
		

GO 
/***************************************************************************************************************************************/ 

