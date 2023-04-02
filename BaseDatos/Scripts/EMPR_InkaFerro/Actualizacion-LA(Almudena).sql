USE BDInkasFerro
GO

SELECT * FROM dbo.Lineas WHERE LEN(LINEA_Codigo) = 2
SELECT * FROM dbo.Lineas WHERE left(LINEA_Codigo, 2) IN ('16', '13')
SELECT * FROM dbo.Lineas WHERE LINEA_Codigo LIKE '19%'


/*********************************************************************************************************/

UPDATE Lineas SET LINEA_Activo = 0 WHERE left(LINEA_Codigo, 2) IN ('16', '13', '18')

/*********************************************************************************************************/

--SELECT *  FROM dbo.Lineas


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
  
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)



/*********************************************************************************************************/

SELECT * FROM BDCopy..ProductosFinales


    SELECT * FROM bdcopy..productosif WHERE FAMILIA IS NOT NULL 
    --DROP TABLE #Articulo_Max
    SELECT ARTIC_Codigo_Max = MAX(RIGHT(ARTIC_Codigo, 3)), LINEA_Codigo, c = COUNT(*) INTO #Articulo_Max FROM dbo.Articulos GROUP BY LINEA_Codigo
    SELECT * FROM #Articulo_Max

    DECLARE @ARTIC_ID INT
    SET @ARTIC_ID = (SELECT MAX(ARTIC_ID) FROM dbo.Articulos )
--    DROP TABLE #Producto
   SELECT [ARTIC_Codigo]               = RTRIM(IFERR.LINEA_CODIGO) + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY IFERR.LINEA_CODIGO ORDER BY IFERR.LINEA_CODIGO) + ISNULL(CONVERT(INT, ISNULL(ART.ARTIC_Codigo_Max, 0)), 0)), 3)
        , [LINEA_Codigo]               = RTRIM(IFERR.LINEA_CODIGO)
        , [TIPOS_CodTipoProducto]      = 'PRO1'
        , [TIPOS_CodCategoria]         = 'CTP2'
        , [TIPOS_CodUnidadMedida]      = 'UND07'
        , [TIPOS_CodTipoColor]         = 'CLR000'
        , [ARTIC_Id]                   = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY IFERR.ARTIC_Descripcion)
        , [ARTIC_Peso]                 = 1
        , [ARTIC_Detalle]              = IFERR.ARTIC_Descripcion
        , [ARTIC_Descripcion]          = IFERR.ARTIC_Descripcion
        , [ARTIC_Percepcion]           = 0
        , [ARTIC_Descontinuado]        = 0
        , [ARTIC_Localizacion]         = 'Zona A'
        , [ARTIC_Orden]                = 50
        , [ARTIC_ExistenciaMin]        = 0
        , [ARTIC_ExistenciaMax]        = 500
        , [ARTIC_PuntoReorden]         = 350
        , [ARTIC_Estado]               = 'I'
        , [ARTIC_CodigoAnterior]       = NULL --RTRIM(CODPROD)
        , [ARTIC_UsrCrea]              = 'SISTEMAS'
        , [ARTIC_FecCrea]              = GETDATE()
        , [ARTIC_UsrMod]               = NULL 
        , [ARTIC_FecMod]               = NULL
        , [ARTIC_Numero]               = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY IFERR.ARTIC_Descripcion)
        , [RCVDT_Id]                   = 1
        , [ARTIC_NuevoIngreso]         = 0
        , [ARTIC_UsrNuevoIngreso]      = NULL 
        , [ARTIC_FecNuevoIngreso]      = NULL 
     INTO #Producto
     FROM BDCopy..ProductosFinales IFERR
     LEFT JOIN #Articulo_Max ART ON ART.LINEA_CODIGO = IFERR.LINEA_Codigo
     LEFT JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = IFERR.LINEA_Codigo
     LEFT JOIN dbo.Lineas LINEA2 ON LINEA2.LINEA_Codigo = ART.LINEA_Codigo
    WHERE IFERR.LINEA_Codigo IS NOT NULL 


      INSERT INTO dbo.Articulos
       (  [ARTIC_Codigo]               , [LINEA_Codigo]               , [TIPOS_CodTipoProducto]      , [TIPOS_CodCategoria]         
        , [TIPOS_CodUnidadMedida]      , [TIPOS_CodTipoColor]         , [ARTIC_Id]                   , [ARTIC_Peso]                 
        , [ARTIC_Detalle]              , [ARTIC_Descripcion]          , [ARTIC_Percepcion]           , [ARTIC_Descontinuado]        
        , [ARTIC_Localizacion]         , [ARTIC_Orden]                , [ARTIC_ExistenciaMin]        , [ARTIC_ExistenciaMax]        
        , [ARTIC_PuntoReorden]         , [ARTIC_Estado]               , [ARTIC_CodigoAnterior]       , [ARTIC_UsrCrea]              
        , [ARTIC_FecCrea]              , [ARTIC_UsrMod]               , [ARTIC_FecMod]               , [ARTIC_Numero]               
        , [RCVDT_Id]                   , [ARTIC_NuevoIngreso]         , [ARTIC_UsrNuevoIngreso]      , [ARTIC_FecNuevoIngreso])
   SELECT * FROM #Producto


     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Producto

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Producto PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 
/*********************************************************************************************************/

