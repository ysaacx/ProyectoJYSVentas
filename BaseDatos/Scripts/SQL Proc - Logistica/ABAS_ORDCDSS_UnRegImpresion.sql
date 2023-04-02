GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ABAS_ORDCDSS_UnRegImpresion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ABAS_ORDCDSS_UnRegImpresion] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 11/01/2011
-- Descripcion         : Procedimiento de Selección según primary foregin keys de la tabla ABAS_OrdenesCompraDetalle
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ABAS_ORDCDSS_UnRegImpresion]
(
	@ORDCO_Codigo Codigo12 = null
)
As

Select 
	ORDCO_Codigo As Codigo
  , ENTID_RazonSocial As ENTID_Proveedor
  , DOCCO_Codigo
  , TIPOS_CodTipoMoneda
  , TIPOS_CodTipoDocDestino
  , ALMAC_Id
  , COTCO_Codigo
  , ORDCO_Id
  , ORDCO_FechaDocumento
  , ORDCO_DireccionProveedor
  , ORDCO_AtencionProveedor
  , ORDCO_TelefonoProveedor
  , ORDCO_CorreoProveedor
  , ORDCO_Condiciones
  , ORDCO_Observaciones
  , ORDCO_ImporteCompra
  , ORDCO_ImporteIgv
  , ORDCO_TotalCompra
  , ORDCO_PesoTotal
  , ORDCO_Estado
From [Logistica].[ABAS_OrdenesCompra] As Ord
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ord.ENTID_CodigoProveedor
WHERE
 ORDCO_Codigo = @ORDCO_Codigo

SELECT  ORDCO_Codigo As Codigo
      , ORDCD_Item
      , Det.ARTIC_Codigo
      , Art.ARTIC_Descripcion 
      , ORDCD_Cantidad
      , ORDCD_PrecioUnitario
      , ORDCD_PesoUnitario
      , ORDCD_SubImporteCompra
      , ORDCD_SubImporteIgv
      , ORDCD_SubTotal
FROM [Logistica].[ABAS_OrdenesCompraDetalle] As Det
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
WHERE ORDCO_Codigo = ISNULL(@ORDCO_Codigo, ORDCO_Codigo)
 

GO 
/***************************************************************************************************************************************/ 

