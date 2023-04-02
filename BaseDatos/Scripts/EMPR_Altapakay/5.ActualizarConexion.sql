USE BDInkaPeru
go

DECLARE @PVENT_DireccionIP VARCHAR(25) = '(LOCAL)\SQL12'
DECLARE @EMPR_Codigo VARCHAR(5) = 'INKAP'

UPDATE dbo.PuntoVenta SET PVENT_DireccionIP = @PVENT_DireccionIP
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = @PVENT_DireccionIP WHERE EMPR_Codigo = @EMPR_Codigo
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = @PVENT_DireccionIP

--SELECT * FROM BDSAdmin..Sucursales

