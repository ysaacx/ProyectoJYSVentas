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

