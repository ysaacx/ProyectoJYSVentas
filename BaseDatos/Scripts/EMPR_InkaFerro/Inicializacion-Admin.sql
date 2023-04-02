use bdsadmin


SELECT * FROM dbo.Usuarios WHERE USER_IdUser <> 104
SELECT * FROM dbo.Usuarios WHERE USER_IdUser <> 104

select * from empresas 
select * INTO #Empr from empresas WHERE EMPR_Codigo = 'SCCYR'

UPDATE #Empr 
  SET EMPR_Codigo = 'IFERR', EMPR_Desc = 'INVERSIONES INKASFERRO SRL'
    , EMPR_Direc = 'AV. MANCO CCAPAC'
	, EMPR_Telef1 = '084-277 373'
	, EMPR_Telef2 = '958 331 917'
	, EMPR_RUC = '20490262181'
	, EMPR_Email = 'inkasferro@hotmail.com'
	, EMPR_Servidor = 'SERVERIF\SQL12'
	, EMPR_BaseDatos = 'BDInkasFerro'
	, EMPR_CodApp = '745'
	, EMPR_BDFija = 0
	, EMPR_Isolation = 0
	, EMPR_UsrCrea = 'YSAACX'
	, EMPR_FecCrea = GETDATE()
	, EMPR_UsrMod = NULL
	, EMPR_FecMod = NULL
	, EMPR_Activo = 1


INSERT INTO dbo.Empresas
SELECT * FROM #Empr


DELETE  FROM dbo.UsuariosAplicaciones WHERE EMPR_Codigo <> 'IFERR'
DELETE FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo <> 'IFERR'

SELECT * FROM dbo.UsuariosPlantillas WHERE EMPR_Codigo <> 'IFERR'

SELECT * FROM dbo.Aplicaciones


DELETE FROM dbo.PlantillasMenu WHERE EMPR_Codigo <> 'IFERR'
DELETE FROM dbo.UsuariosProcesos WHERE EMPR_Codigo = 'I'
DELETE FROM dbo.UsuariosPlantillas WHERE EMPR_Codigo <> 'IFERR'
DELETE FROM dbo.PlantillasMenu WHERE EMPR_Codigo <> 'SCCYR'

UPDATE #PLAMENU SET EMPR_Codigo = 'IFERR'
INSERT INTO dbo.PlantillasMenu 
SELECT * FROM #PLAMENU


DELETE FROM Empresas WHERE EMPR_Codigo <> 'IFERR'

DELETE FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo <> 'IFERR'
DELETE FROM dbo.Usuarios WHERE NOT USER_IdUser IN (5, 104)


SELECT * FROM BDInkasFerro..Articulos