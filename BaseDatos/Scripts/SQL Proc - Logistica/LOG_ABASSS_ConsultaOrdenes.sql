GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ABASSS_ConsultaOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ABASSS_ConsultaOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/12/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ABASSS_ConsultaOrdenes]
(
	 @Cadena VarChar(50)
	,@OpcionTC SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select ORDCO_Codigo
	,ORDCO_Serie
	,ORDCO_Numero
	,ENTID_CodigoProveedor
	,Ent.ENTID_RazonSocial As ENTID_Proveedor
	,OC.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,OC.ORDCO_TotalCompra
	,OC.ORDCO_FechaDocumento
	,OC.ORDCO_Estado
From Logistica.ABAS_OrdenesCompra As OC
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = OC.ENTID_CodigoProveedor
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = OC.TIPOS_CodTipoMoneda
Where Not ORDCO_Estado In ('X', 'C')
	And Convert(Date, OC.ORDCO_FechaDocumento) Between @FecIni And @FecFin
	And (Case @OpcionTC When 0 Then Ent.ENTID_RazonSocial
						When 1 Then OC.ORDCO_Codigo
		 End
		) Like '%' + @Cadena + '%'
	AND (Select Sum(IsNull(DetOrd.ORDCD_Cantidad, 0) - IsNull(Det.INGCD_Cantidad, 0)) As Cantidad
			From Logistica.ABAS_OrdenesCompraDetalle As DetOrd
			Left Join (
				Select ARTIC_Codigo, Sum(Det.INGCD_Cantidad) As INGCD_Cantidad
					from Logistica.ABAS_IngresosCompra As Ing
						Inner Join Logistica.ABAS_IngresosCompraDetalle As Det
							On Det.INGCO_Id = Ing.INGCO_Id
								And Det.ALMAC_Id  = Ing.ALMAC_Id
								And Not INGCO_Estado = 'X'
					Where Ing.ORDCO_Codigo = OC.ORDCO_Codigo
				Group By ARTIC_Codigo
			) As Det 
					On Det.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Articulos As Art
				On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
			Inner Join Tipos As TUni
				On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
		 Where DetOrd.ORDCO_Codigo = OC.ORDCO_Codigo
		) > 0
	Order By ORDCO_Codigo ASC

GO 
/***************************************************************************************************************************************/ 

