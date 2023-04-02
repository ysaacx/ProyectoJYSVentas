USE BDSAdmin
go


INSERT INTO dbo.Procesos( APLI_Codigo ,PROC_Codigo ,PROC_Descripcion ,PROC_UsrCrea ,PROC_FecCrea ,PROC_CopyDefault)
SELECT APLI_Codigo ,PROC_Codigo ,PROC_Descripcion ,PROC_UsrCrea ,PROC_FecCrea ,PROC_CopyDefault
FROM (
   SELECT APLI_Codigo = 'VTA' , PROC_Codigo = 'PMTPC' ,PROC_Descripcion =  'Cotización de Ventas - Permitir modificar la condición de venta' , PROC_UsrCrea = 'SISTEMAS' ,PROC_FecCrea= GETDATE() , PROC_CopyDefault = 1 
) PRO
WHERE NOT PROC_Codigo IN (SELECT PROC_Codigo FROM dbo.Procesos)

