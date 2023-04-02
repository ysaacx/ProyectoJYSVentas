USE BDAmbientaDecora

USE BDAdmin

Select * from [dbo].[Empresas] Where   ISNULL(EMPR_Codigo, '') = 'ADECO'

SELECT * FROM dbo.PlantillasMenu WHERE APLI_Codigo = 'CON'


BEGIN TRAN X
INSERT INTO dbo.PlantillasMenu(
 APLI_Codigo,EMPR_Codigo,PTLA_Codigo,PTLA_Key,PTLA_Relative,PTLA_Text,PTLA_Activo,PTLA_UsrCrea,PTLA_FecCrea) VALUES ( 'CON'
,'ADECO'
,'Base'
,0
,0
,'BDAdmin'
,'A'
,'YSAACX'
,'2016-06-08 22:36:22.987'
)

ROLLBACK TRAN X

SELECT * FROM dbo.Aplicaciones

INSERT INTO dbo.Aplicaciones
        ( APLI_Codigo ,
          APLI_Nombre ,
          APLI_Desc ,
          APLI_NomArc ,
          APLI_DirTra ,
          APLI_TipoLic ,
          APLI_TipoEnv ,
          APLI_NumLic ,
          APLI_NumEmpr ,
          APLI_BaseDatos ,
          APLI_Icono ,
          APLI_Isolation ,
          APLI_UsrCrea ,
          APLI_FecCrea ,
          APLI_UsrMod ,
          APLI_FecMod ,
          APLI_Activo ,
          APLI_ConProceso
        )
VALUES  ( 'CON' , -- APLI_Codigo - char(3)
          'Contabilidad' , -- APLI_Nombre - varchar(50)
          'Sistema de Contabilidad' , -- APLI_Desc - varchar(255)
          'ACReporContables.exe' , -- APLI_NomArc - varchar(50)
          'D:\Sistemas\Contabilidad' , -- APLI_DirTra - varchar(255)
          NULL , -- APLI_TipoLic - char(3)
          NULL , -- APLI_TipoEnv - char(3)
          NULL , -- APLI_NumLic - varchar(20)
          NULL , -- APLI_NumEmpr - varchar(20)
          'BDAmbientaDecora' , -- APLI_BaseDatos - varchar(50)
          1 , -- APLI_Icono - int
          0 , -- APLI_Isolation - bit
          'SISTEMAS' , -- APLI_UsrCrea - Usuario
          GETDATE() , -- APLI_FecCrea - Fecha
          NULL , -- APLI_UsrMod - Usuario
          NULL , -- APLI_FecMod - Fecha
          1 , -- APLI_Activo - bit
          1 -- APLI_ConProceso - bit
        )