--USE BDInkaPeru
--USE BDSisSCC
--USE BDCOMAFISUR
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MSTGENSS_ObtenerCompras]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[MSTGENSS_ObtenerCompras] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/11/2012
-- Descripcion         : Importar las Compras
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MSTGENSS_ObtenerCompras]
(	  @FecIni DateTime
	, @FecFin DATETIME
   , @Id_Compra  VARCHAR(20) = NULL
)
AS

--Declare @FecIni DateTime
--Declare @FecFin DateTime
--Set @FecIni = '01/04/2012'
--Set @FecFin = '30/04/2012'

SELECT Id_Compra           = DOCUS.DOCCO_Codigo
     , Id_Proveedor        = ENTID.ENTID_Codigo
     , Proveedor           = ENTID.ENTID_RazonSocial
	  , Direccion           = ENTID.ENTID_Direccion
	  , Moneda              = TMND.TIPOS_DescCorta
	  , Fecha_Documento     = DOCUS.DOCCO_FechaDocumento
	  , Serie_Documento     = DOCUS.DOCCO_Serie
	  , Numero_Documento    = DOCUS.DOCCO_Numero
	  , Fecha_Ingreso       = DOCUS.DOCCO_FechaDocumento
	  , ID_Tipo_Documento   = RIGHT(DOCUS.TIPOS_CodTipoDocumento, 2)
     , TipoDocumento       = TDOC.TIPOS_DescCorta
	  , Fecha_Pago          = DOCUS.DOCCO_FechaPago
     , Importe             = DOCUS.DOCCO_ImporteCompra
     , Impuesto            = DOCUS.DOCCO_ImporteIgv
     , Total               = DOCUS.DOCCO_TotalCompra
     , ID_Moneda           = CONVERT(SMALLINT, RIGHT(DOCUS.TIPOS_CodTipoMoneda, 1))
	  , PDescuento          = 0
     , Tipo_Cambio         = DOCUS.DOCCO_TipoCambioSunat
  FROM Logistica.ABAS_DocsCompra DOCUS
 INNER JOIN dbo.Entidades ENTID ON ENTID.ENTID_Codigo = DOCUS.ENTID_CodigoProveedor
 INNER JOIN dbo.Tipos TMND ON TMND.TIPOS_Codigo = DOCUS.TIPOS_CodTipoMoneda
 INNER JOIN dbo.Tipos TDOC ON TDOC.TIPOS_Codigo = DOCUS.TIPOS_CodTipoDocumento
 WHERE DOCUS.DOCCO_FechaDocumento Between @FecIni And @FecFin
   AND DOCUS.DOCCO_Codigo = ISNULL(@Id_Compra, DOCUS.DOCCO_Codigo)
   AND DOCUS.DOCCO_Estado <> 'X'
 ORDER BY Id_Compra, Id_Proveedor
	--And not tdoc = '07'

DECLARE @IGV DECIMAL(5, 2) = 18

 SELECT Id_Compra = DOCCD.DOCCO_Codigo
	   , Id_Proveedor = DOCCD.ENTID_CodigoProveedor
	   , Posicion = DOCCD.DOCCD_Item
	   , Cuenta = ''
	   , Id_Producto = DOCCD.ARTIC_Codigo
	   , Cantidad_Producto = DOCCD.DOCCD_Cantidad
	   , Sub_Importe = ISNULL(DOCCD.DOCCD_SubImporteCompra, 0)
	   , Sub_Igv = ISNULL(ROUND(DOCCD.DOCCD_SubImporteCompra * (@IGV/100), 2), 0)
	   , Sub_Total = ISNULL(DOCCD.DOCCD_SubImporteCompra + ROUND(DOCCD.DOCCD_SubImporteCompra * (@IGV/100), 2), 0)
	   , PDescuento = 0
      --, DOCCD.*
   FROM Logistica.ABAS_DocsCompraDetalle DOCCD
  INNER JOIN Logistica.ABAS_DocsCompra DOCUS ON DOCUS.DOCCO_Codigo = DOCCD.DOCCO_Codigo AND DOCUS.ENTID_CodigoProveedor = DOCCD.ENTID_CodigoProveedor
  INNER JOIN dbo.Entidades ENTID ON ENTID.ENTID_Codigo = DOCUS.ENTID_CodigoProveedor
  INNER JOIN dbo.Tipos TMND ON TMND.TIPOS_Codigo = DOCUS.TIPOS_CodTipoMoneda
  INNER JOIN dbo.Tipos TDOC ON TDOC.TIPOS_Codigo = DOCUS.TIPOS_CodTipoDocumento
  WHERE DOCCD.TIPOS_CodTipoDestino = 'DES1'
    AND DOCUS.DOCCO_FechaDocumento Between @FecIni And @FecFin
    AND DOCUS.DOCCO_Codigo = ISNULL(@Id_Compra, DOCUS.DOCCO_Codigo)
    AND DOCUS.DOCCO_Estado <> 'X'
  ORDER BY Id_Compra, Id_Proveedor

GO


--Exec MSTGENSS_ObtenerCompras '2018-01-01', '2018-06-02'--, '010010000016'
--exec MSTGENSS_ObtenerCompras @FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00', @Id_Compra = '01F0010011713'
exec MSTGENSS_ObtenerCompras @FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00', @Id_Compra = '01FE020114121'



