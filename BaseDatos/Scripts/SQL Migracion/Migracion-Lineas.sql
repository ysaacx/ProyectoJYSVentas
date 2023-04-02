USE BDSVAlmacen
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
FROM BDACNet..Lineas


