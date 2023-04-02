USE BDInkasFerro_Almudena
GO

BEGIN TRAN x
/*===================================================================================================================================================================*/
INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '99'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Otros Productos',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '9999'   ,LINEA_CodPadre = '99',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 /*===================================================================================================================================================================*/

UPDATE dbo.Articulos SET LINEA_Codigo = '9999'

DELETE FROM dbo.Lineas WHERE LINEA_Codigo NOT IN ('99', '9999')

/*===================================================================================================================================================================*/
SELECT *  FROM dbo.Lineas


INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '01'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0101' ,LINEA_CodPadre = '01',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CEMENTO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()

  UNION SELECT LINEA_Codigo = '02'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0201' ,LINEA_CodPadre = '02',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACEROS AREQUIPA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0202' ,LINEA_CodPadre = '02',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'SIDERPERU',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '0203' ,LINEA_CodPadre = '02',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OTROS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 /*===================================================================================================================================================================*/
ROLLBACK TRAN x
