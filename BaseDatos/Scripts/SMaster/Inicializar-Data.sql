USE BDMaster
GO
/*===============================================================================================*/
--SELECT * FROM dbo.StockInicial
--select * FROM dbo.Almacenes

DECLARE @Server VARCHAR(50) = '(Local)\SQL12' --'ANTAPAKAY-SVR'
DECLARE @EMPR_Codigo CHAR(5) = 'INKAP'
DECLARE @DATABASE VARCHAR(5) = 'BDInkaPeru'

--SELECT * FROM dbo.Almacenes

DELETE FROM dbo.Almacenes WHERE EMPR_Codigo = @EMPR_Codigo

INSERT INTO dbo.Almacenes
     ( EMPR_Codigo
     , Id_Sucursal                  , Descripcion                  , Base_Datos                   , Direccion_IP                 
     , Activo                       , Direccion_IPNuevo            , Base_DatosNuevo              
        )
SELECT EMPR_Codigo, Id_Sucursal                  , Descripcion                  , Base_Datos                   , Direccion_IP                 
     , Activo                       , Direccion_IPNuevo            , Base_DatosNuevo             
 FROM (
SELECT EMPR_Codigo = @EMPR_Codigo --'INKAP'
     , Id_Sucursal = 1                                 , Descripcion = 'Almacen Principal'                  
     , Base_Datos = 'BDInkaPeru'                         , Direccion_IP = @Server -- 'ANTAPAKAY-SVR'
     , Activo = 1                                      , Direccion_IPNuevo = @Server -- 'ANTAPAKAY-SVR'
     , Base_DatosNuevo = 'BDInkaPeru') AS ALMA
 WHERE NOT EMPR_Codigo + '|' + RTRIM(ALMA.Id_Sucursal)  IN (SELECT EMPR_Codigo + '|' + RTRIM(Id_Sucursal) FROM dbo.Almacenes)



 DELETE FROM dbo.Movimientos_Detalle WHERE EMPR_Codigo <> 'INKAP'
 DELETE FROM dbo.Movimientos WHERE EMPR_Codigo <> 'INKAP'
 DELETE FROM dbo.StockInicial WHERE EMPR_Codigo <> 'INKAP'
 DELETE FROM dbo.Almacenes WHERE EMPR_Codigo <> 'INKAP'

--SELECT * FROM dbo.Almacenes
/*===============================================================================================*/

USE bdsadmin

update aplicaciones set apli_activo = 0 where apli_codigo in ('CON', 'LOG', 'CTD', 'ADM')

INSERT INTO dbo.[Aplicaciones](APLI_Codigo, APLI_Nombre, APLI_Desc, APLI_NomArc, APLI_DirTra, APLI_TipoLic, APLI_TipoEnv, APLI_NumLic, APLI_NumEmpr, APLI_BaseDatos, APLI_Icono, APLI_Isolation, APLI_Activo, APLI_ConProceso, APLI_UsrCrea, APLI_FecCrea, APLI_UsrMod, APLI_FecMod) VALUES ('MSG', 'Master General', 'Master General', 'ACPMasterGeneral.exe', 'D:\Sistema\MasterGeneral', NULL, NULL, NULL, NULL, NULL,  5 ,  0 ,  1 , NULL, 'SISTEMAS' , '12-25-2017 10:34:48' , NULL , NULL )

select * from aplicaciones

USE BDMaster
GO

SELECT * FROM dbo.Almacenes

UPDATE Almacenes SET BASE_DATOS = 'BDInkaPeru'

SELECT * FROM dbo.Compras WHERE Id_Compra = '030050002780'
SELECT * FROM dbo.Ventas WHERE Id_Venta = '030050002780'
030050002780


SP_HELPTEXT MSTGENSS_EliminarImportados


