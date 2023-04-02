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

/*====================================================================================================*/
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
        , ImpDolares = SUM(ImpDolares)
        , ImpSoles = SUM(ImpSoles)
        , EImpDolares = SUM(EImpDolares)
        , EImpSoles = SUM(EImpSoles)
     FROM #MovEfectivo
    GROUP BY TIPOS_TipoMoneda 
        , TIPOS_CodTipoMoneda 
        , CONVERT(DATE, DPAGO_Fecha)

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

/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_REPOSS_MovimientoEfectivo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 26/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_REPOSS_MovimientoEfectivo]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As


--Declare @FecIni DateTime Set @FecIni = '2013-06-24 00:00:00'
--Declare @FecFin DateTime Set @FecFin = '2013-06-26 00:00:00'

/* Ingreso de Efectivo Por Cancelación de Documento de venta */
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
	   , Convert(Date, Doc.DPAGO_Fecha) As DPAGO_Fecha
	   , TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As DocVenta
	   , Ven.ENTID_CodigoCliente 
	   , IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
   FROM VW_Tesoreria_TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc 
  INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj ON DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
  INNER JOIN Tesoreria.TESO_Caja As Caj ON Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id AND CAJ.CAJA_Estado <> 'X'
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
	,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then 'Egreso en Efectivo Para Cancelación de Documento' Else 'Ingreso en Efectivo' End + '  / Responsable: ' 
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
	   , Mon.TIPOS_DescCorta
	   , CCI.TIPOS_CodTipoMoneda
	   , 0.00
	   , 0.00
	   , CCP.CAJAP_Importe
	   , 0.00
	   , 'Devolución de Efectivo a Caja Chica'
	     --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
	     + IsNull(' / Glosa: ' + CCP.CAJAP_Descripcion, '')
	     + IsNull(' / Devolución de: ' + CCI.CAJAC_Detalle, '')
	     + IsNull(' / Responsable: ' + Ent.ENTID_RazonSocial, '')
	     As Detalle
	   , CCP.CAJAP_Fecha
	   , '' As DocVenta
	   , '' As ENTID_CodigoCliente 
	   , '' As ENTID_RazonSocial
   FROM Tesoreria.TESO_CajaChicaPagos As CCP
  INNER Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
  INNER Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
   LEFT Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
  WHERE CCP.TIPOS_CodTipoPago = 'TPC02'
	 AND Convert(Date, CCP.CAJAP_Fecha)  Between @FecIni And @FecFin
	 AND CCP.CAJAP_Estado <> 'X'
  ORDER BY DPAGO_Fecha, DocVenta
--UNION
--Select 'SENC ' + Right('000' + RTRIM(SENC.SENCI_Id), 3)
--	, 'S/'
--   , 'MND1'	
--	,0.00
--	,0.00
--	,SENC.SENCI_Importe
--	,0.00
--	,'Sencillo de Caja'
--	 --+ IsNull(' / Proveedor: ' + CCI.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, '')
--	 + 'Glosa: Sencillo de Caja'
--	 As Detalle
--	, SENC.SENCI_Fecha
--	,'' As DocVenta
--	,'' As ENTID_CodigoCliente 
--	,'' As ENTID_RazonSocial
--From Tesoreria.TESO_Sencillo As SENC
--Where Convert(Date, SENC.SENCI_Fecha) Between @FecIni And @FecFin AND SENC.PVENT_Id = @PVENT_Id
--ORDER By DPAGO_Fecha, DocVenta


/*##########################################################################################################################*/
/* Calculo de Sencillo Inicial */
/* Ingreso de Efectivo por Cancelación de Facturas */
Select  --Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
        Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	   , CONVERT(Decimal(14, 4), 0.00) As EImpDolares
	   --, Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
      , Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	   , CONVERT(Decimal(14, 4), 0.00) As EImpSoles
	   , 'Ingreso de Efectivo por Cancelación de Facturas' As Glosa
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
 SELECT Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
	   , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
	   , Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
	   , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
	   , 'Egreso en Efectivo por Cancelacion de Documentos' As Glosa
   FROM Tesoreria.TESO_Recibos As Rec
   LEFT JOIN Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
  INNER JOIN Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
  INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	LEFT JOIN TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	LEFT JOIN Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo AND RDoc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	LEFT JOIN Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento 
	LEFT JOIN Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
  WHERE Convert(Date, Rec.RECIB_Fecha) < @FecIni
	 AND Rec.RECIB_Estado <> 'X'	
  UNION All /* Egresos por Prestamo de Efectivo */
 SELECT 0.00
	   , Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	   , 0.00
	   , Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	   , 'Egresos por Prestamo de Efectivo' As Glosa
   FROM Tesoreria.TESO_CajaChicaIngreso As CCI
  INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
	LEFT JOIN Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
  WHERE Convert(Date, CCI.CAJAC_Fecha) < @FecIni
	 AND CCI.CAJAC_Estado <> 'X'
  UNION All /* Ingreso de las devoluciones en Efectivo */
 SELECT 0.00
	   , 0.00
	   , CCP.CAJAP_Importe
	   , 0.00
	   , 'Ingreso de las devoluciones en Efectivo' As Glosa
   FROM Tesoreria.TESO_CajaChicaPagos As CCP
  INNER JOIN Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
  INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
	LEFT JOIN Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
  WHERE CCP.TIPOS_CodTipoPago = 'TPC02'
	 AND Convert(Date, CCP.CAJAP_Fecha) < @FecIni
	 AND CCP.CAJAP_Estado <> 'X'
  UNION All /* Saldo Inicial */
 SELECT Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
	   , 0.00
	   , Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
	   , 0.00
	   , 'Saldo Inicial ' As Glosa
   FROM Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

