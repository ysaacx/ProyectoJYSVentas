

INSERT INTO Entidades
SELECT * FROM BDSisSCC.dbo.Entidades
 WHERE ENTID_Codigo NOT IN (SELECT ENTID_Codigo FROM  Entidades)


SELECT * INTO #TMP_CLI FROM BDSisSCC.dbo.Clientes
 WHERE ENTID_Codigo NOT IN ((SELECT ENTID_Codigo FROM  dbo.Clientes))

UPDATE #TMP_CLI SET ZONAS_Codigo = '84.00'

INSERT INTO Clientes
SELECT * FROM #TMP_CLI


INSERT INTO EntidadesRoles
SELECT * FROM BDSisSCC.dbo.EntidadesRoles
WHERE ENTID_Codigo NOT IN (SELECT ENTID_Codigo FROM EntidadesRoles)


--SELECT * FROM BDSisSCC.dbo.Direcciones