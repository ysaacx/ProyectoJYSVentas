USE BDAmbientaDecora
GO

SELECT * FROM Articulos
SELECT * FROM BDCopy.DBO.Articulos
SELECT * FROM BDADyA.DBO.Articulos

INSERT INTO Articulos(ARTIC_Codigo
, LINEA_Codigo
, TIPOS_CodTipoProducto
, TIPOS_CodCategoria
, TIPOS_CodUnidadMedida
, TIPOS_CodTipoColor
, ARTIC_Id
, ARTIC_Peso
, ARTIC_Detalle
, ARTIC_Descripcion
, ARTIC_Percepcion
, ARTIC_Descontinuado
, ARTIC_Localizacion
, ARTIC_Orden
, ARTIC_ExistenciaMin
, ARTIC_ExistenciaMax
, ARTIC_PuntoReorden
, ARTIC_Estado
, ARTIC_CodigoAnterior
, ARTIC_UsrCrea
, ARTIC_FecCrea
, ARTIC_Numero
, RCVDT_Id
)
SELECT ARTIC_Codigo = '0101' + RTRIM('000' + RTRIM(CODIGO), 3)
	, LINEA_Codigo = '0101'
	, TIPOS_CodTipoProducto	= 'PRO2'	, TIPOS_CodCategoria = 'CTP2'
	, TIPOS_CodUnidadMedida	= 'UND12'	, TIPOS_CodTipoColor = 'CLR000'
	, ARTIC_Id = ROW_NUMBER() OVER(ORDER BY CODIGO ASC)
	, ARTIC_Peso = 0				
	, ARTIC_Detalle				, ARTIC_Descripcion
	, ARTIC_Percepcion			, ARTIC_Descontinuado	
	, ARTIC_Localizacion		, ARTIC_Orden			
	, ARTIC_ExistenciaMin		, ARTIC_ExistenciaMax	
	, ARTIC_PuntoReorden		, ARTIC_Estado				
	, ARTIC_CodigoAnterior		, ARTIC_UsrCrea
	, ARTIC_FecCrea				, ARTIC_Numero			
	, RCVDT_Id
FROM BDCopy.DBO.Articulos


SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'PRO%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'CTP%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'UND%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'CLR%'