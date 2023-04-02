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

--DECLARE @FecIni DATETIME = '2022-02-19'
--DECLARE @PVENT_Id BIGINT = 1

--248102.21
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 275834.32 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 0 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 95158.41 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 100552.1400 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 95225.96 WHERE RECIB_Codigo = 'RE0010000002'
-->UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 109337.04 WHERE RECIB_Codigo = 'RE0010000002'
-->UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 108925.96 WHERE RECIB_Codigo = 'RE0010000002'

  SELECT ImpDolares     = CASE Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpDolares    = CONVERT(Decimal(14, 4), 0.00)
       , ImpSoles       = CASE Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpSoles      = CONVERT(Decimal(14, 4), 0.00)
       , Glosa          = 'Ingreso de Efectivo por Cancelación de Facturas'
       , Doc.TIPOS_CodTipoDocumento
       , Caj.CAJA_Fecha
       , Caj.CAJA_FechaAnulado
       , Orden          = 1
    INTO #Inicial
    FROM Tesoreria.TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc
   INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
   INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id --AND CAJ.CAJA_Estado <> 'X'
   --INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
   INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
   WHERE Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01') --Doc.TIPOS_CodTipoDocumento = 'DPG01'
     AND Convert(Date, Caj.CAJA_Fecha) < @FecIni
     AND Doc.PVENT_Id = @PVENT_Id
     AND Doc.DPAGO_Estado <> 'X'
   UNION 
  SELECT Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpDolares
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpDolares
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As ImpSoles
       , Case Rec.TIPOS_CodTipoRecibo When 'CPDRE' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End) Else 0.00 End As EImpSoles
       , 'Egreso en Efectivo de Recibos de Ingreso/Egreso' As Glosa
       , Rec.TIPOS_CodTipoRecibo
       , Rec.RECIB_Fecha -- ISNULL(RDoc.DOCUS_Fecha, 
       , Rec.RECIB_FechaAnulacion
       , Orden          = 2
    FROM Tesoreria.TESO_Recibos As Rec
   INNER JOIN Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
   INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
   WHERE Convert(Date, Rec.RECIB_Fecha) < @FecIni
   UNION
  SELECT 0.00
       , Case CCI.TIPOS_CodTipoMoneda When 'MND2' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
       , 0.00
       , Case CCI.TIPOS_CodTipoMoneda When 'MND1' Then CCI.CAJAC_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
       , 'Egresos de Efectivo (Caja Chica)' As Glosa
       , Tipo = '---'
       , CCI.CAJAC_Fecha
       , CAJA_FechaAnulado = NULL 
       , Orden          = 3
    FROM Tesoreria.TESO_CajaChicaIngreso As CCI
   INNER Join Tipos As Mon On Mon.TIPOS_Codigo = CCi.TIPOS_CodTipoMoneda
    Left Join Entidades As Ent On Ent.ENTID_Codigo = CCI.ENTID_Codigo
   WHERE Convert(Date, CCI.CAJAC_Fecha) < @FecIni
     And CCI.CAJAC_Estado <> 'X'
   UNION 
  SELECT 0.00
       , 0.00
       , ImpSoles = 0.00
       , EImpSoles = CASE Caj.TIPOS_CodTipoMoneda WHEN 'MND1' THEN CONVERT(DECIMAL(12, 4), Caj.CAJA_Importe) ELSE CONVERT(DECIMAL(14, 4), 0.00) END
       , 'Recibo de Egreso por Anulación de Pago' AS Titulo
       , Tipo = Caj.TIPOS_CodTransaccion
       , Caj.CAJA_Fecha
       , Caj.CAJA_FechaAnulado
         --, TDoc.TIPOS_DescCorta + ' ' + VDOC.DOCVE_Serie + '-' + Right('0000000' + RTrim(VDOC.DOCVE_Numero), 7) As Documento
       , Orden          = 4
    FROM Tesoreria.TESO_Caja AS Caj
   INNER JOIN Ventas.VENT_DocsVenta VDOC ON VDOC.DOCVE_Codigo = Caj.DOCVE_Codigo
   INNER JOIN Tipos AS TDoc ON TDoc.TIPOS_Codigo = VDOC.TIPOS_CodTipoDocumento
   WHERE Caj.CAJA_AnuladoCaja = 1
     AND CONVERT(DATE, Caj.CAJA_FechaAnulado) < @FecIni
     AND Caj.PVENT_Id = @PVENT_Id
--   UNION 
  --Select 0.00
  --     , 0.00
  --     , ImpSoles = 0.00
  --     , EImpSoles = CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) END 
  --     , 'Recibo de Egreso por Anulación Documento de Venta' As Titulo
  --     , Tipo = Caj.TIPOS_CodTipoDocumento
  --     , Caj.CAJA_Fecha
  --     , CAJA_FechaAnulado = VDOC.DOCVE_FecAnulacion
  --     --, TDoc.TIPOS_DescCorta + ' ' + VDOC.DOCVE_Serie + '-' + Right('0000000' + RTrim(VDOC.DOCVE_Numero), 7) As Documento
  --     , Orden          = 5
  --  FROM Tesoreria.TESO_Caja As Caj
  -- INNER JOIN Ventas.VENT_DocsVenta VDOC ON VDOC.DOCVE_Codigo = Caj.DOCVE_Codigo
  -- Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = VDOC.TIPOS_CodTipoDocumento
  -- WHERE Caj.CAJA_AnuladoCaja = 0
  --   AND Convert(Date, VDOC.DOCVE_FecAnulacion) < @FecIni
  --   AND Caj.PVENT_Id = @PVENT_Id
   UNION
  SELECT CASE Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecIni
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecIni
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And Convert(Date, CAJA_FechaAnulado) >= @FecIni
					 ), 0))
			
		 Else 0.00
		 End
	     AS PendienteDolares
       , 0.00
       
       ,  (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) <= @FecIni
					--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
					And CAJA_Estado <> 'X'
					), 0)
		- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
					--And Convert(Date, CAJA_Fecha) <= @FecFin
					And CAJA_Estado = 'X'
					And CAJA_AnuladoCaja = 1
					--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
					And Convert(Date, CAJA_FechaAnulado) > @FecIni
					), 0))
		  
	      AS PendienteSoles
       , 0.00
       , 'Pendientes de Pago' As Titulo
       , Tipo = Ent.TIPOS_CodTipoDocumento
       , Ven.DOCVE_FechaTransaccion
       , Ven.DOCVE_FecAnulacion
       --, TDoc.TIPOS_DescCorta + ' ' + VDOC.DOCVE_Serie + '-' + Right('0000000' + RTrim(VDOC.DOCVE_Numero), 7) As Documento
       , Orden          = 6
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	--Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	--Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where Convert(Date, Ven.DOCVE_FechaTransaccion) < @FecIni
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
    AND ( (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecIni
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						--And Not Caj.TIPOS_CodTransaccion In ('TPG03')
						And Convert(Date, CAJA_FechaAnulado) >= @FecIni
					 ), 0))
		 )> 0


  UNION 
  SELECT ImpDolares     = CASE Doc.TIPOS_CodTipoMoneda When 'MND2' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpDolares    = CONVERT(Decimal(14, 4), 0.00)
       , ImpSoles       = CASE Doc.TIPOS_CodTipoMoneda When 'MND1' Then caj.CAJA_Importe Else Convert(Decimal(14, 2), 0.00) End
       , EImpSoles      = CONVERT(Decimal(14, 4), 0.00)
       , Glosa          = 'Ingreso por Facturas Anuladas'
       , Doc.TIPOS_CodTipoDocumento
       , Caj.CAJA_Fecha
       , Ven.DOCVE_FecAnulacion
       , Orden          = 7
    FROM Tesoreria.TESO_DocsPagos Doc  -- Tesoreria.TESO_DocsPagos As Doc
   INNER JOIN Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id AND DCaj.PVENT_Id = Doc.PVENT_Id
   INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo AND Caj.PVENT_Id = DCaj.PVENT_Id --AND CAJ.CAJA_Estado <> 'X'
   --INNER JOIN Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
   INNER JOIN Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo --And Ven.DOCVE_Estado <> 'X'
   WHERE Doc.TIPOS_CodTipoDocumento IN ('DPG01', 'TPG01') --Doc.TIPOS_CodTipoDocumento = 'DPG01'
     AND Convert(Date, Ven.DOCVE_FecAnulacion) <= @FecIni AND Convert(Date, Ven.DOCVE_FecAnulacion) <> Convert(Date, Ven.DOCVE_FechaTransaccion)
     AND Doc.PVENT_Id = @PVENT_Id
     AND Ven.DOCVE_Estado = 'X'
-- ========================================================================================================= --
SELECT SUM(ImpDolares - EImpDolares) As SaldoInicialDol, SUM(ImpSoles - EImpSoles) As SaldoInicial , Fecha = @FecIni
  FROM #Inicial

-- ========================================================================================================= --
--SELECT ImpSoles = SUM(ImpSoles)
--     , EImpSoles = SUM(EImpSoles)
--     , Glosa
--     , Orden
--  FROM #Inicial GROUP BY Glosa, Orden

--SELECT * FROM #Inicial WHERE Orden IN (1) ORDER BY ImpSoles
--SELECT ImpSoles = SUM(ImpSoles) 
--     , EImpSoles = SUM(EImpSoles)
--     , Diferencia = SUM(ImpSoles) - SUM(EImpSoles)
--  FROM #Inicial 

DROP TABLE #Inicial

END 
GO

exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-19',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-20',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-21',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-22',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-23',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-24',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-25',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-26',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-27',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-28',@PVENT_Id=1


DECLARE @FecIni DATETIME = '2022-02-22'
DECLARE @FecFin DATETIME = '2022-02-22'
DECLARE @PVENT_Id BIGINT = 1
