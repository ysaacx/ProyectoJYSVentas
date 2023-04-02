GO 
/*****************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CAJAS_CuadreCaja_Resumen.sql **************************************************************************/
/*****************************************************************************************************************************************************************************************/
GO 
--USE BDInkasFerro
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

--exec VENT_CAJAS_CuadreCaja_Resumen @FecIni='2018-01-20 00:00:00',@FecFin='2018-01-20 00:00:00',@PVENT_Id=2
GO 
/****************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_EfectivoResumen.sql **************************************************************************/
/****************************************************************************************************************************************************************************************/
GO 
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_EfectivoResumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_EfectivoResumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_EfectivoResumen]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
As

Declare @Orden SmallInt Set @Orden = 4

 SELECT Orden                  = @Orden
      , Titulo                 = 'Movimiento de Efectivo'
      , Title                  = '04.- Movimiento de Efectivo'
      , Fecha                  = Caj.CAJA_Fecha
      , ENTID_RazonSocial      = 'Cancelación de Documento de Venta : '
                               + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
                               + ' / ' + Ven.ENTID_CodigoCliente
                               + ' - ' 
                               + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) 
      , Documento              = CONVERT(VARCHAR(50), ISNULL(TPag.TIPOS_DescCorta + ' ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Doc.DPAGO_Id), 7), ''))
      , Moneda                 = Mon.TIPOS_DescCorta
      , TCambioVenta           = TC.TIPOC_VentaSunat
      , ImpDolares             = CASE Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
      , ImpSoles               = CASE Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
      , ENTID_Codigo           = Caj.ENTID_Codigo   
      , DOCVE_Codigo           = Caj.CAJA_Codigo
      , DOCVE_Serie            = Right('000' + RTRIM(@PVENT_Id), 3)
      , DOCVE_Numero           = Doc.DPAGO_Id
      , TipoDocumento          = ''
      , TIPOS_Descripcion      = '' 
      , TIPOS_CodTipoDocumento = Doc.TIPOS_CodTipoDocumento
      , CAJA_Codigo            = ''
      , Detalle                = 'Cancelación de Documento de Venta : '
                               + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
                               + ' / Fecha Fac.: ' + Convert(VarChar(10), Ven.DOCVE_FechaDocumento, 103)     
                               + ' / ' + TMonVen.TIPOS_DescCorta + ' ' + Convert(VarChar(20), CONVERT(money, Ven.DOCVE_TotalPagar), 1)
                               + ' / R.U.C. o D.N.I.: ' + Ven.ENTID_CodigoCliente
                               + ' / Raz. Soc.: ' 
                               + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) 
      , DocDetalle             = ''
   INTO #Efectivo
   FROM Tesoreria.TESO_DocsPagos As Doc
  INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
  INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo
  INNER JOIN Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
  INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
  INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
  INNER JOIN Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
  INNER JOIN Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
  INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
  LEFT JOIN TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
Where Doc.TIPOS_CodTipoDocumento = 'DPG01'
    And Convert(Date, DPAGO_Fecha) Between @FecIni And @FecFin
Union All
SELECT @Orden As Orden
     , 'Movimiento de Efectivo' As Titulo
     , '04.- Movimiento de Efectivo' As Title
     , Rec.RECIB_Fecha
     , 'Egreso en Efectivo Para Cancelación de Documento / Resp.: ' 
       + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
     , TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
     , Mon.TIPOS_DescCorta 
     , TC.TIPOC_VentaSunat As TCambioVenta
     , Case Rec.TIPOS_CodTipoRecibo 
        When 'CPDRE' Then (-Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
        When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
       End
       As ImpDolares
     , Case Rec.TIPOS_CodTipoRecibo 
        When 'CPDRE' Then (-Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
        When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
       End ImpSoles
     , IsNull(Rec.ENTID_Codigo, '-')     
     , RECIB_Codigo
     , Right('000' + RTRIM(@PVENT_Id), 3) As DOCVE_Serie
     , Rec.RECIB_Numero As DOCVE_Numero
     , '' As TipoDocumento
     , '' As TIPOS_Descripcion
     , Rec.TIPOS_CodTipoRecibo As TIPOS_CodTipoDocumento
     , '' As CAJA_Codigo
     , 'Egreso en Efectivo Para Cancelación de Documento / Responsable: ' 
       + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
       + ' / Glosa: ' + Rec.RECIB_Concepto
       + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
                + ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
        , '')
       As Detalle
     , '' As DocDetalle
From Tesoreria.TESO_Recibos As Rec
    Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
    Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo
    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha)  Between @FecIni And @FecFin
    --And TIPOS_CodTipoRecibo In 'CPDRE'
    And Rec.RECIB_Estado <> 'X'
--Order by Fecha
--Union All
--SELECT Orden                = @Orden
--     , Titulo               = 'Movimiento de Efectivo'
--   , Title                = '04.- Movimiento de Efectivo'
--     , Fecha                = CONVERT(DATE, SENCI_Fecha)
--     , ENTID_RazonSocial    = 'Sencillo de Caja - ' + PVen.PVENT_Descripcion
--     , Documento            = 'SE ' + Right('000' + RTrim(Se.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(SENCI_Id), 7)
--     , Moneda               = 'S/.'
--     , TCambioVenta         = 0.00
--     , ImpDolares           = 0.00 --CASE TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End
--     , ImpSoles             = CASE TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End 
--     , ENTID_Codigo         = LTRIM(RTrim(Se.ENTID_Codigo))
--     , DOCVE_Codigo         = NULL  
--     , DOCVE_Serie          = ''
--     , DOCVE_Numero         = SENCI_Id --'SE' + Right('000' + RTrim(Se.PVENT_Id), 3) + Right('0000000' + RTrim(SENCI_Id), 7)
--     , TipoDocumento          = 'SEN'
--   , TIPOS_Descripcion      = '' 
--     , TIPOS_CodTipoDocumento = ''
--     , CAJA_Codigo            = NULL 
--     , Detalle                = ''
--     , DocDetalle             = ''
--  FROM Tesoreria.TESO_Sencillo As Se
-- INNER Join Entidades As Ent On Ent.ENTID_Codigo = Se.ENTID_Codigo
-- INNER Join PuntoVenta As PVen On PVen.PVENT_Id = Se.PVENT_Id
--Where Convert(Date, SENCI_Fecha) = @FecFin
--  And Se.PVENT_Id = @PVENT_Id


--Select * 
--From Tesoreria.TESO_CajaChicaIngreso As CC
--Where Convert(Date, CC.CAJAC_Fecha) Between @FecIni And @FecFin


   SELECT Orden
        , Titulo
        , Title
        , Fecha = CONVERT(DATE, Fecha)
        , ENTID_RazonSocial = Titulo
        , Documento = NULL 
        , Moneda 
        , TCambioVenta = MAX(TCambioVenta)
        , ImpDolares = sum(ISNULL(ImpDolares, 0.00))
        , ImpSoles   = sum(ISNULL(ImpSoles, 0.00))
        , ENTID_Codigo = NULL 
        , DOCVE_Codigo  = NULL 
        , DOCVE_Serie = null
        , DOCVE_Numero = NULL
        , TipoDocumento 
        , TIPOS_Descripcion 
        , TIPOS_CodTipoDocumento 
        , CAJA_Codigo = NULL
        , Detalle = NULL  
        , DocDetalle = NULL 
     FROM #Efectivo
    GROUP BY Orden
        , Titulo
        , Title
        , Moneda 
        , CONVERT(DATE, Fecha)
        , TipoDocumento 
        , TIPOS_Descripcion 
        , TIPOS_CodTipoDocumento 
        
      --SELECT * FROM #Efectivo
GO 
/***************************************************************************************************************************************/ 
--5,575,414.72
--exec VENT_CCAJASS_Efectivo @FecIni='2018-07-06 00:00:00',@FecFin='2018-07-06 00:00:00',@PVENT_Id=1

--exec VENT_CCAJASS_EfectivoResumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_EfectivoResumen @FecIni='2020-10-30',@FecFin='2020-10-30',@PVENT_Id=1
--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2020-10-30 00:00:00',@FecFin='2020-10-30 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SaldoInicialEfectivo @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1


--exec VENT_REPOSS_MovimientoEfectivo @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
GO 
/***************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_EgresosDetalle.sql **************************************************************************/
/***************************************************************************************************************************************************************************************/
GO 
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_EgresosDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_EgresosDetalle] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_EgresosDetalle]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
As

