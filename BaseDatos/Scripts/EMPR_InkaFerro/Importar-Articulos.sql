USE BDInkasFerro_Almudena
/*====================================================================================================*/
-- ACTUALIZAR PRODUCTOS --
-DROP TABLE #AUpdate 
SELECT * INTO #AUpdate FROM bdcopy..productosif WHERE Sistema IS NOT NULL 

SELECT * FROM #AUpdate

/*====================================================================================================*/

BEGIN TRAN X

UPDATE dbo.Articulos SET ARTIC_Descontinuado = 1

UPDATE ARTIC
   SET ARTIC.ARTIC_Descontinuado = 0
  FROM dbo.Articulos ARTIC
 INNER JOIN #AUpdate PROD ON PROD.CODIGO = ARTIC.ARTIC_Codigo

SELECT * FROM bdcopy..productosif WHERE FAMILIA IS NOT NULL 
DROP TABLE #Articulo_Max
SELECT ARTIC_Codigo_Max = MAX(RIGHT(ARTIC_Codigo, 3)), LINEA_Codigo, c = COUNT(*) INTO #Articulo_Max FROM dbo.Articulos GROUP BY LINEA_Codigo

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
     WHERE FAMILIA IS NOT NULL 


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


SELECT ROW_NUMBER() OVER(PARTITION BY IFERR.LINEA_CODIGO ORDER BY IFERR.LINEA_CODIGO) , ISNULL(CONVERT(INT, ART.ARTIC_Codigo_Max), 0)
     , ARTIC_Codigo = IFERR.LINEA_CODIGO + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY IFERR.LINEA_CODIGO ORDER BY IFERR.LINEA_CODIGO) + ISNULL(CONVERT(INT, ART.ARTIC_Codigo_Max), 0)), 3)
     , ROW_NUMBER() OVER(ORDER BY CODPROD)
     , LINEA.LINEA_Nombre
     , LINEA2.LINEA_Nombre
     , * 
  FROM bdcopy..productosif IFERR
  LEFT JOIN #Articulo_Max ART ON ART.LINEA_CODIGO = IFERR.LINEA_CODIGO
  LEFT JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = IFERR.LINEA_Codigo
  LEFT JOIN dbo.Lineas LINEA2 ON LINEA2.LINEA_Codigo = ART.LINEA_Codigo
 WHERE FAMILIA IS NOT NULL 

 /*====================================================================================================*/

 SELECT *  FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CTP%'
 SELECT *  FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'PRO%'
 SELECT *  FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'UND%'

 SELECT * FROM dbo.Articulos WHERE ARTIC_Descontinuado = 1
 SELECT * FROM dbo.Articulos WHERE ARTIC_Descontinuado = 0
 --SELECT ARTIC_Id FROM dbo.Articulos GROUP BY ARTIC_Id HAVING COUNT(*)>1
-- SELECT ARTIC_Descontinuado, COUNT(*) FROM dbo.Articulos GROUP BY ARTIC_Descontinuado
--SELECT * FROM bdcopy..productosif 
 --SELECT * FROM bdcopy..productosif WHERE LINEA_CODIGO = '1404'
 --UPDATE bdcopy..productosif SET LINEA_CODIGO = '1804' WHERE LINEA_CODIGO = '1404'

/*====================================================================================================*/

SELECT MAX(ARTIC_ID) FROM dbo.Articulos ORDER BY ARTIC_Codigo
SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = '0801012'
SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo LIKE '1201%'
SELECT * FROM dbo.Precios WHERE ARTIC_Codigo = '0801012'
SELECT * FROM dbo.Precios WHERE ARTIC_Codigo = '1201016'
SELECT * FROM #Producto WHERE ARTIC_Codigo = '1201016'
SELECT * FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = '0801012'
SELECT * FROM Ventas.VENT_ListaPrecios
--DELETE FROM dbo.Articulos WHERE CONVERT(VARCHAR(8), ARTIC_FecCrea, 112) = '20171229'
SELECT MIN(ARTIC_Id) FROM dbo.Articulos WHERE CONVERT(VARCHAR(8), ARTIC_FecCrea, 112) = '20171229'
UPDATE dbo.Articulos SET ARTIC_Descontinuado = 0 WHERE CONVERT(VARCHAR(8), ARTIC_FecCrea, 112) = '20171230'


SELECT * FROM #Producto
exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'83.00',@Linea=N'1201',@Cadena=N'',@TipoConsulta=N'P',@PERIO_Codigo=N'2017',@ALMAC_Id=2