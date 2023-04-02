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

Declare @Orden SmallInt	Set @Orden = 4

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
	  , Moneda	               = Mon.TIPOS_DescCorta
	  , TCambioVenta           = TC.TIPOC_VentaSunat
      , ImpDolares             = CASE Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
      , ImpSoles	           = CASE Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
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
--	 , Title                = '04.- Movimiento de Efectivo'
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
--	 , TIPOS_Descripcion      = '' 
--     , TIPOS_CodTipoDocumento = ''
--     , CAJA_Codigo            = NULL 
--     , Detalle                = ''
--     , DocDetalle             = ''
--  FROM Tesoreria.TESO_Sencillo As Se
-- INNER Join Entidades As Ent On Ent.ENTID_Codigo = Se.ENTID_Codigo
-- INNER Join PuntoVenta As PVen On PVen.PVENT_Id = Se.PVENT_Id
--Where Convert(Date, SENCI_Fecha) = @FecFin
--	And Se.PVENT_Id = @PVENT_Id


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