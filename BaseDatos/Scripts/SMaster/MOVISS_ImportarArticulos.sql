USE BDMaster
GO

GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ImportarArticulos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[MOVISS_ImportarArticulos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ImportarArticulos]
( 
  @Inicializar BIT 
, @EMPR_Codigo CHAR(5)
)
AS
BEGIN 


   IF @Inicializar = 1
      BEGIN 
         DELETE FROM Productos
         DELETE FROM dbo.Linea
         DELETE FROM dbo.Sublinea
      END 

 INSERT Into Productos 
      ( Id_Producto                  , Id_Producto2                 , Nombre_Producto              , Nombre_Producto2             
      , ID_Sublinea                  , ID_Unidad_Medida             , ID_Color                     , Peso                         
      , Orden                        , ID_Categoria                 , ID_Tipo_Producto             , Tasa_Cero                    
      , Percepcion                   , Descontinuado                , Localizacion                 , Punto_Reorden                
      , stock_inicial                , stock                        , stock1                       , stock2                       
      , Stock_Fecha                  , Existencia_Minima            , Existencia_Maxima            , ID_Moneda                    
      , Tipo_Comision                , Costo_Moneda                 , Costo_Unidad                 , Costo_Moneda_Prod            
      , Costo_Unidad_Prod            , Costo_Unidad_Modificado      , Costo_Unidad_Modificado_Prod , FechaUltimoCosteo            
      , Precio_Venta_Dol             , Utilidad                     , Utilidad_Minimo              , Precio_Venta                 
      , Precio_Venta_Fecha           , Precio_Minimo                , Ventas                       , L1                           
      , C2                           , L2                           , C3                           , L3                           
      , C4                           , L4                           , C5                           , L5                           
      , LCusco                       , LTacna                       , cuenta                       , ctacos                       
      , ctacar                       , saldo                        , ctaabo                       , cventa                       
      , stock_junio                  , conteo                       , pendiente_venta              , pendiente_orden              
      , malogrado                    , Costo                        , Pedidos                      , Fecha_Act                    
      , PreLocCus                    , PreLocTac                    , Cusco_Costo                  , Cusco_Costo_Moneda           
      , Cusco_Precio                 , Cusco_Precio_Fecha           , Cusco_AdmPre                 , Cusco_Modificado             
      , Cusco_Moneda                 , Cusco_L1                     , Cusco_L2                     , Cusco_L3                     
      , Cusco_L4                     , Cusco_L5                     , Cusco_C2                     , Cusco_C3                     
      , Cusco_C4                     , Cusco_C5                     , Tacna_Costo                  , Tacna_Costo_Moneda           
      , Tacna_Precio                 , Tacna_Precio_Fecha           , Tacna_AdmPre                 , Tacna_Modificado             
      , Tacna_Moneda                 , Tacna_L1                     , Tacna_L2                     , Tacna_L3                     
      , Tacna_L4                     , Tacna_L5                     , Tacna_C2                     , Tacna_C3                     
      , Tacna_C4                     , Tacna_C5                     , Producto_Malogrado           , Donacion                     
      , Imprimir                     , ARTIC_Codigo                 , EMPR_Codigo)
 SELECT Id_Producto                  = ARTIC_Codigo
      , Id_Producto2                 = ARTIC_Codigo
      , Nombre_Producto              = LEFT(ARTIC_Descripcion, 80)
      , Nombre_Producto2             = LEFT(ARTIC_Descripcion, 80)
      , ID_Sublinea                  = LINEA_Codigo
      , ID_Unidad_Medida             = right(TIPOS_CodUnidadMedida, 1)
      , ID_Color                     = null
      , Peso                         = ARTIC_Peso
      , Orden                        = ARTIC_Orden
      , ID_Categoria                 = NULL 
      , ID_Tipo_Producto             = NULL 
      , Tasa_Cero                    = NULL 
      , Percepcion                   = NULL 
      , Descontinuado                = ARTIC_Descontinuado
      , Localizacion                 = NULL 
      , Punto_Reorden                = NULL 
      , stock_inicial                = NULL 
      , stock                        = NULL 
      , stock1                       = NULL 
      , stock2                       = NULL 
      , Stock_Fecha                  = NULL 
      , Existencia_Minima            = ARTIC_ExistenciaMin
      , Existencia_Maxima            = ARTIC_ExistenciaMax
      , ID_Moneda                    = NULL 
      , Tipo_Comision                = NULL 
      , Costo_Moneda                 = NULL 
      , Costo_Unidad                 = NULL 
      , Costo_Moneda_Prod            = NULL 
      , Costo_Unidad_Prod            = NULL 
      , Costo_Unidad_Modificado      = NULL 
      , Costo_Unidad_Modificado_Prod = NULL 
      , FechaUltimoCosteo            = NULL 
      , Precio_Venta_Dol             = NULL 
      , Utilidad                     = NULL 
      , Utilidad_Minimo              = NULL 
      , Precio_Venta                 = NULL 
      , Precio_Venta_Fecha           = NULL 
      , Precio_Minimo                = NULL 
      , Ventas                       = NULL 
      , L1                           = NULL 
      , C2                           = NULL 
      , L2                           = NULL 
      , C3                           = NULL 
      , L3                           = NULL 
      , C4                           = NULL 
      , L4                           = NULL 
      , C5                           = NULL 
      , L5                           = NULL 
      , LCusco                       = NULL 
      , LTacna                       = NULL 
      , cuenta                       = NULL 
      , ctacos                       = NULL 
      , ctacar                       = NULL 
      , saldo                        = NULL 
      , ctaabo                       = NULL 
      , cventa                       = NULL 
      , stock_junio                  = NULL 
      , conteo                       = NULL 
      , pendiente_venta              = NULL 
      , pendiente_orden              = NULL 
      , malogrado                    = NULL 
      , Costo                        = NULL 
      , Pedidos                      = NULL 
      , Fecha_Act                    = NULL 
      , PreLocCus                    = NULL 
      , PreLocTac                    = NULL 
      , Cusco_Costo                  = NULL 
      , Cusco_Costo_Moneda           = NULL 
      , Cusco_Precio                 = NULL 
      , Cusco_Precio_Fecha           = NULL 
      , Cusco_AdmPre                 = NULL 
      , Cusco_Modificado             = NULL 
      , Cusco_Moneda                 = NULL 
      , Cusco_L1                     = NULL 
      , Cusco_L2                     = NULL 
      , Cusco_L3                     = NULL 
      , Cusco_L4                     = NULL 
      , Cusco_L5                     = NULL 
      , Cusco_C2                     = NULL 
      , Cusco_C3                     = NULL 
      , Cusco_C4                     = NULL 
      , Cusco_C5                     = NULL 
      , Tacna_Costo                  = NULL 
      , Tacna_Costo_Moneda           = NULL 
      , Tacna_Precio                 = NULL 
      , Tacna_Precio_Fecha           = NULL 
      , Tacna_AdmPre                 = NULL 
      , Tacna_Modificado             = NULL 
      , Tacna_Moneda                 = NULL 
      , Tacna_L1                     = NULL 
      , Tacna_L2                     = NULL 
      , Tacna_L3                     = NULL 
      , Tacna_L4                     = NULL 
      , Tacna_L5                     = NULL 
      , Tacna_C2                     = NULL 
      , Tacna_C3                     = NULL 
      , Tacna_C4                     = NULL 
      , Tacna_C5                     = NULL 
      , Producto_Malogrado           = NULL 
      , Donacion                     = NULL 
      , Imprimir                     = 1 
      , ARTIC_Codigo                 
      , @EMPR_Codigo
   FROM BDSisSCC..Articulos
  WHERE Not ARTIC_Codigo In (Select Id_producto from Productos)
    AND ARTIC_Descontinuado = 0

