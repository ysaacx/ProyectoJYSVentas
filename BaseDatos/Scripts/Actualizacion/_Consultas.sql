USE BDInkasFerro_Almudena
USE BDSAdmin
USE BDInkasFerro_Parusttacca
go
SELECT
   stuff(( SELECT ', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '            '
                + CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'UsuariosEmpresas'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');

SELECT
   stuff(( SELECT ', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '     '
                +  CHAR(10) 
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'UsuariosEmpresas'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');

select
   stuff(( SELECT LEFT(', PRECI.' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'VENT_ListaPreciosArticulos'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'Ventas'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');

SELECT * FROM dbo.Parametros



select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'CAT_Tarjetas'
	            AND INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = 'dbo'
           ORDER BY ORDINAL_POSITION
           for xml path('')), 1, 1, '');
select
   stuff(( SELECT LEFT(', ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME + '                               ', 31)
                + CASE ORDINAL_POSITION % 4 WHEN 0 THEN CHAR(10) ELSE '' END
            FROM
	            INFORMATION_SCHEMA.COLUMNS
            WHERE
	            INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'tipos'
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



select * from BDSAdmin..Empresas




USE BDNOVACERO




exec VENT_CCAJASS_Egresos_Resumen @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-09 00:00:00',@PVENT_Id=1
go
exec VENT_CCAJASS_EgresosDetalle @FecIni='2020-11-09 00:00:00',@FecFin='2020-11-09 00:00:00',@PVENT_Id=1

USE BDSAdmin
sp_helptext  EMPRSS_GetConexion

SELECT DISTINCT EMPR.EMPR_Servidor
     , EMPR.EMPR_BaseDatos
  FROM dbo.UsuariosAplicaciones UAPP
 INNER JOIN dbo.Empresas EMPR ON EMPR.EMPR_Codigo = UAPP.EMPR_Codigo
 WHERE UAPP.EMPR_Codigo = 'INKAP' AND UAPP.APLI_Codigo = 'VTA'