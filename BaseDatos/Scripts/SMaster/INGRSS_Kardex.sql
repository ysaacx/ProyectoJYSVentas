use BDMaster
go
--+Select top 100 * from Ingresos_detalle Where Year(Fecha) = 2011
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[INGRSS_Kardex]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[INGRSS_Kardex]
GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 17/10/2011
-- Descripcion         : Procedimiento de Selección según primary foregin keys de la tabla CONT_Deposito
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[INGRSS_Kardex]
(
	@Id_Producto VarChar(11)
	,@FecIni DateTime
	,@FecFin DateTime
)
AS

Select 'Ingreso' As Condicion
	,@FecIni As Fecha
	,'' As Documento
	,'-' As Nombre_Proveedor
	,Sum(StockFisico) As Entrada
	,0 As Salida
	,0.0 As Stock
	,'' As Id_Venta
	,'' As Id_Ingreso
	,0 As Costo
From StockInicial Where Id_Producto = @Id_Producto And Periodo = Year(@FecFin)
Union All
Select 'Ingreso' 
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then C.Fecha_Documento Else V.Fecha End As Fecha
	,Left(TDoc.Descripcion, 1) + ' ' + V.Serie_Documento + '-' + Right('0000000' + RTrim(V.Numero_Documento), 7) As Documento
	,Pro.Nombre_Proveedor
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then 0 Else D.Cantidad_Producto End As Entrada 
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then D.Cantidad_Producto Else 0 End As Salida
	,0.0 As Stock
	,C.Id_Compra As Id_Venta
	,V.Id_Ingreso
	,(CDet.Sub_Importe/CDet.Cantidad_Producto)
		-((CDet.Sub_Importe/CDet.Cantidad_Producto) * IsNull(CDet.PDescuento, 0)/100) 
from Ingresos_Detalle As D
	Inner Join Ingresos As V On V.Id_Ingreso = D.Id_Ingreso
	Left Join Proveedores As Pro On Pro.ID_Proveedor = D.Id_Proveedor
	Left Join Compras As C On C.Id_Compra = V.Id_Compra
	Left Join Compras_Detalle As CDet On CDet.Id_Compra = C.Id_Compra And CDet.Id_Producto = D.Id_Producto
	Left Join Tipo_Documento As TDoc On TDoc.ID_Tipo_Documento = V.ID_Tipo_Documento
Where V.Fecha Between @FecIni And @FecFin
	And D.Id_Producto = @Id_Producto
Union All
Select 
	Case Left(V.Id_Venta, 2) When '07' Then 'Ingreso' Else  'Egreso' End
	,V.Fecha
	,Left(TDoc.Descripcion, 1) + ' ' + V.Nro_Serie + '-' + Right('0000000' + RTrim(V.Nro_Venta), 7) As Documento
	,Pro.Razon_Social_Cliente
	,Case Left(V.Id_Venta, 2) When '07' Then D.Cantidad_Producto Else  0 End
	,Case Left(V.Id_Venta, 2) When '07' Then 0 Else D.Cantidad_Producto End
	,0.0
	,V.Id_Venta
	,'' As Id_Ingreso
	,0
From Ventas_Detalle As D
	Inner Join Ventas As V On V.Id_Venta = D.Id_Venta
	Inner Join Clientes As Pro On Pro.Id_Cliente = V.Id_Cliente
	Inner Join Tipo_Documento As TDoc On TDoc.ID_Tipo_Documento = V.ID_Tipo_Documento
Where V.Fecha Between @FecIni And @FecFin
	And D.Id_Producto = @Id_Producto
	And V.Anulada = 0
Order By Fecha, Id_Venta

Go

--select * from Tipo_Documento

Exec INGRSS_Kardex 'P0204074000', '01/01/2011', '31/12/2011'

/*
select * from Productos Where id_producto = 'P0103012000' And Periodo = '2011'
select * from StockInicial Where id_producto = 'P0103012000' And Periodo = '2011'

select * from StockInicial Where StockInicialContable Is Null
select * from StockInicial Where CostoInicialContable Is Null
select * from t
Begin Tran x
Update StockInicial Set CostoInicialContable = 0 Where CostoInicialContable Is Null
Commit Tran x

select * from ventas where iv_
select * from Ventas where id_venta like '%83556'
select * from Ventas_Detalle  where id_venta like '010130083556'

Select * from Tipo_Documento
Select * from Tipo_Documento
--Insert Into Tipo_Documento
--select * from BDAcSoft.dbo.Tipo_Documento
--Where not id_tipo_documento in (Select id_tipo_documento from Tipo_Documento)

--Exec INGRSS_Kardex 'P0601002000', '01/01/2011', '31/12/2011'
/**/
--Select * From V_MOVIMIENTOS_DETALLE Where Anulada = 0 
select * from ingresos where Id_Ingreso like '01001%164'
*/

Select 'Ingreso' 
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then C.Fecha_Documento Else V.Fecha End As Fecha
	,Left(TDoc.Descripcion, 1) + ' ' + V.Serie_Documento + '-' + Right('0000000' + RTrim(V.Numero_Documento), 7) As Documento
	,Pro.Nombre_Proveedor
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then 0 Else D.Cantidad_Producto End As Entrada 
	,Case Left(V.ID_Tipo_Documento, 2) When '07' Then D.Cantidad_Producto Else 0 End As Salida
	,0.0 As Stock
	,C.Id_Compra As Id_Venta
	,V.Id_Ingreso
	,(CDet.Sub_Importe/CDet.Cantidad_Producto)
		-((CDet.Sub_Importe/CDet.Cantidad_Producto) * IsNull(CDet.PDescuento, 0)/100) 
	,CDet.*
from Ingresos_Detalle As D
	Inner Join Ingresos As V On V.Id_Ingreso = D.Id_Ingreso
	Left Join Proveedores As Pro On Pro.ID_Proveedor = D.Id_Proveedor
	Left Join Compras As C On C.Id_Compra = V.Id_Compra
	Left Join Compras_Detalle As CDet On CDet.Id_Compra = C.Id_Compra And CDet.Id_Producto = D.Id_Producto
	Left Join Tipo_Documento As TDoc On TDoc.ID_Tipo_Documento = V.ID_Tipo_Documento
Where V.Fecha Between '01/01/2011' And '31/12/2011'
	And V.Id_Ingreso = '090140005465'
	And D.Id_producto = 'P0801019000'

select * from Ingresos where Id_Ingreso like '%090140005465'

select * from compras_detalle where id_compra like '010100000170'

/**/