--SELECT * FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo IN (SELECT RTRIM(ARTIC_Codigo) FROM #Producto)

SELECT * FROM dbo.Articulos WHERE LINEA_Codigo = '2601'

--BEGIN TRAN X
--delete Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE LINEA_Codigo = '2601')
--DELETE dbo.Precios WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE LINEA_Codigo = '2601')

--delete FROM dbo.Articulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE LINEA_Codigo = '2601')
--commit TRAN X


--BEGIN TRAN X
--delete FROM dbo.Articulos WHERE CONVERT(VARCHAR(10), artic_FecCrea, 112) = CONVERT(VARCHAR(10), GETDATE(), 112)
--DELETE dbo.Precios WHERE CONVERT(VARCHAR(10), preci_FecCrea, 112) = CONVERT(VARCHAR(10), GETDATE(), 112)
--delete Ventas.VENT_ListaPreciosArticulos WHERE CONVERT(VARCHAR(10), ALPRE_FecCrea, 112) = CONVERT(VARCHAR(10), GETDATE(), 112)
--ROLLBACK TRAN X
--SELECT RTRIM(ARTIC_Codigo) FROM #Producto

/*********************************************************************************************************/

SELECT *  FROM dbo.Lineas WHERE LINEA_Codigo LIKE '21%'
SELECT * FROM dbo.Articulos WHERE LINEA_Codigo = '2102'

SELECT * INTO #Nicoll_Hidro FROM dbo.Articulos WHERE LINEA_Codigo = '2102'


UPDATE #Nicoll_Hidro SET LINEA_Codigo = '2106', ARTIC_Codigo = '2106' + RIGHT(ARTIC_Codigo, 3) --, ARTIC_Detalle = ARTIC_Detalle + ' - HIDRO' --, ARTIC_Descripcion = ARTIC_Descripcion + ' - HIDRO'

SELECT * FROM #Nicoll_Hidro
/*********************************************************************************************************/
SELECT *  FROM dbo.Lineas WHERE LINEA_Codigo LIKE '22%'
SELECT * INTO #Pavco_Hidro FROM dbo.Articulos WHERE LINEA_Codigo = '2202'
SELECT * FROM dbo.Articulos WHERE LINEA_Codigo = '2202'

UPDATE #Pavco_Hidro SET LINEA_Codigo = '2206', ARTIC_Codigo = '2206' + RIGHT(ARTIC_Codigo, 3), ARTIC_Detalle = ARTIC_Detalle + ' - HIDRO', ARTIC_Descripcion = ARTIC_Descripcion + ' - HIDRO'
SELECT * FROM #Pavco_Hidro

BEGIN TRAN x
 INSERT INTO dbo.Articulos
 SELECT * FROM #Nicoll_Hidro
 UNION 
 SELECT * FROM #Pavco_Hidro

     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Nicoll_Hidro
      UNION 
      SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Pavco_Hidro

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Nicoll_Hidro PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 
         UNION
          SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Pavco_Hidro PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 


ROLLBACK TRAN x
commit TRAN x

/*********************************************************************************************************/

UPDATE dbo.Articulos SET LINEA_Codigo = '2601' WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Descripcion LIKE '%TECNOPOR%')

/*********************************************************************************************************/

SELECT ARTIC_Descripcion, REPLACE(ARTIC_Descripcion, 'Plancha Ond.', 'Calamina'), * FROM dbo.Articulos WHERE LINEA_Codigo = '0406'

UPDATE dbo.Articulos SET ARTIC_Descripcion = REPLACE(ARTIC_Descripcion, 'Plancha Ond.', 'Calamina') WHERE LINEA_Codigo = '0406'
UPDATE dbo.Articulos SET ARTIC_Detalle = REPLACE(ARTIC_Detalle, 'Plancha Ond.', 'Calamina') WHERE LINEA_Codigo = '0406'