INSERT INTO dbo.Ventas( Id_Venta
,Id_Sucursal
,Nro_Serie
,Nro_Venta
,Id_Tipo_Documento
,Id_Tipo_Pago
,Id_Cliente
,Descripcion_Cliente
,Fecha_Ingreso
,Fecha
,Id_Moneda
,IGV
,Sub_Total
,Total_IGV
,Total_Venta
,Doc_Percepcion
,Total_Pagar
,totalpagado
,Ven_Dol
,Ven_Dol_Sunat
,Anulada
,Guia
,Orden
,Pendiente
,Mod_Con
,Mod_Des
,fechadocumento
,VENT_UsrCrea
,VENT_FecCrea
) VALUES ( '030050003286'
,1
,'005'
,3286
,'03'
,1
,'23030232'
,'<SPAN CLASS="STYLE3">23030232</SPAN> NO SE ENCUENTRA EN EL ARCHIVO MAGN&EACUTE;TICO DEL RENIEC EL DNI N&DEG;'
,'2018-03-21 09:58:57.363'
,'2018-03-21 00:00:00.000'
,1
,1
,1367.12
,246.08
,1
,0
,1
,1613.2
,1
,1
,1
,0
,0
,0
,0
,0
,'2018-03-21 09:58:53.987'
,'SISTEMAS'
,'2018-07-26 00:34:45.200'
)



INSERT INTO dbo.Ventas
        ( EMPR_Codigo ,
          Id_Venta ,
          Id_Sucursal ,
          Nro_Serie ,
          Nro_Venta ,
          Id_Cotizacion ,
          Id_Cotizador ,
          Cotizador ,
          ID_Almacen ,
          Id_Punto_Venta ,
          Id_Tipo_Documento ,
          Id_Tipo_Pago ,
          Id_Cliente ,
          Descripcion_Cliente ,
          Direccion_Cliente ,
          Id_Vendedor ,
          Id_Usuario ,
          Fecha_Ingreso ,
          Fecha ,
          Id_Moneda ,
          IGV ,
          Peso ,
          Total_Costo ,
          Sub_Total ,
          Total_IGV ,
          Total_Venta ,
          Afecto_Percepcion ,
          Importe_Percepcion ,
          Total_Percepcion ,
          Afecto_Percepcion_Soles ,
          Importe_Percepcion_Soles ,
          Total_Percepcion_Soles ,
          Tasa_Percepcion ,
          Doc_Percepcion ,
          Total_Pagar ,
          totalpagado ,
          recibo ,
          Saldo ,
          Com_Dol ,
          Ven_Dol ,
          Ven_Dol_Sunat ,
          Anulada ,
          anuladocaja ,
          fechaanulado ,
          Guia ,
          Orden ,
          Pendiente ,
          Mod_Con ,
          Mod_Des ,
          Doc_Referencia ,
          Motivo ,
          Orden_Compra ,
          percepcion ,
          fechadocumento ,
          cheque ,
          numdeposito ,
          idbanco ,
          maquina ,
          pendi ,
          VENT_UsrCrea ,
          VENT_FecCrea ,
          VENT_UsrMod ,
          VENT_FecMod
        )
SELECT EMPR_Codigo = 'INKAP' ,
          Id_Venta ,
          Id_Sucursal ,
          Nro_Serie ,
          Nro_Venta ,
          Id_Cotizacion ,
          Id_Cotizador ,
          Cotizador ,
          ID_Almacen ,
          Id_Punto_Venta ,
          Id_Tipo_Documento ,
          Id_Tipo_Pago ,
          Id_Cliente ,
          Descripcion_Cliente ,
          Direccion_Cliente ,
          Id_Vendedor ,
          Id_Usuario ,
          Fecha_Ingreso ,
          Fecha ,
          Id_Moneda ,
          IGV ,
          Peso ,
          Total_Costo ,
          Sub_Total ,
          Total_IGV ,
          Total_Venta ,
          Afecto_Percepcion ,
          Importe_Percepcion ,
          Total_Percepcion ,
          Afecto_Percepcion_Soles ,
          Importe_Percepcion_Soles ,
          Total_Percepcion_Soles ,
          Tasa_Percepcion ,
          Doc_Percepcion ,
          Total_Pagar ,
          totalpagado ,
          recibo ,
          Saldo ,
          Com_Dol ,
          Ven_Dol ,
          Ven_Dol_Sunat ,
          Anulada ,
          anuladocaja ,
          fechaanulado ,
          Guia ,
          Orden ,
          Pendiente ,
          Mod_Con ,
          Mod_Des ,
          Doc_Referencia ,
          Motivo ,
          Orden_Compra ,
          percepcion ,
          fechadocumento ,
          cheque ,
          numdeposito ,
          idbanco ,
          maquina ,
          pendi ,
          VENT_UsrCrea ,
          VENT_FecCrea ,
          VENT_UsrMod ,
          VENT_FecMod FROM BDMaster_INKAP..Ventas

