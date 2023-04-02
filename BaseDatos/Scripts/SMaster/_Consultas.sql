USE BDSisSCC
USE BDSAdmin
USE BDMaster

select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'Productos'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');
select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CHAR(10)
                --+ CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'Productos'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');


select
   stuff(( SELECT ', entc_nextsis.' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + ' = entc_nextsoft.' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME
                + CHAR(10) 
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'Entidad'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');

select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CHAR(10) --+ CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'CAJ_TablaPreAsientos'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');

select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CHAR(10) 
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'CAT_Tarjetas'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');






SELECT * FROM dbo.Almacenes
SELECT * FROM BDSAdmin..Empresas

SELECT COUNT(*), YEAR(Fecha) FROM dbo.Movimientos GROUP BY YEAR(Fecha)


SELECT * FROM dbo.Movimientos
SELECT * FROM dbo.Movimientos_Detalle

INSERT INTO dbo.Movimientos
        ( EMPR_Codigo ,
          Registro ,
          Id_Documento ,
          Id_CliPro ,
          Fecha ,
          Tip_Doc ,
          Num_Doc ,
          Descripcion ,
          Direccion ,
          Id_Moneda ,
          Tipo_Cambio ,
          Importe ,
          IGV ,
          Total ,
          Percepcion_Documento ,
          Percepcion_Afecto ,
          Percepcion_Tasa ,
          Percepcion_Importe ,
          Anulada ,
          Id_Referencia ,
          Sucursal
        )
SELECT  EMPR_Codigo = 'INKAP',
          Registro ,
          Id_Documento ,
          Id_CliPro ,
          Fecha ,
          Tip_Doc ,
          Num_Doc ,
          Descripcion ,
          Direccion ,
          Id_Moneda ,
          Tipo_Cambio ,
          Importe ,
          IGV ,
          Total ,
          Percepcion_Documento ,
          Percepcion_Afecto ,
          Percepcion_Tasa ,
          Percepcion_Importe ,
          Anulada ,
          Id_Referencia ,
          Sucursal FROM BDMaster_INKAP..Movimientos

INSERT INTO dbo.Movimientos_Detalle
        ( EMPR_Codigo ,
          Registro ,
          Id_Documento ,
          Id_CliPro ,
          Posicion ,
          Id_Producto ,
          Cantidad_Producto ,
          Importe ,
          Id_Nota ,
          PorcentajeDescuentoNota1 ,
          PorcentajeDescuentoNota2 ,
          DescuentoNota1 ,
          DescuentoNota2 ,
          ImporteNota ,
          Costo ,
          Percepcion ,
          Sucursal
        )
SELECT EMPR_Codigo = 'INKAP',
          Registro ,
          Id_Documento ,
          Id_CliPro ,
          Posicion ,
          Id_Producto ,
          Cantidad_Producto ,
          Importe ,
          Id_Nota ,
          PorcentajeDescuentoNota1 ,
          PorcentajeDescuentoNota2 ,
          DescuentoNota1 ,
          DescuentoNota2 ,
          ImporteNota ,
          Costo ,
          Percepcion ,
          Sucursal FROM BDMaster_INKAP..MOVIMIENTOS_DETALLE


INSERT INTO dbo.StockInicial
        ( EMPR_Codigo ,
          Id_Sucursal ,
          Periodo ,
          Id_Producto ,
          StockFisico ,
          StockInicialContable ,
          CostoInicialContable ,
          Pendiente_Inicial_Contable ,
          Fecha ,
          id_Producto2
        )
SELECT EMPR_Codigo = 'INKAP',
          Id_Sucursal = 1,
          Periodo ,
          Id_Producto ,
          StockFisico ,
          StockInicialContable ,
          CostoInicialContable ,
          Pendiente_Inicial_Contable ,
          Fecha ,
          id_Producto2 FROM BDMaster_INKAP..StockInicial