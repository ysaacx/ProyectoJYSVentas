--USE BDJAYVIC
USE BDNOVACERO
GO

---delete FROM dbo.EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR004'
SELECT * FROM dbo.EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR04'
SELECT * FROM dbo.EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR03'
SELECT * FROM tablapadron
SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'PDR%'


exec PADROSU_Finalizar @TipoDoc=4,@Usuario=N'00000000'

exec PADROSU_Finalizar @TipoDoc=3,@Usuario=N'00000000'

SELECT * FROM EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR' + RIGHT('00' + RTRIM(3), 2)
SELECT * FROM EntidadesPadrones WHERE TIPOS_CodTipoPadron = 'PDR03'

SELECT Ruc, COUNT(*) FROM tablapadron GROUP BY Ruc HAVING COUNT(*) > 1
SELECT * FROM tablapadron  WHERE ruc IN (SELECT Ruc FROM tablapadron GROUP BY Ruc HAVING COUNT(*) > 1)

SELECT * FROM dbo.Ubigeos WHERE UBIGO_Codigo LIKE '15.01.22%'

SELECT TOP 1000 * FROM Ventas.VENT_DocsVenta




exec VENT_DOCVESS_UnDocumento @DOCVE_Codigo=N'01F0010012223'

