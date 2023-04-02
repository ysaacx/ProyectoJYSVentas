USE BDInkasFerro_Parusttacca
GO

--DELETE FROM BDCopy..ARTICULOS
--SELECT * FROM BDCopy..Productos2018

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
      , Origen = 'P'
  FROM BDCopy.dbo.Productos2018 PROD
 INNER JOIN BDInkasFerro_Parusttacca..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7)
 WHERE TCol = 'NP'

    INSERT INTO BDCopy.dbo.Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           
         , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
         , Origen = 'P'
      FROM dbo.Precios PRECI
     INNER JOIN BDCopy.dbo.Productos2018 PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE TCol = 'NP'

    INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen = 'N'
      FROM Ventas.VENT_ListaPreciosArticulos PRECI
     INNER JOIN BDCopy.dbo.Productos2018 PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE TCol = 'NP'

-- Productos de comparacion
   
     INSERT INTO BDCopy..ARTICULOS
     SELECT ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
          , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
          , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
          , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
          , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
          , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
          , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
          , Origen = 'PN'
       FROM BDCopy..Articulos_Par PAR
      INNER JOIN BDInkasFerro_Parusttacca..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)
      WHERE ISNULL(PAR.estado, '') NOT IN ('DEL', 'FI')
        AND ISNULL(cod_alterno, 'no hay item en ac') = 'no hay item en ac'

    INSERT INTO BDCopy.dbo.Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           
         , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
         , Origen = 'PN'
      FROM dbo.Precios PRECI
     INNER JOIN BDCopy..Articulos_Par PAR ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDCopy.dbo.Articulos_Par PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE ISNULL(PAR.estado, '') NOT IN ('DEL', 'FI')
       AND ISNULL(PAR.cod_alterno, 'no hay item en ac') = 'no hay item en ac'


    INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen = 'PN'
      FROM Ventas.VENT_ListaPreciosArticulos PRECI
     INNER JOIN BDCopy..Articulos_Par PAR ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDCopy.dbo.Articulos_Par PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE ISNULL(PAR.estado, '') NOT IN ('DEL', 'FI')
       AND ISNULL(PAR.cod_alterno, 'no hay item en ac') = 'no hay item en ac'

-------------------::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-----------------------

     INSERT INTO BDCopy..ARTICULOS
     SELECT ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
          , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
          , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
          , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
          , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
          , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
          , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
          , Origen = 'CN'
       FROM BDCopy..Articulos_Par PROD
      INNER JOIN BDInkasFerro_Parusttacca..Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7)
      WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
        AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7

    INSERT INTO BDCopy.dbo.Precios
         ( PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod           
         , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.ARTIC_Codigo           , PRECI.TIPOS_CodTipoMoneda    , PRECI.PRECI_Precio           
         , PRECI.PRECI_TipoCambio       , PRECI.PRECI_UsrCrea          , PRECI.PRECI_FecCrea          , PRECI.PRECI_UsrMod           
         , PRECI.PRECI_FecMod
         , Origen = 'CN'
      FROM dbo.Precios PRECI
     INNER JOIN BDCopy..Articulos_Par PAR ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDCopy.dbo.Articulos_Par PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
       AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7


    INSERT INTO bdcopy..VENT_ListaPreciosArticulos   
         ( PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen)
    SELECT PRECI.ZONAS_Codigo           , PRECI.LPREC_Id               , PRECI.ARTIC_Codigo           , PRECI.ALPRE_Constante        
         , PRECI.ALPRE_PorcentaVenta    , PRECI.ALPRE_UsrCrea          , PRECI.ALPRE_FecCrea          , PRECI.ALPRE_UsrMod           
         , PRECI.ALPRE_FecMod           , Origen = 'CN'
      FROM Ventas.VENT_ListaPreciosArticulos PRECI
     INNER JOIN BDCopy..Articulos_Par PAR ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7) = PRECI.ARTIC_Codigo
     INNER JOIN BDCopy.dbo.Articulos_Par PROD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo )), 7) = PRECI.ARTIC_Codigo
     WHERE ISNULL(PROD.estado, '') NOT IN ('DEL', 'FI')
       AND LEN(ISNULL(PROD.cod_alterno, '')) > 0 AND LEN(ISNULL(PROD.cod_alterno, '')) <= 7

--ROLLBACK TRAN X
COMMIT TRAN X


--SELECT * FROM BDCopy..Articulos WHERE ORIGEN in ('PN')
--SELECT * FROM BDCopy..Articulos WHERE ORIGEN in ('P')


----SELECT * FROM BDCopy.dbo.Productos2018 WHERE TCol = 'NP'
----SELECT * FROM BDCopy.dbo.Productos2018 WHERE TCol = 'NA'

--SELECT ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
--     , PROD.Descripcion
--     , REG = COUNT(*)
--  INTO #ProdUpdate
--  FROM BDCopy..Productos2018 PROD WHERE TCol IN ('EP', 'EA') AND [Cod-Existente] IS NULL
--  --AND PROD.Descripcion
--GROUP BY Codigo, PROD.Descripcion HAVING COUNT(*) = 2
--ORDER BY Descripcion


--INSERT INTO BDCopy..ARTICULOS_P
--SELECT  ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
--      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
--      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
--      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
--      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
--      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
--      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
--      , Origen = 'P'
--  FROM BDCopy..Productos2018 PROD
--  INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7)
--  LEFT JOIN #ProdUpdate PUPD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = PUPD.ARTIC_CODIGO
-- WHERE PROD.TCol = 'EP'
--  AND PROD.[Cod-Existente] IS NULL 
--  AND PUPD.ARTIC_CODIGO IS NULL 

