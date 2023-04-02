GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_COTCOSS_TodosCotizaciones]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_COTCOSS_TodosCotizaciones] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Cotizaciones
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_COTCOSS_TodosCotizaciones]
(
	 @ZONAS_Codigo VarChar(5)
	,@SUCUR_Id SmallInt
	,@Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime
)
As

Select Ent.ENTID_RazonSocial As ENTID_Proveedor
	,Alma.ALMAC_Descripcion As ALMAC_Descripcion
	,CotCo.*
From Logistica.ABAS_CotizacionesCompra As CotCo 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = CotCo.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = CotCo.ALMAC_Id 
WHERE CotCo.SUCUR_Id = @SUCUR_Id
	AND  CotCo.ZONAS_Codigo = @ZONAS_Codigo
	AND  Convert(Date, CotCo.COTCO_FechaDocumento) Between @FecIni AND @FecFin
	AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
					  When 1 Then CotCo.COTCO_Codigo
					  Else Ent.ENTID_RazonSocial 
		 End) Like '%' + @Cadena + '%' 
	AND CotCo.COTCO_Estado In (Case @Todos When 1 Then (CotCo.COTCO_Estado) Else ('I') End) 


GO 
/***************************************************************************************************************************************/ 