--Print @FecIni
--Print @FecFin
Declare @Orden SmallInt Set @Orden = 5

/* Recibos de Egreso */
/* Egresos en Efectivo */
--Select @Orden As Orden
--    ,'Egresos por Deposito' As Titulo
--    ,'05.- Egresos por Deposito' As Title
--    ,RECIB_Fecha As Fecha
--    ,'Resp : '
--     + IsNull((Case Rec.ENTID_Codigo When Null Then Pro.ENTID_RazonSocial Else Res.ENTID_RazonSocial End), Rec.RECIB_RecibiDe)
--     + ' / Concepto : ' + Rec.RECIB_Concepto 
--     + IsNull(' / Recibo : ' + Rec.RECIB_NroDocumento, '')
--     + ISNULL((Case When Rec.DOCUS_Codigo Is Null Then '' 
--                Else (' / Prov : ' + EntDoc.ENTID_Codigo + ' - ' + EntDoc.ENTID_RazonSocial
--                    + ' / Doc : ' + TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
--                      )
--               End),'-')
--     As ENTID_RazonSocial
--    ,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
--    ,Mon.TIPOS_DescCorta 
--     As Moneda
--    ,TC.TIPOC_VentaSunat As TCambioVenta
--    ,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
--    ,Case Rec.TIPOS_CodTipoMoneda
--        When 'MND1' Then  Rec.RECIB_Importe / (Case IsNull(TC.TIPOC_VentaSunat, 1) When 0 Then 1 Else TC.TIPOC_VentaSunat End)
--         Else  Rec.RECIB_Importe
--        End
--     As Dolares 
--    ,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
--    ,Case Rec.TIPOS_CodTipoMoneda
--        When 'MND2' Then  Rec.RECIB_Importe * TC.TIPOC_VentaSunat                                                 
--         Else  Rec.RECIB_Importe
--        End
--     As Soles
--    ,Rec.ENTID_Codigo As ENTID_Codigo
--    ,Rec.RECIB_Codigo As DOCVE_Codigo
--    ,Rec.RECIB_Serie As DOCVE_Serie
--    ,Rec.RECIB_Numero As DOCVE_Numero
--    ,'' As TipoDocumento
--    ,'' As TIPOS_Descripcion
--    ,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
--    ,'' As CAJA_Codigo
--    ,'' As Detalle
--    ,'' As DocDetalle
--Into #Recibos
--From Tesoreria.TESO_Recibos As Rec
--    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
--    Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
--    Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
--    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
--    Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo 
--        And Doc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
--    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
--    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo --And Rec.ENTID_Codigo = EntDoc.ENTID_Codigo
--Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
--    And Rec.TIPOS_CodTipoRecibo = 'CPDRE'
--    And Rec.PVENT_Id = @PVENT_Id
--    And Rec.RECIB_Estado <> 'X'
--Union All /* Depositos */
Select @Orden As Orden
    ,'Egresos por Depositos' As Titulo
    ,'05.- Egresos por Depositos' As Title
    ,CAJA_Fecha As Fecha
    ,IsNull('Dep. / ' + IsNull(TDoc.TIPOS_DescCorta, '')
        + ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') 
        + ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
        + ' / Fecha: ' + ISNULL(CONVERT(Varchar, DPag.DPAGO_FechaVenc, 103), '') 
        + ' / ' + IsNull(Ent.ENTID_RazonSocial, '')
      , Caj.CAJA_Glosa)
     As ENTID_RazonSocial
    --,IsNull((TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) + ' (' + RTRIM(IsNull(DPag.DPAGO_Id, CAJA_Id)) + ')') 
    --  , 'RC ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7))
    ,IsNull('DB ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(DPag.DPAGO_Id), 7)
     ,TCaj.TIPOS_Desc2 + ' ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Caj.CAJA_Id), 7))
      As Documento
    ,Mon.TIPOS_DescCorta As Moneda
    ,(Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End) As TCambioVenta
    ,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
    --,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
    --  Then Convert(Decimal(12, 4), Caj.CAJA_Importe)
    --  Else Convert(Decimal(14, 2), Caj.CAJA_Importe / (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)) End 
    ,0.00 Dolares
    ,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
    ,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
        Then 
            (Convert(Decimal(12, 4), Caj.CAJA_Importe))
            * (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
        Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
            )) End 
     Soles
    ,Caj.ENTID_Codigo As ENTID_Codigo
    ,Caj.DOCVE_Codigo As DOCVE_Codigo
    ,Ven.DOCVE_Serie
    ,Ven.DOCVE_Numero
    ,'Caj' As TipoDocumento
    ,'' As TIPOS_Descripcion
    ,Caj.TIPOS_CodTipoDocumento
    ,Caj.CAJA_Codigo + ' - ' + RTRIM(DPag.DPAGO_Numero)
    ,'T.Proc.: '+ TEfe.TIPOS_DescCorta 
     + ' / ' +  Caj.CAJA_Glosa
     + IsNull(' / ' + (TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)), '')
     As Detalle
     ,IsNull((TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)) 
      , 'RC ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7))
     As DocDetalle
From Tesoreria.TESO_Caja As Caj
    Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
    Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
    Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
    Left Join Entidades As Ent on Ent.ENTID_Codigo = Caj.ENTID_Codigo
    Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo
    Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
    Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
    And Caj.TIPOS_CodTransaccion <> 'TPG01'
    And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
    And Caj.CAJA_Estado <> 'X'
    And Caj.PVENT_Id = @PVENT_Id
Union All /* Recibos de Facturas Anuladas */
Select @Orden As Orden
    ,'Egresos por Depositos' As Titulo
    ,'05.- Egresos por Depositos' As Title
    ,Ven.DOCVE_FechaDocumento As Fecha
    ,Ent.ENTID_RazonSocial + ' - Recibo de Egreso por Anulación de Factura /  Anulada el ' + CONVERT(VarChar(12), Ven.DOCVE_FecAnulacion, 103)  As ENTID_RazonSocial
    ,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
    ,Mon.TIPOS_DescCorta As Moneda
    ,TC.TIPOC_VentaSunat As TCambioVenta
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
    ,Case Ven.TIPOS_CodTipoMoneda 
        When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar)
        Else Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar) * TC.TIPOC_VentaSunat
     End As Dolares
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat) Else Convert(Decimal(14, 4), Ven.DOCVE_TotalPagar) End ImpSoles
    ,Case Ven.TIPOS_CodTipoMoneda 
        When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat) 
        Else Convert(Decimal(14, 4), Ven.DOCVE_TotalPagar) 
     End As Soles
    ,'' As ENTID_Codigo
    ,'' As DOCVE_Codigo
    ,Ven.DOCVE_Serie
    ,Ven.DOCVE_Numero
    ,TDoc.TIPOS_DescCorta As TipoDocumento
    ,TDoc.TIPOS_Descripcion
    ,Ven.TIPOS_CodTipoDocumento
    ,'' As CAJA_Codigo
    ,'' As Detalle
    ,'' As DocDetalle
From Ventas.VENT_DocsVenta As Ven
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
    Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
    And Ven.PVENT_Id = @PVENT_Id
Where Ven.DOCVE_AnuladoCaja = 1
    And Convert(Date, Ven.DOCVE_FecAnulacion) Between @FecIni And @FecFin
--Union All
--Select * From #Recibos
--Order By Orden, DOCVE_Codigo, Fecha
    
GO 
/***************************************************************************************************************************************/ 


--exec VENT_CCAJASS_EgresosDetalle @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-09 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_EgresosDetalle @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
GO 
/****************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_Egresos_Resumen.sql **************************************************************************/
/****************************************************************************************************************************************************************************************/
GO 
 --VENT_CCAJASS_Egresos--
