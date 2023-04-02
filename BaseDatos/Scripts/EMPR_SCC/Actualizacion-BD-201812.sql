USE BDSisSCC
go

SELECT * FROM Ventas.VENT_PVentDocumento

UPDATE Ventas.VENT_PVentDocumento SET PVDOCU_TipoImpresion = 'K' WHERE TIPOS_CodTipoDocumento = 'CPD03'
UPDATE Ventas.VENT_PVentDocumento SET PVDOCU_TipoImpresion = 'K' WHERE TIPOS_CodTipoDocumento = 'CPD01'
