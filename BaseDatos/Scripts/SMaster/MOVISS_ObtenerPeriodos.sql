USE  BDMaster
GO

GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ObtenerPeriodos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[MOVISS_ObtenerPeriodos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/11/2012
-- Descripcion         : Importar las Compras
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ObtenerPeriodos]
AS

SELECT Periodo = YEAR(Fecha) FROM dbo.Ventas
UNION
SELECT YEAR(Fecha_Documento) FROM dbo.Compras 

GO 

EXEC dbo.MOVISS_ObtenerPeriodos


--SELECT YEAR(Fecha) FROM dbo.Ventas WHERE Fecha BETWEEN '2019-01-01' AND '2019-12-31'
--SELECT YEAR(Fecha_Documento) FROM dbo.Compras WHERE Fecha_Documento BETWEEN '2019-01-01' AND '2019-12-31'

