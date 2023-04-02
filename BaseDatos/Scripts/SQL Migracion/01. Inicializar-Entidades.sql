
USE BDSVAlmacen
GO

SELECT * FROM dbo.Entidades 
SELECT * FROM dbo.EntidadesRoles WHERE ENTID_Codigo IN ('40975980', '74035051')
SELECT * FROM dbo.Roles

-- USUARIOS
DELETE FROM dbo.Conductores
DELETE FROM dbo.EntidadesRoles WHERE ENTID_Codigo NOT IN ('40975980', '74035051')
DELETE FROM dbo.EntidadRelacion
DELETE FROM dbo.Clientes
DELETE FROM dbo.Proveedores
DELETE FROM RRHH.PLAN_CuentasBancarias
DELETE FROM RRHH.PLAN_Trabajador WHERE ENTID_Codigo NOT IN ('40975980', '74035051')
DELETE FROM dbo.Direcciones
DELETE FROM Contabilidad.CONT_RelCuentasVentasDetalle WHERE ENTID_Codigo NOT IN ('40975980', '74035051')

--SELECT * FROM Tesoreria.TESO_SIniciales
--SELECT * FROM BDAdmin..Empresas
UPDATE Tesoreria.TESO_SIniciales SET ENTID_Codigo = '20600432606'

DELETE FROM dbo.Auditoria
DELETE FROM dbo.Entidades WHERE ENTID_Codigo NOT IN ('40975980', '74035051', '20600432606', '10740350515')
--ORDER BY E.ENTID_Nombres

SELECT * FROM dbo.Entidades