--USE BDDACEROSLAM
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Egresos_Resumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_Egresos_Resumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Egresos_Resumen]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
As

 SELECT DocCaja = TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
    ,TIPOS_TipoMoneda = Mon.TIPOS_DescCorta 
    ,Rec.TIPOS_CodTipoMoneda
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
    ,Case Rec.TIPOS_CodTipoRecibo 
          WHEN 'CPDRE' Then 'Egreso en Efectivo' Else 'Ingreso en Efectivo' End 
          + '  / Responsable: ' 
          + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
          + ' / Glosa: ' + Rec.RECIB_Concepto
          + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
                        + ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
                , '')
         As Detalle
    ,Rec.RECIB_Fecha
    ,'<Sin Documento>' As DocVenta
    ,'' As ENTID_CodigoCliente 
    ,'' As ENTID_RazonSocial
INTO #MovEfectivo
From Tesoreria.TESO_Recibos As Rec
    Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
    Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo AND RDoc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha)  Between @FecIni And @FecFin
    --And TIPOS_CodTipoRecibo In 'CPDRE'
    And Rec.RECIB_Estado <> 'X' 
    AND Rec.RECIB_AnuladoCaja <> 1
    --AND TIPOS_CodTipoOrigen NOT IN ('ORI08', 'ORI09', 'ORI10')


   SELECT Orden               = 3
        , Titulo              = 'Recibo de Egresos'
        , Title               = '03.- Recibo de Egresos'
        , Fecha               = CONVERT(DATE, RECIB_Fecha)
        , ENTID_RazonSocial   = Detalle
                                 --(SELECT TOP 1 'Movimiento de Egresos Desde: ' 
                                 --     + CONVERT(VARCHAR(10), MIN(RECIB_Fecha), 103)
                                 --     + ' Hasta: ' + CONVERT(VARCHAR(10), MAX(RECIB_Fecha), 103)
                                 --  FROM #MovEfectivo)
        , Documento           = DocCaja
        , Moneda              = TIPOS_TipoMoneda
        , TCambioVenta        = NULL 
        , ImpDolares          = EImpDolares
        , ImpSoles            = EImpSoles
        , ENTID_Codigo        = '< SIN ENTIDAD >'
        , DOCVE_Codigo        = NULL
        , DOCVE_Serie         = NULL
        , DOCVE_Numero        = NULL
        , TipoDocumento       = NULL
        , TIPOS_Descripcion   = NULL
        , TIPOS_CodTipoDocumento    = NULL
        , CAJA_Codigo         = NULL
        , Detalle             --= NULL
        , DocDetalle          = DocCaja
        --, ImpDolares = (ImpDolares)
        --, ImpSoles = (ImpSoles)
        --, EImpDolares = (EImpDolares)
        --, EImpSoles = (EImpSoles)
     FROM #MovEfectivo
     where EImpSoles > 0
    --GROUP BY TIPOS_TipoMoneda 
    --    , TIPOS_CodTipoMoneda 
    --    , CONVERT(DATE, RECIB_Fecha)


GO

--EXEC dbo.VENT_CCAJASS_Egresos_Resumen @FecIni = '2018-12-31', @FecFin = '2018-12-31', @PVENT_Id = 0 -- bigint
--EXEC dbo.VENT_CCAJASS_Egresos_Resumen @FecIni = '2019-01-03', @FecFin = '2019-01-03', @PVENT_Id = 0 -- bigint
--exec VENT_CCAJASS_Egresos_Resumen @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-09 00:00:00',@PVENT_Id=1

--exec VENT_CCAJASS_Egresos_Resumen @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-09 00:00:00',@PVENT_Id=1

GO 
/****************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_FacturasResumen.sql **************************************************************************/
/****************************************************************************************************************************************************************************************/
GO 
--USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_FacturasResumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_FacturasResumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_FacturasResumen]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id Id
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor From Parametros Where PARMT_Id = 'Empresa')
Declare @Excepcion1 VarChar(14) Set @Excepcion1 = ''
Declare @Excepcion2 VarChar(14) Set @Excepcion2 = ''
Declare @Excepcion3 VarChar(14) Set @Excepcion3 = ''

/* Facturas Disponibles */
 SELECT 1 As Orden
       , Convert(VarChar(250), '') As Titulo
       , Convert(VarChar(50), '01.- Documentos ') As Title
       , Ven.DOCVE_FechaDocumento As Fecha
       , CASE WHEN LEN(ISNULL(Ent.ENTID_NroDocumento,'')) > 8 AND ven.TIPOS_CodTipoDocumento = 'CPD03' THEN '' ELSE ISNULL('[' + Ent.ENTID_NroDocumento + '] - ', '') END 
         + ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
       , IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
       , Mon.TIPOS_DescCorta As Moneda
       , IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As TCambioVenta
       , Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
       , Case Ven.TIPOS_CodTipoMoneda
            When 'MND1' Then  Ven.DOCVE_TotalPagar / (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                            Else Ven.DOCVE_TipoCambio
                                                      End)
             Else  Ven.DOCVE_TotalPagar
             End
         As Dolares
       , Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
       , Case Ven.TIPOS_CodTipoMoneda
            When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                            Else Ven.DOCVE_TipoCambio
                                                      End)
             Else  Ven.DOCVE_TotalPagar
             End
         As Soles
       , 'Documentos de Venta' As ENTID_Codigo
       , Ven.DOCVE_Codigo
       , Ven.DOCVE_Serie
       , Ven.DOCVE_Numero
       , TDoc.TIPOS_DescCorta As TipoDocumento
       , TDoc.TIPOS_Descripcion
       , Ven.TIPOS_CodTipoDocumento
      , DocVenta = Ent.ENTID_NroDocumento
   INTO #Facturas
   FROM Ventas.VENT_DocsVenta As Ven 
  INNER Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
  INNER Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
  WHERE Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
     AND Ven.DOCVE_Estado <> 'X'
     AND Ven.PVENT_Id = @PVENT_Id
     AND Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
  UNION All /* Factura Anulada en otro Tiempo */
 SELECT 1 As Orden
    ,Convert(VarChar(250), '') As Titulo
    ,Convert(VarChar(50), '01.- Documentos ') As Title
    ,Ven.DOCVE_FechaDocumento As Fecha
    ,CASE WHEN LEN(ISNULL(Ent.ENTID_NroDocumento,'')) > 8 AND ven.TIPOS_CodTipoDocumento = 'CPD03' THEN '' ELSE ISNULL('[' + Ent.ENTID_NroDocumento + '] - ', '') END 
    + Ent.ENTID_RazonSocial
    ,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
        , '')  As Documento
    ,Mon.TIPOS_DescCorta As Moneda
    ,TC.TIPOC_VentaSunat As TCambioVenta
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
    ,Case Ven.TIPOS_CodTipoMoneda
        When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
         Else  Ven.DOCVE_TotalPagar
         End
     As Soles
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
    ,Case Ven.TIPOS_CodTipoMoneda
        When 'MND1' Then  Ven.DOCVE_TotalPagar / TC.TIPOC_VentaSunat
         Else  Ven.DOCVE_TotalPagar
         End
     As Dolares
    ,Ven.ENTID_CodigoCliente As ENTID_Codigo
    ,Ven.DOCVE_Codigo
    ,Ven.DOCVE_Serie
    ,Ven.DOCVE_Numero
    ,TDoc.TIPOS_DescCorta As TipoDocumento
    ,TDoc.TIPOS_Descripcion
    ,Ven.TIPOS_CodTipoDocumento
   , DocVenta = '--'
From Ventas.VENT_DocsVenta As Ven 
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
    And Ven.DOCVE_Estado = 'X'
    And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni And Ven.DOCVE_AnuladoCaja = 1
    And Ven.PVENT_Id = @PVENT_Id
    And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* Facturas Anuladas */
