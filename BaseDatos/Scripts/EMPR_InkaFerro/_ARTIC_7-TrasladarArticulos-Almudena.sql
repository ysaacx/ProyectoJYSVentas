

    --SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7), *
    --  FROM BDCopy..Articulos_PAR PROD
    -- WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
    --   AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7


BEGIN TRAN X

   DECLARE @ARTIC_CODIGO_OLD VARCHAR(7) 
   DECLARE @ARTIC_CODIGO_NEW VARCHAR(7) 
   CREATE TABLE #ArtNews(ARTIC_Codigo VARCHAR(7), ARTIC_Codigo_OLD VARCHAR(7))

   DECLARE Art CURSOR FOR 
    SELECT ARTIC_CODIGO_new = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Cod_Alterno)), 7)
         , ARTIC_CODIGO_OLD = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) --, *
      FROM BDCopy..Articulos_PAR PROD
     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
       AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7
      OPEN Art

      FETCH NEXT FROM Art
	   INTO @ARTIC_CODIGO_NEW, @ARTIC_CODIGO_OLD

      WHILE @@FETCH_STATUS = 0
         BEGIN

             PRINT @ARTIC_CODIGO_OLD + ' - ' + @ARTIC_CODIGO_NEW

             IF exists(SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = @ARTIC_CODIGO_NEW)
               BEGIN
                  PRINT 'Enviado a Nuevos'

                   INSERT INTO BDCopy..Articulos_NewsAlm2
                   SELECT ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
                        , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
                        , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
                        , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
                        , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
                        , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
                        , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
                        , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
                        , Origen = 'AL'
                     FROM BDCopy..Articulos ARTIC
                    INNER JOIN BDCopy..Articulos_ALM PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = ARTIC.ARTIC_Codigo
                    WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO_OLD AND ARTIC.ORIGEN = 'CN'
               END 
            ELSE
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
                  FROM BDCopy..Articulos ARTIC
                 INNER JOIN BDCopy..Articulos_ALM PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = ARTIC.ARTIC_Codigo
                 WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO_OLD AND ARTIC.ORIGEN = 'CN'

               --PRINT '================================================================================================================'
                     PRINT 'CREAR PRECIOS'
                    INSERT INTO dbo.Precios
                         ( ZONAS_Codigo ,               ARTIC_Codigo ,               TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea )
                    SELECT ZONAS_Codigo ,               ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , TIPOS_CodTipoMoneda ,               PRECI_Precio ,
                           PRECI_TipoCambio ,           PRECI_UsrCrea ,              PRECI_FecCrea 
                      FROM BDCopy..Precios PRECI
                     WHERE PRECI.ARTIC_Codigo = @ARTIC_CODIGO_OLD AND ORIGEN = 'CN'

               --PRINT '================================================================================================================'
                     PRINT 'CREAR LISTA DE PRECIOS POR ARTICULO '
                    INSERT INTO Ventas.VENT_ListaPreciosArticulos
                         ( ZONAS_Codigo ,               LPREC_Id ,               ARTIC_Codigo ,               ALPRE_Constante ,
                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea              )
                    SELECT ZONAS_Codigo ,               LPREC_Id 
                         , ARTIC_Codigo = @ARTIC_CODIGO_NEW
                         , ALPRE_Constante ,                           ALPRE_PorcentaVenta ,        ALPRE_UsrCrea ,          ALPRE_FecCrea
                      FROM BDCopy..VENT_ListaPreciosArticulos LPRE
                     WHERE LPRE.ARTIC_Codigo = @ARTIC_CODIGO_OLD AND ORIGEN = 'CN'

               --======================================================================================================================--


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

                 END 

            FETCH NEXT FROM Art
	         INTO @ARTIC_CODIGO_NEW, @ARTIC_CODIGO_OLD
         END

   CLOSE Art
   DEALLOCATE Art

SELECT * FROM BDCopy..Articulos_NewsAlm2
SELECT * FROM #ArtNews

ROLLBACK TRAN X



--SELECT * FROM dbo.Articulos WHERE ARTIC_Codigo = '0406026'
