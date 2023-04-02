use BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_SENCISS_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_SENCISS_UnReg] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Generador - 21/01/2013
-- Descripcion         : Procedimiento de Consulta de la tabla TESO_Sencillo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_SENCISS_UnReg]
(	
	@SENCI_Fecha DateTime
	,@PVENT_Id BigInt
)

AS


SELECT  *
FROM Tesoreria.TESO_Sencillo
WHERE CONVERT(Date, SENCI_Fecha) = @SENCI_Fecha
	And PVENT_Id = @PVENT_Id



GO 
/***************************************************************************************************************************************/ 

