
--SELECT * FROM dbo.Articulos WHERE LEFT(LINEA_Codigo, 2) = '19'
/*
SELECT ARTIC_Codigo
    , FAM = LEFT(ARTIC.LINEA_Codigo, 2) 
    , FAMI.LINEA_Nombre
    , SFAM = ARTIC.LINEA_Codigo
    , SFAM.LINEA_Nombre
    , ARTICULO = ARTIC_Descripcion 
 FROM dbo.Articulos ARTIC 
INNER JOIN dbo.Lineas FAMI ON FAMI.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2) AND LEN(FAMI.LINEA_Codigo) = 2
INNER JOIN dbo.Lineas SFAM ON SFAM.LINEA_Codigo = ARTIC.LINEA_Codigo
WHERE LEFT(ARTIC.LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11', '12', '14', '17', '19')
*/

BEGIN TRAN x

/*===================================================================================================================================================================*/
INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '1309'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Otros Productos',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1310'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Fibraforte',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1311'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Balletas y Accesorio',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1312'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Bisagras y Complemen',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1313'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PRE FABRICADOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1314'   ,LINEA_CodPadre = '13',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Supertecho',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

/*===================================================================================================================================================================*/
UPDATE dbo.Articulos
   SET LINEA_Codigo = '1309'
 WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo
                          FROM dbo.Articulos ARTIC 
                         INNER JOIN dbo.Lineas FAMI ON FAMI.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2) AND LEN(FAMI.LINEA_Codigo) = 2
                         INNER JOIN dbo.Lineas SFAM ON SFAM.LINEA_Codigo = ARTIC.LINEA_Codigo
                         WHERE LEFT(ARTIC.LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11', '12', '14', '17', '19'))
UPDATE dbo.Articulos
   SET ARTIC_Descontinuado = 1
 WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo
                          FROM dbo.Articulos ARTIC 
                         INNER JOIN dbo.Lineas FAMI ON FAMI.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2) AND LEN(FAMI.LINEA_Codigo) = 2
                         INNER JOIN dbo.Lineas SFAM ON SFAM.LINEA_Codigo = ARTIC.LINEA_Codigo
                         WHERE NOT LEFT(ARTIC.LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11', '12', '14', '17', '19'))
/*===================================================================================================================================================================*/
DELETE FROM dbo.Lineas WHERE LEFT(LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11', '12', '14', '17', '19')
/*===================================================================================================================================================================*/

INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '07'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0701' ,LINEA_CodPadre = '07',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '08'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0801' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS AREQUIPA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0802' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'SIDERPERU',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0803' ,LINEA_CodPadre = '08',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '09'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CLAVOS Y ALAMBRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0901' ,LINEA_CodPadre = '09',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CLAVOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0902' ,LINEA_CodPadre = '09',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ALAMBRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '10'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TECNOPOR',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1001'   ,LINEA_CodPadre = '10',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TECNOPOR',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '11'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1101' ,LINEA_CodPadre = '11',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  --UNION SELECT LINEA_Codigo = '05'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  --UNION SELECT LINEA_Codigo = '0501' ,LINEA_CodPadre = '05',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCOS DE CORTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '06'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0601' ,LINEA_CodPadre = '06',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)
/*===================================================================================================================================================================*/
UPDATE Artic
   SET Artic.LINEA_Codigo = PROD.FAMILIA COLLATE DATABASE_DEFAULT
     , Artic.ARTIC_Descontinuado = PROD.DESCONTINUADO
  FROM dbo.Articulos Artic
 INNER JOIN BDCopy..ArticulosINKAP PROD ON Artic.ARTIC_Codigo = PROD.ARTIC_Codigo COLLATE DATABASE_DEFAULT
/*===================================================================================================================================================================*/
 SELECT * FROM dbo.Articulos WHERE ARTIC_Descontinuado = 0
/*===================================================================================================================================================================*/

--COMMIT TRAN x
ROLLBACK TRAN x

--SELECT * FROM BDCopy..ArticulosINKAP

--SELECT * FROM Lineas WHERE LINEA_Codigo LIKE '11%'
--UPDATE Lineas SET LINEA_CodPadre = '11' WHERE LINEA_Codigo = '1101'


SELECT * FROM dbo.Lineas WHERE LEN(LINEA_Codigo) = 2

ALTER TABLE [dbo].[Lineas]
ADD [LINEA_Activo] [Boolean] NULL
GO

UPDATE dbo.Lineas SET LINEA_Activo = 1 WHERE LEFT(LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11')
UPDATE dbo.Lineas SET LINEA_Activo = 0 WHERE NOT LEFT(LINEA_Codigo, 2) IN ('07', '08', '09', '10', '11') AND LEN(LINEA_Codigo) = 2