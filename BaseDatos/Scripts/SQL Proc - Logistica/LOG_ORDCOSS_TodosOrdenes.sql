GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ORDCOSS_TodosOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Ordenes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes]
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
	,OrdCo.*
From Logistica.ABAS_OrdenesCompra As OrdCo 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = OrdCo.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = OrdCo.ALMAC_Id 
	
WHERE Alma.SUCUR_Id = @SUCUR_Id
	AND  Alma.ZONAS_Codigo = @ZONAS_Codigo
	AND  Convert(Date, OrdCo.ORDCO_FechaDocumento) Between @FecIni AND @FecFin
	AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
					  When 1 Then OrdCo.COTCO_Codigo
					  Else Ent.ENTID_RazonSocial 
		 End) Like '%' + @Cadena + '%' 
	AND OrdCo.ORDCO_Estado In (Case @Todos When 1 Then (OrdCo.ORDCO_Estado) Else ('I') End) 


GO 
/***************************************************************************************************************************************/ 