Select 1 As Orden
    ,Convert(VarChar(250), '') As Titulo
    ,Convert(VarChar(50), '01.- Documentos ') As Title
    ,Ven.DOCVE_FechaDocumento As Fecha
    ,'ANULADO' As ENTID_RazonSocial
    ,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
        , '')  As Documento
    ,'' As Moneda
    ,0.00 As TCambioVenta
    ,0.00 As ImpDolares
    ,0.00 As Dolares
    ,0.00 As ImpSoles   
    ,0.00 As Soles  
    ,'' As ENTID_Codigo
    ,Ven.DOCVE_Codigo
    ,Ven.DOCVE_Serie
    ,Ven.DOCVE_Numero
    ,TDoc.TIPOS_DescCorta As TipoDocumento
    ,TDoc.TIPOS_Descripcion
    ,Ven.TIPOS_CodTipoDocumento
   , DocVenta = '--'
From Ventas.VENT_DocsVenta As Ven
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
    And DOCVE_Estado = 'X'
    And Not Ven.DOCVE_AnuladoCaja = 1
    And Ven.PVENT_Id = @PVENT_Id
/* Actualizar la Numeración de Fletes */
Update #Facturas
Set Titulo = (Select #Facturas.TIPOS_Descripcion + ' - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
                   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
                        And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
                  )
Update #Facturas Set Title = '01.- ' + Titulo 


--SELECT * FROM #Facturas

 SELECT Titulo, Title, Fecha = CONVERT(DATE, Fecha), Moneda
      , TCambioVenta = MAX(TCambioVenta)
      , Dolares = SUM(Dolares)
      , ImpSoles = SUM(ImpSoles)
      , Soles = SUM(Soles)
      , TipoDocumento, TIPOS_Descripcion, TIPOS_CodTipoDocumento
      , ENTID_RazonSocial = Titulo
      , Detalle = ENTID_RazonSocial
      , DocDetalle = Documento
      , ENTID_Codigo
      , DocVenta --= 'Documento de Venta'
  FROM #Facturas 
  WHERE ImpSoles > 0
  GROUP BY  Titulo, Title, CONVERT(DATE, Fecha), Moneda
      , TipoDocumento, TIPOS_Descripcion, TIPOS_CodTipoDocumento
      , ENTID_RazonSocial, Documento
      , ENTID_Codigo
      , DocVenta
 ORDER BY DocDetalle
-- Order By DOCVE_Codigo

--SELECT * FROM #Facturas



GO 
/***************************************************************************************************************************************/ 
GRANT EXECUTE
ON [dbo].[VENT_CCAJASS_Facturas]
TO [Ventas]
GO
/***************************************************************************************************************************************/ 

--Exec VENT_CCAJASS_Facturas '06-11-2013', '06-11-2013', 5
--exec VENT_CCAJASS_FacturasResumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_FacturasResumen @FecIni='2019-01-04 00:00:00',@FecFin='2019-01-04 00:00:00',@PVENT_Id=1

--select * from Ventas.VENT_DocsVenta where Convert(date, DOCVE_FechaDocumento) = '06-17-2013'
--select * from Ventas.VENT_DocsVenta where DOCVE_Codigo Like 'PE%'
--select * from Ventas.VENT_DocsVenta where DOCVE_Codigo Like '%571'
GO 
/*********************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_Ingresos.sql **************************************************************************/
/*********************************************************************************************************************************************************************************/
GO 
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Ingresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_Ingresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Ingresos]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
As

Print @FecIni
Print @FecFin
Declare @Orden SmallInt Set @Orden = 3

/* Otros Ingresos */
/* Ingresos por Cancelacion en Efectivo */
Select 2 As Orden
    ,'Recibos de Ingresos' As Titulo
    ,'02.- Recibos de Ingresos' As Title
    ,RECIB_Fecha As Fecha
    ,'Resp: '
     + IsNull((Case Rec.ENTID_Codigo When Null Then Pro.ENTID_RazonSocial Else Res.ENTID_RazonSocial End), IsNull(Rec.RECIB_RecibiDe, ''))
     + ' / Concepto: ' + IsNull(Rec.RECIB_Concepto, '')
     + ' / Recibo: ' + IsNull(Rec.RECIB_NroDocumento, '')
     + ISNULL((Case Rec.DOCUS_Codigo When Null Then '' 
                Else (' / Prov:' + EntDoc.ENTID_Codigo + ' ' + EntDoc.ENTID_RazonSocial
                    + ' / Doc:' + TDoc.TIPOS_DescCorta + ' - ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
                      )
               End),'')
     As ENTID_RazonSocial
    ,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
    ,Mon.TIPOS_DescCorta As Moneda
    ,TC.TIPOC_VentaSunat As TCambioVenta
    ,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
    ,Case Rec.TIPOS_CodTipoMoneda
        When 'MND1' Then  Rec.RECIB_Importe / TC.TIPOC_VentaSunat                                                 
         Else  Rec.RECIB_Importe
        End
     As Dolares 
    ,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
    ,Case Rec.TIPOS_CodTipoMoneda
        When 'MND2' Then  Rec.RECIB_Importe * TC.TIPOC_VentaSunat                                                 
         Else  Rec.RECIB_Importe
        End
     As Soles
    ,Rec.ENTID_Codigo As ENTID_Codigo
    ,Rec.RECIB_Codigo As DOCVE_Codigo
    ,Rec.RECIB_Serie As DOCVE_Serie
    ,Rec.RECIB_Numero As DOCVE_Numero
    ,'' As TipoDocumento
    ,'' As TIPOS_Descripcion
    ,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
Into #OtrosIngresos
From Tesoreria.TESO_Recibos As Rec
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
    Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
    And Rec.TIPOS_CodTipoRecibo = 'CPDRI'
    And Rec.PVENT_Id = @PVENT_Id
    And Rec.RECIB_Estado <> 'X'
Union All /* Recibos de Pagos Anulados de Caja */
Select 2 As Orden
    ,'Recibos de Ingresos' As Titulo
    ,'02.- Recibos de Ingresos' As Title
    ,Caj.CAJA_Fecha As Fecha
    ,Ent.ENTID_RazonSocial + ' - Recibo de Ingreso por Anulación de Pago de ' 
                           + TDoc.TIPOS_Descripcion 
                           + ' Con ' + TPag.TIPOS_Descripcion
                           + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
                           + ' /  Anulada el ' 
                           + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As ENTID_RazonSocial
    ,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
    ,Mon.TIPOS_DescCorta As Moneda
    ,TC.TIPOC_VentaSunat As TCambioVenta
    ,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
    ,Case Caj.TIPOS_CodTipoMoneda
        When 'MND1' Then  Caj.CAJA_Importe / TC.TIPOC_VentaSunat                                                  
         Else Caj.CAJA_Importe
        End
     As Dolares 
    ,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
    ,Case Caj.TIPOS_CodTipoMoneda
        When 'MND2' Then  Caj.CAJA_Importe * TC.TIPOC_VentaSunat                                                  
         Else Caj.CAJA_Importe
        End
     As Soles
    ,'' As ENTID_Codigo
    ,'' As RECIB_Codigo
    ,Caj.CAJA_Serie
    ,Caj.CAJA_Numero
    ,TDoc.TIPOS_DescCorta As TipoDocumento
    ,TDoc.TIPOS_Descripcion
    ,Caj.TIPOS_CodTipoDocumento
From Tesoreria.TESO_Caja As Caj
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
    Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
    Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
    Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
    Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
Where Caj.CAJA_AnuladoCaja = 1
    And Convert(Date, Caj.CAJA_FechaAnulado) Between @FecIni And @FecFin
    And Caj.PVENT_Id = @PVENT_Id

Select * From #OtrosIngresos
Order By Orden



GO 
/***************************************************************************************************************************************/ 
GO 
/*******************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_Pendientes_Resumen.sql **************************************************************************/
/*******************************************************************************************************************************************************************************************/
GO 
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Pendientes_Resumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_Pendientes_Resumen]
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 28/11/2020
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Pendientes_Resumen]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
AS
BEGIN

