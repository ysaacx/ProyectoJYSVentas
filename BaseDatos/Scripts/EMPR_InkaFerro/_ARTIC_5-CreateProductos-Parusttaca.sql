USE BDInkasFerro_Parusttacca
go
--IF OBJECT_ID('tempdb..#ProdUpdate') IS NOT NULL
--   BEGIN 
--      DROP TABLE #ProdUpdate
--   END 
--==============================================================================================================================--


BEGIN TRAN X
--ROLLBACK TRAN X

     CREATE TABLE #ArtNews(ARTIC_Codigo VARCHAR(7), ARTIC_Codigo_OLD VARCHAR(7))
    -- CREAR LOS ARTICULOS QUE NO EXISTEN EN PARUSTACA 

    INSERT INTO BDCopy.dbo.Articulos_ALM(Codigo)
    SELECT CONVERT(INT, ARTIC_Codigo)
      FROM BDCopy..Articulos ARTIC
     WHERE ARTIC.ORIGEN = 'A'
       AND ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

       ---::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

       --SELECT * FROM BDCopy..ARTICULOS WHERE ORIGEN = 'AN'

       --INSERT INTO BDCopy..ARTICULOS
       --SELECT ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
       --     , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
       --     , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
       --     , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
       --     , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
       --     , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
       --     , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
       --     , Origen = 'AN'
       --  FROM BDCopy..Articulos ALM
       --  INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = alm.ARTIC_Codigo
       --  WHERE ALM.ORIGEN = 'A'
       --    AND ALM.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

       --     INSERT INTO BDCopy.dbo.Precios
       --        ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
       --        , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
       --        , PRECI.PRECI_FecMod           
       --        , Origen)
       --     SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
       --        , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
       --        , PRECI.PRECI_FecMod
       --        , Origen = 'AN'
       --     FROM dbo.Precios PRECI
       --     INNER JOIN BDCopy..Articulos ALM ON ALM.ARTIC_Codigo = PRECI.ARTIC_Codigo
       --     INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = alm.ARTIC_Codigo
       --     WHERE ALM.ORIGEN = 'A'
       --       AND ALM.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

       --     INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
       --        ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
       --        , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
       --        , PRECI.ALPRE_FecMod           , Origen)
       --     SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
       --        , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
       --        , PRECI.ALPRE_FecMod           , Origen = 'AN'
       --     FROM Ventas.VENT_ListaPreciosArticulos PRECI
       --      INNER JOIN BDCopy..Articulos ALM ON ALM.ARTIC_Codigo = PRECI.ARTIC_Codigo
       --     INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = alm.ARTIC_Codigo
       --     WHERE ALM.ORIGEN = 'A'
       --       AND ALM.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)

       ---::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    
    SELECT ARTIC_Codigo                 
         , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
         , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
         , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
         , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
         , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
         , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
         , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      INTO #ArticulosNews
      FROM BDCopy..Articulos ARTIC
     WHERE ARTIC.ORIGEN = 'A'
       AND ARTIC.ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)
    
    INSERT INTO dbo.Articulos
    SELECT * FROM #ArticulosNews

      INSERT INTO #ArtNews( ARTIC_Codigo, ARTIC_Codigo_OLD )
      SELECT ARTIC.ARTIC_Codigo, NULL FROM #ArticulosNews ARTIC

    -----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           )
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
      FROM BDCopy..Precios PRECI
     INNER JOIN #ArticulosNews ARTIC ON ARTIC.ARTIC_Codigo = PRECI.ARTIC_Codigo
     --WHERE ARTIC.ORIGEN = 'A'
       --AND ARTIC.ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)
   -----------------------------------------------------------------------------------------------------------------------------
     INSERT INTO Ventas.VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           )
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           
      FROM BDCopy..VENT_ListaPreciosArticulos PRECI
     INNER JOIN #ArticulosNews ARTIC ON ARTIC.ARTIC_Codigo = PRECI.ARTIC_Codigo
     --WHERE ARTIC.ORIGEN = 'A'
       --AND ARTIC.ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)



     
