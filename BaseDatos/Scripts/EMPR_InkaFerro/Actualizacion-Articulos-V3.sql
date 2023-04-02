--SELECT * FROM BDCopy..Productos2018V3

  DECLARE @ARTIC_ID INT
    SET @ARTIC_ID = (SELECT MAX(ARTIC_ID) FROM dbo.Articulos )
    DROP TABLE #Producto
   SELECT [ARTIC_Codigo]               = RTRIM(IFERR.LINEA_CODIGO) + RIGHT('000' + RTRIM(IFERR.CODIGO), 3)
        , [LINEA_Codigo]               = RTRIM(IFERR.LINEA_CODIGO)
        , [TIPOS_CodTipoProducto]      = 'PRO1'
        , [TIPOS_CodCategoria]         = 'CTP2'
        , [TIPOS_CodUnidadMedida]      = 'UND07'
        , [TIPOS_CodTipoColor]         = 'CLR000'
        , [ARTIC_Id]                   = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY IFERR.F3)
        , [ARTIC_Peso]                 = 1
        , [ARTIC_Detalle]              = IFERR.F3
        , [ARTIC_Descripcion]          = IFERR.F3
        , [ARTIC_Percepcion]           = 0
        , [ARTIC_Descontinuado]        = 0
        , [ARTIC_Localizacion]         = 'Zona A'
        , [ARTIC_Orden]                = 50
        , [ARTIC_ExistenciaMin]        = 0
        , [ARTIC_ExistenciaMax]        = 500
        , [ARTIC_PuntoReorden]         = 350
        , [ARTIC_Estado]               = 'I'
        , [ARTIC_CodigoAnterior]       = NULL --RTRIM(CODPROD)
        , [ARTIC_UsrCrea]              = 'SISTEMAS'
        , [ARTIC_FecCrea]              = GETDATE()
        , [ARTIC_UsrMod]               = NULL 
        , [ARTIC_FecMod]               = NULL
        , [ARTIC_Numero]               = @ARTIC_ID + ROW_NUMBER() OVER(ORDER BY IFERR.F3)
        , [RCVDT_Id]                   = 1
        , [ARTIC_NuevoIngreso]         = 0
        , [ARTIC_UsrNuevoIngreso]      = NULL 
        , [ARTIC_FecNuevoIngreso]      = NULL 
     INTO #Producto
     FROM BDCopy..Productos2018V3 IFERR
     --LEFT JOIN #Articulo_Max ART ON ART.LINEA_CODIGO = IFERR.LINEA_Codigo
    WHERE IFERR.LINEA_Codigo IS NOT NULL 
    ORDER BY LINEA_Codigo, IFERR.CODIGO

BEGIN TRAN X

      INSERT INTO dbo.Articulos
       (  [ARTIC_Codigo]               , [LINEA_Codigo]               , [TIPOS_CodTipoProducto]      , [TIPOS_CodCategoria]         
        , [TIPOS_CodUnidadMedida]      , [TIPOS_CodTipoColor]         , [ARTIC_Id]                   , [ARTIC_Peso]                 
        , [ARTIC_Detalle]              , [ARTIC_Descripcion]          , [ARTIC_Percepcion]           , [ARTIC_Descontinuado]        
        , [ARTIC_Localizacion]         , [ARTIC_Orden]                , [ARTIC_ExistenciaMin]        , [ARTIC_ExistenciaMax]        
        , [ARTIC_PuntoReorden]         , [ARTIC_Estado]               , [ARTIC_CodigoAnterior]       , [ARTIC_UsrCrea]              
        , [ARTIC_FecCrea]              , [ARTIC_UsrMod]               , [ARTIC_FecMod]               , [ARTIC_Numero]               
        , [RCVDT_Id]                   , [ARTIC_NuevoIngreso]         , [ARTIC_UsrNuevoIngreso]      , [ARTIC_FecNuevoIngreso])
   SELECT * FROM #Producto


     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]             , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'    , [PRECI_Precio] = 0
          , [PRECI_TipoCambio] = 3.2     , [PRECI_UsrCrea] = 'SISTEMAS' , [PRECI_FecCrea] = GETDATE()
      FROM #Producto

       INSERT INTO Ventas.VENT_ListaPreciosArticulos
           (  [ZONAS_Codigo]               , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante]            
            , [ALPRE_PorcentaVenta]        , [ALPRE_UsrCrea]              , [ALPRE_FecCrea]              )
       SELECT [ZONAS_Codigo] = '83.00'     , [LPREC_Id]                   , [ARTIC_Codigo]               , [ALPRE_Constante] = LPRE.LPREC_Comision * 1000
            , [ALPRE_PorcentaVenta] = LPRE.LPREC_Comision * 1000
            , [ALPRE_UsrCrea] = 'SISTEMAS' , [ALPRE_FecCrea] = GETDATE()
         FROM #Producto PROD
         LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.ZONAS_Codigo = '83.00' 

ROLLBACK TRAN X
COMMIT TRAN X

SELECT * FROM dbo.Lineas WHERE LEN(LINEA_Codigo)= 2 
SELECT * FROM dbo.Lineas WHERE left(LINEA_Codigo, 2) IN ('15', '05', '09')

UPDATE Lineas SET LINEA_Activo = 0 WHERE left(LINEA_Codigo, 2) IN ('15', '05', '09', '16')

UPDATE dbo.Articulos SET ARTIC_Descripcion = RTRIM(LTRIM(ARTIC_Descripcion)), ARTIC_Detalle = LTRIM(RTRIM(ARTIC_Detalle))

UPDATE dbo.Lineas SET LINEA_Nombre = UPPER(LINEA_Nombre) WHERE LEN(LINEA_Codigo)= 2 

--SELECT * FROM BDCopy..Productos2018V3

