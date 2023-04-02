--USE BDNOVACERO
--GO

--exec TESO_SENCISS_VerificarIngreso @FecIni='2020-11-25 00:00:00'
--exec VENT_CCAJASS_FacturasResumen @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Ingresos @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Egresos_Resumen @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_EgresosDetalle @FecIni='2020-11-25 00:00:00',@FecFin='2020-11-25 00:00:00',@PVENT_Id=1
--go





--exec TESO_SENCISS_VerificarIngreso @FecIni='2020-11-26 00:00:00'
--exec VENT_CCAJASS_FacturasResumen @FecIni='2020-11-26 00:00:00',@FecFin='2020-11-26 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Ingresos @FecIni='2020-11-26 00:00:00',@FecFin='2020-11-26 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Egresos_Resumen @FecIni='2020-11-26 00:00:00',@FecFin='2020-11-26 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-26 00:00:00',@PVENT_Id=1
--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2020-11-26 00:00:00',@FecFin='2020-11-26 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_EgresosDetalle @FecIni='2020-11-26 00:00:00',@FecFin='2020-11-26 00:00:00',@PVENT_Id=1
--go


--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-25 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2020-11-26 00:00:00',@PVENT_Id=1


--exec VENT_CAJASS_CuadrePendientes @FecFin='2020-11-28 00:00:00',@PVENT_Id=1,@Orden=0

--sp_helptext VENT_CAJASS_CuadrePendientes



Select 0.00
        , 0.00
        , CASE Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
        , 0.00
        , 'Recibo de Ingreso por Anulación' As Titulo
        , Caj.CAJA_Fecha
        , Caj.CAJA_FechaAnulado
        , *
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
      AND Convert(Date, Caj.CAJA_FechaAnulado) > '2020-11-18' AND Caj.CAJA_Fecha < '2020-11-18'
      --AND Convert(Date, Caj.CAJA_FechaAnulado) <= '2020-11-21' 
      --AND Convert(Date, Caj.CAJA_Fecha) <= '2020-11-16'
      AND Caj.PVENT_Id = 1


      /*
      Anulado 21/11/2020
      Creado  18/11/2020

      */