--==============================================================================================================================--
----------------------------------------------------------------------------------------------------
-- PRODUCTOS A SER CREADOS QUE PROVIENEN DE ALMUDENA
   --SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7), *
   --   FROM BDCopy..Articulos_ALM PROD
   --  WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
   --    AND LEN(ISNULL(PROD.cod_alterno, '')) = 0
   ----------------------------------------------------------------------------------------------------
         DECLARE @ARTIC_CODIGO VARCHAR(7) --= '0801567'
         DECLARE @Tipo CHAR(1) 

         DECLARE Art CURSOR FOR 
          SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) --, *
               , 'N'
            FROM BDCopy..Articulos_ALM PROD
           WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
             AND LEN(ISNULL(PROD.cod_alterno, '')) = 0
             UNION
          SELECT ARTIC_CODIGO_OLD = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) --, *
               , 'C'
            FROM BDCopy..Articulos_PAR PROD
           WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
             AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7

            OPEN Art

         FETCH NEXT FROM Art
	         INTO @ARTIC_CODIGO, @Tipo

         WHILE @@FETCH_STATUS = 0
            BEGIN
               --BEGIN TRAN X
               --ROLLBACK TRAN X
               --DECLARE @ARTIC_CODIGO VARCHAR(7) = '0801567'
               --======================================================================================================================--
               DECLARE @Codigo INT
               SET @Codigo = ISNULL((SELECT MAX(CONVERT(INT, RIGHT(ARTIC.ARTIC_Codigo, 3))) 
                                       FROM dbo.Articulos ARTIC
                                      WHERE LEFT(ARTIC.ARTIC_Codigo, 4) = LEFT(@ARTIC_CODIGO, 4)), 0) + 1
	            --======================================================================================================================--
	            -- GENERAR CODIGO NUEVO EN ALMUDENA
               DECLARE @ARTIC_CODIGO_NEW VARCHAR(7)
                   SET @ARTIC_CODIGO_NEW = LEFT(@ARTIC_CODIGO, 4)  + RIGHT('000' + RTRIM(@Codigo), 3)
                 PRINT @ARTIC_CODIGO + ' - ' + @ARTIC_CODIGO_NEW

               INSERT INTO #ArtNews VALUES(@ARTIC_CODIGO_NEW, @ARTIC_CODIGO)
               --======================================================================================================================--
               -- Crear en Parustaca
               PRINT '================================================================================================================'
               PRINT 'CREAR NUEVO ARTICULO'
                INSERT INTO dbo.Articulos
                SELECT TOP 1 ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
                     , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
                     , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
                     , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
                     , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
                     , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
                     , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
                     , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
                     --, PROD.*, ARTIC.ORIGEN
                  FROM BDCopy..Articulos ARTIC
                 INNER JOIN BDCopy..Articulos_ALM PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = ARTIC.ARTIC_Codigo
                 WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO AND ARTIC.ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 

               --PRINT '================================================================================================================'
                     PRINT 'CREAR PRECIOS'
                    INSERT INTO dbo.Precios
                         ( ZONAS_Codigo ,               ARTIC_Codigo ,               TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea )
                    SELECT ZONAS_Codigo ,               ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea 
                      FROM BDCopy..Precios PRECI
                     WHERE PRECI.ARTIC_Codigo = @ARTIC_CODIGO AND ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 

               --PRINT '================================================================================================================'
                     PRINT 'CREAR LISTA DE PRECIOS POR ARTICULO '
                    INSERT INTO Ventas.VENT_ListaPreciosArticulos
                         ( ZONAS_Codigo ,               LPREC_Id ,               ARTIC_Codigo ,               ALPRE_Constante ,
                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea              )
                    SELECT ZONAS_Codigo ,               LPREC_Id 
                         , ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , ALPRE_Constante ,                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea
                      FROM BDCopy..VENT_ListaPreciosArticulos LPRE
                     WHERE LPRE.ARTIC_Codigo = @ARTIC_CODIGO AND ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 
  
                 --PRINT '================================================================================================================'
               -- Crear en Almudena y Moverlos al nuevo codigo segun lo creado en Parustaca
               PRINT 'COPIAR EL ARTICULO A UNA TABLA ALTERNA PARA ACTUALIZAR ALMUDENA'

                INSERT INTO BDCOPY.dbo.Articulos_News
                SELECT TOP 1 ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
                     , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
                     , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
                     , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
                     , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
                     , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
                     , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
                     , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
                     , 'NW'
                     , @ARTIC_CODIGO
                  FROM BDCopy..Articulos ARTIC
                 INNER JOIN BDCopy..Articulos_ALM PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = ARTIC.ARTIC_Codigo
                 WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO AND ARTIC.ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 

                 INSERT INTO BDCOPY.dbo.Precios_News
                         ( ZONAS_Codigo ,               ARTIC_Codigo ,               TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea , ORIGEN)
                    SELECT ZONAS_Codigo ,               ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea , 'NW'
                      FROM BDCopy..Precios PRECI
                     WHERE PRECI.ARTIC_Codigo = @ARTIC_CODIGO  AND ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 

                     INSERT INTO BDCopy..VENT_ListaPreciosArticulos_News
                         ( ZONAS_Codigo ,               LPREC_Id ,               ARTIC_Codigo ,               ALPRE_Constante ,
                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea              
                           , Origen)
                    SELECT ZONAS_Codigo ,               LPREC_Id 
                         , ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , ALPRE_Constante ,                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea
                         , 'NW'
                      FROM BDCopy..VENT_ListaPreciosArticulos LPRE
                     WHERE LPRE.ARTIC_Codigo = @ARTIC_CODIGO  AND ORIGEN = CASE @Tipo WHEN 'N' THEN 'AN' WHEN 'C' THEN 'CN' END 
  
                 --PRINT '================================================================================================================'

               --PRINT 'CREAR NUEVO ARTICULO'
               -- ELIMINAR ARTICULO

               --DELETE FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
               --DELETE FROM dbo.Precios WHERE ARTIC_Codigo = @ARTIC_CODIGO
               --DELETE FROM dbo.Articulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
   
               --======================================================================================================================--
   
               FETCH NEXT FROM Art
	            INTO @ARTIC_CODIGO, @Tipo
            END

         CLOSE Art
         DEALLOCATE Art
      --==============================================================================================================================--
   --==============================================================================================================================--
