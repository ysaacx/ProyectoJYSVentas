use BDInkasFerro
go

--select * from Lineas
--select * from Articulos
--SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'UND%'

begin tran x

INSERT INTO dbo.Lineas( LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
        )
SELECT LINEA_Codigo ,LINEA_CodPadre ,TIPOS_CodTipoComision ,LINEA_Nombre ,
          LINEA_UsrCrea ,LINEA_FecCrea
 FROM (
        SELECT LINEA_Codigo = '20'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CHEMA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2001' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'SELLADORES DE SUPERFICIES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2002' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LINEAS DE MADERA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2003' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'IMPERMEABILIZANTES INTEGRALES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2004' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ADITIVOS PARA CONCRETO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2005' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'IMPERMEABILIZANTES SUPERFICIALES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2006' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIMPIADORES Y REMOVEDORES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2007' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PRODUCTOS PARA LA CONSTRUCCION',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2008' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'FRAGUAS CHEMITA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2009' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'IMPRIMANTES Y JUNTAFLEX',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2010' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'CURADORES DE CONCRETO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2011' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PEGAMENTOS DE MAYOLICAS Y CERAMICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2012' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PEGAMENTOS EPOXICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2013' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'FRAGUAS ESPECIALES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2014' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'FRAGUAS SANSON',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2015' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'LIMPIADORESY SELLADORES',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2016' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'FRAGUAS SUPER PORCELANATOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2017' ,LINEA_CodPadre = '20',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ANTIOXIDOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  
  UNION SELECT LINEA_Codigo = '21'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'NICOLL',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2101' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA SIMPLE PRESION',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2102' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA CON ROSCA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2103' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ELECTRICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2104' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DESAGUE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2105' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ROTOMOLDEO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2106' ,LINEA_CodPadre = '21',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA CALIENTE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1

  UNION SELECT LINEA_Codigo = '22'   ,LINEA_CodPadre = NULL,TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'PAVCO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2201' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA SIMPLE PRESION',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2202' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA CON ROSCA',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2203' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ELECTRICOS',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2204' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'DESAGUE',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2205' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'ROTOMOLDEO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
  UNION SELECT LINEA_Codigo = '2206' ,LINEA_CodPadre = '22',TIPOS_CodTipoComision = NULL ,LINEA_Nombre = 'AGUA CALIENTE - HIDRO',LINEA_UsrCrea = 'SISTEMAS',LINEA_FecCrea = GETDATE(), LINEA_Activo = 1
 ) LIN
 WHERE NOT LIN.LINEA_Codigo IN (SELECT LINEA_Codigo FROM dbo.Lineas)

 rollback tran x



 select * from BDCopy..PRODUCTOS2018
 select * from Articulos ARTI
 select MAX(ARTIC_ID) from Articulos ARTI
  INNER JOIN BDCopy..PRODUCTOS2018 PROD ON RTRIM(LTRIM(PROD.DESCRIPCION)) = RTRIM(LTRIM(ARTI.ARTIC_Descripcion))

--SELECT * FROM BDCopy..PRODUCTOS2018_2 WHERE LINEA1 IS NULL

BEGIN TRAN X
    /*
	SELECT [ARTIC_Codigo] = rtrim(LINEA1) + RIGHT('000' + RTRIM(ROW_NUMBER() OVER(PARTITION BY LINEA1 ORDER BY LINEA1)), 3)
   --ROW_NUMBER() OVER(PARTITION BY LINEA ORDER BY LINEA ASC) 
        , [LINEA_Codigo] = LINEA1                               , [TIPOS_CodTipoProducto] = 'PRO1'                              , [TIPOS_CodCategoria]= 'CTP1'                              
        , [TIPOS_CodUnidadMedida] = UND                              , [TIPOS_CodTipoColor] = NULL                             , [ARTIC_Id] = 5165 + ROW_NUMBER() OVER(ORDER BY DESCRIPCION)                              , [ARTIC_Peso] = ISNULL(PESO, 0)
        , [ARTIC_Detalle] = DESCRIPCION                              , [ARTIC_Descripcion] = DESCRIPCION                              , [ARTIC_Percepcion]= NULL                               , [ARTIC_Descontinuado]  = 0
        , [ARTIC_Localizacion] = NULL                              , [ARTIC_Orden] = 1                              , [ARTIC_ExistenciaMin] = 0                              , [ARTIC_ExistenciaMax] = 100
        , [ARTIC_PuntoReorden] = 0                              , [ARTIC_Estado] = 1                              , [ARTIC_CodigoAnterior] = CODIGO                              , [ARTIC_UsrCrea] = 'SISTEMAS'
        , [ARTIC_FecCrea] = GETDATE()                              , [ARTIC_UsrMod] = NULL                              , [ARTIC_FecMod] = NULL                              , [ARTIC_Numero] = 5165 + ROW_NUMBER() OVER(ORDER BY DESCRIPCION)                              
        , [RCVDT_Id] = NULL                              , [ARTIC_NuevoIngreso] = NULL                              , [ARTIC_UsrNuevoIngreso] = NULL                              , [ARTIC_FecNuevoIngreso] = NULL
	 INTO #Producto
     FROM BDCopy..PRODUCTOS2018_2
     */

  INSERT INTO dbo.Articulos
        ( [ARTIC_Codigo]                               , [LINEA_Codigo]                               , [TIPOS_CodTipoProducto]                               , [TIPOS_CodCategoria]                               
        , [TIPOS_CodUnidadMedida]                               , [TIPOS_CodTipoColor]                               , [ARTIC_Id]                               , [ARTIC_Peso]                               
        , [ARTIC_Detalle]                               , [ARTIC_Descripcion]                               , [ARTIC_Percepcion]                               , [ARTIC_Descontinuado]                               
        , [ARTIC_Localizacion]                               , [ARTIC_Orden]                               , [ARTIC_ExistenciaMin]                               , [ARTIC_ExistenciaMax]                               
        , [ARTIC_PuntoReorden]                               , [ARTIC_Estado]                               , [ARTIC_CodigoAnterior]                               , [ARTIC_UsrCrea]                               
        , [ARTIC_FecCrea]                               , [ARTIC_UsrMod]                               , [ARTIC_FecMod]                               , [ARTIC_Numero]                               
        , [RCVDT_Id]                               , [ARTIC_NuevoIngreso]                               , [ARTIC_UsrNuevoIngreso]                               , [ARTIC_FecNuevoIngreso]    )
   SELECT * FROM #Producto

     INSERT INTO dbo.Precios
          ( [ZONAS_Codigo]               , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda]        , [PRECI_Precio]               
          , [PRECI_TipoCambio]           , [PRECI_UsrCrea]              , [PRECI_FecCrea]              )
     SELECT [ZONAS_Codigo] = '83.00'     , [ARTIC_Codigo]               , [TIPOS_CodTipoMoneda] = 'MND1'     , [PRECI_Precio] = 0
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