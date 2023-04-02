USE BDAmbientaDecora
GO

SELECT * FROM Lineas

DELETE FROM Lineas

INSERT INTO Lineas(LINEA_Codigo
, LINEA_CodPadre
, TIPOS_CodTipoComision
, LINEA_Nombre
, LINEA_UsrCrea
, LINEA_FecCrea)
SELECT LINEA_Codigo
, LINEA_CodPadre
, TIPOS_CodTipoComision
, LINEA_Nombre
, LINEA_UsrCrea
, LINEA_FecCrea
FROM (

	SELECT LINEA_Codigo = '01', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'TELA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '02', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ACCESORIOS', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE()
) LINEAS_PADRE

INSERT INTO Lineas(LINEA_Codigo
, LINEA_CodPadre
, TIPOS_CodTipoComision
, LINEA_Nombre
, LINEA_UsrCrea
, LINEA_FecCrea)
SELECT LINEA_Codigo = '01' + RIGHT('00' + RTRIM(ROW_NUMBER() OVER(ORDER BY LINEA_Codigo ASC)), 2)
, LINEA_CodPadre = '01'
, TIPOS_CodTipoComision
, LINEA_Nombre = UPPER(LINEA_Nombre)
, LINEA_UsrCrea
, LINEA_FecCrea
FROM (
	
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Brocado', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Chenille', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Chintz', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Corderoy', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Cretona', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Damasco', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Espolinado', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Gasa', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Jaquard', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Lona', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Loneta', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Madrás', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Moaré', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Muselina', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Organza u Organdí', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Otomán', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Pana', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Percal', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Piqué', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Shangtung', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Terciopelo', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'Toile de Jouy', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ACETATO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'AIDA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ALEMANISCO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ALENCON', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ALGODÓN', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ASIS', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'BATISTA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'BAYADERA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'BROCADILLO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'BROCATEL', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CACHEMIR', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CAÑAMAZO DE BORDAR', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CASSIMÉRE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CREPÉ-GEORGETTE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CRËPON', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CRESPÓN', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CRETONA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CRINOLINA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CUTÍ', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CHAMBRAY', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CHANTILLÍ', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CHARMEAU ó SATÉN CHARMEUSSE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CHEVIOT', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CHIFFÓN ó SHIFON', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CREPÉ', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'D´ALENCON', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'DENIM ó JEAN ó VAQUERO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'DRIL', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'DUPIONI DE SEDA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'DUVETIN', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'ENCAJE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'FALLA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'FIELTRO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'GABARDINA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'GAZAR', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'GEORGETTE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'GUIPURE ó VALENCIENNES', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'LONA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'MIKADO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'MOARÉ o MOIRÉE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'RASO O SATÉN', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'SEDA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'SEDA CHARMEUSE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'SOUTACHE', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'TAFETA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'TAFETÁN', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'TUL', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0101', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'TWEED', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() 
) LINEAS_NUEVAS
WHERE LINEA_Codigo NOT IN (SELECT LINEA_Codigo FROM LINEAS)
ORDER BY LINEA_Nombre


INSERT INTO Lineas(LINEA_Codigo
, LINEA_CodPadre
, TIPOS_CodTipoComision
, LINEA_Nombre
, LINEA_UsrCrea
, LINEA_FecCrea)
SELECT LINEA_Codigo = '02' + RIGHT('00' + RTRIM(ROW_NUMBER() OVER(ORDER BY LINEA_Codigo ASC)), 2)
, LINEA_CodPadre = '02'
, TIPOS_CodTipoComision
, LINEA_Nombre = UPPER(LINEA_Nombre)
, LINEA_UsrCrea
, LINEA_FecCrea
FROM (
	
	SELECT LINEA_Codigo = '0201', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'BARRAS DE CORTINA', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0201', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'CABLES DE ACERO', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0201', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'SISTEMA DE RIELES', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() UNION
	SELECT LINEA_Codigo = '0201', LINEA_CodPadre = NULL, TIPOS_CodTipoComision = NULL, LINEA_Nombre = 'OTROS', LINEA_UsrCrea = 'SISTEMAS', LINEA_FecCrea = GETDATE() 
) LINEAS_NUEVAS
WHERE LINEA_Codigo NOT IN (SELECT LINEA_Codigo FROM LINEAS)
ORDER BY LINEA_Nombre






