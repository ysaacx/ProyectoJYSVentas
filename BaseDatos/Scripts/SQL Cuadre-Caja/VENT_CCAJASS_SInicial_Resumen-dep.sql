USE BDDakaConsultores
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
    
    DECLARE @FecFin DATETIME = @FecIni

    CREATE TABLE #Pendientes(Orden INT NULL, Titulo VARCHAR(100) NULL , Title VARCHAR(100) NULL, Fecha DATETIME NULL
                            , ENTID_RazonSocial VARCHAR(100) NULL, Documento VARCHAR(50) NULL, Moneda VARCHAR(10) NULL
                            , TCambioVenta DECIMAL(8, 4) NULL, ImpDolares DECIMAL(12,2) NULL, ImpSoles DECIMAL(12, 2) NULL
                            , ENTID_Codigo VARCHAR(20) NULL, DOCVE_Codigo VARCHAR(50) NULL, DOCVE_Serie VARCHAR(10) NULL, DOCVE_Numero VARCHAR(10) NULL
                            , TipoDocumento VARCHAR(10) NULL, TIPOS_Descripcion VARCHAR(100) NULL, TIPOS_CodTipoDocumento VARCHAR(10) NULL
                            , CAJA_Codigo VARCHAR(10) NULL, Detalle VARCHAR(100) NULL, DocDetalle VARCHAR(100) NULL)
    
    INSERT INTO #Pendientes
    EXEC VENT_CCAJASS_Pendientes_Resumen @FecIni = @FecIni,@FecFin = @FecFin,@PVENT_Id = @PVENT_Id

    SET @FecFin = DATEADD(DAY, -1, @FecIni)

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
       , Caj.CAJA_FechaAnulado
    INTO #Inicial
    FROM VW_Tesoreria_TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc
   INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
   INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id AND CAJ.CAJA_Estado <> 'X'
   INNER JOIN Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
   INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
   INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
    LEFT JOIN Tipos As TVen ON
     TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
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
       , Rec.RECIB_FechaAnulacion
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
       , CAJA_FechaAnulado = NULL 
    FROM Tesoreria.TESO_CajaChicaIngreso As CCI
   INNER Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE Convert(Date, CCI.CAJAC_Fecha) < @FecIni
     And CCI.CAJAC_Estado <> 'X'
   UNION All /* Ingreso de las devoluciones en Efectivo */
  --SELECT 0.00
  --     , 0.00
  --     , CCP.CAJAP_Importe
  --     , 0.00
  --     , 'Ingreso de las devoluciones en Efectivo' As Glosa
  --     , CCI.CAJAC_Fecha
  --     , CAJA_FechaAnulado = NULL 
  --  FROM Tesoreria.TESO_CajaChicaPagos As CCP
  -- Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
  -- Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
  --  Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
  -- WHERE CCP.TIPOS_CodTipoPago = 'TPC02'
  --   And Convert(Date, CCP.CAJAP_Fecha) < @FecIni
  --   AND CCP.CAJAP_Estado <> 'X'
  -- UNION All /* Saldo Inicial */
  --SELECT Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
  --     , 0.00
  --     , Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
  --     , 0.00
  --     , 'Saldo Inicial ' As Glosa
  --     , SINIC_Fecha
  --     , CAJA_FechaAnulado = NULL 
  --  FROM Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'
  --  UNION ALL 
   Select 0.00
        , 0.00
        , 0.00
        , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
        , 'Recibo de Egreso por Anulación' As Titulo
        , Caj.CAJA_Fecha
        , Caj.CAJA_FechaAnulado
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
      AND Convert(Date, Caj.CAJA_FechaAnulado) < @FecIni
      AND Caj.PVENT_Id = @PVENT_Id
      UNION ALL 
   Select 0.00
        , 0.00
        , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
        , 0.00
        , 'Recibo de Ingreso por Anulación - 2' As Titulo
        , Caj.CAJA_Fecha
        , Caj.CAJA_FechaAnulado
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
      AND Convert(Date, Caj.CAJA_FechaAnulado) >= @FecIni AND Caj.CAJA_Fecha < @FecIni
      AND Caj.PVENT_Id = @PVENT_Id
    UNION ALL
    SELECT ImpDolares     = ImpDolares
         , EImpDolares    = 0.00
         , ImpSoles       = ImpSoles
         , EImpSoles      = 0.00
         , Glosa          = 'Pendientes de Pago'
         , Fecha
         , FechaAnulado   = null
     FROM #Pendientes
    -- UNION ALL
    --SELECT ImpDolares     = ImpDolares
    --     , EImpDolares    = 0.00
    --     , ImpSoles       = ImpSoles
    --     , EImpSoles      = 0.00
    --     , Glosa          = 'Pendientes de Pago'
    --     , Fecha
    --     , FechaAnulado   = null
    -- FROM #Pendientes

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial 
     FROM #Inicial

   SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa 
     FROM #Inicial Group By Glosa

   --SELECT * FROM #Inicial ORDER BY CAJA_Fecha -- ImpSoles, EImpSoles
   
   --SELECT * FROM #Inicial WHERE EImpSoles > 0
   SELECT * FROM #Pendientes
   --SELECT * FROM #Inicial  WHERE ImpSoles = 332.1300
   --union
   --SELECT * FROM #Inicial  WHERE EImpSoles = 332.1300


