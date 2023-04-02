--USE BDInkaPeru
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

/* Ingreso de Efectivo Por Cancelaci贸n de Documento de venta */
 SELECT TPag.TIPOS_DescCorta + ' ' + Right('000' + RTRIM(Doc.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Doc.DPAGO_Id), 7) As DocCaja
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Doc.TIPOS_CodTipoMoneda
       , Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , Convert(Decimal(14, 4), 0.00) As EImpDolares
       , Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles 
       , Convert(Decimal(14, 4), 0.00) As EImpSoles
       , 'Cancelaci髇 de Documento de Venta : '
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
  UNION All /* Egreso en Efectivo por Cancelacion de Documentos */
 SELECT TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
    ,Mon.TIPOS_DescCorta 
    ,Rec.TIPOS_CodTipoMoneda
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then 'Egreso en Efectivo Para Cancelaci贸n de Documento' Else 'Ingreso en Efectivo' End + '  / Responsable: ' 
     + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
     + ' / Glosa: ' + Rec.RECIB_Concepto
     + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
                + ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
        , '')
     As Detalle
    ,Rec.RECIB_Fecha
    ,'' As DocVenta
    ,'' As ENTID_CodigoCliente 
    ,'' As ENTID_RazonSocial
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
    ,'Devoluci髇 de Efectivo a Caja Chica'
     --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
     + IsNull(' / Glosa: ' + CCP.CAJAP_Descripcion, '')
     + IsNull(' / Devoluci贸n de: ' + CCI.CAJAC_Detalle, '')
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
 ORDER By DPAGO_Fecha, DocVenta
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
/* Calculo de Sencillo Inicial */
/* Ingreso de Efectivo por Cancelaci贸n de Facturas */
Select  Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , CONVERT(Decimal(14, 4), 0.00) As EImpDolares
       , Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
       , CONVERT(Decimal(14, 4), 0.00) As EImpSoles
       , 'Ingreso de Efectivo por Cancelaci髇 de Facturas' As Glosa
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
Union All /* Egreso en Efectivo por Cancelacion de Documentos */
Select 
     Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
    ,'Egreso en Efectivo por Cancelacion de Documentos' As Glosa
From Tesoreria.TESO_Recibos As Rec
    Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
    Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo AND RDoc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento 
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
    And Rec.RECIB_Estado <> 'X' 
Union All /* Egresos por Prestamo de Efectivo */
Select 0.00
    ,Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
    ,0.00
    ,Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
    ,'Egresos por Prestamo de Efectivo' As Glosa
From Tesoreria.TESO_CajaChicaIngreso As CCI
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where Convert(Date, CCI.CAJAC_Fecha) < @FecIni
    And CCI.CAJAC_Estado <> 'X'
Union All /* Ingreso de las devoluciones en Efectivo */
Select 0.00
    ,0.00
    ,CCP.CAJAP_Importe
    ,0.00
    ,'Ingreso de las devoluciones en Efectivo' As Glosa
From Tesoreria.TESO_CajaChicaPagos As CCP
    Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
    Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
Where CCP.TIPOS_CodTipoPago = 'TPC02'
    And Convert(Date, CCP.CAJAP_Fecha) < @FecIni
    And CCP.CAJAP_Estado <> 'X'
Union All /* Saldo Inicial */
Select Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
    ,0.00
    ,Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
    ,0.00
    ,'Saldo Inicial ' As Glosa
From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

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
        , ENTID_RazonSocial   = NULL 
        , Documento           = NULL
        , Moneda              = TIPOS_TipoMoneda
        , TCambioVenta        = 1
        , ImpDolares          = SUM(ImpDolares) - SUM(EImpDolares)
        , ImpSoles            = SUM(ImpSoles) - SUM(EImpSoles)
        , ENTID_Codigo        = NULL
        , DOCVE_Codigo        = NULL
        , DOCVE_Serie         = NULL
        , DOCVE_Numero        = NULL
        , TipoDocumento       = NULL
        , TIPOS_Descripcion   = NULL
        , TIPOS_CodTipoDocumento    = NULL
        , CAJA_Codigo         = NULL
        , Detalle             = NULL
        , DocDetalle          = NULL
     FROM #MovEfectivo
    GROUP BY TIPOS_TipoMoneda 
        , TIPOS_CodTipoMoneda 
        --, DPAGO_Glosa
        , CONVERT(DATE, DPAGO_Fecha)

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial 
    FROM #Inicial

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa 
     FROM #Inicial Group By Glosa


GO 
/***************************************************************************************************************************************/ 

exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1

--exec VENT_CCAJASS_EfectivoResumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1
--Orden  Titulo                 Title                       Fecha      ENTID_RazonSocial      Documento   Moneda     TCambioVenta                            ImpDolares                              ImpSoles                                ENTID_Codigo DOCVE_Codigo DOCVE_Serie DOCVE_Numero TipoDocumento TIPOS_Descripcion TIPOS_CodTipoDocumento CAJA_Codigo Detalle     DocDetalle
