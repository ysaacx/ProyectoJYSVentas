USE BDInkasFerro
go


/*==========================================================================================================================================*/
/*------------------------------------------------------------------------------------------------------------------------------------------*/

ALTER TABLE [Ventas].[VENT_Pedidos]
DROP CONSTRAINT [FK_VENT_Pedidos_VENT_DocsVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Contabilidad].[CONT_DocsPercepcion]
DROP CONSTRAINT [FK_CONT_DocsPercepcion_DocumentoVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Logistica].[CTRL_Arreglos]
DROP CONSTRAINT [FK_LOG_Arreglos_DocsVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Tesoreria].[TESO_Caja]
DROP CONSTRAINT [FK_TESO_Caja_DocVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Tesoreria].[TESO_DocsPagos]
DROP CONSTRAINT [FK_TESO_DocsPagos_Ventas]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Transportes].[TRAN_Cotizaciones]
DROP CONSTRAINT [FK_TRAN_Cotizaciones_DocumentoVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Transportes].[TRAN_ViajesVentas]
DROP CONSTRAINT [FK_TRAN_ViajesVentas_Ventas]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Ventas].[VENT_DocsRelacion]
DROP CONSTRAINT [FK_VENT_DocsRelacion_CodPadre]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Ventas].[VENT_DocsRelacion]
DROP CONSTRAINT [FK_VENT_DocsRelacion_CodReferencia]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
DROP CONSTRAINT [FK_VENT_DocsVentaDetalle_DocsVenta]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
DROP CONSTRAINT [FK_VENT_DocsVentaDetalle_DocReferencia]
GO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
ALTER TABLE [Ventas].[VENT_DocsVentaPagos]
DROP CONSTRAINT [FK_VENT_DocsVentaPagos_DocsVenta]
GO

/*==========================================================================================================================================*/

--ALTER TABLE [Ventas].[VENT_DocsVenta]
--DROP CONSTRAINT [PK_VENT_DocsVenta]
--GO

/*==========================================================================================================================================*/

ALTER TABLE [Ventas].[VENT_DocsVenta]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO

/*==========================================================================================================================================*/

ALTER TABLE [Ventas].[VENT_DocsVenta]
DROP CONSTRAINT [PK_VENT_DocsVenta]
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVenta]
ADD CONSTRAINT [PK_VENT_DocsVenta] 
PRIMARY KEY CLUSTERED ([DOCVE_Codigo])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
GO
/*==========================================================================================================================================*/
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVentaPagos] DROP CONSTRAINT [PK__VENT_Doc__17A85D1B3732A735]
--ALTER TABLE [Ventas].[VENT_DocsVentaPagos] DROP CONSTRAINT [PK_VENT_DocsVentaPagos]
GO
ALTER TABLE [Ventas].[VENT_DocsVentaPagos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO
ALTER TABLE [Ventas].[VENT_DocsVentaPagos]
ADD CONSTRAINT [PK_VENT_DocsVentaPagos] 
PRIMARY KEY CLUSTERED ([PVENT_Id], [DPAGO_Id], [DOCVE_Codigo])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVentaPagos]
ADD CONSTRAINT [FK_VENT_DocsVentaPagos_DocsVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[DIST_GuiasRemisionVentas]
DROP CONSTRAINT [FK_DIST_GuiasRemisionVentas_VentasDetalle]
GO

DROP INDEX [IDX_DIST_GuiasRemisionVentas_idx] ON [Logistica].[DIST_GuiasRemisionVentas]
GO

DROP INDEX [IDX_DIST_GuiasRemisionVentas_idx3] ON [Logistica].[DIST_GuiasRemisionVentas]
GO

ALTER TABLE [Logistica].[DIST_GuiasRemisionVentas]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO

CREATE NONCLUSTERED INDEX [IDX_DIST_GuiasRemisionVentas_idx] ON [Logistica].[DIST_GuiasRemisionVentas]
  ([DOCVE_Codigo])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_DIST_GuiasRemisionVentas_idx3] ON [Logistica].[DIST_GuiasRemisionVentas]
  ([DOCVE_Codigo], [DOCVD_Item])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[ABAS_IngresoPorPiezasDetalle] DROP CONSTRAINT [R_576]
--ALTER TABLE [Logistica].[ABAS_IngresoPorPiezasDetalle] DROP CONSTRAINT [FK_ABAS_IngresoPorPiezasDetalle_VentasDetalle]

GO
ALTER TABLE [Logistica].[ABAS_IngresoPorPiezasDetalle]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO

