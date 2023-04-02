USE BDMaster
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ImportarMovimientos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[MOVISS_ImportarMovimientos] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/01/2012
-- Descripcion         : Procedimiento de Inserción de la tabla Departamento
-- Autor - Fecha Modif : 
-- Descripcion         : Se retiro la restriccion de importar a movimientos solo las facturas 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ImportarMovimientos]
(   
      @FecIni DateTime
    , @FecFin DATETIME
    , @EMPR_Codigo CHAR(5)
)
AS

/**********************************************************************************************************************/
Begin Tran X
/**********************************************************************************************************************/
/* Eliminar Datos */
/**********************************************************************************************************************/
-- Eliminar el Detalle
PRINT 'DELETE FROM Movimientos_detalle  '
/**/
DELETE FROM Movimientos_detalle  
Where Id_Documento+Id_CliPro IN (Select Id_Documento+Id_CliPro 
    From Movimientos Where fecha Between @FecIni And @FecFin --And Registro = 'RV'
    ) AND EMPR_Codigo = @EMPR_Codigo
-- Eliminar La Cabecera
DELETE FROM Movimientos Where fecha Between @FecIni And @FecFin --And Registro = 'RV'
   AND EMPR_Codigo = @EMPR_Codigo

/***********************************************************************************************************************************/
/*Ventas*/
/***********************************************************************************************************************************/
print 'Insert Into movimientos - VENTAS'

Insert Into movimientos (
    Registro                ,Id_Documento           ,Id_CliPro
    ,Fecha                  ,Tip_Doc                ,Num_Doc
    ,Descripcion            ,Direccion              ,Id_Moneda
    ,Tipo_Cambio
    ,Importe                ,IGV                    ,Total
    ,Percepcion_Documento   
    ,Percepcion_Afecto      ,Percepcion_Tasa
    ,Percepcion_Importe     ,Anulada                ,Id_Referencia
    ,Sucursal               , EMPR_Codigo
)
select 
    'RV'                    ,Id_Venta               ,Id_Cliente
    ,Fecha                  ,Id_Tipo_Documento      ,Id_Cliente
    ,Descripcion_Cliente    ,Direccion_Cliente      ,Id_Moneda
    ,Ven_Dol_Sunat
    ,Sub_Total              ,Total_IGV              ,Total_Venta
    ,Case When Afecto_Percepcion > 0 Then 1 Else 0 End
    ,Afecto_Percepcion      ,Tasa_Percepcion
    ,Importe_Percepcion     ,Anulada                ,Null
    ,A.Descripcion As Sucursal
    , @EMPR_Codigo
from Ventas As V
    Left Join Almacenes As A On A.Id_Sucursal = V.Id_Sucursal AND V.EMPR_Codigo = A.EMPR_Codigo
Where Fecha between @FecIni And @FecFin AND A.EMPR_Codigo = @EMPR_Codigo
    --And Nro_Serie <> '010' And Id_Tipo_Documento = '01' se retiro

/*=================================================================================================================================*/
print 'Insert Into movimientos_detalle - VENTAS DETALLE '

Insert Into movimientos_detalle(
    Registro                ,Id_Documento           ,Id_CliPro
    ,Posicion               ,Id_Producto            ,Cantidad_Producto
    ,Importe                ,Id_Nota                ,PorcentajeDescuentoNota1
    ,DescuentoNota1         ,ImporteNota            ,Costo
    ,Percepcion
    ,Sucursal
    , EMPR_Codigo
)
Select 
    'RV'                    ,D.ID_Venta             ,C.Id_Cliente
    ,D.Posicion             ,D.ID_Producto          ,D.Cantidad_Producto
    ,D.Importe              ,Null                   ,Null
    ,Null                   ,Null                   ,D.Importe
    ,D.Percepcion
    ,A.Descripcion As Sucursal
    , @EMPR_Codigo
