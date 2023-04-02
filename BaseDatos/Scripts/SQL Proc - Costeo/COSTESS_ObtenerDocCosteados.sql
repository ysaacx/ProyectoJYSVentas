GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[COSTESS_ObtenerDocCosteados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[COSTESS_ObtenerDocCosteados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 08/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[COSTESS_ObtenerDocCosteados]
(
	 @ENTID_CodigoProveedor CodEntidad
	,@DOCCO_Codigo VarChar(14)
	,@Detalle Bit
	
)
As

 SELECT Ent.ENTID_RazonSocial As ENTID_Proveedor
	   , Ent.ENTID_Codigo As ENTID_CodigoProveedor
	   , Ent.ENTID_NroDocumento As ENTID_NroDocumento
	   , TDoc.TIPOS_DescCorta As TIPOS_Documento
	   , DocCo.* 
   FROM Logistica.ABAS_DocsCompra As DocCo 
  INNER Join dbo.Entidades As Ent On Ent.ENTID_Codigo = DocCo.ENTID_CodigoProveedor 
  INNER Join Tipos As TDoc On TDoc.TIPOS_Codigo = DocCo.TIPOS_CodTipoDocumento
  WHERE DocCo.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
	 AND DocCo.DOCCO_Codigo = @DOCCO_Codigo

IF @Detalle = 1
Begin
	 SELECT Art.ARTIC_Descripcion As ARTIC_Descripcion
		   , Art.ARTIC_Id As ARTIC_Id
		   , TDes.TIPOS_Descripcion As TIPOS_TipoDestino
		   , TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
		   , DocCodetalle.* 
	   FROM Logistica.ABAS_DocsCompraDetalle As DocCodetalle 
	  INNER Join dbo.Articulos As Art On Art.ARTIC_Codigo = DocCodetalle.ARTIC_Codigo
	  INNER Join dbo.Tipos As TDes On TDes.TIPOS_Codigo = DocCodetalle.TIPOS_CodTipoDestino
	  INNER Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida 
	  WHERE DocCoDetalle.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
		 AND DocCoDetalle.DOCCO_Codigo = @DOCCO_Codigo
    /* OBTENER DETALLES */
    SELECT COSTE.ENTID_CodigoProveedor
         , COSTE.DOCCO_Codigo
         , COSTE.COSTE_CodigoProveedor
         , COSTE.COSTE_Importe
         , COSTE.COSTE_CodigoDocumento
         , COSTE.TIPOS_CodTipoCosteo
         , TipoDocumento   = LEFT(COSTE.COSTE_CodigoDocumento, 2)
         , Serie           = SUBSTRING(COSTE.COSTE_CodigoDocumento, 3, 3)
         , Numero          = SUBSTRING(COSTE.COSTE_CodigoDocumento, 5, 7)
      FROM Logistica.ABAS_Costeos COSTE
     WHERE COSTE.DOCCO_Codigo = @DOCCO_Codigo
       AND COSTE.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
       AND COSTE.TIPOS_CodTipoCosteo IN ('CTO01', 'CTO02') AND COSTE.COSTE_Item < 0
   /* DESCUENTOS */
    SELECT COSTE.TIPOS_CodTipoCosteo
         , COSTE_Item = ROW_NUMBER() OVER(ORDER BY COSTE.COSTE_Item ASC)
         , COSTE.COSTE_Porcentaje
      FROM Logistica.ABAS_Costeos COSTE
     WHERE COSTE.DOCCO_Codigo = @DOCCO_Codigo
       AND COSTE.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
       AND COSTE.TIPOS_CodTipoCosteo IN ('CTO04') --AND COSTE.COSTE_Item < 0
       AND COSTE.DOCCD_Item = 1
END


GO 
/***************************************************************************************************************************************/ 

exec COSTESS_ObtenerDocCosteados @ENTID_CodigoProveedor=N'20370146994',@DOCCO_Codigo=N'010120004580',@Detalle=1