Select 
     LTrim(RTRim(Ven.ENTID_CodigoCliente)) As ENTID_Codigo
    ,Ent.ENTID_RazonSocial As Titulo
    ,Ent.ENTID_RazonSocial
    ,Ven.DOCVE_Codigo
    ,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
    ,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
    ,Ven.DOCVE_FechaDocumento
    ,Ven.TIPOS_CodTipoMoneda
    ,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
        Then (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        And Convert(Date, CAJA_Fecha) <= @FecFin
                        --And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And CAJA_Estado <> 'X'
                     ), 0)
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        --And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And Convert(Date, CAJA_FechaAnulado) > @FecFin
                     ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                                    Else Ven.DOCVE_TipoCambio
                               End)
         Else (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        And Convert(Date, CAJA_Fecha) <= @FecFin
                        --And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And CAJA_Estado <> 'X'
                     ), 0)
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        --And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        --And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And Convert(Date, CAJA_FechaAnulado) > @FecFin
                     ), 0))
         End
     As PendienteSoles
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
            Then (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        And Convert(Date, CAJA_Fecha) <= @FecFin
                        --And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And CAJA_Estado <> 'X'
                     ), 0)
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        --And Not Caj.TIPOS_CodTransaccion In ('TPG03')
                        And Convert(Date, CAJA_FechaAnulado) >= @FecFin
                     ), 0))
            
         Else 0.00
         End
     As PendienteDolares
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
            Then (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                          Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                            And Convert(Date, CAJA_Fecha) <= @FecFin
                            And CAJA_Estado <> 'X'
                         ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                                        Else Ven.DOCVE_TipoCambio
                                   End)
         Else (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                          Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                            And Convert(Date, CAJA_Fecha) <= @FecFin
                            And CAJA_Estado <> 'X'
                         ), 0))
         End
     As Pago
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
    ,Case Ven.TIPOS_CodTipoMoneda
        When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
         Else  Ven.DOCVE_TotalPagar
         End
     As ImpSoles
    ,(Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                        Else Ven.DOCVE_TipoCambio
                   End) As TCambioVenta
    ,Ven.ENTID_CodigoVendedor
    ,Vend.ENTID_RazonSocial As ENTID_RazonSocialVendedor
    ,Ven.TIPOS_CodTipoDocumento
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
    Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) <= @FecFin
    And Ven.DOCVE_Estado <> 'X'
    And Ven.PVENT_Id = @PVENT_Id
    --And Ven.DOCVE_AnuladoCaja = 0 And Ven.DOCVE_FecAnulacion < @FecFin
    And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All /* Facturas Anuladas */
Select LTrim(RTrim(Ven.ENTID_CodigoCliente)) As ENTID_Codigo
    ,Ent.ENTID_RazonSocial As Titulo
    ,Ent.ENTID_RazonSocial              
    ,Ven.DOCVE_Codigo
    ,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
    ,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
    ,Ven.DOCVE_FechaDocumento
    ,Ven.TIPOS_CodTipoMoneda
    ,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
    ,Case Ven.TIPOS_CodTipoMoneda 
        When 'MND2' Then (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
                        Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                            And Convert(Date, CAJA_Fecha) <= @FecFin
                            And CAJA_Estado <> 'X'
                    ), 0)
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        --And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        And Convert(Date, CAJA_FechaAnulado) > @FecFin
                     ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
                                                                    Else Ven.DOCVE_TipoCambio
                               End)
         Else (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
                        Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                            And Convert(Date, CAJA_Fecha) <= @FecFin
                            And CAJA_Estado <> 'X'
                    ), 0)
            - IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                        --And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        And Convert(Date, CAJA_FechaAnulado) >= @FecFin
                     ), 0))
         End
     As PendienteSoles
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
            Then (Ven.DOCVE_TotalPagar
            - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
          Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
            And Convert(Date, CAJA_Fecha) <= @FecFin
            And CAJA_Estado <> 'X'
         ), 0)) 
         Else 0.00
         End
     As PendienteDolares
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
            Then (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
          Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
            And Convert(Date, CAJA_Fecha) <= @FecFin
            And CAJA_Estado <> 'X'
         ), 0)) * TC.TIPOC_VentaSunat
         Else (IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
          Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
            And Convert(Date, CAJA_Fecha) <= @FecFin
            And CAJA_Estado <> 'X'
         ), 0))
         End
     As Pago
    ,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End As ImpDolares
    ,Case Ven.TIPOS_CodTipoMoneda 
        When 'MND2' Then (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
                            - IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
                                        Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                                            And CAJA_Estado <> 'X'
                                            And Convert(Date, CAJA_Fecha) <= @FecFin                                     
                                    ) ), 0)) * TC.TIPOC_VentaSunat
         Else (ISNULL(Ven.DOCVE_TotalPagar, Ven.DOCVE_TotalPagar)
                - IsNull(((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As Caj
                                        Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
                                            And Convert(Date, CAJA_Fecha) <= @FecFin
                                            And CAJA_Estado <> 'X'
                                    )), 0))
         End
     As ImpSoles
    ,TC.TIPOC_VentaSunat As TCambioVenta
    ,Ven.ENTID_CodigoVendedor
    ,Vend.ENTID_RazonSocial As ENTID_RazonSocialVendedor
    ,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
    Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
    Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) <= @FecFin
    And Ven.DOCVE_Estado = 'X'
    And Ven.DOCVE_AnuladoCaja = 1 And Convert(Date, DateAdd(Day, -1, Ven.DOCVE_FecAnulacion)) >= @FecFin
    And Ven.PVENT_Id = @PVENT_Id
    And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
--Union All
--Select LTrim(RTrim(Se.ENTID_Codigo)) As ENTID_Codigo
--  ,Ent.ENTID_RazonSocial As Titulo
--  ,'Sencillo de Caja - ' + PVen.PVENT_Descripcion
--  ,'SE' + Right('000' + RTrim(Se.PVENT_Id), 3) + Right('0000000' + RTrim(SENCI_Id), 7)
--  ,'Sen' As TipoDocumento
--  ,'SE ' + Right('000' + RTrim(Se.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(SENCI_Id), 7) As Documento
--  ,SENCI_Fecha
--  ,'MND1'
--  ,'S/.' As TIPOS_TipoMoneda
--  ,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As PendienteSoles
--  ,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As PendienteDolares
--  ,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As Pago
--  ,Case TIPOS_CodTipoMoneda When 'MND2' Then SENCI_Importe Else 0.00 End As ImpDolares
--  ,Case TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End As ImpSoles
--  ,SENCI_TipoCambio As TCambioVenta
--  ,'10000000' As ENTID_CodigoVendedor
--  ,'Efectivo' As ENTID_RazonSocialVendedor
--  ,'' As TIPOS_CodTipoDocumento
--From Tesoreria.TESO_Sencillo As Se
--  Inner Join Entidades As Ent On Ent.ENTID_Codigo = Se.ENTID_Codigo
--  Inner Join PuntoVenta As PVen On PVen.PVENT_Id = Se.PVENT_Id
--Where Convert(Date, SENCI_Fecha) = @FecFin
--  And Se.PVENT_Id = @PVENT_Id
Union All /* Pendiente de Caja */
Select '00000000000'
    ,'Pendiente de Caja' 
    ,'PC: ' 
        + CAJAC_Detalle
        + ' / Fecha: ' + Convert(VarChar(10), CAJAC_Fecha, 103)
        + ' / Resp.:' + IsNull(CC.ENTID_Codigo + '-' + Ent.ENTID_RazonSocial, '')
         As Titulo
    ,'PC' + Right('000' + RTrim(PVENT_Id), 3) + Right('0000000' + RTrim(CAJAC_Id), 7)
    ,'PCaj'
    ,'PC ' + Right('000' + RTrim(PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJAC_Id), 7) As Documento
    ,CC.CAJAC_Fecha
    ,CC.TIPOS_CodTipoMoneda
    ,'S/.'
    ,CC.CAJAC_Importe - IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos 
                                Where CAJAC_Id = CC.CAJAC_Id 
                                    And PVENT_Id = CC.PVENT_Id 
                                    And Convert(Date, CAJAP_Fecha) <= @FecFin
                                    And CAJAP_Estado <> 'X'), 0)
    ,0.00
    ,IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos 
                                Where CAJAC_Id = CC.CAJAC_Id 
                                    And PVENT_Id = CC.PVENT_Id 
                                    And Convert(Date, CAJAP_Fecha) <= @FecFin
                                    And CAJAP_Estado <> 'X'), 0)
     As Pago
    ,0.00
    ,CC.CAJAC_Importe
    ,0.00
    ,'10000001' As ENTID_CodigoVendedor
    ,'Pendiente de Caja: ' + IsNull(CC.ENTID_Codigo + '-' + Ent.ENTID_RazonSocial, '')
        + ' / Glosa: ' + CAJAC_Detalle
        + ' / Fecha: ' + Convert(VarChar(10), CAJAC_Fecha, 103)
        As ENTID_RazonSocialVendedor
    ,'' As TIPOS_CodTipoDocumento