END 
GO
--SELECT 246166.3100 + 1935.90 
--SELECT 332.1300 * 2
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 275834.32 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 0 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 246166.3100 + 1935.90 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 248102.2100 + 1935.90 WHERE RECIB_Codigo = 'RE0010000002'
--SELECT * FROM Tesoreria.TESO_Recibos WHERE RECIB_Codigo = 'RE0010000002'
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-18 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-19 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-23 00:00:00',@PVENT_Id=1
GO


--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-21 00:00:00',@PVENT_Id=1


--EXEC dbo.VENT_CCAJASS_SInicial_Resumen @FecIni = '2018-12-31', @PVENT_Id = 1 -- bigint
--EXEC dbo.VENT_CCAJASS_SInicial_Resumen @FecIni = '2019-01-07', @PVENT_Id = 1 -- bigint
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2019-02-11 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-09 00:00:00',@PVENT_Id=1

--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-18',@PVENT_Id=1

--SELECT * FROM Tesoreria.TESO_Recibos WHERE RECIB_Codigo = 'RE0010000002'



  --Select 0.00
  --      , 0.00
  --      , 0.00
  --      , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
  --      , 'Recibo de Egreso por Anulación' As Titulo
  --      , Caj.CAJA_Fecha
  --   FROM Tesoreria.TESO_Caja As Caj
  --  Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
  --  Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
  --  Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
  --  Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
  --   Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
  --   Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
  --   Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
  --   Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
  --  WHERE Caj.CAJA_AnuladoCaja = 1
  --    AND Convert(Date, Caj.CAJA_FechaAnulado) = '2022-02-19'
  --    AND Caj.PVENT_Id = 1


   --Select 0.00
   --     , 0.00
   --     , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
   --     , 0.00
   --     , 'Recibo de Ingreso por Anulación - 2' As Titulo
   --     , Caj.CAJA_Fecha
   --     , Caj.CAJA_FechaAnulado
   --  FROM Tesoreria.TESO_Caja As Caj
   -- Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
   -- Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
   -- Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
   -- Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
   --  Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
   --  Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
   --  Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
   --  Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
   -- WHERE Caj.CAJA_AnuladoCaja = 1
   --   --AND Convert(Date, Caj.CAJA_FechaAnulado) <=  '2022-02-20'
   --   AND Convert(Date, Caj.CAJA_FechaAnulado) >= '2022-02-20' AND Caj.CAJA_Fecha <= '2022-02-20'
   --   --AND Caj.CAJA_Fecha <= '2022-02-20'
   --   AND Caj.PVENT_Id = 1