--Plancha Ond. 0.17mm X 1.80m X 3.6m
/*********************************************************************************************************/

--USE BDInkasFerro

BEGIN TRAN X

--DROP TABLE #Articulo_Max
--SELECT ARTIC_Codigo_Max = MAX(RIGHT(ARTIC_Codigo, 3)), LINEA_Codigo, c = COUNT(*) INTO #Articulo_Max FROM dbo.Articulos GROUP BY LINEA_Codigo

DECLARE @ARTIC_ID INT
SET @ARTIC_ID = (SELECT MAX(ARTIC_ID) FROM dbo.Articulos )

SELECT [ARTIC_Codigo] = IFERR.LINEA_CODIGO + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY IFERR.LINEA_CODIGO ORDER BY IFERR.LINEA_CODIGO) + ISNULL(CONVERT(INT, ART.ARTIC_Codigo_Max), 0)), 3)
        , [LINEA_Codigo] = IFERR.LINEA_CODIGO
        , [TIPOS_CodTipoProducto]      = 'PRO1'
        , [TIPOS_CodCategoria]         = 'CTP2'
        , [TIPOS_CodUnidadMedida]      = 'UND07'
        , [TIPOS_CodTipoColor]         = 'CLR000'
        , [ARTIC_Id]                   = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY CODPROD)
        , [ARTIC_Peso]                 = 1
        , [ARTIC_Detalle]              = IFERR.Descripcion
        , [ARTIC_Descripcion]          = IFERR.Descripcion
        , [ARTIC_Percepcion]           = 0
        , [ARTIC_Descontinuado]        = 0
        , [ARTIC_Localizacion]         = 'Zona A'
        , [ARTIC_Orden]                = 50
        , [ARTIC_ExistenciaMin]        = 0
        , [ARTIC_ExistenciaMax]        = 500
        , [ARTIC_PuntoReorden]         = 350
        , [ARTIC_Estado]               = 'I'
        , [ARTIC_CodigoAnterior]       = RTRIM(CODPROD)
        , [ARTIC_UsrCrea]              = 'SISTEMAS'
        , [ARTIC_FecCrea]              = GETDATE()
        , [ARTIC_UsrMod]               = NULL 
        , [ARTIC_FecMod]               = NULL
        , [ARTIC_Numero]               = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY CODPROD)
        , [RCVDT_Id]                   = 1
        , [ARTIC_NuevoIngreso]         = 0
        , [ARTIC_UsrNuevoIngreso]      = NULL 
        , [ARTIC_FecNuevoIngreso]      = NULL 
     INTO #Producto
      FROM bdcopy..ProductosIF IFERR
      LEFT JOIN #Articulo_Max ART ON ART.LINEA_CODIGO = IFERR.LINEA_CODIGO
      LEFT JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = IFERR.LINEA_Codigo
      LEFT JOIN dbo.Lineas LINEA2 ON LINEA2.LINEA_Codigo = ART.LINEA_Codigo
     WHERE ISNULL(Nuevos, 0) = 1


   INSERT INTO dbo.Articulos
       (  [ARTIC_Codigo]               , [LINEA_Codigo]               , [TIPOS_CodTipoProducto]      , [TIPOS_CodCategoria]         
        , [TIPOS_CodUnidadMedida]      , [TIPOS_CodTipoColor]         , [ARTIC_Id]                   , [ARTIC_Peso]                 
        , [ARTIC_Detalle]              , [ARTIC_Descripcion]          , [ARTIC_Percepcion]           , [ARTIC_Descontinuado]        
        , [ARTIC_Localizacion]         , [ARTIC_Orden]                , [ARTIC_ExistenciaMin]        , [ARTIC_ExistenciaMax]        
        , [ARTIC_PuntoReorden]         , [ARTIC_Estado]               , [ARTIC_CodigoAnterior]       , [ARTIC_UsrCrea]              
        , [ARTIC_FecCrea]              , [ARTIC_UsrMod]               , [ARTIC_FecMod]               , [ARTIC_Numero]               
        , [RCVDT_Id]                   , [ARTIC_NuevoIngreso]         , [ARTIC_UsrNuevoIngreso]      , [ARTIC_FecNuevoIngreso])
   SELECT * FROM #Producto


     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Producto

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Producto PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 

DROP TABLE #Producto
 COMMIT TRAN X
 ROLLBACK TRAN X

--SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Precios)
--SELECT * FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Precios)


BEGIN TRAN X

--DROP TABLE #Articulo_Max
--SELECT ARTIC_Codigo_Max = MAX(RIGHT(ARTIC_Codigo, 3)), LINEA_Codigo, c = COUNT(*) INTO #Articulo_Max FROM dbo.Articulos GROUP BY LINEA_Codigo

DECLARE @ARTIC_ID INT
SET @ARTIC_ID = (SELECT MAX(ARTIC_ID) FROM dbo.Articulos )

SELECT [ARTIC_Codigo] = IFERR.LINEA_CODIGO + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY IFERR.LINEA_CODIGO ORDER BY IFERR.LINEA_CODIGO) + ISNULL(CONVERT(INT, ART.ARTIC_Codigo_Max), 0)), 3)
        , [LINEA_Codigo] = IFERR.LINEA_CODIGO
        , [TIPOS_CodTipoProducto]      = 'PRO1'
        , [TIPOS_CodCategoria]         = 'CTP2'
        , [TIPOS_CodUnidadMedida]      = 'UND07'
        , [TIPOS_CodTipoColor]         = 'CLR000'
        , [ARTIC_Id]                   = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY CODPROD)
        , [ARTIC_Peso]                 = 1
        , [ARTIC_Detalle]              = IFERR.Descripcion
        , [ARTIC_Descripcion]          = IFERR.Descripcion
        , [ARTIC_Percepcion]           = 0
        , [ARTIC_Descontinuado]        = 0
        , [ARTIC_Localizacion]         = 'Zona A'
        , [ARTIC_Orden]                = 50
        , [ARTIC_ExistenciaMin]        = 0
        , [ARTIC_ExistenciaMax]        = 500
        , [ARTIC_PuntoReorden]         = 350
        , [ARTIC_Estado]               = 'I'
        , [ARTIC_CodigoAnterior]       = RTRIM(CODPROD)
        , [ARTIC_UsrCrea]              = 'SISTEMAS'
        , [ARTIC_FecCrea]              = GETDATE()
        , [ARTIC_UsrMod]               = NULL 
        , [ARTIC_FecMod]               = NULL
        , [ARTIC_Numero]               = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY CODPROD)
        , [RCVDT_Id]                   = 1
        , [ARTIC_NuevoIngreso]         = 0
        , [ARTIC_UsrNuevoIngreso]      = NULL 
        , [ARTIC_FecNuevoIngreso]      = NULL 
     INTO #Producto
      FROM bdcopy..ProductosIF IFERR
      LEFT JOIN #Articulo_Max ART ON ART.LINEA_CODIGO = IFERR.LINEA_CODIGO
      LEFT JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = IFERR.LINEA_Codigo
      LEFT JOIN dbo.Lineas LINEA2 ON LINEA2.LINEA_Codigo = ART.LINEA_Codigo
     WHERE ISNULL(Nuevos2, 0) = 1


   INSERT INTO dbo.Articulos
       (  [ARTIC_Codigo]               , [LINEA_Codigo]               , [TIPOS_CodTipoProducto]      , [TIPOS_CodCategoria]         
        , [TIPOS_CodUnidadMedida]      , [TIPOS_CodTipoColor]         , [ARTIC_Id]                   , [ARTIC_Peso]                 
        , [ARTIC_Detalle]              , [ARTIC_Descripcion]          , [ARTIC_Percepcion]           , [ARTIC_Descontinuado]        
        , [ARTIC_Localizacion]         , [ARTIC_Orden]                , [ARTIC_ExistenciaMin]        , [ARTIC_ExistenciaMax]        
        , [ARTIC_PuntoReorden]         , [ARTIC_Estado]               , [ARTIC_CodigoAnterior]       , [ARTIC_UsrCrea]              
        , [ARTIC_FecCrea]              , [ARTIC_UsrMod]               , [ARTIC_FecMod]               , [ARTIC_Numero]               
        , [RCVDT_Id]                   , [ARTIC_NuevoIngreso]         , [ARTIC_UsrNuevoIngreso]      , [ARTIC_FecNuevoIngreso])
   SELECT * FROM #Producto


     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Producto

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Producto PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 

 COMMIT TRAN X
 ROLLBACK TRAN X



ALTER TABLE [dbo].[Articulos]
ALTER COLUMN [ARTIC_Peso] [Peso] NOT NULL
GO

ALTER TABLE [dbo].[Articulos]
ADD DEFAULT 0.00 FOR [ARTIC_Peso]
GO