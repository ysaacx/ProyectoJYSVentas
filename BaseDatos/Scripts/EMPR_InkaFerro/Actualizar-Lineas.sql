USE BDInkasFerro_Almudena
GO
SELECT * FROM dbo.Lineas


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
  /*=============================================================================================================================================================================*/
  UNION SELECT LINEA_Codigo = '28' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PINTURAS ANTICORROSIVOS Y ESMALTES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2801' ,LINEA_CodPadre = '28',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ANTICORROSIVOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2802' ,LINEA_CodPadre = '28',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ESMALTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2803' ,LINEA_CodPadre = '28',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'BARNIZ LACAS Y TINNER',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2804' ,LINEA_CodPadre = '28',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PINTURAS LATEX E IMPRIMANTES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '29' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIJAR',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2901' ,LINEA_CodPadre = '29',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIJAR AGUA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2902' ,LINEA_CodPadre = '29',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIJAR METAL',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2903' ,LINEA_CodPadre = '29',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIJAR MADERA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '30' ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ACCESORIOS DE AGUA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '3001' ,LINEA_CodPadre = '30',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'VALVULAS Y LLAVES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '3002' ,LINEA_CodPadre = '30',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'GALVANIZADOS Y BRONCE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 
 --SELECT * FROM dbo.Lineas WHERE LEN(LINEA_Codigo) = 2
 --SELECT * FROM dbo.Lineas WHERE LEFT(LINEA_Codigo, 2) = '19'
 --EXEC dbo.ARTICSS_GetCodigo @Linea = '1902' -- CodigoLinea