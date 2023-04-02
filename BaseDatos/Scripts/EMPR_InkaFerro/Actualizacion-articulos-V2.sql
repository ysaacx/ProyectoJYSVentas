USE BDInkasFerro
GO

INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea,LINEA_Activo
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea, LINEA_Activo
 FROM (
        SELECT LINEA_Codigo = '23'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'MANGUERAS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2301' ,LINEA_CodPadre = '23',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'MANGUERAS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '24' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ELECTRICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2401' ,LINEA_CodPadre = '24',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ELECTRICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '25' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OCRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2501' ,LINEA_CodPadre = '25',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'OCRES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '26' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PLASTOFORMOS Y/O TECNOPORES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2601' ,LINEA_CodPadre = '26',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PLASTOFORMOS Y/O TECNOPORES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '27' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2701' ,LINEA_CodPadre = '27',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '2107' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PEGAMENTOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '28' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2801' ,LINEA_CodPadre = '28',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '27' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2701' ,LINEA_CodPadre = '27',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'TRIPLEY Y OSBs',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)


BEGIN TRAN X

INSERT INTO dbo.Lineas
SELECT * FROM BDInkasFerro_almudena.dbo.Lineas WHERE LINEA_Codigo NOT IN (SELECT linea_codigo FROM dbo.Lineas)


UPDATE ARTIC
   SET ARTIC.LINEA_CODIGO  = base.linea_codigo
  FROM BDInkasFerro..Articulos ARTIC
 INNER JOIN BDInkasFerro_Almudena..Articulos BASE
    ON BASE.ARTIC_Codigo = ARTIC.ARTIC_Codigo
    WHERE artic.LINEA_Codigo <> base.linea_codigo 


 INSERT INTO dbo.Articulos
 SELECT * FROM BDInkasFerro_Almudena.dbo.Articulos
  WHERE ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

 INSERT INTO dbo.Precios
  SELECT * FROM BDInkasFerro_Almudena.dbo.Precios WHERE ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Precios)

  INSERT INTO Ventas.VENT_ListaPreciosArticulos
  SELECT * FROM BDInkasFerro_Almudena.Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM .Ventas.VENT_ListaPreciosArticulos)

ROLLBACK TRAN X
commit TRAN X