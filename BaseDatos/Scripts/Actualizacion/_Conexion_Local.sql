--USE BDInkasFerro_Almudena
--USE BDInkasFerro_Parusttacca
USE BDInkaPeru
--SELECT * FROM BDSAdmin..Sucursales
update BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'YSAACX-LP\SQL12'

UPDATE BDSisSCC.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDSisSCC'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

--SELECT * FROM BDSAdmin..Empresas
UPDATE BDSAdmin..Empresas SET EMPR_Activo = 1

GO
/*===============================================================================================================*/
--SELECT * FROM dbo.PuntoVenta

SELECT * FROM BDSAdmin..Empresas
SELECT * FROM BDSAdmin..Sucursales

SELECT * FROM BDInkasFerro_PA.dbo.Sucursales

UPDATE BDSAdmin..Empresas SET EMPR_BaseDatos = 'BDInkasFerro_PA' WHERE EMPR_Codigo = 'IFERR'

UPDATE BDInkasFerro_PA.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_PA', PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

UPDATE BDInkasFerro_PA.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_AL', PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 2

UPDATE BDInkasFerro_AL.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_AL', PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

UPDATE BDInkasFerro_AL.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' , PVENT_BaseDatos = 'BDInkasFerro_AL', PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 2

/*===============================================================================================================*/


--SELECT * FROM BDInkasFerro_Parusttacca.dbo.PuntoVenta 
UPDATE BDInkasFerro_Parusttacca.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDInkasFerro_Parusttacca'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

UPDATE BDInkasFerro_Parusttacca.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDInkasFerro_Almudena'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 2

--SELECT * FROM BDSAdmin..Sucursales
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'YSAACX-LP\SQL12' WHERE EMPRE_Codigo = 'IFERR'

--SELECT * FROM BDSAdmin..Empresas WHERE EMPR_Codigo = 'IFERR'
UPDATE BDSAdmin..Empresas SET EMPR_BaseDatos = 'BDInkasFerro_Parusttacca' WHERE EMPR_Codigo = 'IFERR'

/*===============================================================================================================*/

--USE BDInkasFerro_Almudena_20180117
--go

--UPDATE BDInkasFerro_Almudena_20180117.dbo.PuntoVenta 
--   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
--     , PVENT_BaseDatos = 'BDInkasFerro_Parusttacca'
--     , PVENT_BDAdmin = 'BDSAdmin'
-- WHERE PVENT_Id = 1

--UPDATE BDInkasFerro_Almudena_20180117.dbo.PuntoVenta 
--   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
--     , PVENT_BaseDatos = 'BDInkasFerro_Almudena_20180117'
--     , PVENT_BDAdmin = 'BDSAdmin'
-- WHERE PVENT_Id = 2

 
--SELECT * FROM BDSAdmin..Sucursales
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'YSAACX-LP\SQL12' WHERE EMPRE_Codigo = 'IFERR'

--BDInkasFerro_Almudena_20180117

/*===============================================================================================================*/

USE BDImportacionesZegarra
go

UPDATE BDImportacionesZegarra.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDImportacionesZegarra'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

 /*===============================================================================================================*/

 UPDATE BDInkaPeru.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' 
     , PVENT_BaseDatos = 'BDInkaPeru'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1
 
 SELECT * FROM BDInkaPeru..PuntoVenta
 SELECT * FROM BDSAdmin..Empresas

  /*===============================================================================================================*/
UPDATE BDJAYVIC.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' 
     , PVENT_BaseDatos = 'BDJAYVIC'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1
 
 SELECT * FROM BDInkaPeru..PuntoVenta
 SELECT * FROM BDSAdmin..Empresas

 /*===============================================================================================================*/

 UPDATE BDDakaConsultores.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' 
     , PVENT_BaseDatos = 'BDDakaConsultores'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

 SELECT * FROM BDDakaConsultores..PuntoVenta


 /*===============================================================================================================*/

 UPDATE BDInkaPeru.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(local)\SQL12', PVENT_DireccionIPAC = '(local)\SQL12' 
     , PVENT_BaseDatos = 'BDInkaPeru'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

 --SELECT * FROM BDSAdmin..Empresas

 /*===============================================================================================================*/
 
UPDATE BDSisSCC.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDSisSCC'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

UPDATE BDSisCARLO.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDSisCARLO'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1
 SELECT * FROM BDSisCARLO.dbo.PuntoVenta 
 --SCC-Server\SQL12
 --BDSisCARLO

  /*===============================================================================================================*/

 UPDATE BDJYM.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDJYM'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1


-- SELECT * FROM BDSAdmin..Sucursales

UPDATE BDSAdmin..Sucursales SET SUCUR_DIRECCIONIP = 'YSAACX-LP\SQL12'


/*===============================================================================================================*/

UPDATE BDCOMAFISUR.dbo.PuntoVenta 
   SET PVENT_DireccionIP = '(Local)\SQL12', PVENT_DireccionIPAC = '(Local)\SQL12' 
     , PVENT_BaseDatos = 'BDCOMAFISUR'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1


UPDATE BDDACEROSLAM.dbo.PuntoVenta 
   SET PVENT_DireccionIP = 'YSAACX-LP\SQL12', PVENT_DireccionIPAC = 'YSAACX-LP\SQL12' 
     , PVENT_BaseDatos = 'BDDACEROSLAM'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

 USE BDNOVACERO
 GO
 
UPDATE BDNOVACERO..PuntoVenta 
   SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12' 
     , PVENT_BaseDatos = 'BDNOVACERO'
     , PVENT_BDAdmin = 'BDSAdmin'
 WHERE PVENT_Id = 1

UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = '(LOCAL)\SQL12' WHERE EMPRE_Codigo = 'NOVAC'
UPDATE BDSAdmin..Empresas SET EMPR_Desc = 'NOVACERO' WHERE EMPR_Codigo = 'NOVAC'

SELECT * FROM BDNOVACERO..PuntoVenta 
SELECT * FROM BDSAdmin..Empresas

UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = '(LOCAL)\SQL12' WHERE EMPRE_Codigo = 'JAYVI'
UPDATE BDSAdmin..Empresas SET EMPR_Desc = 'NOVACERO'

-- USE BDSAdmin
--SELECT * FROM BDSAdmin..Empresas

SELECT * FROM BDSAdmin..Empresas
SELECT * FROM BDJAYVIC..PuntoVenta

--USE BDMasterActual
--GO

----Almacenes
----Compras
----Compras_Detalle
----StockInicial
----Stocks
----Ventas
----Ventas_Detalle
----[Movimientos]
----[Movimientos_Detalle]
----Total_Valorado

--SELECT * FROM BDSAdmin..Empresas