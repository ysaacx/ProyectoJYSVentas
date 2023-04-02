ALTER TABLE [Logistica].[DIST_GuiasRemision]
ALTER COLUMN [GUIAR_DireccOrigen] varchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL
GO

ALTER TABLE Historial.[DIST_GuiasRemision]
ALTER COLUMN [GUIAR_DireccOrigen] varchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL
GO}