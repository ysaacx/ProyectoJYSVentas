
CREATE TABLE [Logistica].[ABAS_IngresoPorPiezas] (
  [ARTIC_Codigo] [CodArticulo] NOT NULL,
  [INGCO_Id] [Id] NOT NULL,
  [INGCD_Item] [CodSmall] NOT NULL,
  [ALMAC_Id] [CodAlmacen] NOT NULL,
  [INPZA_Codigo] [CodSmall] NOT NULL,
  [INPZA_FechaIngreso] [Fecha] NULL,
  [INPZA_CantidadIngreso] [Importe4D] NULL,
  [INPZA_Estado] [CadLetra] NULL,
  [INPZA_UsrCrea] [Usuario] NULL,
  [INPZA_FecCrea] [Fecha] NULL,
  [INPZA_UsrMod] [Usuario] NULL,
  [INPZA_FecMod] [Fecha] NULL,
  CONSTRAINT [XPKABAS_IngresoPorPiezas] PRIMARY KEY CLUSTERED ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]),
  CONSTRAINT [R_570] FOREIGN KEY ([ARTIC_Codigo]) 
  REFERENCES [dbo].[Articulos] ([ARTIC_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_578] FOREIGN KEY ([ALMAC_Id], [INGCO_Id], [INGCD_Item]) 
  REFERENCES [Logistica].[ABAS_IngresosCompraDetalle] ([ALMAC_Id], [INGCO_Id], [INGCD_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
)
ON [PRIMARY]
GO

EXEC sp_bindefault '[dbo].[Cero]', '[Logistica].[ABAS_IngresoPorPiezas].[INPZA_CantidadIngreso]'
GO

CREATE TABLE [Ventas].[VENT_PedidoPiezas] (
  [PEDID_Codigo] [Codigo12] NOT NULL,
  [PDDET_Item] [Cantidad] NOT NULL,
  [PEDPZ_Item] [CodSmall] NOT NULL,
  [ARTIC_Codigo] [CodArticulo] NOT NULL,
  [INPZA_Codigo] [CodSmall] NOT NULL,
  [INGCO_Id] [Id] NOT NULL,
  [INGCD_Item] [CodSmall] NOT NULL,
  [ALMAC_Id] [CodAlmacen] NOT NULL,
  [PEDPZ_Cantidad] [Monto4d] NULL,
  [PEDPZ_UsrCrea] [Usuario] NULL,
  [PEDPZ_FecCrea] [Fecha] NULL,
  [PEDPZ_UsrMod] [Usuario] NULL,
  [PEDPZ_FecMod] [Fecha] NULL,
  CONSTRAINT [XPKVENT_PedidoPiezas] PRIMARY KEY CLUSTERED ([PEDID_Codigo], [PDDET_Item], [PEDPZ_Item]),
  CONSTRAINT [R_579] FOREIGN KEY ([PEDID_Codigo], [PDDET_Item]) 
  REFERENCES [Ventas].[VENT_PedidosDetalle] ([PEDID_Codigo], [PDDET_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_580] FOREIGN KEY ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  REFERENCES [Logistica].[ABAS_IngresoPorPiezas] ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
)
ON [PRIMARY]
GO

CREATE TABLE [Ventas].[VENT_PedidoPiezas] (
  [PEDID_Codigo] [Codigo12] NOT NULL,
  [PDDET_Item] [Cantidad] NOT NULL,
  [PEDPZ_Item] [CodSmall] NOT NULL,
  [ARTIC_Codigo] [CodArticulo] NOT NULL,
  [INPZA_Codigo] [CodSmall] NOT NULL,
  [INGCO_Id] [Id] NOT NULL,
  [INGCD_Item] [CodSmall] NOT NULL,
  [ALMAC_Id] [CodAlmacen] NOT NULL,
  [PEDPZ_Cantidad] [Monto4d] NULL,
  [PEDPZ_UsrCrea] [Usuario] NULL,
  [PEDPZ_FecCrea] [Fecha] NULL,
  [PEDPZ_UsrMod] [Usuario] NULL,
  [PEDPZ_FecMod] [Fecha] NULL,
  CONSTRAINT [XPKVENT_PedidoPiezas] PRIMARY KEY CLUSTERED ([PEDID_Codigo], [PDDET_Item], [PEDPZ_Item]),
  CONSTRAINT [R_579] FOREIGN KEY ([PEDID_Codigo], [PDDET_Item]) 
  REFERENCES [Ventas].[VENT_PedidosDetalle] ([PEDID_Codigo], [PDDET_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_580] FOREIGN KEY ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  REFERENCES [Logistica].[ABAS_IngresoPorPiezas] ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
)
ON [PRIMARY]
GO

CREATE TABLE [Logistica].[ABAS_IngresoPorPiezasDetalle] (
  [ARTIC_Codigo] [CodArticulo] NOT NULL,
  [INGCO_Id] [Id] NOT NULL,
  [INGCD_Item] [CodSmall] NOT NULL,
  [ALMAC_Id] [CodAlmacen] NOT NULL,
  [INPZA_Codigo] [CodSmall] NOT NULL,
  [INPZD_Item] [CodSmall] NOT NULL,
  [PEDID_Codigo] [Codigo12] NULL,
  [PDDET_Item] [Cantidad] NULL,
  [DOCVD_Item] [CodSmall] NULL,
  [DOCVE_Codigo] [CodDocVenta] NULL,
  [INPZD_CantidadIngreso] [Importe4D] NULL,
  [INPZD_CantidadSalida] [Importe4D] NULL,
  [INPZD_Fecha] [Fecha] NULL,
  [INPZD_Estado] [CadLetra] NULL,
  [INPZD_UsrCrea] [Usuario] NULL,
  [INPZD_FecCrea] [Fecha] NULL,
  [INPZD_UsrMod] [Usuario] NULL,
  [INPZD_FecMod] [Fecha] NULL,
  [PEDPZ_Item] [CodSmall] NULL,
  CONSTRAINT [XPKABAS_IngresoPorPiezasDetalle] PRIMARY KEY CLUSTERED ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo], [INPZD_Item]),
  CONSTRAINT [R_574] FOREIGN KEY ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  REFERENCES [Logistica].[ABAS_IngresoPorPiezas] ([ARTIC_Codigo], [INGCO_Id], [INGCD_Item], [ALMAC_Id], [INPZA_Codigo]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_575] FOREIGN KEY ([PEDID_Codigo], [PDDET_Item]) 
  REFERENCES [Ventas].[VENT_PedidosDetalle] ([PEDID_Codigo], [PDDET_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_576] FOREIGN KEY ([DOCVE_Codigo], [DOCVD_Item]) 
  REFERENCES [Ventas].[VENT_DocsVentaDetalle] ([DOCVE_Codigo], [DOCVD_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  CONSTRAINT [R_581] FOREIGN KEY ([PEDID_Codigo], [PDDET_Item], [PEDPZ_Item]) 
  REFERENCES [Ventas].[VENT_PedidoPiezas] ([PEDID_Codigo], [PDDET_Item], [PEDPZ_Item]) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
)
ON [PRIMARY]
GO

EXEC sp_bindefault '[dbo].[Cero]', '[Logistica].[ABAS_IngresoPorPiezasDetalle].[INPZD_CantidadIngreso]'
GO

EXEC sp_bindefault '[dbo].[Cero]', '[Logistica].[ABAS_IngresoPorPiezasDetalle].[INPZD_CantidadSalida]'
GO

EXEC sp_addextendedproperty 'MS_Description', N'Estado
I = Ingresado
X = Anulado', 'schema', 'Logistica', 'table', 'ABAS_IngresoPorPiezasDetalle', 'column', 'INPZD_Estado'
GO