USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJAS_CuadreCaja_Resumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJAS_CuadreCaja_Resumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJAS_CuadreCaja_Resumen]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
AS
    /*========================================================================================================================*/
    Create Table #Facturas(Orden SmallInt
                ,Titulo VarChar(200)
                ,Title VarChar(200)
                ,Fecha DateTime
                ,ENTID_RazonSocial VarChar(500)
                ,Documento VarChar(50)
                ,Moneda VarChar(10)
                ,TCambioVenta Decimal(10, 4)
                ,ImpDolares Decimal(12, 2)
                ,ImpSoles Decimal(12, 2)
                ,ENTID_Codigo VarChar(50)
                ,DOCVE_Codigo VarChar(50)
                ,DOCVE_Serie VarChar(5)
                ,DOCVE_Numero Integer
                ,TipoDocumento VarChar(50)
                ,TIPOS_Descripcion VarChar(500)
                ,TIPOS_CodTipoDocumento VarChar(50)
                ,CAJA_Codigo VarChar(50)
                ,Detalle VarChar(500)
                ,DocDetalle VarChar(500)
                ,flagrd varchar(1000))
    /*========================================================================================================================*/
    CREATE Table #Egresos(Orden SmallInt
                , Titulo VarChar(500)
                , Title VarChar(500)
                , Fecha DateTime
                , ENTID_RazonSocial VarChar(500)
                , Documento VarChar(100)
                , Moneda VarChar(10)
                , TCambioVenta Decimal(10, 4)
                , ImpDolares Decimal(12, 2)
                , ImpSoles Decimal(12, 2)
                , ENTID_Codigo VarChar(100)
                , DOCVE_Codigo VarChar(100)
                , DOCVE_Serie VarChar(10)
                , DOCVE_Numero Integer
                , TipoDocumento VarChar(100)
                , TIPOS_Descripcion VarChar(500)
                , TIPOS_CodTipoDocumento VarChar(100)
                , CAJA_Codigo VarChar(80)
                , Detalle VarChar(1000)
                , DocDetalle VarChar(1000)
                , flagrd varchar(1000))
    /*========================================================================================================================*/
    /*========================================================================================================================*/
    /*========================================================================================================================*/

    PRINT '-------------------------------------------------------------------------------'
    PRINT 'VENT_CAJASS_SaldoInicial'
    EXEC VENT_CAJASS_SaldoInicial @FecIni, @PVENT_Id
    PRINT '-------------------------------------------------------------------------------'
    PRINT 'VENT_CAJASS_CuadreCaja_Facturas'

    INSERT INTO #Facturas(Orden
    ,Titulo
    ,Title
    ,Fecha
    ,ENTID_RazonSocial
    ,Documento
    ,Moneda
    ,TCambioVenta
    ,ImpDolares
    ,ImpSoles
    ,ENTID_Codigo
    ,DOCVE_Codigo
    ,DOCVE_Serie
    ,DOCVE_Numero
    ,TipoDocumento
    ,TIPOS_Descripcion
    ,TIPOS_CodTipoDocumento
    )
    Exec VENT_CAJASS_CuadreCaja_Facturas @FecIni, @FecFin, @PVENT_Id
    PRINT '-------------------------------------------------------------------------------'
    PRINT 'VENT_CAJASS_CuadreCaja_Ingresos'

    INSERT INTO #Facturas(Orden
    ,Titulo
    ,Title
    ,Fecha
    ,ENTID_RazonSocial
    ,Documento
    ,Moneda
    ,TCambioVenta
    ,ImpDolares
    ,ImpSoles
    ,ENTID_Codigo
    ,DOCVE_Codigo
    ,DOCVE_Serie
    ,DOCVE_Numero
    ,TipoDocumento
    ,TIPOS_Descripcion
    ,TIPOS_CodTipoDocumento
    )
    Exec VENT_CAJASS_CuadreCaja_Ingresos @FecIni, @FecFin, @PVENT_Id
    PRINT '-------------------------------------------------------------------------------'

    Select Orden, Titulo, SUM(ImpSoles) As ImpSoles From #Facturas 
    Group By Orden, Titulo

INSERT INTO #Egresos(Orden              , Titulo                    , Title          , Fecha             , ENTID_RazonSocial
                   , Documento          , Moneda                    , TCambioVenta   , ImpDolares        , ImpSoles
                   , ENTID_Codigo       , DOCVE_Codigo              , DOCVE_Serie    , DOCVE_Numero      , TipoDocumento
                   , TIPOS_Descripcion  , TIPOS_CodTipoDocumento    , CAJA_Codigo    , Detalle           , DocDetalle 
                   , flagrd )
  EXEC VENT_CAJASS_CuadreCaja_Egresos @FecIni, @FecFin, @PVENT_Id


    SELECT Orden                , Titulo            , Title         , Fecha
         , ENTID_RazonSocial    = ENTID_RazonSocial + ISNULL(' < Documento: ' + Documento + '>', '')
         , Documento            = LEFT(Documento, 15)
         , Moneda        
         , TCambioVenta      
         , ENTID_Codigo
	     , SUM(ImpSoles) As ImpSoles
         , Sum(ImpDolares) As ImpDolares
     FROM #Egresos
    GROUP By Orden, Titulo, Title, ENTID_RazonSocial, Documento
	    , Moneda, TCambioVenta, ENTID_Codigo, Fecha
    ORDER By Orden, Fecha


GO 
/***************************************************************************************************************************************/ 

exec VENT_CAJAS_CuadreCaja_Resumen @FecIni='2018-01-20 00:00:00',@FecFin='2018-01-20 00:00:00',@PVENT_Id=2
