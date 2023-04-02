
use BDCopy
go

SELECT * INTO #PROD FROM ProductosIZ_h1
union
SELECT * FROM ProductosIZ_h2
ORDER BY Nombre_Producto

SELECT * FROM #PROD
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
USE BDImportacionesZegarra
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
DELETE FROM dbo.Lineas
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

    SELECT DISTINCT ID_Linea, Nombre_Linea INTO #LIN FROM #PROD


   INSERT INTO dbo.Lineas
        ( LINEA_Codigo                 , LINEA_CodPadre               , TIPOS_CodTipoComision        , LINEA_Nombre                 
        , LINEA_UsrCrea                , LINEA_FecCrea                , LINEA_Activo                 )
   SELECT LINEA_Codigo = RIGHT('00' + RTRIM(ID_Linea), 2)
        , LINEA_CodPadre = NULL        
        , TIPOS_CodTipoComision = NULL , LINEA_Nombre  = Nombre_Linea
        , LINEA_UsrCrea = 'SISTEMAS'   , LINEA_FecCrea = GETDATE()    , LINEA_Activo = 1
     FROM #LIN
    WHERE NOT ID_Linea IN (SELECT LINEA_Codigo FROM dbo.Lineas)

   INSERT INTO dbo.Lineas
        ( LINEA_Codigo                 , LINEA_CodPadre               , TIPOS_CodTipoComision        , LINEA_Nombre                 
        , LINEA_UsrCrea                , LINEA_FecCrea                , LINEA_Activo                 )
   SELECT LINEA_Codigo      = RIGHT('00' + RTRIM(ID_Linea), 2) + RIGHT('00' + RTRIM(ID_Linea), 2)
        , LINEA_CodPadre    = RIGHT('00' + RTRIM(ID_Linea), 2)
        , TIPOS_CodTipoComision = NULL , LINEA_Nombre  = Nombre_Linea
        , LINEA_UsrCrea = 'SISTEMAS'   , LINEA_FecCrea = GETDATE()    , LINEA_Activo = 1
     FROM #LIN
    WHERE NOT RIGHT('00' + RTRIM(ID_Linea), 2) + RIGHT('00' + RTRIM(ID_Linea), 2) 
       IN (SELECT LINEA_Codigo FROM dbo.Lineas)

    SELECT * FROM Lineas
    SELECT * FROM #LIN

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
   --SELECT * FROM #PROD
   --SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'UND%'

   SELECT DISTINCT
          ARTIC_Codigo                 = RIGHT('00' + RTRIM(ID_Linea), 2) + RIGHT('00' + RTRIM(ID_Linea), 2) 
                                       + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY ID_Linea ORDER BY Nombre_Producto)), 3)
        , LINEA_Codigo                 = RIGHT('00' + RTRIM(ID_Linea), 2) + RIGHT('00' + RTRIM(ID_Linea), 2) 
        , TIPOS_CodTipoProducto        = 'PRO1'
        , TIPOS_CodCategoria           = 'CTP1'
        , TIPOS_CodUnidadMedida        = 'UND03'
        , TIPOS_CodTipoColor           = 'CLR000'
        , ARTIC_Id                     = ROW_NUMBER() OVER(ORDER BY Nombre_Producto DESC)
        , ARTIC_Peso                   = 1
        , ARTIC_Detalle                = Nombre_Producto
        , ARTIC_Descripcion            = Nombre_Producto
        , ARTIC_Percepcion             = NULL 
        , ARTIC_Descontinuado          = 0
        , ARTIC_Localizacion           = 'Zona A'
        , ARTIC_Orden                  = 0
        , ARTIC_ExistenciaMin          = 0
        , ARTIC_ExistenciaMax          = 100
        , ARTIC_PuntoReorden           = 1
        , ARTIC_Estado                 = 'I'
        , ARTIC_CodigoAnterior         = MAX(Id_Producto)
        , ARTIC_UsrCrea                = 'SISTEMAS'
        , ARTIC_FecCrea                = GETDATE()
        , ARTIC_Numero                 = ROW_NUMBER() OVER(ORDER BY Nombre_Producto DESC)
        , RCVDT_Id                     = 1
        , ARTIC_NuevoIngreso           = 0
        , ARTIC_UsrNuevoIngreso        = NULL
        , ARTIC_FecNuevoIngreso        = NULL
     INTO #Productos
     FROM #PROD
     GROUP BY ID_Linea, Nombre_Producto
     ORDER BY LINEA_Codigo, ARTIC_Codigo

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

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
     SELECT [ZONAS_Codigo] = '54.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Productos

    INSERT INTO Ventas.VENT_ListaPreciosArticulos
       (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
        , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
   SELECT [ZONAS_Codigo] = '54.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
        , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
        , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
     FROM #Productos PROD
     LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '54.00' 


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--



