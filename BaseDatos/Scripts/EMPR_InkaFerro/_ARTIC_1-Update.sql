
/* Actualizar Productos - Ambas Sucursales */

USE BDInkasFerro_Parusttacca
go
--DROP TABLE #ProdUpdate

SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
     , PROD.Descripcion
     , REG = COUNT(*)
  INTO #ProdUpdate
  FROM BDCopy..Productos2018 PROD WHERE TCol IN ('EP', 'EA') AND [Cod-Existente] IS NULL
  --AND PROD.Descripcion
GROUP BY Codigo, PROD.Descripcion HAVING COUNT(*) = 2
ORDER BY Descripcion

BEGIN TRAN X

UPDATE ARTIC
   SET ARTIC.ARTIC_Descripcion = PROD.Descripcion
     , ARTIC.ARTIC_Detalle = PROD.Descripcion
  FROM dbo.Articulos ARTIC
 INNER JOIN #ProdUpdate PROD ON PROD.ARTIC_CODIGO = ARTIC.ARTIC_Codigo
  WHERE PROD.Descripcion <> ARTIC.ARTIC_Detalle


SELECT PROD.Descripcion, ARTIC.ARTIC_Detalle,* FROM #ProdUpdate PROD
INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = PROD.ARTIC_CODIGO

--ROLLBACK TRAN X
COMMIT TRAN X



--SELECT TOP 1 ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
-- FROM Productos2018 PROD WHERE TCol = 'EP' AND [Cod-Existente] IS NULL
--  --AND PROD.Descripcion 





-- SELECT * FROM productosCorregir2018

--DECLARE @ARTIC_Codigo CHAR(7) = '0406001'
   
--   SELECT * FROM cat_prod
   