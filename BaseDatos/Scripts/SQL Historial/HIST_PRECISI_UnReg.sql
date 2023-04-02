USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[HIST_PRECISI_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[HIST_PRECISI_UnReg] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Generador - 06/02/2013
-- Descripcion         : Procedimiento de Inserción de la tabla Precios
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[HIST_PRECISI_UnReg]
(   @ZONAS_Codigo CodigoZona,
    @PRECI_Id Id,
    @ARTIC_Codigo CodArticulo,
    @TIPOS_CodTipoMoneda CodigoTipo = null ,
    @PRECI_Precio Importe = null ,
    @PRECI_TipoCambio Importe4D = null ,
    @Usuario Usuario
)

AS


INSERT INTO Historial.Precios
(   PRECI_Id                        , ZONAS_Codigo           , ARTIC_Codigo     , TIPOS_CodTipoMoneda
,   PRECI_Precio                    , PRECI_TipoCambio       , PRECI_UsrCrea    , PRECI_FecCrea
,   AUDIT_Fecha                     , AUDIT_HostName            , AUDIT_Operacion    , AUDIT_ServerName
,   AUDIT_DataBase                  , AUDIT_BDUsuario           , AUDIT_Aplicacion

)
VALUES
(   @PRECI_Id
,   @ZONAS_Codigo
,   @ARTIC_Codigo
,   @TIPOS_CodTipoMoneda
,   @PRECI_Precio
,   @PRECI_TipoCambio
,   @Usuario
,   GetDate()
,   Getdate()                       ,HOST_NAME()                ,'DELETED'          ,@@SERVERNAME 
,   db_name()                       ,SUSER_SNAME()              ,APP_NAME()
)

   UPDATE dbo.Articulos
      SET ARTIC_NuevoIngreso = 0
        , ARTIC_UsrMod = @Usuario
        , ARTIC_FecMod = GETDATE()
    WHERE ARTIC_Codigo = @ARTIC_Codigo


GO 
/***************************************************************************************************************************************/ 
