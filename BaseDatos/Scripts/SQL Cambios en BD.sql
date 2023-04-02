select * from entidades where ENTID_NroDocumento = '20606762250'

begin tran x
update  entidades set ENTID_RazonSocial = 'NUCLEO EJECUTOR DEL PROYECTO MEJORAMIENTO DE VIVIENDA RURAL DE LOS CENTROS POBLADOS CONCHAPALLANA' where ENTID_NroDocumento = '20606762250'
rollback tran x

--NUCLEO EJECUTOR DEL PROYECTO MEJORAMIENTO DE VIVIENDA RURAL DE LOS CENTROS POBLADOS CONCHAPALLANA

alter table entidades alter column ENTID_Nombres varchar(100)
alter table entidades alter column ENTID_Razonsocial varchar(100)
alter table ventas.VENT_DocsVenta alter column DOCVE_DescripcionCliente varchar(100)
alter table Historial.VENT_DocsVenta alter column DOCVE_DescripcionCliente varchar(100)
alter table ventas.VENT_Pedidos alter column PEDID_DescripcionCliente varchar(100)
alter table Historial.VENT_Pedidos alter column PEDID_DescripcionCliente varchar(100)

