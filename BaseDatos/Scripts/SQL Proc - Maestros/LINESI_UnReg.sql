GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LINESI_UnReg]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[LINESI_UnReg]
GO
-- =========================================================
-- Autor - Fecha Crea  : Generador - 16/07/2022
-- Descripcion         : Procedimiento de Inserción de la tabla Lineas
-- Autor-Fec.Mod.-Desc : 
-- Autor-Fec.Mod.-Desc : 
-- =========================================================
CREATE PROCEDURE [dbo].[LINESI_UnReg]
( @LINEA_Codigo CodigoLinea OUTPUT
, @LINEA_CodPadre CodigoLinea
, @TIPOS_CodTipoComision CodigoTipo = NULL 
, @LINEA_Nombre Nombres
, @LINEA_UsrCrea Usuario
, @LINEA_Activo Boolean
) AS
BEGIN

    IF @LINEA_CodPadre IS NOT NULL 
        SET @LINEA_Codigo = @LINEA_CodPadre + RIGHT('00' + RTRIM(ISNULL((SELECT MAX(RIGHT(LINEA_Codigo, 2)) FROM Lineas WHERE LEN(LINEA_Codigo) = 4 AND LINEA_CodPadre = @LINEA_CodPadre), 0) + 1), 2)
    ELSE
        SET @LINEA_Codigo = RIGHT('00' + RTRIM(ISNULL((SELECT MAX(LINEA_Codigo) FROM Lineas WHERE LEN(LINEA_Codigo) = 2), 0) + 1), 2)

   INSERT INTO [Lineas]
        ( LINEA_Codigo , LINEA_CodPadre , TIPOS_CodTipoComision , LINEA_Nombre
        , LINEA_UsrCrea , LINEA_FecCrea , LINEA_Activo   )
   VALUES
        ( @LINEA_Codigo , @LINEA_CodPadre , @TIPOS_CodTipoComision , @LINEA_Nombre
        , @LINEA_UsrCrea , GETDATE() , @LINEA_Activo   )

END


GO
BEGIN TRAN X
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre=NULL,@LINEA_Nombre=N'LINEA ',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre='02',@LINEA_Nombre=N'LINEA 2.1',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre='02',@LINEA_Nombre=N'LINEA 2.2',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre=NULL,@LINEA_Nombre=N'LINEA ',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre='03',@LINEA_Nombre=N'LINEA 3.1',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
exec LINESI_UnReg @LINEA_Codigo=N'',@LINEA_CodPadre='03',@LINEA_Nombre=N'LINEA 3.2',@LINEA_UsrCrea=N'000000',@LINEA_Activo=N'True'
SELECT * FROM [Lineas]
ROLLBACK TRAN X

