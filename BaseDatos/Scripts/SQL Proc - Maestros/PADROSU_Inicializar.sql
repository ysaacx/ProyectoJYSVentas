GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PADROSU_Inicializar]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[PADROSU_Inicializar] 
GO 
CREATE PROC PADROSU_Inicializar
@TipoDoc INT = NULL 
AS

IF ISNULL(@TipoDoc, 0) = 0
    BEGIN
        PRINT '-- RUC --'
        TRUNCATE TABLE TablaRUC
    END 
ELSE
    BEGIN
        TRUNCATE TABLE TablaPadron
    END 

GO 
/***************************************************************************************************************************************/ 

--SELECT TOP 100 * FROM TablaRUC
--exec PADROSS_ConsultarRUC @Ruc=N'20509119008'
