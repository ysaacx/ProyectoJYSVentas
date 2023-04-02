USE BDInkasFerro_PA
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
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PADROSS_ConsultarRUC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[PADROSS_ConsultarRUC]
GO 
CREATE PROC PADROSS_ConsultarRUC
@Ruc VARCHAR(15)
AS

    SELECT ENTID_NroDocumento = Ruc
         , ENTID_RazonSocial = RazonSocial
         --, Estado
         --, Condicion
         , Ubigeo = Ubigeo
         , ENTID_Direccion = Direccion 
      FROM TablaRUC 
     WHERE Ruc = @Ruc

GO 
/***************************************************************************************************************************************/ 


--SELECT TOP 10  * FROM dbo.Entidades

--SELECT count(*) FROM TablaRUC