INSERT INTO dbo.Linea
        ( ID_Linea ,
          Nombre_Linea ,
          ID_Tipo_Comision,
          EMPR_Codigo
        )
SELECT ID_Linea = LINEA_Codigo,
       Nombre_Linea = LINEA_Nombre,
       ID_Tipo_Comision = 0,
       @EMPR_Codigo
  FROM BDSisSCC..Lineas 
 WHERE LINEA_CodPadre IS NULL 
   AND NOT LINEA_Codigo IN (SELECT ID_Linea FROM dbo.Linea)

INSERT INTO dbo.Sublinea
        ( ID_Linea ,
          ID_Sublinea ,
          Nombre_Sublinea,
          EMPR_Codigo 
        )
   SELECT ID_Linea = LINEA_CodPadre ,
          ID_Sublinea = LINEA_Codigo,
          Nombre_Sublinea = LINEA_Nombre,
          @EMPR_Codigo
 FROM BDSisSCC..Lineas WHERE LINEA_CodPadre IS not NULL 
  AND NOT LINEA_Codigo IN (SELECT ID_Sublinea FROM dbo.Sublinea)

  UPDATE dbo.Almacenes SET Activo = Activo

END 

GO


--SELECT * FROM BDSisSCC..Lineas WHERE LINEA_CodPadre IS NULL 
--SELECT * FROM BDSisSCC..Lineas WHERE LINEA_CodPadre IS not NULL 

--SELECT * FROM Sublinea

--SELECT * FROM BDSisSCC..Articulos WHERE ARTIC_Descontinuado = 0