/* CREAR LINEAS Y SUBLINEAS */

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


/* INGRESAR UN ARTICULO */

INSERT INTO dbo.[Articulos](ARTIC_Codigo, LINEA_Codigo, TIPOS_CodTipoProducto, TIPOS_CodCategoria, TIPOS_CodUnidadMedida, TIPOS_CodTipoColor, ARTIC_Id, ARTIC_Peso, ARTIC_Detalle, ARTIC_Descripcion, ARTIC_Percepcion, ARTIC_Descontinuado, ARTIC_Localizacion, ARTIC_Orden, ARTIC_ExistenciaMin, ARTIC_ExistenciaMax, ARTIC_PuntoReorden, ARTIC_Estado, ARTIC_CodigoAnterior, ARTIC_Numero, RCVDT_Id, ARTIC_NuevoIngreso, ARTIC_UsrNuevoIngreso, ARTIC_FecNuevoIngreso, ARTIC_UsrCrea, ARTIC_FecCrea, ARTIC_UsrMod, ARTIC_FecMod) VALUES ('0101001', '0101', 'PRO1', 'CTP1', 'UND07', 'CLR000',  1 ,  3.7700 , 'Angulo 20mm X 20mm X 2.0mm X 6.0m', 'Angulo 20mm X 20mm X 2.0mm X 6.0m',  0 ,  0 , 'Zona A',  14 ,  0 ,  500 ,  0 , 'I', 'P0101001000',  1 ,  1 ,  1 , '46529051', '12-16-2017 09:24:49', 'SISTEMAS' , '02-27-2013 12:59:03' , '02417510' , '11-06-2017 03:53:29' )

/* INGRESAR PRECIOS */

INSERT INTO dbo.[Precios](ZONAS_Codigo, ARTIC_Codigo, TIPOS_CodTipoMoneda, PRECI_Precio, PRECI_TipoCambio, PRECI_UsrCrea, PRECI_FecCrea, PRECI_UsrMod, PRECI_FecMod) VALUES (@ZONAS_Codigo, '0101001', 'MND2',  3.3500 ,  3.3100 , '40975980' , '02-27-2013 02:24:08' , '02417510' , '11-06-2017 03:53:29' )

/* INGRESAR LISTA VS PRODUCTO */

INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  0 , '0101001',  3.00 ,  0.00 , 'SISTEMAS' , '02-27-2013 02:25:21' , '02417510' , '11-06-2017 03:53:29' )
INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  1 , '0101001',  3.00 ,  4.00 , 'SISTEMAS' , '02-27-2013 02:25:21' , '02417510' , '11-06-2017 03:53:29' )
INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  2 , '0101001',  2.00 ,  6.00 , 'SISTEMAS' , '02-27-2013 02:25:21' , '02417510' , '11-06-2017 03:53:29' )
INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  3 , '0101001',  2.00 ,  8.00 , 'SISTEMAS' , '02-27-2013 02:25:22' , '02417510' , '11-06-2017 03:53:29' )
INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  4 , '0101001',  3.00 ,  11.00 , 'SISTEMAS' , '02-27-2013 02:25:22' , '02417510' , '11-06-2017 03:53:29' )
INSERT INTO Ventas.[VENT_ListaPreciosArticulos](ZONAS_Codigo, LPREC_Id, ARTIC_Codigo, ALPRE_Constante, ALPRE_PorcentaVenta, ALPRE_UsrCrea, ALPRE_FecCrea, ALPRE_UsrMod, ALPRE_FecMod) VALUES (@ZONAS_Codigo,  5 , '0101001',  3.00 ,  14.00 , 'SISTEMAS' , '02-27-2013 02:25:22' , '02417510' , '11-06-2017 03:53:29' )


/*===================================================================*/
/* LINEAS ANTERIOR */


INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '18'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Productos PVC',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1801' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Agua Simple Presi?n',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1802' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Agua con Rosca',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1803' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Electricos',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1804' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Sanitarios',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1805' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Rotomoldeo',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1806' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Transformados',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1807' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'HIDRO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1808' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Accesorios',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1809' ,LINEA_CodPadre = '18',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Pegamentos y lubricantes',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '19'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Varios',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1901' ,LINEA_CodPadre = '19',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Productos Varios',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
  UNION SELECT LINEA_Codigo = '1902' ,LINEA_CodPadre = '19',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'Herramientas',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE()
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)
