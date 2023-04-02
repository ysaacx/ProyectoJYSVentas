USE BDSisSCC
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_STINISI_CargarStockInicial]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[LOG_STINISI_CargarStockInicial]
GO
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 26/12/2016
-- Descripcion         : Generacion de Asientos
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_STINISI_CargarStockInicial]
( @Tabla         [TablaStockInicial] READONLY
, @Usuario	     VARCHAR(20) 
) AS            
BEGIN   
   PRINT 'Levantar Stock Inicial'

   SELECT * FROM @Tabla

END 

GO

--EXEC LOG_STINISI_Cargar 