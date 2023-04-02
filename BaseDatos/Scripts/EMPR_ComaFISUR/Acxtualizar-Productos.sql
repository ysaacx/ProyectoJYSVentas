USE BDCOMAFISUR
GO


--SELECT * FROM BDSisSCC..Articulos
--SELECT * FROM Articulos
--SELECT * FROM Ventas.VENT_ListaPrecios
--SELECT * FROM Ventas.VENT_ListaPreciosArticulos
--SELECT * FROM BDCopy..Articulos_CFisur
--SELECT * FROM dbo.Precios
--SELECT * FROM BDSisSCC.dbo.Precios

BEGIN TRAN X

INSERT INTO dbo.Articulos
SELECT * FROM BDSisSCC..Articulos

SELECT * INTO #Prec FROM BDSisSCC.dbo.Precios
UPDATE #Prec SET ZONAS_Codigo = '84.00'

INSERT INTO Precios
SELECT * FROM #Prec

SELECT * INTO #LPArticulos FROM BDSisSCC.Ventas.VENT_ListaPreciosArticulos
UPDATE #LPArticulos SET ZONAS_Codigo = '84.00'

INSERT INTO Ventas.VENT_ListaPreciosArticulos
SELECT * FROM #LPArticulos

DROP TABLE #Prec
DROP TABLE #LPArticulos

COMMIT TRAN X



