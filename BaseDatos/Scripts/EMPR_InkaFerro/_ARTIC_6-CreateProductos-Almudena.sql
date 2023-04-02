USE BDInkasFerro_Almudena
go

--DROP TABLE #ArtNews
BEGIN TRAN X
--ROLLBACK TRAN X

     CREATE TABLE #ArtNews(ARTIC_Codigo VARCHAR(7), ARTIC_Codigo_OLD VARCHAR(7))
    -- CREAR LOS ARTICULOS QUE NO EXISTEN EN PARUSTACA 

    --INSERT INTO BDCopy.dbo.Articulos_ALM(Codigo)
/*
    SELECT Codigo = CONVERT(INT, ARTIC_Codigo)
      INTO BDCopy..Articulos_NewsAlm
      FROM BDCopy..Articulos ARTIC
     WHERE ARTIC.ORIGEN = 'P'
       AND ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)
*/
   --SELECT * FROM BDCopy..Articulos WHERE ARTIC_Codigo = '0801572'

   --CREATE TABLE #ArtNews(ARTIC_Codigo VARCHAR(7), ARTIC_Codigo_OLD VARCHAR(7))

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
     WHERE ARTIC.ORIGEN = 'P'
       AND ARTIC.ARTIC_Codigo NOT IN (SELECT ARTIC_Codigo FROM dbo.Articulos)
    
    INSERT INTO dbo.Articulos
    SELECT * FROM #ArticulosNews
    -----------------------------------------------------------------------------------------------------------------------------
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
        DECLARE @ARTIC_CODIGO_OLD VARCHAR(7) 
        DECLARE @ARTIC_CODIGO_NEW VARCHAR(7) 

         DECLARE Art CURSOR FOR 
          SELECT ARTIC_CODIGO, ARTIC_CODIGO_OLD
            FROM BDCopy..Articulos_News
            OPEN Art

            FETCH NEXT FROM Art
	         INTO @ARTIC_CODIGO_NEW, @ARTIC_CODIGO_OLD

         WHILE @@FETCH_STATUS = 0
            BEGIN
               
               INSERT INTO #ArtNews VALUES(@ARTIC_CODIGO_NEW, @ARTIC_CODIGO_OLD)
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
                     --, PROD.*, ARTIC.ORIGEN
                  FROM BDCopy..Articulos_News ARTIC
                 WHERE ARTIC.ARTIC_Codigo_old = @ARTIC_CODIGO_OLD AND ARTIC.ORIGEN = 'NW'

               --PRINT '================================================================================================================'
                     PRINT 'CREAR PRECIOS'
                    INSERT INTO dbo.Precios
                         ( ZONAS_Codigo ,               ARTIC_Codigo ,               TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea )
                    SELECT ZONAS_Codigo ,               ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea 
                      FROM BDCopy..Precios_News PRECI
                     INNER JOIN BDCopy..Articulos_News ARTIC ON ARTIC.ARTIC_CODIGO = PRECI.ARTIC_CODIGO
                     WHERE ARTIC.ARTIC_Codigo_OLD = @ARTIC_CODIGO_OLD AND ARTIC.ORIGEN = 'NW'

                  ----PRINT '================================================================================================================'
                     PRINT 'CREAR LISTA DE PRECIOS POR ARTICULO '
                    INSERT INTO Ventas.VENT_ListaPreciosArticulos
                         ( ZONAS_Codigo ,               LPREC_Id ,               ARTIC_Codigo ,               ALPRE_Constante ,
                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea              )
                    SELECT ZONAS_Codigo ,               LPREC_Id 
                         , ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , ALPRE_Constante ,                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea
                      FROM BDCopy..VENT_ListaPreciosArticulos_News LPRE
                     INNER JOIN BDCopy..Articulos_News ARTIC ON ARTIC.ARTIC_CODIGO = LPRE.ARTIC_CODIGO
                     WHERE ARTIC.ARTIC_Codigo_OLD = @ARTIC_CODIGO_OLD AND ARTIC.ORIGEN = 'NW'
  

               --======================================================================================================================--
               -- MOVER ARTICULO A NUEVO CODIGO
                PRINT 'MOVER'

                --PRINT '--------------------------------------------------------'
                --PRINT 'Ventas.VENT_ListaPreciosArticulos'
                --UPDATE Ventas.VENT_ListaPreciosArticulos
                --  SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                --WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD

                PRINT '--------------------------------------------------------'
                PRINT 'Ventas.VENT_DocsVentaDetalle'
               UPDATE Ventas.VENT_DocsVentaDetalle
                  SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                PRINT '--------------------------------------------------------'
                PRINT 'Ventas.VENT_PedidosDetalle'
                UPDATE Ventas.VENT_PedidosDetalle
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.DIST_GuiasRemisionDetalle'
                UPDATE Logistica.DIST_GuiasRemisionDetalle
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.LOG_Stocks'
                UPDATE Logistica.LOG_Stocks
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.LOG_StockIniciales'
                UPDATE Logistica.LOG_StockIniciales
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.CTRL_ArreglosDetalle'
                UPDATE Logistica.CTRL_ArreglosDetalle
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.ABAS_DocsCompraDetalle'
                UPDATE Logistica.ABAS_DocsCompraDetalle
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
                 PRINT '--------------------------------------------------------'
                 PRINT 'Logistica.ABAS_IngresosCompraDetalle'
                UPDATE Logistica.ABAS_IngresosCompraDetalle
                   SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
                 WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
               --======================================================================================================================--

               DELETE FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
               DELETE FROM dbo.Precios WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD
               DELETE FROM dbo.Articulos WHERE ARTIC_Codigo = @ARTIC_CODIGO_OLD

            FETCH NEXT FROM Art
	            INTO @ARTIC_CODIGO_NEW, @ARTIC_CODIGO_OLD
            END

         CLOSE Art
         DEALLOCATE Art

