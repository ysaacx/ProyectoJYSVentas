--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_UnDocumento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_UnDocumento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_UnDocumento]
(
	 @DOCVE_Codigo VarChar(13)
)
As

 SELECT Doc.DOCVE_Codigo 
	   , Ent.ENTID_RazonSocial As ENTID_Cliente
	   , ENTID_NroDocumento = (Case Ent.ENTID_NroDocumento When '11000000000' Then '' Else Ent.ENTID_NroDocumento End)
	   , Vend.ENTID_RazonSocial As ENTID_Vendedor
	   , TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	   , Doc.DOCVE_Serie
	   , Doc.DOCVE_Numero
	   , IsNull(Doc.DOCVE_DireccionCliente, '') As DOCVE_DireccionCliente
	   , Doc.DOCVE_DescripcionCliente
	   , Doc.DOCVE_FechaDocumento
	   , Doc.DOCVE_ImporteVenta
	   , Doc.DOCVE_ImporteIgv
	   , Doc.DOCVE_TotalVenta
	   , Doc.DOCVE_AfectoPercepcion	
	   , Doc.DOCVE_AfectoPercepcionSoles
	   , Doc.DOCVE_ImportePercepcion
	   , Doc.DOCVE_ImportePercepcionSoles
	   , Doc.DOCVE_TotalPeso
	   , Doc.DOCVE_TotalPagar
	   , Doc.TIPOS_CodTipoDocumento
	   --,IsNull(Ent.ENTID_CodUsuario, '-') As Cotizador
	   , IsNull(Cotiz.ENTID_CodUsuario, Cotiz.ENTID_RazonSocial) As Cotizador
	   , Doc.TIPOS_CodTipoMoneda
	   , Doc.DOCVE_EstEntrega
	   , TCon.TIPOS_Descripcion As TIPOS_CondicionPagoCorto
	   , Doc.DOCVE_OrdenCompra
	   , Doc.DOCVE_PorcentajePercepcion
	   , Doc.DOCVE_PorcentajeIGV
	   , Doc.DOCVE_Codigo
      , Ped.PEDID_Codigo
      , Ped.PEDID_Numero
      , ENTID_CodTipoDocumento = RIGHT(Ent.TIPOS_CodTipoDocumento, 1)
      , Ped.PEDID_FechaDocumento
      , TIPOS_TipoDocumento = TDOC.TIPOS_Descripcion + CASE WHEN LEFT(Doc.DOCVE_Serie, 1) IN ('F', 'B') THEN ' Electrónica' ELSE '' END 
      , Doc.TIPOS_CodTipoDocumento
      , Doc.DOCVE_Motivo
      --TDREF.TIPOS_DescCorta + ' ' +  DVREL.DOCVE_Serie + '-' + RIGHT('0000000' +  RTRIM(DVREL.DOCVE_Numero), 7)
      , DOCVE_Referencia = (SELECT STUFF((SELECT ', ' + TDREF.TIPOS_DescCorta + ' ' +  DVREL.DOCVE_Serie + '-' + RIGHT('0000000' +  RTRIM(DVREL.DOCVE_Numero), 7)
                             FROM Ventas.VENT_DocsRelacion DRELA 
                             LEFT JOIN Ventas.VENT_DocsVenta DVREL ON DVREL.DOCVE_Codigo = DRELA.DOCVE_CodReferencia
                             LEFT JOIN dbo.Tipos TDREF ON TDREF.TIPOS_Codigo = DVREL.TIPOS_CodTipoDocumento
                            WHERE DRELA.DOCVE_Codigo = Doc.DOCVE_Codigo FOR xml path('')), 1, 1, ''))
      --, Ent.tipos
	   --,TIPOS_CodCondicionPago
	   --,Doc.* 
	  , Doc.DOCVE_Observaciones
      , Doc.DOCVE_FechaPago
      , Doc.DOCVE_Plazo
      , Doc.DOCVE_PlazoFecha
      , Retencion = CONVERT(BIT, (CASE WHEN PADR.ENTID_NroDocumento IS NULL THEN 0 ELSE 1 END))
      , RetencionImporte = CASE WHEN CONVERT(BIT, (CASE WHEN PADR.ENTID_NroDocumento IS NULL THEN 0 ELSE 1 END)) = 1
                                THEN Doc.DOCVE_TotalVenta * 0.03
                                ELSE 0
                           END 
      , TotalPagar = CASE WHEN CONVERT(BIT, (CASE WHEN PADR.ENTID_NroDocumento IS NULL THEN 0 ELSE 1 END)) = 1
                            THEN Doc.DOCVE_TotalVenta - Doc.DOCVE_TotalVenta * 0.03
                            ELSE 0
                     END 
   FROM Ventas.VENT_DocsVenta As Doc 
  INNER JOIN dbo.Tipos TDOC ON TDOC.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
        --INNER JOIN Ventas.VENT_Pedidos PEDID ON 
  INNER JOIN dbo.Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_CodigoCliente
        --LEFT JOIN dbo.Clientes AS CLI ON CLI.ENTID_Codigo = Ent.ENTID_Codigo
   LEFT Join dbo.Entidades As Vend On Vend.ENTID_Codigo = Doc.ENTID_CodigoVendedor
  INNER Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda 
   LEFT Join Ventas.VENT_Pedidos As Ped On Ped.PEDID_Codigo = Doc.PEDID_Codigo
   LEFT Join dbo.Entidades As Cotiz On Cotiz.ENTID_Codigo = Doc.ENTID_CodigoCotizador
   LEFT Join Tipos As TCon On TCon.TIPOS_Codigo = Doc.TIPOS_CodCondicionPago
        --LEFT JOIN Ventas.VENT_DocsRelacion DRELA ON DRELA.DOCVE_Codigo = Doc.DOCVE_Codigo
        --LEFT JOIN Ventas.VENT_DocsVenta DVREL ON DVREL.DOCVE_Codigo = DRELA.DOCVE_CodReferencia
        --LEFT JOIN dbo.Tipos TDREF ON TDREF.TIPOS_Codigo = DVREL.TIPOS_CodTipoDocumento
   LEFT JOIN dbo.EntidadesPadrones PADR ON PADR.ENTID_NroDocumento = Ent.ENTID_NroDocumento AND PADR.TIPOS_CodTipoPadron = 'PDR04'
  WHERE Doc.DOCVE_Codigo = @DOCVE_Codigo


 --select
 --  stuff((
 --          SELECT ', ' + TDREF.TIPOS_DescCorta + ' ' +  DVREL.DOCVE_Serie + '-' + RIGHT('0000000' +  RTRIM(DVREL.DOCVE_Numero), 7)
 --            FROM Ventas.VENT_DocsRelacion DRELA 
 --            LEFT JOIN Ventas.VENT_DocsVenta DVREL ON DVREL.DOCVE_Codigo = DRELA.DOCVE_CodReferencia
 --            LEFT JOIN dbo.Tipos TDREF ON TDREF.TIPOS_Codigo = DVREL.TIPOS_CodTipoDocumento
 --           WHERE DRELA.DOCVE_Codigo = @DOCVE_Codigo
 --        for xml path('')), 1, 1, '')


 SELECT Alm.ALMAC_Descripcion As ALMAC_Descripcion
	   , Det.DOCVD_Cantidad
	   , TUni.TIPOS_DescCorta As DOCVD_Unidad
	   , Art.ARTIC_Descripcion As ARTIC_Descripcion
	   , Det.DOCVD_PrecioUnitario
	   , Det.DOCVD_SubImporteVenta	
	      --,Det.DOCVD_PesoUnitario
	   , Art.ARTIC_Peso As DOCVD_PesoUnitario
	   , Det.DOCVD_PesoUnitario * Det.DOCVD_Cantidad
	   , IsNull(Det.DOCVD_Detalle, Art.ARTIC_Descripcion) As DOCVD_Detalle
	   , Det.DOCVE_Codigo
      , Art.ARTIC_Codigo
   FROM Ventas.VENT_DocsVentaDetalle As Det 
	LEFT JOIN dbo.Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	LEFT JOIN dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	LEFT JOIN dbo.Almacenes As Alm On Alm.ALMAC_Id = Det.ALMAC_Id 
  WHERE Det.DOCVE_Codigo = @DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 
