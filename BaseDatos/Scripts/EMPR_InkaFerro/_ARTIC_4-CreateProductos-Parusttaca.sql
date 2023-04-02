USE BDInkasFerro_Parusttacca
go

 if OBJECT_ID('tempdb..#ProdUpdate') IS NOT NULL
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


/* INSERTAR EN ALMUDENA */

--SELECT * FROM #ProdUpdate

-- Buscar todos los productos de Almudena y crearlos en Parusttaca
Declare @ARTIC_CODIGO VARCHAR(7)

DECLARE Art CURSOR FOR 
SELECT TOP 1 ARTIC_CODIGO = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, Codigo)), 7)
  FROM BDCopy..Productos2018 PROD
  LEFT JOIN #ProdUpdate PUPD ON RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PROD.Codigo)), 7) = PUPD.ARTIC_CODIGO
 WHERE PROD.TCol = 'EA'
  AND PROD.[Cod-Existente] IS NULL 
  AND PUPD.ARTIC_CODIGO IS NULL 
Open Art

FETCH NEXT FROM Art
	INTO @ARTIC_CODIGO

BEGIN TRAN X

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
      AND ARTIC.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos)


WHILE @@FETCH_STATUS = 0
Begin
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

   --======================================================================================================================--
   -- CREAR NUEVO ARTICULO
    INSERT INTO dbo.Articulos
    SELECT ARTIC_Codigo                 = @ARTIC_CODIGO_NEW
         , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
         , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
         , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
         , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
         , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
         , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
         , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      FROM BDCopy..ArticuloS_P ARTIC
     WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO

    
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
      FROM BDCopy..ArticuloS_P ARTIC
     WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO
    
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
     FROM BDCopy..ArticuloS_P ARTIC
     WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO

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
      FROM BDCopy..ArticuloS_P ARTIC
      LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00'
     WHERE ARTIC.ARTIC_Codigo = @ARTIC_CODIGO
  
   -- ELIMINAR ARTICULO

   --DELETE FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
   --DELETE FROM dbo.Precios WHERE ARTIC_Codigo = @ARTIC_CODIGO
   --DELETE FROM dbo.Articulos WHERE ARTIC_Codigo = @ARTIC_CODIGO
   
   --======================================================================================================================--
   
   FETCH NEXT FROM Art
	INTO @ARTIC_CODIGO
End

CLOSE Art
DEALLOCATE Art

ROLLBACK TRAN X

DROP TABLE #ProdUpdate


--SELECT * FROM Ventas.VENT_ListaPrecios 