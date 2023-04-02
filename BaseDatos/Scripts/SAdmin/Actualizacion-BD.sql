USE BDSAdmin
go

ALTER TABLE [dbo].[PlantillasMenu]
ADD [PTLA_CopyDefault] bit NULL
GO

ALTER TABLE [dbo].[PlantillasMenu]
ADD [PTLA_VisibleDefault] bit NULL
GO

ALTER TABLE [dbo].[Procesos]
ADD [PROC_CopyDefault] bit NULL
GO



UPDATE dbo.Procesos SET PROC_CopyDefault = 1

UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'CVP4D'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'DJGPV'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'DPIOR'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'FPMVE'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'LPUPC'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'MVFAC'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'PADPC'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'PBDVT'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'PCTCC'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'VPMVE'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'XOCDD'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'XOCDI'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'XPREP'
UPDATE dbo.Procesos SET PROC_CopyDefault = 0 WHERE PROC_Codigo = 'XPRPP'


--SELECT * FROM dbo.Usuarios

 exec USUARSD_UnReg @USER_IdUser=104,@EMPR_Codigo=N'00001',@APLI_Codigo=N'VTA'
 --exec APLISS_AplicacionesXUsuario @EMPR_Codigo=N'00001',@USER_IdUser=104

 exec USUARSI_UnReg @USER_IdUser=104,@EMPR_Codigo=N'00001',@APLI_Codigo=N'VTA',@Usuario=N'SISTEMAS'
 --exec APLISS_AplicacionesXUsuario @EMPR_Codigo=N'00001',@USER_IdUser=104

 Insert Into Procesos(APLI_Codigo,PROC_Codigo,PROC_Descripcion,PROC_UsrCrea,PROC_FecCrea)
Values('VTA', 'PCTCC', 'Caja - Permitir cambiar el tipo de cambio en la cancelacion de documentos', '40975980', GETDATE())


USE BDSAdmin
SELECT * FROM dbo.Procesos WHERE PROC_Codigo IN ('CPCAR', 'PDSKG', 'CPCXR', 'CPCXF')

UPDATE BDSAdmin.dbo.Procesos SET APLI_Codigo = 'VTA' WHERE PROC_Codigo IN ('CPCAR', 'PDSKG', 'CPCXR', 'CPCXF')

INSERT INTO dbo.[Aplicaciones](APLI_Codigo, APLI_Nombre, APLI_Desc, APLI_NomArc, APLI_DirTra, APLI_TipoLic, APLI_TipoEnv, APLI_NumLic, APLI_NumEmpr, APLI_BaseDatos, APLI_Icono, APLI_Isolation, APLI_Activo, APLI_ConProceso, APLI_UsrCrea, APLI_FecCrea, APLI_UsrMod, APLI_FecMod) VALUES ('MSG', 'Master General', 'Master General', 'ACPMasterGeneral.exe', 'D:\Sistema\Master', NULL, NULL, NULL, NULL, 'BDMaster',  5 ,  0 ,  1 ,  0 , 'SISTEMAS' , '12-25-2017 10:34:48' , 'SISTEMAS' , '07-21-2018 11:56:30' )


SELECT * FROM dbo.Aplicaciones

UPDATE Aplicaciones SET APLI_Activo = 0 WHERE APLI_Codigo = 'CON'
UPDATE Aplicaciones SET APLI_Activo = 0 WHERE APLI_Codigo = 'LOG'
UPDATE Aplicaciones SET APLI_Activo = 0 WHERE APLI_Codigo = 'CTD'
UPDATE Aplicaciones SET APLI_Activo = 0 WHERE APLI_Codigo = 'ADM'