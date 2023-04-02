GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_INGCOSS_IngresoCompras]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_INGCOSS_IngresoCompras] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 31/08/2012
-- Descripcion         : Obtener el stock actual de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_INGCOSS_IngresoCompras]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select Ent.ENTID_RazonSocial As ENTID_Proveedor
	,Alma.ALMAC_Descripcion As ALMAC_Descripcion
	,TMone.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Doc.DOCCO_Codigo
	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCCO_Serie + '-' + Right('0000000' + RTRIM(Doc.DOCCO_Numero), 7) As DocCompra
	,Ord.*
From Logistica.ABAS_OrdenesCompra As Ord 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = Ord.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Ord.ALMAC_Id
	Inner Join dbo.Tipos As TMone On TMone.TIPOS_Codigo = Ord.TIPOS_CodTipoMoneda 
	Left Join Logistica.ABAS_DocsCompra As Doc On Doc.ORDCO_Codigo = Ord.ORDCO_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
WHERE	Case @Opcion 
			When 0 Then Ent.ENTID_RazonSocial
			When 1 Then Ord.ORDCO_Codigo
		End Like '%' + @Cadena + '%' 
	AND (Case @Todos When 1 Then 'I' Else Ord.ORDCO_Estado End) <> 'X' 
	AND  Convert(Date, Ord.ORDCO_FechaDocumento) Between @FecIni AND @FecFin
	AND (Select Sum(IsNull(DetOrd.ORDCD_Cantidad, 0) - IsNull(Det.INGCD_Cantidad, 0)) As Cantidad
			From Logistica.ABAS_OrdenesCompraDetalle As DetOrd
			Left Join (
				Select ARTIC_Codigo, Sum(Det.INGCD_Cantidad) As INGCD_Cantidad
					from Logistica.ABAS_IngresosCompra As Ing
						Inner Join Logistica.ABAS_IngresosCompraDetalle As Det
							On Det.INGCO_Codigo = Ing.INGCO_Codigo
								And Not INGCO_Estado = 'X'
					Where Ing.ORDCO_Codigo = Ord.ORDCO_Codigo
				Group By ARTIC_Codigo
			) As Det 
					On Det.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		 Where DetOrd.ORDCO_Codigo = Ord.ORDCO_Codigo
		) > 0
	Order By ORDCO_Codigo ASC


GO 
/***************************************************************************************************************************************/ 