SELECT * FROM #ArtNews

commit TRAN X

/*

-- PRODUCTOS CREADOS EN PARUSTACA
    SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7), *
      FROM BDCopy..Articulos_PAR PROD
     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
       AND LEN(ISNULL(PROD.cod_alterno, '')) = 0
   -- Crear en Almudena Con el Codigo de Parustaca
----------------------------------------------------------------------------------------------------
-- PRODUCTOS A REEMPLAZAR EN ALMUDENA
    SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7), *
      FROM BDCopy..Articulos_PAR PROD
     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
       AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7
   -- Trasladar al codigo Alterno todos los productos

   */

--SELECT  * FROM dbo.Articulos WHERE ARTIC_Codigo = '0801572'

    --INSERT INTO Articulos
    --SELECT ARTIC_Codigo                 
    --     , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
    --     , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
    --     , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
    --     , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
    --     , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
    --     , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
    --     , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
    --  FROM BDCopy..Articulos_News ARTIC





--   SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = '0406002'
--   SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = '0406026'


--   SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo IN 
--   (
--   SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7)
--      FROM BDCopy..Articulos_PAR PROD
--     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
--       AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7
--       )


-- DECLARE @ARTIC_CODIGO VARCHAR(7)

--   DECLARE Art CURSOR FOR 
--    SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7)
--     , *
--      FROM BDCopy..Articulos_ALM PROD
--     WHERE PROD.ESTADO NOT IN ('DEL', 'FI')
--      OPEN Art

--   FETCH NEXT FROM Art
--	   INTO @ARTIC_CODIGO



--   WHILE @@FETCH_STATUS = 0
--      BEGIN


---- CREAR ARTICULO DE PARUSSTACA
-- --======================================================================================================================--
--   -- MOVER ARTICULO A NUEVO CODIGO
--   PRINT 'MOVER'
--   PRINT '--------------------------------------------------------'
--   PRINT 'Ventas.VENT_DocsVentaDetalle'
--   UPDATE Ventas.VENT_DocsVentaDetalle
--      SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--    WHERE ARTIC_Codigo = @ARTIC_CODIGO
--    PRINT '--------------------------------------------------------'
--    PRINT 'Ventas.VENT_PedidosDetalle'
--    UPDATE Ventas.VENT_PedidosDetalle
--       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--     WHERE ARTIC_Codigo = @ARTIC_CODIGO
--     PRINT '--------------------------------------------------------'
--     PRINT 'Logistica.DIST_GuiasRemisionDetalle'
--    UPDATE Logistica.DIST_GuiasRemisionDetalle
--       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--     WHERE ARTIC_Codigo = @ARTIC_CODIGO
--     PRINT '--------------------------------------------------------'
--     PRINT 'Logistica.LOG_Stocks'
--    UPDATE Logistica.LOG_Stocks
--       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--     WHERE ARTIC_Codigo = @ARTIC_CODIGO
--     PRINT '--------------------------------------------------------'
--     PRINT 'Logistica.LOG_StockIniciales'
--    UPDATE Logistica.LOG_StockIniciales
--       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--     WHERE ARTIC_Codigo = @ARTIC_CODIGO
--     PRINT '--------------------------------------------------------'
--     PRINT 'Logistica.CTRL_ArreglosDetalle'
--    UPDATE Logistica.CTRL_ArreglosDetalle
--       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
--     WHERE ARTIC_Codigo = @ARTIC_CODIGO
--   --======================================================================================================================--

--   FETCH NEXT FROM Art
--	      INTO @ARTIC_CODIGO
--      END

--   CLOSE Art
--   DEALLOCATE Art