From Tesoreria.TESO_CajaChicaIngreso As CC
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = CC.ENTID_Codigo
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CC.TIPOS_CodTipoMoneda
Where CC.PVENT_Id = @PVENT_Id
    And Abs(CC.CAJAC_Importe - IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos 
                                       Where CAJAC_Id = CC.CAJAC_Id 
                                            And PVENT_Id = CC.PVENT_Id 
                                            And Convert(Date, CAJAP_Fecha) <= @FecFin
                                            And CAJAP_Estado <> 'X'), 0)) > 0
    And Convert(Date, CAJAC_Fecha) <= @FecFin
    And CC.CAJAC_Estado <> 'X'

--If @Orden = 0
--Begin 
   SELECT Orden               = 6
        , Titulo              = 'Documentos pendientes de pago'
        , Title               = '06.- Pendientes de pago'
        , Fecha               = CONVERT(DATE, DOCVE_FechaDocumento)
        , ENTID_RazonSocial   = ENTID_RazonSocial
        , Documento           = Documento
        , Moneda              = TIPOS_TipoMoneda
        , TCambioVenta        = NULL 
        , ImpDolares          = PendienteDolares
        , ImpSoles            = PendienteSoles
        , ENTID_Codigo        = ENTID_Codigo
        , DOCVE_Codigo        = DOCVE_Codigo
        , DOCVE_Serie         = null
        , DOCVE_Numero        = NULL
        , TipoDocumento       = NULL
        , TIPOS_Descripcion   = NULL
        , TIPOS_CodTipoDocumento    = NULL
        , CAJA_Codigo         = NULL
        , Detalle             = NULL 
        , DocDetalle          = NULL --DocCaja
     FROM #Facturas 
    Where TIPOS_CodTipoDocumento <> 'CPD07'
        And PendienteSoles > 0
    Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo

    --CREATE TABLE #Pendientes(Orden INT NULL, Titulo VARCHAR(100) NULL , Title VARCHAR(100) NULL, Fecha DATETIME NULL
    --                        , ENTID_RazonSocial VARCHAR(100) NULL, Documento VARCHAR(50) NULL, Moneda VARCHAR(10) NULL
    --                        , TCambioVenta DECIMAL(8, 4) NULL, ImpDolares DECIMAL(12,2) NULL, ImpSoles DECIMAL(12, 2) NULL
    --                        , ENTID_Codigo INT NULL, DOCVE_Codigo INT NULL, DOCVE_Serie VARCHAR(10) NULL, DOCVE_Numero VARCHAR(10) NULL
    --                        , TipoDocumento VARCHAR(10) NULL, TIPOS_Descripcion VARCHAR(100) NULL, TIPOS_CodTipoDocumento VARCHAR(10) NULL
    --                        , CAJA_Codigo VARCHAR(10) NULL, Detalle VARCHAR(100) NULL, DocDetalle VARCHAR(100) NULL)

--End
--If @Orden = 1
--Begin 
--  Select * From #Facturas 
--  Where TIPOS_CodTipoDocumento <> 'CPD07'
--      And PendienteSoles > 0
--  Order By ENTID_RazonSocialVendedor, DOCVE_FechaDocumento, DOCVE_Codigo
    
--End

--Select Titulo As ENTID_RazonSocial, RTrim(ENTID_Codigo) As ENTID_CodigoCliente , Count(*) 
--From #Facturas 
--Where TIPOS_CodTipoDocumento <> 'CPD07'
--      And PendienteSoles > 0
--Group By Titulo, ENTID_Codigo Order By Titulo


/*========================================================================================================*
Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
                      Where Caj.DOCVE_Codigo = '030210051984'
                        --And Convert(Date, CAJA_Fecha) <= @FecFin
                        And CAJA_Estado = 'X'
                        And CAJA_AnuladoCaja = 1
                        And Convert(Date, CAJA_FechaAnulado) > @FecFin
*========================================================================================================*/
    --Select * From #Facturas Where PendienteSoles < 0 And ENTID_CodigoVendedor = '29452467'


--Select SUM(ImpSoles), ENTID_NroDocumento, ENTID_RazonSocial From #Fletes 
--Where Pendiente > 0
--Group By ENTID_NroDocumento, ENTID_RazonSocial

--Select SUM(ImpSoles) From #Fletes 
--Where Pendiente > 0


END

GO

--exec VENT_CCAJASS_Pendientes_Resumen @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-28 00:00:00',@PVENT_Id=1

--CodEntidad

GO 
/*****************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_CCAJASS_SInicial_Resumen.sql **************************************************************************/
/*****************************************************************************************************************************************************************************************/
GO 
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_SInicial_Resumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_CCAJASS_SInicial_Resumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_SInicial_Resumen]
(
     @FecIni DateTime
    ,@PVENT_Id BigInt
)
As
BEGIN
    -- ==================================================================================================================================================== --
    /* PENDIENTES */
    
    DECLARE @FecFin DATETIME = DATEADD(DAY, -1, @FecIni)

    CREATE TABLE #Pendientes(Orden INT NULL, Titulo VARCHAR(100) NULL , Title VARCHAR(100) NULL, Fecha DATETIME NULL
                            , ENTID_RazonSocial VARCHAR(100) NULL, Documento VARCHAR(50) NULL, Moneda VARCHAR(10) NULL
                            , TCambioVenta DECIMAL(8, 4) NULL, ImpDolares DECIMAL(12,2) NULL, ImpSoles DECIMAL(12, 2) NULL
                            , ENTID_Codigo VARCHAR(20) NULL, DOCVE_Codigo VARCHAR(50) NULL, DOCVE_Serie VARCHAR(10) NULL, DOCVE_Numero VARCHAR(10) NULL
                            , TipoDocumento VARCHAR(10) NULL, TIPOS_Descripcion VARCHAR(100) NULL, TIPOS_CodTipoDocumento VARCHAR(10) NULL
                            , CAJA_Codigo VARCHAR(10) NULL, Detalle VARCHAR(100) NULL, DocDetalle VARCHAR(100) NULL)
    INSERT INTO #Pendientes
    EXEC VENT_CCAJASS_Pendientes_Resumen @FecIni = @FecIni,@FecFin = @FecFin,@PVENT_Id = @PVENT_Id
    --SELECT * FROM #Pendientes
    -- ==================================================================================================================================================== --

