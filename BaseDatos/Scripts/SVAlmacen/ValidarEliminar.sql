USE BDInkaPeru
go

SELECT  * 
 FROM Tesoreria.TESO_Caja
 WHERE 
  DOCVE_Codigo = '01F0010000021' AND  ISNULL(CAJA_Estado, '') <> 'X'


  SELECT  * 
 FROM Logistica.DIST_GuiasRemision
 WHERE 
  ISNULL(GUIAR_Estado, '') <> 'X' AND  DOCVE_Codigo = '01F0010000021'


  SELECT  * 
 FROM Logistica.DIST_Ordenes
 WHERE 
  DOCVE_Codigo = '01F0010000021' AND  ISNULL(ORDEN_Estado, '') <> 'X'


  SELECT  * 
 FROM Tesoreria.TESO_Caja
 WHERE 
  DOCVE_Codigo = '01F0010000021'

exec VENT_VENTSS_RomperRelacionDocsVentas @DOCVE_Codigo=N'01F0010000021',@PVENT_Id=1,@XPago=1

  SELECT * 
 FROM Ventas.VENT_Pedidos
 WHERE 
PEDID_Codigo = 'CT0010028190'


Select m_vent_docsventa.* , Ent.ENTID_RazonSocial As ENTID_Cliente
, Entu.ENTID_RazonSocial As ENTID_UsrAdmin
, Fact.ENTID_RazonSocial As ENTID_Facturador
, Coti.ENTID_RazonSocial As ENTID_Cotizador
 From Ventas.VENT_DocsVenta As m_vent_docsventa 
 Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCliente
 Left Join dbo.Entidades As Entu On Entu.ENTID_Codigo = m_vent_docsventa.DOCVE_FPUsrMod
 Left Join dbo.Entidades As Fact On Fact.ENTID_Codigo = m_vent_docsventa.DOCVE_UsrCrea
 Left Join dbo.Entidades As Coti On Coti.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCotizador WHERE   m_VENT_DocsVenta.DOCVE_Codigo = '01F0010000021'

 Select m_vent_docsventadetalle.* , Art.ARTIC_Descripcion As ARTIC_Descripcion
, TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
, TUni.TIPOS_Codigo As TIPOS_CodUnidadMedida
, Alm.ALMAC_Descripcion As ALMAC_Descripcion
 From Ventas.VENT_DocsVentaDetalle As m_vent_docsventadetalle 
 Left Join dbo.Articulos As Art On Art.ARTIC_Codigo = m_vent_docsventadetalle.ARTIC_Codigo
 Left Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
 Left Join dbo.Almacenes As Alm On Alm.ALMAC_Id = m_vent_docsventadetalle.ALMAC_Id WHERE   m_VENT_DocsVentaDetalle.DOCVE_Codigo = '01F0010000021'

 SELECT  * 
 FROM Logistica.LOG_Stocks
 WHERE 
  DOCVE_Codigo = '01F0010000021' AND  ALMAC_Id = 1 AND  DOCVD_Item = 1 AND  ARTIC_Codigo = '0801565' AND  PERIO_Codigo = '2019'



----------------------------------------------------

DELETE FROM Logistica.LOG_Stocks
 WHERE     STOCK_Id = 51209
And ALMAC_Id = 1

DELETE FROM Ventas.VENT_DocsVentaDetalle
 WHERE   DOCVE_Codigo = '01F0010000021'

DELETE FROM Ventas.VENT_DocsVenta
 WHERE   DOCVE_Codigo = '01F0010000021'

UPDATE Ventas.VENT_Pedidos Set  PEDID_Codigo = 'CT0010028190'
,PEDID_DocumentoPercepcion = 1
,PEDID_ParaFacturar = 1
,PEDID_Estado = 'I'
,PEDID_GenerarGuia = 0
,PEDID_ModReporte = 0
,PEDID_AnuladoCaja = 0
,PEDID_UsrMod = '00000000'
,PEDID_FecMod = '2019-01-05 11:30:16.440'
 Where   ISNULL(PEDID_Codigo, '') = 'CT0010028190'

----------------------------------------------------

Select CAJA_Codigo From Tesoreria.TESO_Caja Where DOCVE_Codigo like '%00020' AND CONVERT(DATE, CAJA_FecCrea) = '2019-01-04'

SELECT * FROM Tesoreria.TESO_DocsPagos WHERE CONVERT(DATE, DPAGO_FecCrea) = '2019-01-04' AND DPAGO_Estado = 'x'

BEGIN TRAN x

delete FROM Tesoreria.TESO_CajaDocsPago
 WHERE CONVERT(DATE, CDEPO_FecCrea) = '2019-01-04'
  AND DPAGO_Id = 28686


ROLLBACK TRAN x

SELECT * FROM dbo.Parametros WHERE PARMT_Id LIKE '%serie%'

UPDATE dbo.Parametros SET PARMT_Valor = 1 WHERE PARMT_Id LIKE '%serie%'
