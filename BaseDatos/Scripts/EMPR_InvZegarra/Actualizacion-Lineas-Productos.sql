USE BDImportacionesZegarra
GO

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--SELECT * FROM BDZegarra.dbo.Linea
--SELECT * FROM BDZegarra.dbo.Sublinea

    DELETE FROM Ventas.VENT_ListaPreciosArticulos
    DELETE FROM dbo.Precios
    DELETE FROM dbo.Articulos
    DELETE FROM dbo.Lineas


   INSERT INTO dbo.Lineas
        ( LINEA_Codigo                 , LINEA_CodPadre               , TIPOS_CodTipoComision        , LINEA_Nombre                 
        , LINEA_UsrCrea                , LINEA_FecCrea                , LINEA_Activo                 )
   SELECT LINEA_Codigo = ID_Linea      , LINEA_CodPadre = NULL        , TIPOS_CodTipoComision = NULL , LINEA_Nombre  = Nombre_Linea
        , LINEA_UsrCrea = 'SISTEMAS'   , LINEA_FecCrea = GETDATE()    , LINEA_Activo = 1
    FROM BDZegarra.dbo.Linea
    WHERE NOT ID_Linea IN (SELECT LINEA_Codigo FROM dbo.Lineas)
   INSERT INTO dbo.Lineas
        ( LINEA_Codigo                 , LINEA_CodPadre               , TIPOS_CodTipoComision        , LINEA_Nombre                 
        , LINEA_UsrCrea                , LINEA_FecCrea                , LINEA_Activo                 )
   SELECT LINEA_Codigo = ID_Sublinea   , LINEA_CodPadre = ID_Linea    , TIPOS_CodTipoComision = NULL , LINEA_Nombre  = Nombre_Sublinea
        , LINEA_UsrCrea = 'SISTEMAS'   , LINEA_FecCrea = GETDATE()    , LINEA_Activo = 1
    FROM BDZegarra.dbo.Sublinea
    WHERE NOT ID_Sublinea IN (SELECT LINEA_Codigo FROM dbo.Lineas)

    INSERT INTO dbo.Lineas
        ( LINEA_Codigo                 , LINEA_CodPadre               , TIPOS_CodTipoComision        , LINEA_Nombre                 
        , LINEA_UsrCrea                , LINEA_FecCrea                , LINEA_Activo                 )
   SELECT LINEA_Codigo = FAM.LINEA_Codigo + FAM.LINEA_Codigo                
        , LINEA_CodPadre = FAM.LINEA_Codigo    
        , TIPOS_CodTipoComision = NULL 
        , LINEA_Nombre  = FAM.LINEA_Nombre
        , LINEA_UsrCrea = 'SISTEMAS'   , LINEA_FecCrea = GETDATE()    , LINEA_Activo = 1
     FROM dbo.Lineas FAM
     LEFT JOIN dbo.Lineas SUB ON SUB.LINEA_Codigo = FAM.LINEA_CodPadre
    WHERE SUB.LINEA_Codigo IS NULL
      AND FAM.LINEA_Codigo + FAM.LINEA_Codigo NOT  IN (SELECT LINEA_Codigo FROM dbo.Lineas)
    
    --SELECT * FROM dbo.Lineas
    --SELECT * FROM dbo.SubLineas
    --SELECT * FROM BDZegarra..Sublinea
    -- SELECT * FROM BDZegarra..linea

    --SELECT FAM.*, SUB.* FROM dbo.Lineas FAM
    -- LEFT JOIN dbo.Lineas SUB ON SUB.LINEA_Codigo = FAM.LINEA_CodPadre
    -- WHERE SUB.LINEA_Codigo IS NULL

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--    SELECT * FROM #Productos WHERE linea_codigo NOT IN (SELECT LINEA_Codigo FROM dbo.Lineas)
--SELECT * FROM BDZegarra..Producto
--SELECT * FROM BDImportacion..Producto
   
   SELECT ARTIC_Codigo                 = Id_linea + Id_Producto
        , LINEA_Codigo                 = Id_linea + LEFT(Id_Producto, 2)
        , TIPOS_CodTipoProducto        = 'PRO1'
        , TIPOS_CodCategoria           = 'CTP1'
        , TIPOS_CodUnidadMedida        = CASE ID_Unidad_Medida
                                              WHEN 1 THEN 'UND19'
                                              WHEN 2 THEN 'UND04'
                                              WHEN 3 THEN 'UND03'
                                              WHEN 4 THEN 'UND20'
                                              WHEN 6 THEN 'UND06'
                                              WHEN 7 THEN 'UND07'
                                              ELSE 'UND06'
                                         END
        , TIPOS_CodTipoColor           = 'CLR000'
        , ARTIC_Id                     = ROW_NUMBER() OVER(ORDER BY Id_Producto DESC)
        , ARTIC_Peso                   = ISNULL(Peso, 0)
        , ARTIC_Detalle                = Nombre_Producto
        , ARTIC_Descripcion            = Nombre_Producto
        , ARTIC_Percepcion             = NULL 
        , ARTIC_Descontinuado          = 0
        , ARTIC_Localizacion           = 'Zona A'
        , ARTIC_Orden                  = 0
        , ARTIC_ExistenciaMin          = Existencia_Minima
        , ARTIC_ExistenciaMax          = Existencia_Maxima
        , ARTIC_PuntoReorden           = Punto_Reorden
        , ARTIC_Estado                 = 'I'
        , ARTIC_CodigoAnterior         = Id_Producto
        , ARTIC_UsrCrea                = 'SISTEMAS'
        , ARTIC_FecCrea                = GETDATE()
        , ARTIC_Numero                 = ROW_NUMBER() OVER(ORDER BY Id_Producto DESC)
        , RCVDT_Id                     = 1
        , ARTIC_NuevoIngreso           = 0
        , ARTIC_UsrNuevoIngreso        = NULL
        , ARTIC_FecNuevoIngreso        = NULL
     INTO #Productos
     FROM BDZegarra..Producto

   INSERT INTO dbo.Articulos
        ( ARTIC_Codigo                 , LINEA_Codigo                 , TIPOS_CodTipoProducto        , TIPOS_CodCategoria           
        , TIPOS_CodUnidadMedida        , TIPOS_CodTipoColor           , ARTIC_Id                     , ARTIC_Peso                   
        , ARTIC_Detalle                , ARTIC_Descripcion            , ARTIC_Percepcion             , ARTIC_Descontinuado          
        , ARTIC_Localizacion           , ARTIC_Orden                  , ARTIC_ExistenciaMin          , ARTIC_ExistenciaMax          
        , ARTIC_PuntoReorden           , ARTIC_Estado                 , ARTIC_CodigoAnterior         , ARTIC_UsrCrea                
        , ARTIC_FecCrea                , ARTIC_Numero                 
        , RCVDT_Id                     , ARTIC_NuevoIngreso           , ARTIC_UsrNuevoIngreso        , ARTIC_FecNuevoIngreso        )
   SELECT * FROM #Productos


     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '54.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = PZEG.Precio_Venta
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Productos PROD
     INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo

       --INSERT INTO Ventas.VENT_ListaPreciosArticulos
       --    (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
       --     , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       --SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
       --     , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
       --     , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
       --  FROM #Productos PROD
       --  LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' 

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 0               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = 0
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 0
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 1               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = L1
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 1
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo
       
       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              ) 
        SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 2               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = L2
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 2
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
        SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 3               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = L3
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 3
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo
   
       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 4               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = L4
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 4
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo
   
       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]  = 5               , [ARTIC_Codigo]               
            , [ALPRE_Constante]             = 0
            , [ALPRE_PorcentaVenta]         = L5
            , [ALPRE_UsrCrea]               = 'SISTEMAS' 
            , [ALPRE_FecCrea]               = GETDATE()
         FROM #Productos PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' AND LPRE.LPREC_Id = 5
        INNER JOIN BDZegarra..Producto PZEG ON (PZEG.Id_linea + PZEG.Id_Producto) = PROD.ARTIC_Codigo
   

   --SELECT * FROM BDZegarra..Producto
   --SELECT * FROM BDZegarra..tmp_Producto_Stock_Fecha

   --SELECT * FROM BDZegarra..Lista_Precios
   --SELECT * FROM BDZegarra..Precios
   --SELECT * FROM BDImportacion..Precios

   -- SELECT * FROM dbo.Articulos
   -- SELECT * FROM BDZegarra..Tipo_Unidad_Medida
   -- SELECT * FROM TIPOS WHERE TIPOS_Codigo LIKE 'UND%'

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--