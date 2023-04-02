USE BDCOMAFISUR
GO

EXEC VENT_CCAJASS_FacturasResumen @FecIni='2019-02-11 00:00:00',@FecFin='2019-02-11 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_Ingresos @FecIni='2019-02-11 00:00:00',@FecFin='2019-02-11 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_Egresos_Resumen @FecIni='2019-02-11 00:00:00',@FecFin='2019-02-11 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_SInicial_Resumen @FecIni='2019-02-11 00:00:00',@PVENT_Id=1
exec VENT_REPOSS_MovimientoEfectivo_Resumen @FecIni='2019-02-11 00:00:00',@FecFin='2019-02-11 00:00:00',@PVENT_Id=1
exec VENT_CCAJASS_EgresosDetalle @FecIni='2019-02-11 00:00:00',@FecFin='2019-02-11 00:00:00',@PVENT_Id=1
go
