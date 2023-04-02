USE BDInkasFerro
GO

IF NOT EXISTS(SELECT  SYSCOLUMNS.NAME FROM SYSOBJECTS JOIN SYSCOLUMNS   ON SYSOBJECTS.ID = SYSCOLUMNS.ID
			   WHERE SYSOBJECTS.NAME = 'ABAS_DocsCompra' AND SYSCOLUMNS.NAME= 'DOCCO_TipoRegistro') 

	ALTER TABLE [Logistica].[ABAS_DocsCompra]
	ADD [DOCCO_TipoRegistro] char(1) NULL
GO


IF NOT EXISTS(SELECT * FROM sys.extended_properties prop INNER JOIN sys.all_columns colum ON colum.column_id = prop.minor_id AND colum.object_id = prop.major_id INNER JOIN sys.all_objects tb ON tb.object_id = colum.object_id 
               WHERE prop.name = 'MS_Description' AND class = 1 AND tb.name = 'ABAS_DocsCompra' AND colum.name = 'DOCCO_TipoRegistro')

	EXEC sp_addextendedproperty 'MS_Description', N'Tipo de Registro
	R: Registro de Compra
	I: Registro e Ingreso de Mercaderia', 'schema', 'Logistica', 'table', 'ABAS_DocsCompra', 'column', 'DOCCO_TipoRegistro'
GO

UPDATE Logistica.ABAS_DocsCompra SET DOCCO_TipoRegistro = 'I' WHERE DOCCO_TipoRegistro IS NULL 
UPDATE dbo.Parametros SET PARMT_Valor = '3.3.1.5' WHERE PARMT_Id = 'pg_Version'

USE BDSisSCC
SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_TipoRegistro IS NULL 

--exec LOG_DOCCOSS_TodosDocCompra @ZONAS_Codigo=N'83.00',@SUCUR_Id=1,@Cadena=N'',@Opcion=0,@Todos=0,@FecIni='2017-12-01 00:00:00',@FecFin='2017-12-20 00:00:00',@TipoRegistro=N'T'

