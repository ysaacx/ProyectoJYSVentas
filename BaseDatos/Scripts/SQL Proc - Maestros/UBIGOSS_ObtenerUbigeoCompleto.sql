GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[UBIGOSS_ObtenerUbigeoCompleto]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[UBIGOSS_ObtenerUbigeoCompleto] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[UBIGOSS_ObtenerUbigeoCompleto]
(
    @UBIGO_Codigo VarChar(17)
)
As
DECLARE @Ubigeo VARCHAR(150)
SET @Ubigeo  = (SELECT UBIGO_Descripcion FROM dbo.Ubigeos Dep WHERE Dep.UBIGO_Codigo = LEFT(@UBIGO_Codigo, 2))
SET @Ubigeo += ' / ' + (SELECT UBIGO_Descripcion FROM  Ubigeos Pro WHERE Pro.UBIGO_Codigo = LEFT(@UBIGO_Codigo, 5))
SET @Ubigeo += ' / ' + (SELECT UBIGO_Descripcion FROM  Ubigeos Dis WHERE Dis.UBIGO_Codigo = @UBIGO_Codigo)

  SELECT UBIGO_Codigo
       , UBIGO_CodPadre
       , UBIGO_Descripcion = @Ubigeo
       , UBIGO_DescCorta
       , UBIGO_Protegido
    FROM dbo.Ubigeos
   WHERE UBIGO_Codigo = @UBIGO_Codigo



GO 
/***************************************************************************************************************************************/ 