--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'03B0010002074'
--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'07F0010000003'
--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'01F0010000001'
--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'01F0010007032'
GO
exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'01F0010012223'

--SELECT TOP 10 TIPOS_CodCondicionPago, * FROM Ventas.VENT_DocsVenta 
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'PGO%'

 --SELECT  * 
 --FROM dbo.Auditoria
 --WHERE 
 -- TIPOS_CodTipoProceso = 'AUT006' AND  SUCUR_Id = 1 AND  AUDIT_CodigoReferencia = 'CT0010060540' AND  AUDIT_Estado = 'I' AND  TIPOS_CodTipoDocumento = 'CPDCV' AND  APLIC_Codigo = 'VTA' AND  ZONAS_Codigo = '84.00'




--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'03B0010001355'

--select * from ventas.VENT_DocsRelacion
--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'

--select * from Ventas.VENT_DocsVenta where DOCVE_Codigo = '01F0010001328'

--SELECT * FROM BDSAdmin..Empresas


--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'03B0010000059'


--exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'010050005061'

----exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'010040001768'
----SELECT * FROM dbo.Sucursales
----SELECT * FROM dbo.PuntoVenta
----SELECT * FROM dbo.Almacenes

--SELECT * FROM Ventas.VENT_DocsVenta WHERE DOCVE_Codigo = '010050002723'

--SELECT DOCVE_Codigo, COUNT(*) FROM Ventas.VENT_DocsVentaDetalle

--GROUP BY DOCVE_Codigo 
--HAVING COUNT(*) > 5

--SELECT * FROM agenteretencion