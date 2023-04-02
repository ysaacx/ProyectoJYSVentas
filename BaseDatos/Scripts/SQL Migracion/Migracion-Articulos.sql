USE BDAmbientaDecora
GO
/*#########################################################################################################*/
--SELECT * FROM Articulos
--SELECT * FROM BDCopy.DBO.Articulos
--SELECT * FROM BDADyA.DBO.Articulos
/* ARTICULOS */

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
SELECT ARTIC_Codigo 
	, LINEA_Codigo 
	, TIPOS_CodTipoProducto	
	, TIPOS_CodUnidadMedida	
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
	, ARTIC_UsrCrea = 'SISTEMAS'
	, ARTIC_FecCrea	= GETDATE()
	, ARTIC_Numero 
	, RCVDT_Id 
FROM BDACNet..Articulos

/*#########################################################################################################*/
/* PRECIOS */

--SELECT * FROM BDADyA..Precios ORDER BY ARTIC_Codigo
--SELECT ARTIC_Codigo, count(*) FROM BDADyA..Precios group BY ARTIC_Codigo having count(*)>1

INSERT INTO Precios(ZONAS_Codigo
, ARTIC_Codigo
, TIPOS_CodTipoMoneda
, PRECI_Precio
, PRECI_TipoCambio
, PRECI_UsrCrea
, PRECI_FecCrea
)
SELECT ZONAS_Codigo 
, ARTIC_Codigo
, TIPOS_CodTipoMoneda 
, PRECI_Precio 
, PRECI_TipoCambio 
, PRECI_UsrCrea 
, PRECI_FecCrea 
FROM BDACNet..Precios

/*#########################################################################################################*/
/* LISTA DE PRECIOS VS ARTICULOS */
--SELECT * FROM  Ventas.VENT_ListaPreciosArticulos
--SELECT * FROM  BDADyA.Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = '0101001'
SELECT * FROM  Ventas.VENT_ListaPreciosArticulos WHERE ARTIC_Codigo = '0101001'
--DELETE FROM Ventas.VENT_ListaPreciosArticulos
delete FROM  Ventas.VENT_ListaPrecios WHERE LPREC_Id IN (3,4,5)

INSERT INTO Ventas.VENT_ListaPreciosArticulos(ZONAS_Codigo
, LPREC_Id
, ARTIC_Codigo
, ALPRE_Constante
, ALPRE_PorcentaVenta
, ALPRE_UsrCrea
, ALPRE_FecCrea)
SELECT ZONAS_Codigo
, LPREC_Id
, ARTIC_Codigo
, ALPRE_Constante
, ALPRE_PorcentaVenta 
, ALPRE_UsrCrea = 'SISTEMAS'
, ALPRE_FecCrea = GETDATE()
FROM BDACNet.Ventas.VENT_ListaPreciosArticulos 

/*#########################################################################################################*/
/* REGISTRAR PERIODOS */

--SELECT * FROM Periodos
--SELECT * FROM BDADyA..Periodos
UPDATE Periodos SET PERIO_StockActivo = 0

INSERT INTO Periodos(PERIO_Codigo
, PERIO_Descripcion
, PERIO_StockActivo
, PERIO_Lock
, PERIO_UsrCrea
, PERIO_FecCrea
, PERIO_Activo)
SELECT PERIO_Codigo = '2017'
, PERIO_Descripcion = 'PERIODO 2017'
, PERIO_StockActivo = 1
, PERIO_Lock = NULL
, PERIO_UsrCrea = 'SISTEMAS'
, PERIO_FecCrea = GETDATE()
, PERIO_Activo = 1
FROM Periodos
WHERE PERIO_Codigo = '2014'
--SELECT * FROM Periodos
/*#########################################################################################################*/
/* REGISTRAR EL STOCK INICIAL */
--SELECT * FROM Logistica.LOG_StockIniciales
--SELECT * FROM BDADyA.Logistica.LOG_StockIniciales
--SELECT * FROM Almacenes

INSERT INTO Logistica.LOG_StockIniciales(PERIO_Codigo
, ARTIC_Codigo
, ALMAC_Id
--, STINI_Id
, STINI_Cantidad
, STINI_Fecha
, STINI_UsrCrea
, STINI_FecCrea)
SELECT PERIO_Codigo = '2017'
, ARTIC_Codigo 
, ALMAC_Id
--, STINI_Id = 10
, STINI_Cantidad 
, STINI_Fecha = '2017/01/01'
, STINI_UsrCrea = 'SISTEMAS'
, STINI_FecCrea = GETDATE()
FROM BDACNet.Logistica.LOG_StockIniciales


 

SELECT * FROM BDCopy.DBO.Articulos
SELECT * FROM BDADyA..Articulos
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'PRO%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'CTP%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'UND%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'CLR%'
SELECT * FROM Tipos WHERE TIPOS_Codigo LIKE 'MND%'





