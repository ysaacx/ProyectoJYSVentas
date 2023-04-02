GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PADROSU_Finalizar]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[PADROSU_Finalizar] 
GO 
CREATE PROC PADROSU_Finalizar
( @TipoDoc INT = NULL 
, @Usuario VARCHAR(20)
)
AS

IF ISNULL(@TipoDoc, 0) = 0
    BEGIN
        PRINT '-- RUC --'        
    END 
ELSE
    BEGIN
        PRINT '-- PERCEPCION 3 --'
        DELETE FROM EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR' + RIGHT('00' + RTRIM(@TipoDoc), 2)
        INSERT INTO dbo.EntidadesPadrones
                ( ENTID_Codigo ,
                  TIPOS_CodTipoPadron ,
                  ENTID_NroDocumento ,
                  ENPAD_MaqReg ,
                  ENPAD_RazonSocial ,
                  ENPAD_TipoEntidad ,
                  ENPAD_FecIni ,
                  ENPAD_Resolucion ,
                  ENPAD_UsrCrea ,
                  ENPAD_FecCrea)
           SELECT ENTID_Codigo = RUC,
                  TIPOS_CodTipoPadron = 'PDR' + RIGHT('00' + RTRIM(@TipoDoc), 2) ,
                  ENTID_NroDocumento = Ruc ,
                  ENPAD_MaqReg = NULL ,
                  ENPAD_RazonSocial = RazonSocial ,
                  ENPAD_TipoEntidad = NULL  ,
                  ENPAD_FecIni = MAX(Fecha) ,
                  ENPAD_Resolucion = MAX(Resolucion) ,
                  ENPAD_UsrCrea = @Usuario,
                  ENPAD_FecCrea = GETDATE()
             FROM TablaPadron
            GROUP BY Ruc, RazonSocial
        
    END 
--IF ISNULL(@TipoDoc, 0) = 4
--    BEGIN
--        PRINT '-- RETENCION 4 --'
        
--    END 

GO 
/***************************************************************************************************************************************/ 
