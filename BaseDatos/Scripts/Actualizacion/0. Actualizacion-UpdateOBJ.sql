--USE BDJAYVIC
--USE BDNOVACERO
USE BDInkasFerro_PA
go

--SELECT * FROM dbo.Articulos
IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
  WHERE SYSOBJECTS.NAME = 'Articulos' AND SYSCOLUMNS.NAME= 'ARTIC_CodigoAlterno') 
    ALTER TABLE Articulos ADD ARTIC_CodigoAlterno VARCHAR(15) NULL 

ALTER TABLE Ventas.VENT_DocsVenta ALTER COLUMN DOCVE_DireccionCliente VARCHAR(200) NULL

ALTER TABLE Historial.VENT_DocsVenta ALTER COLUMN DOCVE_DireccionCliente VARCHAR(200) NULL

ALTER TABLE Ventas.VENT_Pedidos ALTER COLUMN PEDID_DireccionCliente VARCHAR(200) NULL


IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'TablaPadron')
   BEGIN
      CREATE TYPE [dbo].[TablaPadron] AS TABLE
      (
        Ruc             VARCHAR(15) NOT NULL,
        RazonSocial     VARCHAR(200) NOT NULL,
        Fecha           DATETIME NULL,
        Resolucion      VARCHAR(50) NULL
      )
   END 
GO

--IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'TablaPadron')
--   BEGIN
      CREATE TABLE [dbo].[TablaPadron] 
      (
        Ruc             VARCHAR(15) NOT NULL,
        RazonSocial     VARCHAR(200) NOT NULL,
        Fecha           DATETIME NULL,
        Resolucion      VARCHAR(50) NULL
      )
--   END 
--GO
      --DROP TABLE [TablaRUC]
      CREATE TABLE [dbo].[TablaRUC] 
      (
        Ruc             VARCHAR(15) NOT NULL,
        RazonSocial     VARCHAR(200) NOT NULL,
        Estado          BIT NULL,
        Condicion       VARCHAR(20) NULL ,
        Ubigeo          VARCHAR(6),
        Direccion       VARCHAR(200) NULL
        CONSTRAINT [CAT_HSAGPK] PRIMARY KEY CLUSTERED ( Ruc ASC   )
      )



SELECT * FROM [TablaPadron]
SELECT * FROM dbo.EntidadesPadrones
--TRUNCATE TABLE TablaRUC
SELECT COUNT(*) FROM TablaRUC
SELECT * FROM TablaRUC WHERE Ruc = '20454819137'

--SELECT TOP 100 * FROM dbo.Entidades WHERE ENTID_Direccion IS NOT NULL  ORDER BY ENTID_FecCrea DESC 
--SELECT * FROM Historial.VENT_DocsVenta
-- SELECT  * 
-- FROM dbo.Entidades
-- WHERE 
--  ISNULL(ENTID_NroDocumento, '') = '20607591734'
--  Select Distinct m_entidades.* , TDoc.TIPOS_DescCorta As TIPOS_Documento
--, Prov.PROVE_Contacto As PROVE_Contacto
-- From dbo.Entidades As m_entidades 
-- Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = m_entidades.TIPOS_CodTipoDocumento
-- Inner Join dbo.EntidadesRoles As Rol On Rol.ENTID_Codigo = m_entidades.ENTID_Codigo
-- Left Join dbo.Proveedores As Prov On Prov.ENTID_Codigo = m_entidades.ENTID_Codigo WHERE  ISNULL(CONVERT(VARCHAR(100), m_Entidades.ENTID_NroDocumento), '') Like '%20607591734%' AND  ISNULL(m_Entidades.ENTID_Estado, '') <> 'X'
