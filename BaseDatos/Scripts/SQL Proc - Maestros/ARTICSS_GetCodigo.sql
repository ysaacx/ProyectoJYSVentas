USE BDInkaPeru
--USE BDInkasFerro_Parusttacca
GO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_GetCodigo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[ARTICSS_GetCodigo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_GetCodigo]
(
      @Linea CodigoLinea = Null
)
AS
BEGIN 

DECLARE @Codigo INT 

    SET @Codigo = ISNULL((SELECT MAX(CONVERT(INT, RIGHT(ARTIC.ARTIC_Codigo, 3))) 
                     FROM dbo.Articulos ARTIC
                    WHERE LEFT(ARTIC.ARTIC_Codigo, 4) = @Linea), 0) + 1

    SELECT @Codigo AS CODIGO
END 
GO
  
EXEC dbo.ARTICSS_GetCodigo @Linea = '0701' -- CodigoLinea
  
  --SELECT * FROM dbo.Articulos WHERE LINEA_Codigo = '0701'
  --SELECT * FROM dbo.Articulos WHERE LEFT(ARTIC_Codigo, 4) = '0701'