----------------------------------------------------------------------------------------------------
--SELECT * FROM BDCopy..Articulos_News
--SELECT * FROM BDCopy..Precios_News
--SELECT * FROM BDCopy..VENT_ListaPreciosArticulos_News

SELECT * FROM #ArtNews

--==============================================================================================================================--
ROLLBACK TRAN X
--COMMIT TRAN X

----------------------------------------------------------------------------------------------------

--   SELECT A.ARTIC_Codigo_OLD, ART.* 
--    FROM dbo.Articulos ART 
--    INNER JOIN #ArtNews A ON A.ARTIC_Codigo = ART.ARTIC_Codigo
    

    
--delete FROM BDCopy..Articulos_News
--delete FROM BDCopy..Precios_News
--delete FROM BDCopy..VENT_ListaPreciosArticulos_News
--SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = '3002026'

--IF OBJECT_ID('tempdb..#ProdUpdate') IS NOT NULL
--   BEGIN 
--      DROP TABLE #ProdUpdate
--   END 

----==============================================================================================================================--
   --SELECT * FROM Ventas.VENT_ListaPrecios 





       --INSERT INTO BDCopy.dbo.Articulos_P
    --SELECT ARTIC.ARTIC_Codigo           --, A.ARTIC_Detalle
    --     , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
    --     , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
    --     , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
    --     , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
    --     , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
    --     , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
    --     , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
    --     , Origen = 'N'
    --  FROM BDCopy..Articulos ARTIC
    --  LEFT JOIN dbo.Articulos A ON A.ARTIC_Codigo = ARTIC.ARTIC_Codigo
    -- WHERE ARTIC.ORIGEN = 'A'
    --   AND A.ARTIC_Codigo IS NOT NULL
    --  --AND ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)
