USE BDMaster
go

exec MOVISS_ImportarMovimientos @FecIni='2020-01-01 00:00:00',@FecFin='2020-12-31 00:00:00',@EMPR_Codigo=N'FISUR'
EXEC MOVISS_ActualizarDetalles @FecIni='2020-01-01 00:00:00',@FecFin='2020-12-31 00:00:00',@EMPR_Codigo=N'FISUR'


SELECT COUNT(*) FROM dbo.Kardex_valorado
SELECT * FROM dbo.Kardex_valorado WHERE Fecha BETWEEN '2020-01-01' AND '2020-12-31'
SELECT * FROM dbo.Kardex_valorado WHERE Fecha BETWEEN '2019-01-01' AND '2019-12-31'
--DELETE FROM dbo.Kardex_valorado 

SELECT * FROM dbo.Ventas WHERE Fecha BETWEEN '2019-01-01' AND '2019-12-31'
SELECT * FROM Total_Valorado
SELECT * FROM dbo.Movimientos
--delete FROM dbo.Total_Valorado
--ALTER TABLE Kardex_valorado ADD Periodo INT NOT NULL 

SELECT * FROM Total_Valorado WHERE Periodo = 2019
SELECT COUNT(*) FROM Kardex_valorado WHERE Periodo = 2019
SELECT TOP 100 * FROM Kardex_valorado WHERE Periodo = 2019
SELECT COUNT(*) FROM Kardex_valorado WHERE Periodo = 2020

 --DELETE FROM dbo.Kardex_valorado WHERE   Usuario = 'SISTEMAS' AND  Periodo = 2019


EXEC ARTISS_Consulta '2019'

SELECT * FROM dbo.Compras WHERE Id_Compra LIKE '%6223'

SELECT * FROM BDInkaPeru.Logistica.ABAS_DocsCompra WHERE DOCCO_Numero LIKE 6223
SELECT * FROM BDInkaPeru..Entidades WHERE ENTID_Codigo = '20402885549'
SELECT * FROM BDInkaPeru.Logistica.ABAS_DocsCompra WHERE ENTID_CodigoProveedor = '20402885549'




USE BDInkaPeru
GO
SELECT * FROM BDInkaPeru.Logistica.ABAS_DocsCompra WHERE DOCCO_Numero LIKE 6223
BEGIN TRAN x
UPDATE BDInkaPeru.Logistica.ABAS_DocsCompra SET DOCCO_FechaDocumento = '2019-07-18 15:54:24.000' WHERE DOCCO_Numero LIKE 6223
ROLLBACK TRAN x

exec LOG_DOCCOSS_TodosDocCompra @ZONAS_Codigo=N'84.00',@SUCUR_Id=1,@Cadena=N'EMPRESA SIDERURGICA DEL PERU S.A.A.',@Opcion=0,@Todos=1,@FecIni='2018-01-30 00:00:00',@FecFin='2021-12-11 00:00:00',@TipoRegistro=N'I'

sp_helptext LOG_DOCCOSS_TodosDocCompra
