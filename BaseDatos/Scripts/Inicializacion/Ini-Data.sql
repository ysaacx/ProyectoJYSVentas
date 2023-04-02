
USE BDSisSCC
GO

/* ELiminar Articulos *
delete FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%malograda%')
delete FROM dbo.Precios WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%malograda%')
delete FROM Logistica.LOG_StockIniciales WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%malograda%')
DELETE  FROM dbo.Articulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%malograda%')


--SELECT * FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*M*%'
delete FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*M*%')
delete FROM dbo.Precios WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*M*%')
delete FROM Logistica.LOG_StockIniciales WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*M*%')
DELETE  FROM dbo.Articulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*M*%')

delete FROM Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*%')
delete FROM dbo.Precios WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*%')
delete FROM Logistica.LOG_StockIniciales WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*%')
DELETE  FROM dbo.Articulos WHERE ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*%')

SELECT * FROM dbo.Articulos WHERE ARTIC_Detalle LIKE '%*%'

*/
/* Actualizar Entidades *
DELETE FROM dbo.EntidadesRoles WHERE ROLES_Id = 7 AND ENTID_Codigo <> '00000000000'
DELETE FROM dbo.EntidadesRoles WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.Clientes WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.UsuariosPorAlmacen WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.EntidadRelacion WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.EntidadRelacion WHERE ENTID_CodRelacion IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

UPDATE dbo.Clientes SET ENTID_CodigoVendedor = NULL WHERE NOT (LEN(ENTID_CodigoVendedor) = 8 or LEN(ENTID_CodigoVendedor) = 11) AND NOT ENTID_CodigoVendedor IN ('00000000', '00000000000', '', '40975980')

DELETE FROM dbo.Conductores WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.Proveedores WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.Entidades WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE NOT (LEN(ENTID_Codigo) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

*/

DELETE FROM dbo.EntidadesRoles WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.Clientes WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.UsuariosPorAlmacen WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.EntidadRelacion WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.EntidadRelacion WHERE ENTID_CodRelacion IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

UPDATE dbo.Clientes SET ENTID_CodigoVendedor = NULL WHERE ENTID_CodigoVendedor IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

DELETE FROM dbo.Conductores WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM dbo.Proveedores WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))
DELETE FROM RRHH.PLAN_CuentasBancarias WHERE TRABA_Codigo IN (SELECT TRABA_Codigo FROM RRHH.PLAN_Trabajador WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980')))
DELETE FROM RRHH.PLAN_Trabajador WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

DELETE FROM dbo.Direcciones WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))

DELETE FROM dbo.Entidades WHERE ENTID_Codigo IN (SELECT ENTID_Codigo FROM dbo.Entidades WHERE UBIGO_Codigo IS NULL AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980'))




--SELECT * FROM dbo.Clientes WHERE NOT (LEN(ENTID_CodigoVendedor) = 8 or LEN(ENTID_Codigo) = 11) AND NOT ENTID_Codigo IN ('00000000', '00000000000', '', '40975980')
--SELECT * FROM dbo.Entidades WHERE ENTID_RazonSocial LIKE '%Vendedor%'
--SELECT * FROM dbo.Entidades WHERE ENTID_Codigo IN ('00000000', '00000000000', '')



SELECT * FROM dbo.Entidades
--1000408092
--20100241022



SELECT * FROM dbo.Articulos

UPDATE Articulos SET ARTIC_Percepcion = 0 

SELECT * FROM BDSAdmin..Procesos WHERE APLI_Codigo = 'VTA'


USE BDSAdmin
GO

UPDATE dbo.Procesos SET PROC_CopyDefault = 1
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = ''

SELECT 'UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = '''+ PROC_Codigo + '''' FROM dbo.Procesos WHERE ISNULL(PROC_CopyDefault, 0) = 0 AND APLI_Codigo = 'VTA'

USE BDSisSCC
go
DELETE FROM Historial.VENT_ListaPreciosArticulos WHERE AUDIT_DataBase = 'BDACNet'