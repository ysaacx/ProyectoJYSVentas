USE BDNOVACERO
GO

SELECT art.ARTIC_Codigo, fami.LINEA_Nombre, sub.LINEA_Nombre, art.ARTIC_Descripcion,art.ARTIC_Peso FROM dbo.Articulos art
 INNER JOIN dbo.Lineas fami ON fami.LINEA_Codigo = LEFT(art.LINEA_Codigo, 2) --AND LEN(fami.LINEA_Codigo) = 2
 INNER JOIN dbo.Lineas sub ON sub.LINEA_Codigo = art.LINEA_Codigo