INSERT INTO dbo.Ventas_Detalle
        ( EMPR_Codigo ,
          ID_Venta ,
          Posicion ,
          Id_Sucursal ,
          ID_Producto ,
          Costo_Unitario ,
          Precio_Unitario ,
          Peso_Unitario ,
          Cantidad_Producto ,
          Cantidad_Saldo ,
          Importe ,
          Lista ,
          Cuenta ,
          Comprobacion ,
          Percepcion ,
          VEND_UsrCrea ,
          VEND_FecCrea ,
          VEND_UsrMod ,
          VEND_FecMod
        )
SELECT EMPR_Codigo = 'INKAP',
          ID_Venta ,
          Posicion ,
          Id_Sucursal ,
          ID_Producto ,
          Costo_Unitario ,
          Precio_Unitario ,
          Peso_Unitario ,
          Cantidad_Producto ,
          Cantidad_Saldo ,
          Importe ,
          Lista ,
          Cuenta ,
          Comprobacion ,
          Percepcion ,
          VEND_UsrCrea ,
          VEND_FecCrea ,
          VEND_UsrMod ,
          VEND_FecMod FROM BDMaster_INKAP..Ventas_Detalle

INSERT INTO dbo.Compras
        ( EMPR_Codigo ,
          Id_Compra ,
          Id_Proveedor ,
          Id_Sucursal ,
          Fecha_Ingreso ,
          Fecha_Documento ,
          Periodo_Declaracion ,
          ID_Tipo_Documento ,
          Numero_Documento ,
          Serie_Documento ,
          ID_Moneda ,
          ID_Tipo_Pago ,
          Fecha_Pago ,
          Id_Usuario ,
          Descuento ,
          Importe ,
          Impuesto ,
          Total ,
          Ven_Dol_Sunat ,
          Id_Almacen ,
          Anulada ,
          Maquina ,
          COMP_UsrCrea ,
          COMP_FecCrea ,
          COMP_UsrMod ,
          COMP_FecMod ,
          Tipo_Cambio
        )
SELECT EMPR_Codigo = 'INKAP',
          Id_Compra ,
          Id_Proveedor ,
          Id_Sucursal ,
          Fecha_Ingreso ,
          Fecha_Documento ,
          Periodo_Declaracion ,
          ID_Tipo_Documento ,
          Numero_Documento ,
          Serie_Documento ,
          ID_Moneda ,
          ID_Tipo_Pago ,
          Fecha_Pago ,
          Id_Usuario ,
          Descuento ,
          Importe ,
          Impuesto ,
          Total ,
          Ven_Dol_Sunat ,
          Id_Almacen ,
          Anulada ,
          Maquina ,
          COMP_UsrCrea ,
          COMP_FecCrea ,
          COMP_UsrMod ,
          COMP_FecMod ,
          Tipo_Cambio = 1 FROM BDMaster_INKAP..Compras

INSERT INTO dbo.Compras_Detalle
        ( EMPR_Codigo ,
          Id_Compra ,
          Id_Proveedor ,
          Posicion ,
          Id_Sucursal ,
          Cuenta ,
          Id_Producto ,
          Cantidad_Producto ,
          Sub_Importe ,
          Sub_Igv ,
          Sub_Total ,
          PDescuento ,
          COMD_UsrCrea ,
          COMD_FecCrea ,
          COMD_UsrMod ,
          COMD_FecMod
        )
SELECT EMPR_Codigo = 'INKAP',
          Id_Compra ,
          Id_Proveedor ,
          Posicion ,
          Id_Sucursal ,
          Cuenta ,
          Id_Producto ,
          Cantidad_Producto ,
          Sub_Importe ,
          Sub_Igv ,
          Sub_Total ,
          PDescuento ,
          COMD_UsrCrea ,
          COMD_FecCrea ,
          COMD_UsrMod ,
          COMD_FecMod FROM BDMaster_INKAP..Compras_Detalle 


SELECT * FROM dbo.TipoCambio
SELECT * FROM BDMaster_INKAP..TipoCambio