/* Calculo de Sencillo Inicial */
/* Ingreso de Efectivo por Cancelación de Facturas */
  SELECT ImpDolares     = CASE Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpDolares    = CONVERT(Decimal(14, 4), 0.00)
       , ImpSoles       = CASE Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpSoles      = CONVERT(Decimal(14, 4), 0.00)
       , Glosa          = 'Ingreso de Efectivo por Cancelación de Facturas'
       , Caj.CAJA_Fecha
    INTO #Inicial
    FROM VW_Tesoreria_TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc
   INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
   INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id AND CAJ.CAJA_Estado <> 'X'
   INNER JOIN Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
   INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
   INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
    LEFT JOIN Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    LEFT JOIN Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    LEFT JOIN Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    LEFT JOIN TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
   WHERE Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01') --Doc.TIPOS_CodTipoDocumento = 'DPG01'
     AND Convert(Date, Caj.CAJA_Fecha) < @FecIni
     AND Doc.PVENT_Id = @PVENT_Id
         --AND Doc.DPAGO_Estado <> 'X'
   UNION All /* Egreso en Efectivo por Cancelacion de Documentos */
  SELECT 
         Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
       , 'Egreso en Efectivo por Cancelacion de Documentos' As Glosa
       , ISNULL(RDoc.DOCUS_Fecha, Rec.RECIB_Fecha)
    FROM Tesoreria.TESO_Recibos As Rec
    LEFT Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
   Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo AND RDoc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento 
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
   WHERE Convert(Date, Rec.RECIB_Fecha) < @FecIni
     And Rec.RECIB_Estado <> 'X' 
   UNION All /* Egresos por Prestamo de Efectivo */
  SELECT 0.00
       , Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , 0.00
       , Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
       , 'Egresos por Prestamo de Efectivo' As Glosa
       , CCI.CAJAC_Fecha
    FROM Tesoreria.TESO_CajaChicaIngreso As CCI
   INNER Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE Convert(Date, CCI.CAJAC_Fecha) < @FecIni
     And CCI.CAJAC_Estado <> 'X'
   UNION All /* Ingreso de las devoluciones en Efectivo */
  SELECT 0.00
       , 0.00
       , CCP.CAJAP_Importe
       , 0.00
       , 'Ingreso de las devoluciones en Efectivo' As Glosa
       , CCI.CAJAC_Fecha
    FROM Tesoreria.TESO_CajaChicaPagos As CCP
   Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE CCP.TIPOS_CodTipoPago = 'TPC02'
     And Convert(Date, CCP.CAJAP_Fecha) < @FecIni
     AND CCP.CAJAP_Estado <> 'X'
   UNION All /* Saldo Inicial */
  SELECT Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
       , 0.00
       , Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
       , 0.00
       , 'Saldo Inicial ' As Glosa
       , SINIC_Fecha
    FROM Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'
    UNION ALL 
   Select 0.00
        , 0.00
        , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
        , 0.00
        , 'Recibo de Ingreso por Anulación' As Titulo
        , Caj.CAJA_Fecha
     FROM Tesoreria.TESO_Caja As Caj
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
    Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
    Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
     Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
     Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
     Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
     Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
    WHERE Caj.CAJA_AnuladoCaja = 1
      AND Convert(Date, Caj.CAJA_FechaAnulado) <=  @FecIni
      AND Caj.PVENT_Id = @PVENT_Id
      UNION ALL 
   Select 0.00
        , 0.00
        , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
        , 0.00
        , 'Recibo de Ingreso por Anulación' As Titulo
        , Caj.CAJA_Fecha
     FROM Tesoreria.TESO_Caja As Caj
    Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
    Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
    Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
     Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
     Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
     Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
     Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
    WHERE Caj.CAJA_AnuladoCaja = 1
      --AND Convert(Date, Caj.CAJA_FechaAnulado) <=  @FecIni
      AND Convert(Date, Caj.CAJA_FechaAnulado) > @FecIni AND Caj.CAJA_Fecha < @FecIni
      AND Caj.PVENT_Id = @PVENT_Id
    UNION ALL
    SELECT ImpDolares     = ImpDolares
         , EImpDolares    = 0.00
         , ImpSoles       = ImpSoles
         , EImpSoles      = 0.00
         , Glosa          = 'Pendientes de Pago'
         , Fecha
     FROM #Pendientes

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial 
    FROM #Inicial

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa 
     FROM #Inicial Group By Glosa

   SELECT * FROM #Inicial ORDER BY ImpSoles, EImpSoles
   --SELECT * FROM #Pendientes

   --SELECT * FROM #Inicial  WHERE ImpSoles = 6463.52
   --SELECT * FROM #Inicial  WHERE EImpSoles = 6463.52

END 
GO

--EXEC dbo.VENT_CCAJASS_SInicial_Resumen @FecIni = '2018-12-31', @PVENT_Id = 1 -- bigint
--EXEC dbo.VENT_CCAJASS_SInicial_Resumen @FecIni = '2019-01-07', @PVENT_Id = 1 -- bigint
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2019-02-11 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-09 00:00:00',@PVENT_Id=1

--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-18',@PVENT_Id=1

GO 
/**************************************************************************************************************************************************************************************************/
/**************************************************************************** VENT_REPOSS_MovimientoEfectivo_Resumen.sql **************************************************************************/
/**************************************************************************************************************************************************************************************************/
GO 
--USE BDNOVACERO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_REPOSS_MovimientoEfectivo_Resumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo_Resumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo_Resumen]
(
     @FecIni DateTime
    ,@FecFin DateTime
    ,@PVENT_Id BigInt
)
As


--Declare @FecIni DateTime Set @FecIni = '2013-06-24 00:00:00'
--Declare @FecFin DateTime Set @FecFin = '2013-06-26 00:00:00'

/* Ingreso de Efectivo Por CancelaciÃ³n de Documento de venta */
 SELECT TPag.TIPOS_DescCorta + ' ' + Right('000' + RTRIM(Doc.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Doc.DPAGO_Id), 7) As DocCaja
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Doc.TIPOS_CodTipoMoneda
       --, Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , Convert(Decimal(14, 4), 0.00) As EImpDolares
       --, Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles 
       , Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles  
       , Convert(Decimal(14, 4), 0.00) As EImpSoles
       , 'Cancelación de Documento de Venta : '
           + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
           + ' / Fecha Fac.: ' + Convert(VarChar(10), Ven.DOCVE_FechaDocumento, 103)     
           + ' / ' + TMonVen.TIPOS_DescCorta + ' ' + Convert(VarChar(20), CONVERT(money, Ven.DOCVE_TotalPagar), 1)
           + ' / R.U.C. o D.N.I.: ' + Ven.ENTID_CodigoCliente
           + ' / Raz. Soc.: ' 
           + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) + '.'
         As DPAGO_Glosa
       , Convert(Date, Caj.CAJA_Fecha) As DPAGO_Fecha
       , TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As DocVenta
       , Ven.ENTID_CodigoCliente 
       , IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
       
   INTO #MovEfectivo
   FROM VW_Tesoreria_TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc 
  INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
  INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id AND CAJ.CAJA_Estado <> 'X'
  INNER JOIN Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
  INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
  INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo  And Ven.DOCVE_Estado <> 'X'
    LEFT JOIN Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
    LEFT JOIN Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    LEFT JOIN Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    LEFT JOIN TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
  WHERE Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01')-- = 'DPG01'
         --And Convert(Date, Doc.DPAGO_Fecha) Between @FecIni And @FecFin
    AND Convert(Date, Caj.CAJA_Fecha) Between @FecIni And @FecFin
     AND Doc.PVENT_Id = @PVENT_Id
    --AND Doc.DPAGO_Estado <> 'X'
--  UNION All /* Egreso en Efectivo por Cancelacion de Documentos */
-- SELECT TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
--    ,Mon.TIPOS_DescCorta 
--    ,Rec.TIPOS_CodTipoMoneda
--    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
--    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
--    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
--    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
--    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then 'Egreso en Efectivo Para CancelaciÃ³n de Documento' Else 'Ingreso en Efectivo' End + '  / Responsable: ' 
--     + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
--     + ' / Glosa: ' + Rec.RECIB_Concepto
--     + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
--                + ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
--        , '')
--     As Detalle
--    ,Rec.RECIB_Fecha
--    ,'' As DocVenta
--    ,'' As ENTID_CodigoCliente 
--    ,'' As ENTID_RazonSocial
--From Tesoreria.TESO_Recibos As Rec
--    Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
--    Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
--    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
--    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
--    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo AND RDoc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
--    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
--    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
--Where Convert(Date, Rec.RECIB_Fecha)  Between @FecIni And @FecFin
--    --And TIPOS_CodTipoRecibo In 'CPDRE'
--    And Rec.RECIB_Estado <> 'X' 
Union All /* Egresos por Prestamo de Efectivo */
Select 'PCaj ' + Right('000' + RTRIM(CCI.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CCI.CAJAC_Id), 7)
    ,Mon.TIPOS_DescCorta 
    ,CCI.TIPOS_CodTipoMoneda
    ,0.00
    ,Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
    ,0.00
    ,Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
    ,'Pendiente de Caja Chica ' 
     + ' / Responsable: ' + Ent.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial
     + ' / Glosa: ' + CCI.CAJAC_Detalle
     As Detalle
    ,CCI.CAJAC_Fecha
    ,'' As DocVenta
    ,'' As ENTID_CodigoCliente 
    ,'' As ENTID_RazonSocial
