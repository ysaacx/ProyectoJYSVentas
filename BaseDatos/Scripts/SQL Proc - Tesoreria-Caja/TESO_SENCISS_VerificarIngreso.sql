use BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_SENCISS_VerificarIngreso]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_SENCISS_VerificarIngreso] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_SENCISS_VerificarIngreso]
(
	@FecIni Datetime
)
As

--Declare @FecIni Datetime
--Set @FecIni = '12-02-2013'

Select * From Tesoreria.TESO_Sencillo
where Convert(Date, SENCI_Fecha) = @FecIni


GO 
/***************************************************************************************************************************************/ 

