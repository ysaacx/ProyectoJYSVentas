

ALTER TABLE [dbo].[Articulos]
ADD [ARTIC_NuevoIngreso] [Boolean] NULL
GO

ALTER TABLE [dbo].[Articulos]
ADD [ARTIC_UsrNuevoIngreso] [Usuario] NULL
GO

ALTER TABLE [dbo].[Articulos]
ADD [ARTIC_FecNuevoIngreso] [Fecha] NULL
GO
