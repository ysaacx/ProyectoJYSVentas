
select * from Ventas.VENT_ListaPreciosArticulos
select * from Precios
select * from Ventas.VENT_ListaPrecios

select * into #listap from Ventas.VENT_ListaPrecios
update  #listap set ZONAS_Codigo = '54.00'

insert into Ventas.VENT_ListaPrecios
select * from #listap

select * into #Precios54 from Precios
update #Precios54 set ZONAS_Codigo = '54.00'

insert into Precios
select * from #Precios54


select * into #lprec from Ventas.VENT_ListaPreciosArticulos
update #lprec set ZONAS_Codigo = '54.00'

insert into Ventas.VENT_ListaPreciosArticulos
select * from #lprec

