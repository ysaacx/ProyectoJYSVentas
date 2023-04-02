USE BDDakaConsultores
GO
-- +---------------------------------------------------------------------------------------+ --
-- ACTUALIZAR EN PRODUCCION

--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = RECIB_Importe + 332.1100 WHERE RECIB_Codigo = 'RE0010000002'
--UPDATE Tesoreria.TESO_Recibos SET RECIB_Importe = 275834.32 WHERE RECIB_Codigo = 'RE0010000002'
--
---exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-21 00:00:00',@PVENT_Id=1


exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-22 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-23 00:00:00',@PVENT_Id=1

SELECT 22451.49 - 17605.29


--exec TESO_SENCISS_VerificarIngreso @FecIni='2022-02-23 00:00:00'

--exec VENT_CCAJASS_FacturasResumen @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Ingresos @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Egresos_Resumen @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_SInicial_Resumen @FecIni='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_EgresosDetalle @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1
--exec VENT_CCAJASS_Pendientes_Resumen @FecIni='2022-02-23 00:00:00',@FecFin='2022-02-23 00:00:00',@PVENT_Id=1