/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[LOG_Stocks]
DROP CONSTRAINT [FK_LOG_Saldos_DocVenta]
GO
ALTER TABLE [Logistica].[LOG_Stocks]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
DROP CONSTRAINT [PK_VENT_DocsVentaDetalle]
GO
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
ADD CONSTRAINT [PK_VENT_DocsVentaDetalle] 
PRIMARY KEY CLUSTERED ([DOCVE_Codigo], [DOCVD_Item])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[LOG_Stocks]
ADD CONSTRAINT [FK_LOG_Saldos_DocVenta] FOREIGN KEY ([DOCVE_Codigo], [DOCVD_Item]) 
  REFERENCES [Ventas].[VENT_DocsVentaDetalle] ([DOCVE_Codigo], [DOCVD_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[ABAS_IngresoPorPiezasDetalle]
ADD CONSTRAINT [FK_ABAS_IngresoPorPiezasDetalle_VentasDetalle] FOREIGN KEY ([DOCVE_Codigo], [DOCVD_Item]) 
  REFERENCES [Ventas].[VENT_DocsVentaDetalle] ([DOCVE_Codigo], [DOCVD_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[DIST_GuiasRemisionVentas]
ADD CONSTRAINT [FK_DIST_GuiasRemisionVentas_VentasDetalle] FOREIGN KEY ([DOCVE_Codigo], [DOCVD_Item]) 
  REFERENCES [Ventas].[VENT_DocsVentaDetalle] ([DOCVE_Codigo], [DOCVD_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
ALTER COLUMN [DOCVE_CodigoReferencia] [CodDocVentaNew] null 
GO
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
ADD CONSTRAINT [FK_VENT_DocsVentaDetalle_DocReferencia] FOREIGN KEY ([DOCVE_CodigoReferencia]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsVentaDetalle]
ADD CONSTRAINT [FK_VENT_DocsVentaDetalle_DocsVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_DocsRelacion] DROP CONSTRAINT [PK__VENT_Doc__8731F6583065AE15]
---ALTER TABLE [Ventas].[VENT_DocsRelacion] DROP CONSTRAINT [PK_VENT_DocsRelacion]
GO
ALTER TABLE [Ventas].[VENT_DocsRelacion]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO
ALTER TABLE [Ventas].[VENT_DocsRelacion]
ADD CONSTRAINT [PK_VENT_DocsRelacion] 
PRIMARY KEY CLUSTERED ([DOCVE_Codigo], [DOCVE_CodReferencia])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
GO

ALTER TABLE [Ventas].[VENT_DocsRelacion]
DROP CONSTRAINT [PK_VENT_DocsRelacion]
GO

ALTER TABLE [Ventas].[VENT_DocsRelacion]
ALTER COLUMN [DOCVE_CodReferencia] [CodDocVentaNew] NOT NULL
GO

ALTER TABLE [Ventas].[VENT_DocsRelacion]
ADD CONSTRAINT [PK_VENT_DocsRelacion] 
PRIMARY KEY CLUSTERED ([DOCVE_Codigo], [DOCVE_CodReferencia])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [Ventas].[VENT_DocsRelacion]
ADD CONSTRAINT [FK_VENT_DocsRelacion_CodReferencia] FOREIGN KEY ([DOCVE_CodReferencia]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

ALTER TABLE [Ventas].[VENT_DocsRelacion]
ADD CONSTRAINT [FK_VENT_DocsRelacion_CodPadre] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Transportes].[TRAN_ViajesVentas]
DROP CONSTRAINT [PK__TRAN_Via__485FED550E0FCABA]
GO
ALTER TABLE [Transportes].[TRAN_ViajesVentas]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO
ALTER TABLE [Transportes].[TRAN_ViajesVentas]
ADD CONSTRAINT [PK_TRAN_ViajesVentas] 
PRIMARY KEY CLUSTERED ([VIAJE_Id], [DOCVE_Codigo], [FLETE_Id])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
GO
ALTER TABLE [Transportes].[TRAN_ViajesVentas]
ADD CONSTRAINT [FK_TRAN_ViajesVentas_Ventas] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Transportes].[TRAN_Cotizaciones]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
ALTER TABLE [Transportes].[TRAN_Cotizaciones]
ADD CONSTRAINT [FK_TRAN_Cotizaciones_DocumentoVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO

/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Tesoreria].[TESO_DocsPagos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL
GO
ALTER TABLE [Tesoreria].[TESO_DocsPagos]
ADD CONSTRAINT [FK_TESO_DocsPagos_Ventas] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
DROP INDEX [IDX_TESO_Caja_DOCVE_Codigo] ON [Tesoreria].[TESO_Caja]
GO

ALTER TABLE [Tesoreria].[TESO_Caja]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO

CREATE NONCLUSTERED INDEX [IDX_TESO_Caja_DOCVE_Codigo] ON [Tesoreria].[TESO_Caja]
  ([DOCVE_Codigo])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO
ALTER TABLE [Tesoreria].[TESO_Caja]
ADD CONSTRAINT [FK_TESO_Caja_DocVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[CTRL_Arreglos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
ALTER TABLE [Logistica].[CTRL_Arreglos]
ADD CONSTRAINT [FK_LOG_Arreglos_DocsVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Contabilidad].[CONT_DocsPercepcion]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
ALTER TABLE [Contabilidad].[CONT_DocsPercepcion]
ADD CONSTRAINT [FK_CONT_DocsPercepcion_DocumentoVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Ventas].[VENT_Pedidos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL
GO
ALTER TABLE [Ventas].[VENT_Pedidos]
ADD CONSTRAINT [FK_VENT_Pedidos_VENT_DocsVenta] FOREIGN KEY ([DOCVE_Codigo]) 
  REFERENCES [Ventas].[VENT_DocsVenta] ([DOCVE_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
DROP INDEX [IDX_VENT_DocsVenta_idx] ON [Historial].[VENT_DocsVenta]
GO

ALTER TABLE [Historial].[VENT_DocsVenta]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NOT NULL
GO

CREATE NONCLUSTERED INDEX [IDX_VENT_DocsVenta_idx] ON [Historial].[VENT_DocsVenta]
  ([DOCVE_Codigo], [AUDIT_Id])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO
ALTER TABLE [Historial].[VENT_Pedidos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL
GO
ALTER TABLE [Historial].[DIST_GuiasRemision]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
ALTER TABLE [Historial].[DIST_Ordenes]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
ALTER TABLE [Historial].[LOG_Stocks]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL
GO
ALTER TABLE [Historial].[TESO_Caja]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
ALTER TABLE [Logistica].[DIST_GuiasRemision]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew]
GO
/*------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------*/

/*==========================================================================================================================================*/