From Ventas_Detalle As D
    Inner Join Ventas As C On C.Id_Venta = D.Id_Venta AND C.EMPR_Codigo = D.EMPR_Codigo
    --And C.Nro_Serie <> '010' And C.Id_Tipo_Documento = '01' se retiro
    Left Join Almacenes As A On A.Id_Sucursal = C.Id_Sucursal AND C.EMPR_Codigo = A.EMPR_Codigo
Where C.Fecha between @FecIni And @FecFin AND D.EMPR_Codigo = @EMPR_Codigo
/**/
    --C.Fecha between '01/01/2011' And '31/12/2011'
    --And id_producto = 'P0101055000' 
/***********************************************************************************************************************************/
/*Compras*/
/***********************************************************************************************************************************/
/**/
print 'Insert Into movimientos - COMPRAS'
insert into movimientos (
    Registro                ,Id_Documento           ,Id_CliPro
    ,Fecha                  ,Tip_Doc                ,Num_Doc
    ,Descripcion            ,Direccion              ,Id_Moneda
    ,Tipo_Cambio  
    ,Importe                ,IGV                    ,Total
    ,Percepcion_Documento   
    ,Percepcion_Afecto      ,Percepcion_Tasa
    ,Percepcion_Importe     ,Anulada                ,Id_Referencia
    ,Sucursal
    , EMPR_Codigo
    )
select 
    'RC' As Registro        ,Id_Compra              ,C.Id_Proveedor
    ,Fecha_Documento        ,ID_Tipo_Documento      ,C.Id_Proveedor As Num_Doc
    ,Pro.Nombre_Proveedor   ,Pro.Direccion          ,id_moneda
    ,CASE ISNULL(Ven_Dol_Sunat, 0) WHEN 0 THEN Tipo_Cambio ELSE Ven_Dol_Sunat END 
    ,importe                ,impuesto               ,total
    ,Null As Percepcion_Documento
    ,Null As Percepcion_Afecto                  ,Null As Percepcion_Tasa
    ,Null As Percepcion_Importe                 ,anulada                ,Null As Id_Referencia
    ,A.Descripcion As Sucursal
    , @EMPR_Codigo
from Compras As C
    Left Join Proveedor As Pro On Pro.Id_Proveedor = C.Id_Proveedor
    Left Join Almacenes As A On A.Id_Sucursal = C.Id_Sucursal AND A.EMPR_Codigo = C.EMPR_Codigo
Where C.Fecha_Documento between @FecIni And @FecFin AND A.EMPR_Codigo = @EMPR_Codigo AND C.EMPR_Codigo = @EMPR_Codigo
    
/*=================================================================================================================================*/
print 'Insert Into movimientos_detalle - COMPRAS DETALLE '
Insert Into movimientos_detalle(
    Registro                ,Id_Documento           ,Id_CliPro
    ,Posicion               ,Id_Producto            ,Cantidad_Producto
    ,Importe                ,Id_Nota                ,PorcentajeDescuentoNota1
    ,DescuentoNota1         ,ImporteNota            ,Costo
    ,Percepcion
    ,Sucursal
    ,EMPR_Codigo
)
Select 
    'RC'                    ,C.Id_Compra            ,C.Id_Proveedor
    ,Posicion               ,Id_Producto            ,Cantidad_Producto
    ,Sub_Importe            ,Null                   ,Null
    ,Null                   ,Null                   
    ,Sub_Importe/Cantidad_Producto      
    ,Null
    ,A.Descripcion As Sucursal
    ,@EMPR_Codigo
From Compras_Detalle As D
    Inner Join Compras As C On C.Id_Compra = D.Id_Compra And C.Id_Proveedor = D.Id_Proveedor AND C.EMPR_Codigo = D.EMPR_Codigo
    Left Join Almacenes As A On A.Id_Sucursal = C.Id_Sucursal  AND A.EMPR_Codigo = D.EMPR_Codigo
Where C.Fecha_Documento between @FecIni And @FecFin AND d.EMPR_Codigo = @EMPR_Codigo
/**/
/***********************************************************************************************************************************/
/* Proveedores */


