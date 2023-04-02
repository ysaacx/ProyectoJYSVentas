USE BDSisSCC
GO

SELECT * FROM dbo.Articulos WHERE YEAR(ARTIC_FecCrea) = 2018
SELECT * FROM Ventas.VENT_ListaPreciosArticulos
SELECT * FROM ventas.VENT_ListaPrecios
SELECT * FROM dbo.Precios WHERE TIPOS_CodTipoMoneda IS NULL 

update dbo.Precios SET TIPOS_CodTipoMoneda = 'MND1' WHERE TIPOS_CodTipoMoneda IS NULL 



SELECT * FROM BDSAdmin..Empresas
SELECT * FROM BDInkaPeru..PuntoVenta