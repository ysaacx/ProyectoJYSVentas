USE BDPAKELUZ
go

--SELECT * FROM BDSisSCC..Ubigeos WHERE UBIGO_Descripcion LIKE '%CUS%'
--SELECT * FROM BDSisSCC..Ubigeos WHERE LEFT(UBIGO_Codigo, 2) = '08'
--SELECT * FROM BDSisSCC..Sucursales
--SELECT * FROM BDDACEROSLAM..Sucursales
--SELECT * FROM BDCOMAFISUR..Sucursales
--SELECT * FROM BDInkaPeru..Sucursales

SELECT * FROM dbo.PuntoVenta
SELECT * FROM dbo.Sucursales
SELECT * FROM dbo.Almacenes
SELECT * FROM BDSAdmin..Sucursales
SELECT * FROM BDSAdmin..Empresas

SELECT * FROM BDSAdmin..Usuarios

UPDATE BDSAdmin..Usuarios SET USER_CodUsr = 'SISTEMAS', USER_DNI = '00000000' WHERE USER_CodUsr = 'SISTEMAS'

UPDATE BDSAdmin..Empresas SET EMPR_Servidor = 'SERVERSQL\SQL12'
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = 'SERVERSQL\SQL12'
UPDATE PuntoVenta SET PVENT_DireccionIP = 'SERVERSQL\SQL12', PVENT_DireccionIPAC = 'SERVERSQL\SQL12'

UPDATE BDSAdmin..Empresas SET EMPR_Servidor = '(LOCAL)\SQL12'
UPDATE BDSAdmin..Sucursales SET SUCUR_DireccionIP = '(LOCAL)\SQL12'
UPDATE PuntoVenta SET PVENT_DireccionIP = '(LOCAL)\SQL12', PVENT_DireccionIPAC = '(LOCAL)\SQL12'

UPDATE BDSAdmin..Empresas SET EMPR_RUC = '20491202069'
SELECT * FROM dbo.Parametros
UPDATE Parametros SET PARMT_Valor = '20491202069' WHERE PARMT_Id = 'Empresa'
UPDATE Parametros SET PARMT_Valor = 'INVERSIONES PAKELUZ S.R.L.' WHERE PARMT_Id = 'EmpresaRS'



USE BDSAdmin
go
Select m_usuariosplantillas.* , Pla.PTLA_Key As PTLA_Key
, Pla.PTLA_Relative As PTLA_Relative
, Us.USER_DNI As USER_DNI
 From dbo.UsuariosPlantillas As m_usuariosplantillas 
 Inner Join dbo.PlantillasMenu As Pla On Pla.APLI_Codigo = m_usuariosplantillas.APLI_Codigo And Pla.EMPR_Codigo = m_usuariosplantillas.EMPR_Codigo And Pla.PTLA_Codigo = m_usuariosplantillas.PTLA_Codigo
 Inner Join dbo.Usuarios As Us On Us.USER_IdUser = m_usuariosplantillas.USER_IdUser WHERE   ISNULL(Us.USER_DNI, '') = '00000000' AND  ISNULL(m_UsuariosPlantillas.EMPR_Codigo, '') = 'PAKEL' AND  ISNULL(m_UsuariosPlantillas.APLI_Codigo, '') = 'VTA'


 USE BDSAdmin
 GO
 
 SELECT * FROM dbo.Procesos WHERE PROC_Codigo = 'pg_PerStockNega'


 USE BDNOVACERO
 go


SELECT * FROM dbo.Parametros WHERE PARMT_Id= 'pg_PerStockNega'
update dbo.Parametros SET PARMT_Valor = '0' WHERE PARMT_Id= 'pg_PerStockNega'