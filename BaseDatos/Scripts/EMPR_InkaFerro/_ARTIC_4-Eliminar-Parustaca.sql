USE BDInkasFerro_Parusttacca
GO

BEGIN TRAN x

 PRINT '================================================================================================================================='
 PRINT 'VENT_ListaPreciosArticulos'
 DELETE ARTIC
   FROM BDCopy..Articulos_PAR PAR 
   LEFT JOIN Ventas.VENT_ListaPreciosArticulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)
  WHERE PAR.ESTADO IN ('DEL', 'FI')
    AND ARTIC.ARTIC_Codigo NOT 
     IN (SELECT ARTIC_Codigo FROM Ventas.VENT_DocsVentaDetalle UNION 
         SELECT ARTIC_Codigo FROM Ventas.VENT_PedidosDetalle UNION 
         SELECT ARTIC_Codigo FROM Logistica.LOG_Stocks)

  PRINT '================================================================================================================================='
  PRINT 'Precios'
 DELETE ARTIC
   FROM BDCopy..Articulos_PAR PAR 
   LEFT JOIN dbo.Precios ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)
  WHERE PAR.ESTADO IN ('DEL', 'FI')
    AND ARTIC.ARTIC_Codigo NOT 
     IN (SELECT ARTIC_Codigo FROM Ventas.VENT_DocsVentaDetalle UNION 
         SELECT ARTIC_Codigo FROM Ventas.VENT_PedidosDetalle UNION 
         SELECT ARTIC_Codigo FROM Logistica.LOG_Stocks)

  PRINT '================================================================================================================================='
  PRINT 'Articulos'
 DELETE ARTIC
   FROM BDCopy..Articulos_PAR PAR 
   LEFT JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)
  WHERE PAR.ESTADO IN ('DEL', 'FI')
    AND ARTIC.ARTIC_Codigo NOT 
     IN (SELECT ARTIC_Codigo FROM Ventas.VENT_DocsVentaDetalle UNION 
         SELECT ARTIC_Codigo FROM Ventas.VENT_PedidosDetalle UNION 
         SELECT ARTIC_Codigo FROM Logistica.LOG_Stocks)

  PRINT '================================================================================================================================='

 SELECT ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      , Origen = 'P'
   FROM BDCopy..Articulos_PAR PAR 
  INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)
  WHERE PAR.ESTADO IN ('DEL', 'FI')

--ROLLBACK TRAN x
COMMIT TRAN x

/*

 SELECT ARTIC.ARTIC_Codigo           , ARTIC.LINEA_Codigo           , ARTIC.TIPOS_CodTipoProducto  , ARTIC.TIPOS_CodCategoria     
      , ARTIC.TIPOS_CodUnidadMedida  , ARTIC.TIPOS_CodTipoColor     , ARTIC.ARTIC_Id               , ARTIC.ARTIC_Peso             
      , ARTIC.ARTIC_Detalle          , ARTIC.ARTIC_Descripcion      , ARTIC.ARTIC_Percepcion       , ARTIC.ARTIC_Descontinuado    
      , ARTIC.ARTIC_Localizacion     , ARTIC.ARTIC_Orden            , ARTIC.ARTIC_ExistenciaMin    , ARTIC.ARTIC_ExistenciaMax    
      , ARTIC.ARTIC_PuntoReorden     , ARTIC.ARTIC_Estado           , ARTIC.ARTIC_CodigoAnterior   , ARTIC.ARTIC_UsrCrea          
      , ARTIC.ARTIC_FecCrea          , ARTIC.ARTIC_UsrMod           , ARTIC.ARTIC_FecMod           , ARTIC.ARTIC_Numero           
      , ARTIC.RCVDT_Id               , ARTIC.ARTIC_NuevoIngreso     , ARTIC.ARTIC_UsrNuevoIngreso  , ARTIC.ARTIC_FecNuevoIngreso  
      , Origen = 'P'
 FROM BDCopy..Articulos_PAR PAR 
 INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = RIGHT('000000' + RTRIM(CONVERT(DECIMAL, PAR.Codigo )), 7)

*/