--Select * From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'
--SELECT * FROM #Inicial

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial From #Inicial

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa From #Inicial Group By Glosa



GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_SENCISS_VerificarIngreso]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_SENCISS_VerificarIngreso] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_SENCISS_VerificarIngreso]
(
	@FecIni Datetime
)
As

--Declare @FecIni Datetime
--Set @FecIni = '12-02-2013'

Select * From Tesoreria.TESO_Sencillo
where Convert(Date, SENCI_Fecha) = @FecIni


GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
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
	   , ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
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
	   , Ven.ENTID_CodigoCliente As ENTID_Codigo
	   , Ven.DOCVE_Codigo
	   , Ven.DOCVE_Serie
	   , Ven.DOCVE_Numero
	   , TDoc.TIPOS_DescCorta As TipoDocumento
	   , TDoc.TIPOS_Descripcion
	   , Ven.TIPOS_CodTipoDocumento
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
	,Ent.ENTID_RazonSocial
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
  FROM #Facturas 
  WHERE ImpSoles > 0
  GROUP BY  Titulo, Title, CONVERT(DATE, Fecha), Moneda
      , TipoDocumento, TIPOS_Descripcion, TIPOS_CodTipoDocumento
      , ENTID_RazonSocial, Documento
-- Order By DOCVE_Codigo

--SELECT * FROM #Facturas




GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
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
Declare @Orden SmallInt	Set @Orden = 3

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
--Union All /* Recibos de Pagos Anulados de Caja */
--Select 2 As Orden
--	,'Recibos de Ingresos' As Titulo
--	,'02.- Recibos de Ingresos' As Title
--	,Caj.CAJA_Fecha As Fecha
--	,Ent.ENTID_RazonSocial + ' - Recibo de Ingreso por Anulación de Pago de ' 
--						   + TDoc.TIPOS_Descripcion 
--						   + ' Con ' + TPag.TIPOS_Descripcion
--						   + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
--						   + ' /  Anulada el ' 
--						   + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As ENTID_RazonSocial
--	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
--	,Mon.TIPOS_DescCorta As Moneda
--	,TC.TIPOC_VentaSunat As TCambioVenta
--	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
--	,Case Caj.TIPOS_CodTipoMoneda
--		When 'MND1' Then  Caj.CAJA_Importe / TC.TIPOC_VentaSunat 												  
--		 Else Caj.CAJA_Importe
--		End
--	 As Dolares	
--	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
--	,Case Caj.TIPOS_CodTipoMoneda
--		When 'MND2' Then  Caj.CAJA_Importe * TC.TIPOC_VentaSunat 												  
--		 Else Caj.CAJA_Importe
--		End
--	 As Soles
--	,'' As ENTID_Codigo
--	,'' As RECIB_Codigo
--	,Caj.CAJA_Serie
--	,Caj.CAJA_Numero
--	,TDoc.TIPOS_DescCorta As TipoDocumento
--	,TDoc.TIPOS_Descripcion
--	,Caj.TIPOS_CodTipoDocumento
--From Tesoreria.TESO_Caja As Caj
--	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
--	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
--	Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
--	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
--	Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
--	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
--	Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
--	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
--Where Caj.CAJA_AnuladoCaja = 1
--	And Convert(Date, Caj.CAJA_FechaAnulado) Between @FecIni And @FecFin
--	And Caj.PVENT_Id = @PVENT_Id

Select * From #OtrosIngresos
Order By Orden



GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
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

/* Calculo de Sencillo Inicial */
/* Ingreso de Efectivo por CancelaciÃ³n de Facturas */
Select  --Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares   --caj.CAJA_Importe
       Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , CONVERT(Decimal(14, 4), 0.00) As EImpDolares
       --, Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
       , Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
       , CONVERT(Decimal(14, 4), 0.00) As EImpSoles
       , 'Ingreso de Efectivo por Cancelación de Facturas' As Glosa
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


   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial 
    FROM #Inicial

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa 
     FROM #Inicial Group By Glosa

END 

GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
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
    ,Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then 'Egreso en Efectivo Para Cancelación de Documento' Else 'Ingreso en Efectivo' End + '  / Responsable: ' 
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
        , ENTID_Codigo        = '< SIN DOCUMENTO >'
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
/***************************************************************************************************************************************/ 

/*====================================================================================================*/

