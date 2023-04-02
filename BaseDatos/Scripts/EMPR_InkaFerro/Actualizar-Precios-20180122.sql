SELECT * FROM Lineas WHERE LINEA_Nombre LIKE '%DISCO%'
SELECT * FROM Lineas WHERE LEN(LINEA_CODIGO) = 2
SELECT * FROM Lineas WHERE LEFT(LINEA_CODIGO, 2) = '29'
SELECT * FROM Articulos WHERE LINEA_Codigo = '0904'

BEGIN TRAN X
INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea,LINEA_Activo
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea, LINEA_Activo
 FROM (
  SELECT LINEA_Codigo = '2904' ,LINEA_CodPadre = '29',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DISCO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 UPDATE Articulos SET LINEA_Codigo = '2904' WHERE LINEA_Codigo = '0904'

ROLLBACK TRAN X
COMMIT TRAN X

/*ACTUALIZAR NOMBRES */


SELECT ARTIC_Descripcion, * FROM Articulos WHERE left(LINEA_Codigo, 2) = '21' and NOT ARTIC_Descripcion like '%NICOLL%'
SELECT ARTIC_Detalle, * FROM Articulos WHERE left(LINEA_Codigo, 2) = '21' and NOT ARTIC_Detalle like '%NICOLL%'
SELECT ARTIC_Descripcion, * FROM Articulos WHERE left(LINEA_Codigo, 2) = '22' and NOT ARTIC_Descripcion like '%PAVCO%'
SELECT ARTIC_Detalle, * FROM Articulos WHERE left(LINEA_Codigo, 2) = '22' and NOT ARTIC_Detalle like '%PAVCO%'

BEGIN TRAN X

UPDATE Articulos  SET ARTIC_Descripcion  = REPLACE(ARTIC_Descripcion, 'NICOLL', ' - NICOLL') WHERE left(LINEA_Codigo, 2) = '21' and ARTIC_Detalle like '%NICOLL%'
UPDATE Articulos  SET ARTIC_Detalle  = ARTIC_Detalle  + ' - NICOLL' WHERE left(LINEA_Codigo, 2) = '21' and NOT ARTIC_Detalle like '%NICOLL%'

UPDATE Articulos  
   SET ARTIC_Descripcion  = ARTIC_Descripcion  + ' - PAVCO' 
	 , ARTIC_Detalle  = ARTIC_Detalle  + ' - PAVCO'
 WHERE left(LINEA_Codigo, 2) = '22' and NOT ARTIC_Detalle like '%PAVCO%'

 SELECT ARTIC_Descripcion, ARTIC_Detalle, * FROM Articulos WHERE LEFT(LINEA_CODIGO, 2) in ('21')
 SELECT ARTIC_Descripcion, ARTIC_Detalle, * FROM Articulos WHERE LEFT(LINEA_CODIGO, 2) in ('22')

ROLLBACK TRAN X
commit TRAN X



BEGIN TRAN X
UPDATE Articulos  SET ARTIC_Descripcion  = REPLACE(ARTIC_Descripcion, 'NICOLL', ' - NICOLL') WHERE left(LINEA_Codigo, 2) = '21' and ARTIC_Detalle like '%NICOLL%' AND LINEA_Codigo = '2106'
SELECT ARTIC_Descripcion, ARTIC_Detalle, * FROM Articulos WHERE LEFT(LINEA_CODIGO, 2) in ('21') AND LINEA_Codigo = '2106'
ROLLBACK TRAN X
commit TRAN X