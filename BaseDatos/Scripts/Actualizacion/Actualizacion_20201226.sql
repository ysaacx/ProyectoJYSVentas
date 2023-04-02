USE BDCOMAFISUR
USE BDInkaPeru
USE BDInkasFerro_PA
go


IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
			   WHERE SYSOBJECTS.NAME = 'LOG_StockIniciales' AND SYSCOLUMNS.NAME= 'STINI_CostoInicial') 
    ALTER TABLE Logistica.LOG_StockIniciales ADD STINI_CostoInicial DECIMAL(15,4)


go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_STOCKSS_TodosPorPeriodo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[LOG_STOCKSS_TodosPorPeriodo]
GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 18/05/2017
-- Descripcion         : Procedimiento de Selección de todos de la tabla StockIniciales
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSS_TodosPorPeriodo]
(@PERIO_Codigo CodigoTipo)
AS

BEGIN 

SELECT STOCK.PERIO_Codigo
     , LINEA.LINEA_Nombre AS LINEA
     , SLIN.LINEA_Nombre AS SUBLINEA
     , ARTIC.ARTIC_Codigo
     , ARTIC.ARTIC_Descripcion
     , STOCK.ALMAC_Id
     , ALMAC.ALMAC_Descripcion
     , STOCK.STINI_Cantidad
     , STOCK.STINI_CostoInicial
  INTO #StockIni
  FROM Logistica.LOG_StockIniciales STOCK 
 INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = STOCK.ARTIC_Codigo
 INNER JOIN dbo.Almacenes ALMAC ON ALMAC.ALMAC_Id = STOCK.ALMAC_Id
 INNER JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2)
 INNER JOIN dbo.Lineas SLIN ON SLIN.LINEA_Codigo = ARTIC.LINEA_Codigo
 WHERE STOCK.PERIO_Codigo = @PERIO_Codigo
   AND ARTIC.ARTIC_Descontinuado = 0
 ORDER BY PERIO_Codigo, ARTIC_Codigo

 IF NOT EXISTS(SELECT * FROM #StockIni)
    BEGIN
        SELECT PERIO_Codigo = @PERIO_Codigo
             , LINEA.LINEA_Nombre AS LINEA
             , SLIN.LINEA_Nombre AS SUBLINEA
             , ARTIC.ARTIC_Codigo
             , ARTIC.ARTIC_Descripcion
             , ALMAC_Id = 1
             , ALMAC.ALMAC_Descripcion
             , STINI_Cantidad = CONVERT(DECIMAL(15, 2), 0.00)
             , STINI_CostoInicial = CONVERT(DECIMAL(15, 4), 0.0000)
          FROM dbo.Articulos ARTIC 
         INNER JOIN dbo.Almacenes ALMAC ON ALMAC.ALMAC_Id = 1
         INNER JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2)
         INNER JOIN dbo.Lineas SLIN ON SLIN.LINEA_Codigo = ARTIC.LINEA_Codigo
         WHERE ARTIC.ARTIC_Descontinuado = 0
         ORDER BY LINEA, SUBLINEA, ARTIC_Codigo    
    END 
ELSE
    BEGIN 
        SELECT * FROM #StockIni
        UNION 
        SELECT PERIO_Codigo = @PERIO_Codigo
             , LINEA.LINEA_Nombre AS LINEA
             , SLIN.LINEA_Nombre AS SUBLINEA
             , ARTIC.ARTIC_Codigo
             , ARTIC.ARTIC_Descripcion
             , ALMAC_Id = 1
             , ALMAC.ALMAC_Descripcion
             , STINI_Cantidad = CONVERT(DECIMAL(15, 2), 0.00)
             , STINI_CostoInicial = CONVERT(DECIMAL(15, 4), 0.0000)
          FROM dbo.Articulos ARTIC 
         INNER JOIN dbo.Almacenes ALMAC ON ALMAC.ALMAC_Id = 1
         INNER JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2)
         INNER JOIN dbo.Lineas SLIN ON SLIN.LINEA_Codigo = ARTIC.LINEA_Codigo
         WHERE NOT ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM #StockIni)
           AND ARTIC.ARTIC_Descontinuado = 0
         ORDER BY LINEA, SUBLINEA, ARTIC_Codigo    
    END 

END 

GO

GO
IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_STOCKSI_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[LOG_STOCKSI_UnReg]

GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 18/05/2017
-- Descripcion         : Procedimiento de Inserción de la tabla StockIniciales
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSI_UnReg]
(	@PERIO_Codigo CodigoTipo,
	@ARTIC_Codigo CodArticulo,
	@ALMAC_Id CodAlmacen,
--	@STINI_Id Id,
	@STINI_Cantidad decimal(14, 4),
    @STINI_CostoInicial decimal(14, 4),
--	@STINI_Fecha Fecha,
	@Usuario Usuario
)
AS

IF EXISTS(SELECT * FROM Logistica.LOG_StockIniciales 
           WHERE PERIO_Codigo = @PERIO_Codigo AND ARTIC_Codigo = @ARTIC_Codigo AND ALMAC_Id = @ALMAC_Id)
   BEGIN 
      PRINT 'UPDATE'
      UPDATE Logistica.LOG_StockIniciales
         SET [STINI_Cantidad] = @STINI_Cantidad
           , [STINI_Fecha]    = GETDATE()
           , [STINI_UsrMod]   = @Usuario
           , [SYINI_FecMod]   = GetDate()
           , STINI_CostoInicial = @STINI_CostoInicial
       WHERE PERIO_Codigo = @PERIO_Codigo
         And ALMAC_Id = @ALMAC_Id
         And ARTIC_Codigo = @ARTIC_Codigo
   END
ELSE
   BEGIN 
      PRINT 'INSERT'
        INSERT INTO Logistica.LOG_StockIniciales
            (	PERIO_Codigo            ,	ARTIC_Codigo            ,	ALMAC_Id            , STINI_Cantidad
            ,	STINI_Fecha             ,	STINI_UsrCrea           ,	STINI_FecCrea       , STINI_CostoInicial)
            VALUES
            (	@PERIO_Codigo           ,	@ARTIC_Codigo           ,	@ALMAC_Id           ,	@STINI_Cantidad
            ,	GETDATE()               ,	@Usuario                ,	GetDate()           , @STINI_CostoInicial
            )
   END

GO

GO
