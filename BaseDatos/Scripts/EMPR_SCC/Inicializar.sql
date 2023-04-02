USE bdSisScc
GO

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
/* Acceso */

--SELECT * FROM BDSAdmin..Empresas
UPDATE BDSAdmin..Empresas SET EMPR_Servidor = '(Local)\SQL12' WHERE EMPR_Codigo = 'SCCYR'
--SELECT * FROM BDSAdmin..Sucursales
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = '(Local)\SQL12'

UPDATE BDSisSCC.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12' 
     , PVENT_BaseDatos = 'BDSisSCC'
     , PVENT_BDAdmin = 'BDSAdmin'

UPDATE Parametros SET PARMT_Valor = '20600704495' WHERE PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = 'SCC COMERCIO Y REPRESENTACIONES SRL' WHERE PARMT_Id = 'EmpresaRS'

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
USE BDSisSCC
GO


SELECT * FROM dbo.PuntoVenta


 USE BDSAdmin
 GO
 
 SELECT * FROM dbo.Empresas
 UPDATE dbo.Empresas SET EMPR_Activo =1 WHERE EMPR_Codigo = 'SCCYR'

