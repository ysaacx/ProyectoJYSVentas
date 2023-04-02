USE BDSisSCC
go

CREATE TYPE [dbo].[TablaStockInicial] AS TABLE
(      [PERIO_Codigo]            [CodigoTipo]
     , [ARTIC_Codigo]            [CodArticulo]
     , [STINI_Cantidad]          [DECIMAL](14, 4)
)

--SELECT * FROM Logistica.LOG_StockIniciales




/*************************************************/
ALTER TABLE [dbo].[Parametros]
DROP CONSTRAINT [FK_Parametros_Sucursal]
GO

ALTER TABLE [dbo].[Parametros]
DROP CONSTRAINT [UNQ_Parametros]
GO

ALTER TABLE [dbo].[Parametros]
ALTER COLUMN [ZONAS_Codigo] [CodigoZona] NOT NULL
GO

ALTER TABLE [dbo].[Parametros]
ADD CONSTRAINT [UNQ_Parametros] 
UNIQUE NONCLUSTERED ([ZONAS_Codigo], [SUCUR_Id], [PARMT_Id], [APLIC_Codigo])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Parametros]
DROP CONSTRAINT [PK_Parametros]
GO

ALTER TABLE [dbo].[Parametros]
ADD CONSTRAINT [PK_Parametros] 
PRIMARY KEY CLUSTERED ([PARMT_Id], [APLIC_Codigo], [SUCUR_Id], [ZONAS_Codigo])
WITH (
  PAD_INDEX = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

/*************************************************/

INSERT INTO dbo.Parametros --( PARMT_Id ,APLIC_Codigo ,ZONAS_Codigo ,SUCUR_Id ,PARMT_Valor ,PARMT_Descripcion ,PARMT_TipoDato ,PARMT_General)
SELECT distinct PARMT_Id 
      ,APLIC_Codigo 
      ,ZONAS_Codigo = '84.00'
      ,SUCUR_Id = 1
      ,PARMT_Valor ,PARMT_Descripcion ,PARMT_TipoDato ,PARMT_General
  FROM #TMP_Para

SELECT * FROM dbo.Parametros WHERE APLIC_Codigo = 'VTA' AND SUCUR_Id = 1 AND ZONAS_Codigo = '83.00'
SELECT * INTO #TMP_Para FROM dbo.Parametros WHERE APLIC_Codigo = 'VTA' AND SUCUR_Id = 1 AND ZONAS_Codigo = '83.00'
SELECT * FROM #TMP_Para

UPDATE dbo.Parametros SET ZONAS_Codigo = '' WHERE ZONAS_Codigo IS NULL 
