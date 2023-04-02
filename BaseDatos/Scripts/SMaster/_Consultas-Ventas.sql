USE BDInkaPeru
GO 


exec LOG_DIST_GUIASS_ObtDetDocVenta @DOCVE_Codigo=N'01F0010004994',@ALMAC_Id=1

exec LOG_DISTSS_OrdenesXDocumento @DOCVE_Codigo=N'01F0010004994',@PVENT_Id=1

--LOG_DIST_GUIASS_ObtDetOrdenes
exec LOG_DISTSS_GuiasXDocumento @DOCVE_Codigo=N'01F0010004994',@PVENT_Id=1

exec VENT_DOCVESS_GetDocsPago @DOCVE_Codigo=N'01F0010004994'
exec LOG_DIST_GUIASS_ObtDetDocVenta @DOCVE_Codigo=N'01F0010004994',@ALMAC_Id=1

Select m_vent_docsventa.* , Ent.ENTID_RazonSocial As ENTID_Cliente
, Entu.ENTID_RazonSocial As ENTID_UsrAdmin
, Fact.ENTID_RazonSocial As ENTID_Facturador
, Coti.ENTID_RazonSocial As ENTID_Cotizador
 From Ventas.VENT_DocsVenta As m_vent_docsventa 
 Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCliente
 Left Join dbo.Entidades As Entu On Entu.ENTID_Codigo = m_vent_docsventa.DOCVE_FPUsrMod
 Left Join dbo.Entidades As Fact On Fact.ENTID_Codigo = m_vent_docsventa.DOCVE_UsrCrea
 Left Join dbo.Entidades As Coti On Coti.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCotizador WHERE   m_VENT_DocsVenta.DOCVE_Codigo = '01F0010004994'



Select m_vent_docsventadetalle.* , Art.ARTIC_Descripcion As ARTIC_Descripcion
, TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
, TUni.TIPOS_Codigo As TIPOS_CodUnidadMedida
, Alm.ALMAC_Descripcion As ALMAC_Descripcion
 From Ventas.VENT_DocsVentaDetalle As m_vent_docsventadetalle 
 Left Join dbo.Articulos As Art On Art.ARTIC_Codigo = m_vent_docsventadetalle.ARTIC_Codigo
 Left Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
 Left Join dbo.Almacenes As Alm On Alm.ALMAC_Id = m_vent_docsventadetalle.ALMAC_Id WHERE   m_VENT_DocsVentaDetalle.DOCVE_Codigo = '01F0010004994'

Select m_vent_docsventa.* , Ent.ENTID_RazonSocial As ENTID_Cliente
, Entu.ENTID_RazonSocial As ENTID_UsrAdmin
, Fact.ENTID_RazonSocial As ENTID_Facturador
, Coti.ENTID_RazonSocial As ENTID_Cotizador
 From Ventas.VENT_DocsVenta As m_vent_docsventa 
 Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCliente
 Left Join dbo.Entidades As Entu On Entu.ENTID_Codigo = m_vent_docsventa.DOCVE_FPUsrMod
 Left Join dbo.Entidades As Fact On Fact.ENTID_Codigo = m_vent_docsventa.DOCVE_UsrCrea
 Left Join dbo.Entidades As Coti On Coti.ENTID_Codigo = m_vent_docsventa.ENTID_CodigoCotizador WHERE   m_VENT_DocsVenta.DOCVE_Codigo = '01F0010004994'

