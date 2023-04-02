

begin tran x

insert into BDInkasFerro..Articulos
select * from BDInkasFerro_Almudena..Articulos WHERE LINEA_Codigo = '1901' and ARTIC_Descripcion like '%tecno%'

insert into BDInkasFerro..Precios
select * from BDInkasFerro_Almudena..Precios 
 where ARTIC_Codigo in (select ARTIC_Codigo from BDInkasFerro_Almudena..Articulos WHERE LINEA_Codigo = '1901' and ARTIC_Descripcion like '%tecno%')

insert into BDInkasFerro.Ventas.VENT_ListaPreciosArticulos
select * from BDInkasFerro_Almudena.Ventas.VENT_ListaPreciosArticulos
 where ARTIC_Codigo in (select ARTIC_Codigo from BDInkasFerro_Almudena..Articulos WHERE LINEA_Codigo = '1901' and ARTIC_Descripcion like '%tecno%')

commit tran x