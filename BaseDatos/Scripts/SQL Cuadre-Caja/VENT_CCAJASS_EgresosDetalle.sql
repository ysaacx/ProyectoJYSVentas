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