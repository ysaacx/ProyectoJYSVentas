USE BDSisSCC
GO

IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
			   WHERE SYSOBJECTS.NAME = 'ABAS_DocsCompra' AND SYSCOLUMNS.NAME= 'DOCCO_TipoRegistro') 

	ALTER TABLE [Logistica].[ABAS_DocsCompra]
	ADD [DOCCO_TipoRegistro] char(1) NULL
GO


IF NOT EXISTS(SELECT * FROM sys.extended_properties prop INNER JOIN sys.all_columns colum ON colum.column_id = prop.minor_id AND colum.object_id = prop.major_id INNER JOIN sys.all_objects tb ON tb.object_id = colum.object_id 
               WHERE prop.name = 'MS_Description' AND class = 1 AND tb.name = 'ABAS_DocsCompra' AND colum.name = 'DOCCO_TipoRegistro')

	EXEC sp_addextendedproperty 'MS_Description', N'Tipo de Registro
	R: Registro de Compra
	I: Registro e Ingreso de Mercaderia', 'schema', 'Logistica', 'table', 'ABAS_DocsCompra', 'column', 'DOCCO_TipoRegistro'
GO

--ALTER TABLE [dbo].[Lineas]
--ADD [LINEA_Inactivo] [Boolean] NULL
GO

IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'Lineas' AND SYSCOLUMNS.NAME= 'LINEA_Activo') 
    BEGIN 
        ALTER TABLE [dbo].[Lineas]
        ADD [LINEA_Activo] [Boolean] NULL
    END 
go
UPDATE dbo.Lineas SET LINEA_Activo = 1 

IF NOT EXISTS(SELECT * FROM sys.objects WHERE name LIKE 'PK_Sucursales')
    BEGIN
        ALTER TABLE [dbo].[Sucursales]
        DROP CONSTRAINT [PK_Sucursales]

        ALTER TABLE [dbo].[Sucursales]
        ADD CONSTRAINT [PK_Sucursales] 
        PRIMARY KEY CLUSTERED ([EMPRE_Codigo], [ZONAS_Codigo], [SUCUR_Id])
        WITH (
          PAD_INDEX = OFF,
          STATISTICS_NORECOMPUTE = OFF,
          ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON)
        ON [PRIMARY]
    END 
    
ALTER TABLE [dbo].[PuntoVenta]
ALTER COLUMN [PVENT_BaseDatos] varchar(50) COLLATE Modern_Spanish_CI_AS
GO

IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'VENT_PVentDocumento' AND SYSCOLUMNS.NAME= 'PVDOCU_Default') 
    BEGIN 
        ALTER TABLE [Ventas].[VENT_PVentDocumento]
        ADD [PVDOCU_Default] bit NULL
    END 
GO


ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_SubImporteCompra] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_SubImporteIgv] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_PrecioUnitario] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_SubImporteCompra] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_Costo] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_CostoIGV] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_SubTotal] [Importe4D]
GO

ALTER TABLE [Logistica].[ABAS_DocsCompraDetalle]
ALTER COLUMN [DOCCD_PesoUnitario] [Importe4D]
GO


IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'VENT_PVentDocumento' AND SYSCOLUMNS.NAME= 'PVDOCU_PrintHeader') 
    BEGIN 
        ALTER TABLE [Ventas].[VENT_PVentDocumento]
        ADD [PVDOCU_PrintHeader] [Boolean] NULL
    END 


IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'VENT_PVentDocumento' AND SYSCOLUMNS.NAME= 'PVDOCU_PrintBody') 
    BEGIN 
        ALTER TABLE [Ventas].[VENT_PVentDocumento]
        ADD [PVDOCU_PrintBody] [Boolean] NULL
    END 

IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'VENT_PVentDocumento' AND SYSCOLUMNS.NAME= 'PVDOCU_PrintFooter') 
    BEGIN 
        ALTER TABLE [Ventas].[VENT_PVentDocumento]
        ADD [PVDOCU_PrintFooter] [Boolean] NULL
    END 





ALTER TABLE [Logistica].[DIST_GuiasRemision]
ALTER COLUMN [GUIAR_TotalPeso] [Peso] NOT NULL
GO

--ALTER TABLE [Logistica].[DIST_GuiasRemision]
--ADD DEFAULT 0 FOR [GUIAR_TotalPeso]
--GO

UPDATE BDSAdmin.dbo.Procesos SET APLI_Codigo = 'VTA' WHERE PROC_Codigo IN ('CPCAR', 'PDSKG', 'CPCXR', 'CPCXF')

ALTER TABLE [Logistica].[CTRL_Arreglos]
ALTER COLUMN [DOCVE_Codigo] [CodDocVentaNew] NULL 
GO

