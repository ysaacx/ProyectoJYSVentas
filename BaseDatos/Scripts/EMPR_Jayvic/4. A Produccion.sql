
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'SERVERJAYVIC\SQL12'

UPDATE PuntoVenta 
   SET PVENT_DireccionIP = 'SERVERJAYVIC\SQL12', PVENT_DireccionIPAC = 'SERVERJAYVIC\SQL12' 
     , PVENT_BaseDatos = 'BDJAYVIC'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

--SELECT * FROM BDSAdmin..Empresas
UPDATE BDSAdmin..Empresas SET EMPR_Activo = 1



------
SELECT * FROM dbo.Tipos WHERE TIPOS_Descripcion LIKE 'Fact%'
SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'

UPDATE dbo.Tipos SET TIPOS_Items = 50 WHERE TIPOS_Codigo = 'CPD01'
UPDATE dbo.Tipos SET TIPOS_Items = 50 WHERE TIPOS_Codigo = 'CPD03'