DECLARE @SQL nVARCHAR(MAX)
DECLARE @EMPR_BaseDatos VARCHAR(50) = (SELECT EMPR_BaseDatos FROM BDSAdmin..Empresas WHERE EMPR_Codigo = @EMPR_Codigo)

SET @SQL = ''
SET @SQL = @SQL + 'INSERT INTO dbo.Proveedor ( ID_Proveedor , Nombre_Proveedor , Ruc  )' + CHAR(10)
SET @SQL = @SQL + 'SELECT ID_Proveedor = ENTC.ENTID_Codigo ,Nombre_Proveedor = LEFT(ENTID_RazonSocial, 60) ,Ruc = ENTID_NroDocumento '+ CHAR(10)
SET @SQL = @SQL + '  FROM ' + @EMPR_BaseDatos + '..Entidades ENTC'+ CHAR(10)
SET @SQL = @SQL + ' INNER JOIN ' + @EMPR_BaseDatos + '..EntidadesRoles  EROL ON EROL.ENTID_Codigo = ENTC.ENTID_Codigo'+ CHAR(10)
SET @SQL = @SQL + ' WHERE EROL.ROLES_Id = 3'+ CHAR(10)
SET @SQL = @SQL + '   AND NOT ENTC.ENTID_Codigo IN (SELECT ID_Proveedor FROM dbo.Proveedor)'+ CHAR(10)

EXECUTE sp_executesql @SQL  

/***********************************************************************************************************************************/
/* Actualizar los tipos de cambio *
/*=================================================================================================================================*/
Update Movimientos
Set Tipo_Cambio = (Select Precio_Venta_Dol from bdacsoft.dbo.tipo_cambio_sunat
                    Where Convert(varchar, Fecha, 112) = Convert(varchar, Movimientos.Fecha, 112))
Where Fecha between @FecIni And @FecFin
    And Id_Moneda = 2
    And IsNull(Tipo_Cambio, 0) = 0
/*=================================================================================================================================*/
Update Movimientos
Set Tipo_Cambio = 1
Where Fecha between @FecIni And @FecFin
    And Id_Moneda = 1
    And IsNull(Tipo_Cambio, 0) = 0
*/
/*=================================================================================================================================*/
/***********************************************************************************************************************************/
Commit Tran X
/***********************************************************************************************************************************/


GO 
/***************************************************************************************************************************************/ 


--SELECT * FROM dbo.Compras
--SELECT * FROM dbo.Proveedor



--SELECT * FROM BDInkaPeru..Roles

BEGIN TRAN X

exec MOVISS_ImportarMovimientos @FecIni='2019-01-01 00:00:00',@FecFin='2019-12-31 00:00:00',@EMPR_Codigo=N'FISUR'

ROLLBACK TRAN X

--select * from Movimientos_detalle where empr_codigo = 'FISUR'





--select 
--    V.empr_codigo, V.Id_Venta, V.Id_Cliente, count(*)
--from Ventas As V
--    Left Join Almacenes As A On A.Id_Sucursal = V.Id_Sucursal and V.EMPR_Codigo = A.EMPR_Codigo
--Where Fecha between '2019-01-01' And '2019-12-31'
--group by V.EMPR_Codigo, V.Id_Venta, V.Id_Cliente
--having count(*) > 1


--select 
--    'RV'                    ,Id_Venta               ,Id_Cliente
--    ,Fecha                  ,Id_Tipo_Documento      ,Id_Cliente
--    ,Descripcion_Cliente    ,Direccion_Cliente      ,Id_Moneda
--    ,Ven_Dol_Sunat
--    ,Sub_Total              ,Total_IGV              ,Total_Venta
--    ,Case When Afecto_Percepcion > 0 Then 1 Else 0 End
--    ,Afecto_Percepcion      ,Tasa_Percepcion
--    ,Importe_Percepcion     ,Anulada                ,Null
--    ,A.Descripcion As Sucursal
--    , @EMPR_Codigo
--from Ventas As V
--    Left Join Almacenes As A On A.Id_Sucursal = V.Id_Sucursal 
--Where Fecha between @FecIni And @FecFin