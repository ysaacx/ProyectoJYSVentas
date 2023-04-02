USE BDSisSCC
GO
--exec VENT_REPOSS_MovimientoEfectivo @FecIni='2018-08-01 00:00:00',@FecFin='2018-08-13 00:00:00',@PVENT_Id=1

DECLARE @FecIni DATETIME = '2018-08-11'
--DECLARE @FecIni DATETIME = '2018-08-01'
DECLARE @FecFin DATETIME = '2018-08-11'
DECLARE @PVENT_Id BIGINT = 1


DROP TABLE #Inicial

  SELECT SUM(Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) END) As ImpDolares
       , SUM(CONVERT(Decimal(14, 4), 0.00)) As EImpDolares
       , SUM(Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) END) As ImpSoles
       , SUM(CONVERT(Decimal(14, 4), 0.00)) As EImpSoles
       , 'Ingreso de Efectivo por Cancelación de Facturas' As Glosa
       , Fecha = CONVERT(DATE, DPAGO_Fecha)
    INTO #Inicial
    FROM Tesoreria.TESO_DocsPagos As Doc
   Inner Join Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
   Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo
   Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
   Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
   Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
   Inner Join Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
   Inner Join Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
   WHERE Doc.TIPOS_CodTipoDocumento = 'DPG01'
     And Convert(Date, DPAGO_Fecha) < @FecIni
     And Doc.PVENT_Id = @PVENT_Id
   GROUP BY CONVERT(DATE, DPAGO_Fecha) --, MONTH(DPAGO_Fecha)
   UNION All /* Egreso en Efectivo por Cancelacion de Documentos */
  SELECT SUM(Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End) As ImpDolares
       , SUM(Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End) As EImpDolares
       , SUM(Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End) As ImpSoles
       , SUM(Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End) As EImpSoles
       , 'Egreso en Efectivo por Cancelacion de Documentos' As Glosa
       , Fecha = (CONVERT(DATE, Rec.RECIB_Fecha))
    FROM Tesoreria.TESO_Recibos As Rec
    Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
   Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
    Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
    Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo
    Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
    Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
   WHERE Convert(Date, Rec.RECIB_Fecha) < @FecIni
     And Rec.RECIB_Estado <> 'X' 
   GROUP BY CONVERT(DATE, Rec.RECIB_Fecha)--, MONTH(Rec.RECIB_Fecha)
   UNION All /* Egresos por Prestamo de Efectivo */
  SELECT 0.00
       , SUM(Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) END) As ImpDolares
       , 0.00
       , SUM(Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) END) As ImpSoles
       , 'Egresos por Prestamo de Efectivo' As Glosa
       , Fecha = (CONVERT(DATE, CCI.CAJAC_Fecha))
    FROM Tesoreria.TESO_CajaChicaIngreso As CCI
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE Convert(Date, CCI.CAJAC_Fecha) < @FecIni
     AND CCI.CAJAC_Estado <> 'X'
   GROUP BY CONVERT(DATE, CCI.CAJAC_Fecha) --, MONTH(CCI.CAJAC_Fecha)
   UNION All /* Ingreso de las devoluciones en Efectivo */
  SELECT 0.00
       , 0.00
       , SUM(CCP.CAJAP_Importe)
       , 0.00
       , 'Ingreso de las devoluciones en Efectivo' As Glosa
       , Fecha = (CONVERT(DATE, CCP.CAJAP_Fecha))
    FROM Tesoreria.TESO_CajaChicaPagos As CCP
   Inner Join Tesoreria.TESO_CajaChicaIngreso As CCI On CCI.CAJAC_Id = CCP.CAJAC_Id 
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCI.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE CCP.TIPOS_CodTipoPago = 'TPC02'
     And Convert(Date, CCP.CAJAP_Fecha) < @FecIni
     AND CCP.CAJAP_Estado <> 'X'
   GROUP BY CONVERT(DATE, CCP.CAJAP_Fecha) --, MONTH(CCP.CAJAP_Fecha)
   UNION All /* Saldo Inicial */
  SELECT Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
       , 0.00
       , Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
       , 0.00
       , 'Saldo Inicial ' As Glosa
       , '2018-08-13'
    FROM Tesoreria.TESO_SIniciales 
   WHERE PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

--Select * From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

SELECT ImpSoles  = SUM(ImpSoles) 
     , EImpSoles = SUM(EImpSoles)
     , Glosa = (SELECT stuff((SELECT '/ ' + Glosa
                  FROM #Inicial Ini 
                 WHERE Ini.Fecha = Base.Fecha FOR XML path('')), 1, 1, ''))
     , Fecha
  FROM #Inicial Base
 GROUP BY Fecha
 ORDER BY Fecha

SELECT ImpSoles  = SUM(ImpSoles) 
     , EImpSoles = SUM(EImpSoles)
     --, Glosa = (SELECT stuff((SELECT '/ ' + Glosa
     --             FROM #Inicial Ini 
     --            WHERE Ini.Fecha = Base.Fecha FOR XML path('')), 1, 1, ''))
     , Año = YEAR(Fecha)
     , Mes = MONTH(Fecha)
  FROM #Inicial Base
 GROUP BY YEAR(Fecha), MONTH(Fecha)
 ORDER BY Año, Mes

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial From #Inicial

Select SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial, Glosa From #Inicial Group By Glosa


