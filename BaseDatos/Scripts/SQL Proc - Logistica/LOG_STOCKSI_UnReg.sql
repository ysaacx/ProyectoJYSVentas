--USE BDSVAlmacen
--USE BDInkaPeru
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

--PERIO_Codigo, ALMAC_Id, ARTIC_Codigo
--SELECT * FROM Logistica.LOG_StockIniciales WHERE PERIO_Codigo = '2017'

--exec LOG_STOCKSI_UnReg @PERIO_Codigo=N'2019',@ARTIC_Codigo=N'0801001',@ALMAC_Id=1,@STINI_Cantidad=N'2500',@STINI_CostoInicial=N'0',@Usuario=N'00000000'