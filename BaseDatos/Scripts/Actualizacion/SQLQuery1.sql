USE BDSisSCC
GO


--SELECT * FROM Logistica.ABAS_IngresosCompra WHERE INGCO_Id = 191
--SELECT * FROM Logistica.ABAS_IngresosCompraDetalle WHERE INGCO_Id = 191

--DELETE FROM Logistica.ABAS_IngresosCompraDetalle WHERE INGCO_Id = 191
--DELETE FROM Logistica.ABAS_IngresosCompra WHERE INGCO_Id = 191

--SELECT * FROM BDSAdmin..Empresas

USE BDInkasFerro_Almudena
GO

SELECT * FROM Ventas.VENT_DocsVenta WHERE ENTID_CodigoCliente = '40975980'



SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '00000000'
SELECT * FROM dbo.Entidades WHERE ENTID_RazonSocial LIKE '%cliente%'

SELECT * FROM dbo.Parametros
/*====================================================================================================================================================*/
USE BDACNet
GO

SELECT * FROM dbo.Parametros
SELECT * FROM Ventas.VENT_PVentDocumento
SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'CPD%'
/*====================================================================================================================================================*/
USE BDInkasFerro_Almudena
GO

--SELECT * FROM dbo.Entidades WHERE ENTID_Codigo = '11000000000'


/*====================================================================================================================================================*/