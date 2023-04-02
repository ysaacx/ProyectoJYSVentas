GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LINESU_UnReg]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[LINESU_UnReg]
GO
-- =========================================================
-- Autor - Fecha Crea  : Generador - 16/07/2022
-- Descripcion         : Procedimiento de Actualización de la tabla Lineas
-- Autor-Fec.Mod.-Desc : 
-- Autor-Fec.Mod.-Desc : 
-- =========================================================
CREATE PROCEDURE [dbo].[LINESU_UnReg]
( @LINEA_Codigo CodigoLinea
, @LINEA_CodPadre CodigoLinea
, @TIPOS_CodTipoComision CodigoTipo = NULL
, @LINEA_Nombre Nombres
, @LINEA_UsrMod Usuario
, @LINEA_Activo Boolean ) AS 
BEGIN

   UPDATE [Lineas]
      SET [LINEA_CodPadre] = @LINEA_CodPadre
        , [TIPOS_CodTipoComision] = @TIPOS_CodTipoComision
        , [LINEA_Nombre] = @LINEA_Nombre
        , [LINEA_UsrMod] = @LINEA_UsrMod
        , [LINEA_FecMod] = GETDATE()
        , [LINEA_Activo] = @LINEA_Activo
    WHERE [LINEA_Codigo] = @LINEA_Codigo

END
GO

