USE BDInkaPeru


GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_Tesoreria_TESO_DocsPagos]') AND OBJECTPROPERTY(id,N'IsView') = 1) 
    DROP VIEW [dbo].[VW_Tesoreria_TESO_DocsPagos] 
GO 
-- =========================================================  
-- Autor - Fecha Crea  : Ysaacx - 23/10/2017
-- Descripcion         : Consulta de horarios disponibles
-- =========================================================  
CREATE VIEW dbo.VW_Tesoreria_TESO_DocsPagos
AS

SELECT * FROM Tesoreria.TESO_DocsPagos
 WHERE DPAGO_Estado <> 'X'


 GO
 
 SELECT * FROM VW_Tesoreria_TESO_DocsPagos WHERE CONVERT(DATE, DPAGO_Fecha) BETWEEN '2018-12-29' AND '2018-12-31' AND ENTID_Codigo = '10252196507'
 SELECT * FROM Tesoreria.TESO_Recibos WHERE RECIB_Estado <> 'X' ORDER BY RECIB_Fecha ASC 


 BEGIN TRAN x

 UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 8451995.08 + 120404.6 WHERE RECIB_Codigo = 'RE0010000022' 
 UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 67047.13 WHERE RECIB_Codigo = 'RE0010000036' 

ROLLBACK TRAN x
 COMMIT TRAN x