From Tesoreria.TESO_CajaChicaIngreso As CCI
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where Convert(Date, CCI.CAJAC_Fecha)  Between @FecIni And @FecFin
    And CCI.CAJAC_Estado <> 'X'
Union All /* Ingreso de las devoluciones en Efectivo */
Select 'VCaj ' + Right('000' + RTRIM(CCP.PVENT_Id), 3) + '-' + Right('00000' + RTrim(CCP.CAJAC_Id), 4) + Right('00' + RTrim(CCP.CAJAP_Item), 2)
    ,Mon.TIPOS_DescCorta
    ,CCI.TIPOS_CodTipoMoneda
    ,0.00
    ,0.00
    ,CCP.CAJAP_Importe
    ,0.00
    ,'Devolución de Efectivo a Caja Chica'
     --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
     + IsNull(' / Glosa: ' + CCP.CAJAP_Descripcion, '')
     + IsNull(' / DevoluciÃ³n de: ' + CCI.CAJAC_Detalle, '')
     + IsNull(' / Responsable: ' + Ent.ENTID_RazonSocial, '')
     As Detalle
    ,CCP.CAJAP_Fecha
    ,'' As DocVenta
    ,'' As ENTID_CodigoCliente 
    ,'' As ENTID_RazonSocial
From Tesoreria.TESO_CajaChicaPagos As CCP
    Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where CCP.TIPOS_CodTipoPago = 'TPC02'
    And Convert(Date, CCP.CAJAP_Fecha)  Between @FecIni And @FecFin
    And CCP.CAJAP_Estado <> 'X'
-- ORDER By DPAGO_Fecha, DocVenta
--UNION
--Select 'SENC ' + Right('000' + RTRIM(SENC.SENCI_Id), 3)
--  , 'S/'
--   , 'MND1'   
--  ,0.00
--  ,0.00
--  ,SENC.SENCI_Importe
--  ,0.00
--  ,'Sencillo de Caja'
--   --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
--   + 'Glosa: Sencillo de Caja'
--   As Detalle
--  , SENC.SENCI_Fecha
--  ,'' As DocVenta
--  ,'' As ENTID_CodigoCliente 
--  ,'' As ENTID_RazonSocial
--From Tesoreria.TESO_Sencillo As SENC
--Where Convert(Date, SENC.SENCI_Fecha) Between @FecIni And @FecFin AND SENC.PVENT_Id = @PVENT_Id
--ORDER By DPAGO_Fecha, DocVenta


/*##########################################################################################################################*/


--Select * From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'
--SELECT * FROM #Inicial

    SELECT --DocCaja             = NULL --MAX(DocCaja)
         --, TIPOS_TipoMoneda 
         --, TIPOS_CodTipoMoneda 
         --, ImpDolares          = SUM(ImpDolares)
         --, EImpDolares         = SUM(EImpDolares)
         --, ImpSoles            = SUM(ImpSoles)
         --, EImpSoles           = SUM(EImpSoles)
         ----, DPAGO_Glosa
         --, DPAGO_Fecha         = CONVERT(DATE, DPAGO_Fecha)
         --, DocVenta            = NULL 
         --, ENTID_CodigoCliente = NULL 
         --, ENTID_RazonSocial   = NULL}
         --
           Orden               = 4
         , Titulo              = 'Movimiento de Efectivo'
         , Title               = '04.- Movimiento de Efectivo'
         , Fecha               = CONVERT(DATE, DPAGO_Fecha)
         , ENTID_RazonSocial   = 'Movimiento de Efectivo Desde: ' 
                                 + CONVERT(VARCHAR(10), MIN(DPAGO_Fecha), 103)
                                 + ' Hasta: ' + CONVERT(VARCHAR(10), MAX(DPAGO_Fecha), 103)
         , Documento           = NULL
         , Moneda              = TIPOS_TipoMoneda
         , TCambioVenta        = 1
         , ImpDolares          = SUM(ImpDolares) - SUM(EImpDolares)
         , ImpSoles            = SUM(ImpSoles) - SUM(EImpSoles)
         , ENTID_Codigo        = 'MOVIMIENTO DE EFECTIVO'
         , DOCVE_Codigo        = NULL
         , DOCVE_Serie         = NULL
         , DOCVE_Numero        = NULL
         , TipoDocumento       = NULL
         , TIPOS_Descripcion   = NULL
         , TIPOS_CodTipoDocumento    = NULL
         , CAJA_Codigo         = NULL
         , Detalle             = NULL
         , DocDetalle          = 'Movimiento'
         , ImpDolares          = SUM(ImpDolares)
         , ImpSoles            = SUM(ImpSoles)
         , EImpDolares         = SUM(EImpDolares)
         , EImpSoles           = SUM(EImpSoles)
      FROM #MovEfectivo
     GROUP BY TIPOS_TipoMoneda 
         , TIPOS_CodTipoMoneda 
         , CONVERT(DATE, DPAGO_Fecha)
    UNION ALL
    SELECT Orden                = 4
         , Titulo               = 'Movimiento de Efectivo'
         , Title                = '04.- Movimiento de Efectivo'
         , Fecha                = CONVERT(DATE, SENCI_Fecha)
         , ENTID_RazonSocial    = 'Sencillo de Caja - ' + PVen.PVENT_Descripcion
         , Documento            = 'SE ' + Right('000' + RTrim(Se.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(SENCI_Id), 7)
         , Moneda               = 'S/.'
         , TCambioVenta         = 0.00
         , ImpDolares           = 0.00 --CASE TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End
         , ImpSoles             = CASE TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End 
         , ENTID_Codigo         = LTRIM(RTrim(Se.ENTID_Codigo))
         , DOCVE_Codigo         = NULL  
         , DOCVE_Serie          = ''
         , DOCVE_Numero         = SENCI_Id --'SE' + Right('000' + RTrim(Se.PVENT_Id), 3) + Right('0000000' + RTrim(SENCI_Id), 7)
         , TipoDocumento          = 'SEN'
         , TIPOS_Descripcion      = '' 
         , TIPOS_CodTipoDocumento = ''
         , CAJA_Codigo            = NULL 
         , Detalle                = ''
         , DocDetalle             = ''
         , ImpDolares             = 0.00
         , ImpSoles               = CASE TIPOS_CodTipoMoneda When 'MND2' Then (SENCI_Importe * SENCI_TipoCambio) Else SENCI_Importe End 
         , EImpDolares            = 0.00
         , EImpSoles              = 0.00
      FROM Tesoreria.TESO_Sencillo As Se
     INNER Join Entidades As Ent On Ent.ENTID_Codigo = Se.ENTID_Codigo
     INNER Join PuntoVenta As PVen On PVen.PVENT_Id = Se.PVENT_Id
    Where Convert(Date, SENCI_Fecha) = @FecFin
        And Se.PVENT_Id = @PVENT_Id

   --SELECT ImpDolares = SUM(ImpDolares)
   --     , ImpSoles = SUM(ImpSoles)
   --     , EImpDolares = SUM(EImpDolares)
   --     , EImpSoles = SUM(EImpSoles)
   --  FROM #MovEfectivo
   -- GROUP BY TIPOS_TipoMoneda 
   --     , TIPOS_CodTipoMoneda 
   --     , CONVERT(DATE, DPAGO_Fecha)

GO 
/***************************************************************************************************************************************/ 

--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2019-01-03',@FecFin='2019-01-03',@PVENT_Id=1

--exec VENT_REPOSS_MovimientoEfectivo @FecIni='2019-01-03',@FecFin='2019-01-03',@PVENT_Id=1

----exec VENT_CCAJASS_EfectivoResumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
--Orden  Titulo                 Title                       Fecha      ENTID_RazonSocial      Documento   Moneda     TCambioVenta                            ImpDolares                              ImpSoles                                ENTID_Codigo DOCVE_Codigo DOCVE_Serie DOCVE_Numero TipoDocumento TIPOS_Descripcion TIPOS_CodTipoDocumento CAJA_Codigo Detalle     DocDetalle
