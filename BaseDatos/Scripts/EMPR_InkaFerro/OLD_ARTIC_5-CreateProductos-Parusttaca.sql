USE BDInkasFerro_Parusttacca
go

IF OBJECT_ID('tempdb..#ProdUpdate') IS NOT NULL
   BEGIN 
      DROP TABLE #ProdUpdate
   END 

SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
     , PROD.Descripcion
     , REG = COUNT(*)
  INTO #ProdUpdate
  FROM BDCopy..Productos2018 PROD WHERE TCol IN ('EP', 'EA') AND [Cod-Existente] IS NULL
  --AND PROD.Descripcion
GROUP BY Codigo, PROD.Descripcion HAVING COUNT(*) = 2
ORDER BY Descripcion

--SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
--     , PROD.Descripcion
--     , Codigo
--     , REG = COUNT(*)
--  --INTO #ProdInsert
--  FROM BDCopy..Productos2018 PROD WHERE TCol IN ('EP', 'EA') 
--   AND [Cod-Existente] IS NULL
--  --AND PROD.Descripcion
--GROUP BY Codigo, PROD.Descripcion HAVING COUNT(*) = 1
--ORDER BY Codigo
--/* INSERTAR EN ALMUDENA */
--SELECT * FROM #ProdUpdate
-- Buscar todos los productos de Almudena y crearlos en Parusttaca
--==============================================================================================================================--

BEGIN TRAN X

   CREATE TABLE #ArtNews(ARTIC_Codigo VARCHAR(7), ARTIC_Codigo_OLD VARCHAR(7))

    INSERT INTO BDCopy.dbo.Articulos_P
    SELECT ARTIC.ARTIC_Codigo           --, A.ARTIC_Detalle
         , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
         , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
         , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
         , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
         , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
         , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
         , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
         , Origen = 'N'
      FROM BDCopy..Articulos ARTIC
      LEFT JOIN dbo.Articulos A ON A.ARTIC_Codigo = ARTIC.ARTIC_Codigo
     WHERE ARTIC.ORIGEN = 'A'
       AND A.ARTIC_Codigo IS NOT NULL
      --AND ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

    INSERT INTO dbo.Articulos
    SELECT ARTIC_Codigo                 
         , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
         , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
         , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
         , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
         , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
         , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
         , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      FROM BDCopy..Articulos ARTIC
     WHERE ARTIC.ORIGEN = 'A'
      AND ARTIC.ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

--==============================================================================================================================--

   DECLARE @ARTIC_CODIGO VARCHAR(7)

   DECLARE Art CURSOR FOR 
    SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7)
      FROM BDCopy..Productos2018 PROD
      LEFT JOIN #ProdUpdate PUPD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = PUPD.ARTIC_CODIGO
     WHERE PROD.TCol = 'EA'
       AND PROD.[Cod-Existente] IS NULL 
       AND PUPD.ARTIC_CODIGO IS NULL 
       AND PROD.Descripcion <> 'ELIMINAR'
      OPEN Art

   FETCH NEXT FROM Art
	   INTO @ARTIC_CODIGO

   WHILE @@FETCH_STATUS = 0
      BEGIN
         --======================================================================================================================--
         DECLARE @Codigo INT
         SET @Codigo = ISNULL((SELECT MAX(CONVERT(INT, RIGHT(ARTIC.ARTIC_Codigo, 3))) 
                                 FROM dbo.Articulos ARTIC
                                WHERE LEFT(ARTIC.ARTIC_Codigo, 4) = LEFT(@ARTIC_CODIGO, 4)), 0) + 1
	      --======================================================================================================================--
	      -- GENERAR CODIGO NUEVO EN ALMUDENA
         Declare @ARTIC_CODIGO_NEW VARCHAR(7)
         SET @ARTIC_CODIGO_NEW = LEFT(@ARTIC_CODIGO, 4)  + RIGHT('000' + RTRIM(@Codigo), 3)
         PRINT @ARTIC_CODIGO + ' - ' + @ARTIC_CODIGO_NEW

         INSERT INTO #ArtNews VALUES(@ARTIC_CODIGO_NEW, @ARTIC_CODIGO)
         --======================================================================================================================--
         PRINT '================================================================================================================'
         PRINT 'CREAR NUEVO ARTICULO'
          INSERT INTO dbo.Articulos
          SELECT ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
               , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
               , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
               , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
               , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
               , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
               , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
               , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
            FROM BDCopy..Articulos_A ARTIC
           WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO

         --PRINT '================================================================================================================'
         PRINT 'COPIAR EL ARTICULO A UNA TABLA ALTERNA PARA ACTUALIZAR ALMUDENA'

          INSERT INTO BDCOPY.dbo.Articulos_News
          SELECT ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
               , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
               , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
               , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
               , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
               , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
               , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
               , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
               , 'N'
            FROM BDCopy..Articulos_A ARTIC
           WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO
    
         --PRINT '================================================================================================================'
         PRINT 'CREAR PRECIOS'
           INSERT INTO dbo.Precios
                   ( ZONAS_Codigo ,               ARTIC_Codigo ,               TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                     PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea )
            SELECT ZONAS_Codigo  = '83.00'
                 , ARTIC_Codigo  = @ARTIC_CODIGO_NEW 
                 , TIPOS_CodTipoMoneda = 'MND1'
                 , PRECI_Precio = 1
                 , PRECI_TipoCambio = 3.2
                 , PRECI_UsrCrea = 'SISTEMAS'
                 , PRECI_FecCrea = GETDATE()
           FROM BDCopy..Articulos_A ARTIC
           WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO

         --PRINT '================================================================================================================'
         PRINT 'CREAR LISTA DE PRECIOS POR ARTICULO '
           INSERT INTO Ventas.VENT_ListaPreciosArticulos
                   ( ZONAS_Codigo ,               LPREC_Id ,               ARTIC_Codigo ,               ALPRE_Constante ,
                     ALPRE_PorcentaVenta ,               ALPRE_UsrCrea ,               ALPRE_FecCrea              )
           SELECT ZONAS_Codigo = '83.00'
                , LPREC_Id 
                , ARTIC_Codigo = @ARTIC_CODIGO_NEW
                , ALPRE_Constante = LPREC_Id
                , ALPRE_PorcentaVenta = 0
                , ALPRE_UsrCrea  = 'SISTEMAS'
                , ALPRE_FecCrea  = GETDATE()
            FROM BDCopy..Articulos_A ARTIC
            LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00'
           WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO
  
         --PRINT '================================================================================================================'

         --PRINT 'CREAR NUEVO ARTICULO'
         -- ELIMINAR ARTICULO

         --DELETE FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
         --DELETE FROM dbo.Precios WHERE ARTIC_Codigo = @ARTIC_CODIGO
         --DELETE FROM dbo.Articulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
   
         --======================================================================================================================--
   
         FETCH NEXT FROM Art
	      INTO @ARTIC_CODIGO
      END

   CLOSE Art
   DEALLOCATE Art
--==============================================================================================================================--

   SELECT A.ARTIC_Codigo_OLD, ART.* 
    FROM dbo.Articulos ART 
    INNER JOIN #ArtNews A ON A.ARTIC_Codigo = ART.ARTIC_Codigo
    

--==============================================================================================================================--
   ROLLBACK TRAN X




IF OBJECT_ID('tempdb..#ProdUpdate') IS NOT NULL
   BEGIN 
      DROP TABLE #ProdUpdate
   END 

--==============================================================================================================================--
   --SELECT * FROM Ventas.VENT_ListaPrecios 