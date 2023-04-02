USE BDInkasFerro_Almudena
go

UPDATE dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' 
     , PVENT_BaseDatos = 'BDInkasFerro_Almudena'
     , PVENT_BDAdmin = 'BDSAdmin'

