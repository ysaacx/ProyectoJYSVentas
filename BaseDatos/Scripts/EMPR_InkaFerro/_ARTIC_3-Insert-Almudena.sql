USE BDInkasFerro_Almudena
GO

BEGIN TRAN X

-- Productos Nuevos

INSERT INTO BDCopy..ARTICULOS
SELECT  ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      , Origen = 'A'
  FROM BDCopy.dbo.Productos2018 PROD
 INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7)
 WHERE TCol = 'NA'


    INSERT INTO BDCopy.dbo.Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           
         , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
         , Origen = 'A'
      FROM dbo.Precios PRECI
     INNER JOIN BDCopy.dbo.Productos2018 PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE TCol = 'NA'

    INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen = 'A'
      FROM Ventas.VENT_ListaPreciosArticulos PRECI
     INNER JOIN BDCopy.dbo.Productos2018 PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE TCol = 'NA'

-- Productos de comparacion

 INSERT INTO BDCopy..ARTICULOS
 SELECT   ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      , Origen = 'AN'
   FROM BDCopy..Articulos_ALM ALM
  INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, ALM.Codigo )), 7)
  WHERE ISNULL(ALM.estado, '') NOT IN ('DEL', 'FI')
    AND ISNULL(cod_alterno, 'no hay item en parustaca') = 'no hay item en parustaca'

    INSERT INTO BDCopy.dbo.Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           
         , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
         , Origen = 'AN'
      FROM dbo.Precios PRECI
     INNER JOIN BDCopy..Articulos_ALM ALM ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, ALM.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, ALM.Codigo )), 7)
     WHERE ISNULL(ALM.estado, '') NOT IN ('DEL', 'FI')
      AND ISNULL(cod_alterno, 'no hay item en parustaca') = 'no hay item en parustaca'


    INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen = 'AN'
      FROM Ventas.VENT_ListaPreciosArticulos PRECI
     INNER JOIN BDCopy..Articulos_ALM ALM ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, ALM.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDInkasFerro_Almudena..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, ALM.Codigo )), 7)
     WHERE ISNULL(ALM.estado, '') NOT IN ('DEL', 'FI')
      AND ISNULL(cod_alterno, 'no hay item en parustaca') = 'no hay item en parustaca'



ROLLBACK TRAN X
--COMMIT TRAN X

--SELECT * FROM BDCopy..Articulos WHERE ORIGEN in ('AN')
--SELECT * FROM BDCopy..Articulos WHERE ORIGEN in ('A')


--SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
--     , PROD.Descripcion
--     , REG = COUNT(*)
--  INTO #ProdUpdate
--  FROM BDCopy..Productos2018 PROD WHERE TCol IN ('EP', 'EA') AND [Cod-Existente] IS NULL
--  --AND PROD.Descripcion
--GROUP BY Codigo, PROD.Descripcion HAVING COUNT(*) = 2
--ORDER BY Descripcion


--INSERT INTO BDCopy..ARTICULOS_A
--SELECT  ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
--      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
--      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
--      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
--      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
--      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
--      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
--      , Origen = 'A'
--  FROM BDCopy..Productos2018 PROD
--  INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7)
--  LEFT JOIN #ProdUpdate PUPD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = PUPD.ARTIC_CODIGO
-- WHERE PROD.TCol = 'EA'
--  AND PROD.[Cod-Existente] IS NULL 
--  AND PUPD.ARTIC_CODIGO IS NULL 

----SELECT * FROM BDCopy..ARTICULOS_A
