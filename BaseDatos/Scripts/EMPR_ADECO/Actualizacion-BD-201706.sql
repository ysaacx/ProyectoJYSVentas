

/*========================================================================================================================*/

USE BDAmbientaDecora
go

UPDATE dbo.Parametros SET PARMT_Valor = '3.3.1.2' WHERE PARMT_Id = 'pg_Version'

/*========================================================================================================================*/


CREATE TABLE Logistica.PROD_Cotizacion
( 
	COTP_Codigo          dbo.Codigo  NOT NULL ,
	COTP_FechaEmision    dbo.Fecha ,
	ARTIC_CodMateriaPrima CodArticulo NOT NULL ,
	ENTID_CodCliente     dbo.CodEntidad ,
	COTP_DireccionCliente dbo.Direccion200 ,
	TIPOS_CodTipoCotizacion dbo.CodigoTipo ,
	TIPOS_CodTipoDocumento dbo.CodigoTipo ,
	TIPOS_CodMedioPago   dbo.CodigoTipo ,
	COTP_FechaEntrega    dbo.Fecha ,
	COTP_Adelanto        dbo.Importe ,
	COTP_MatPrimaPrecio  dbo.Importe ,
	COTP_ProduccionAlto  dbo.Importe ,
	COTP_ProduccionAncho dbo.Importe ,
	COTP_ProduccionPanos dbo.Importe ,
	COTP_ProduccionMatUsado dbo.Importe ,
	COTP_PrecioTotal     dbo.Importe ,
	COTP_PrecioMatPrima  dbo.Importe ,
	COTP_PrecioConfeccion dbo.Importe ,
	COTP_PrecioAccesorios dbo.Importe ,
	COTP_PrecioInstalacion dbo.Importe ,
	COTP_PrecioOtrosGastos dbo.Importe ,
	COTP_UsrCrea         dbo.Usuario ,
	COTP_FecCrea         dbo.Fecha ,
	COTP_UsrMod          dbo.Usuario ,
	COTP_FecMod          dbo.Fecha ,
	DOCVE_Codigo         dbo.CodDocVenta  NULL ,
	PEDID_Codigo         dbo.Codigo12  NULL ,
	PVENT_Id             dbo.Id  NULL ,
	ZONAS_Codigo         dbo.CodigoZona ,
	SUCUR_Id             dbo.CodSucursal  NULL ,
	ALMAC_Id             dbo.CodAlmacen  NULL ,
	COTP_NombreCliente   dbo.Direccion200 
)
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPPK PRIMARY KEY  CLUSTERED (COTP_Codigo ASC)
go

CREATE TABLE Logistica.PROD_CotizacionDetAccesorios
( 
	COTP_Codigo          dbo.Codigo  NOT NULL ,
	CDPA_Item            dbo.CodSmall  NOT NULL ,
	CDPA_Cantidad        dbo.CantDecimal ,
	ARTIC_Codigo         dbo.CodArticulo  NULL ,
	CDPA_PrecioUnitario  dbo.Importe ,
	CDPA_Total           dbo.Importe ,
	CDPA_UsrCrea         dbo.Usuario ,
	CDPA_FecCrea         dbo.Fecha ,
	CDPA_UsrMod          dbo.Usuario ,
	CDPA_FecMod          dbo.Fecha ,
	CDPA_Tipo            char(1)  NULL 
)
go

ALTER TABLE Logistica.PROD_CotizacionDetAccesorios
	ADD CONSTRAINT PROD_COPAPK PRIMARY KEY  CLUSTERED (COTP_Codigo ASC,CDPA_Item ASC)
go

CREATE TABLE Logistica.PROD_CotizacionDetServicios
( 
	COTP_Codigo          dbo.Codigo  NOT NULL ,
	CDPS_Item            dbo.CodSmall  NOT NULL ,
	CDPS_Cantidad        dbo.CantDecimal ,
	ARTIC_Codigo         dbo.CodArticulo  NULL ,
	CDPS_PrecioUnitario  dbo.Importe ,
	CDPS_Total           dbo.Importe ,
	CDPS_UsrCrea         dbo.Usuario ,
	CDPS_FecCrea         dbo.Fecha ,
	CDPS_UsrMod          dbo.Usuario ,
	CDPS_FecMod          dbo.Fecha 
)
go

ALTER TABLE Logistica.PROD_CotizacionDetServicios
	ADD CONSTRAINT PROD_CDPSPK PRIMARY KEY  CLUSTERED (COTP_Codigo ASC,CDPS_Item ASC)
go


ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_ARTIC FOREIGN KEY (ARTIC_CodMateriaPrima) REFERENCES Articulos(ARTIC_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_ENTID FOREIGN KEY (ENTID_CodCliente) REFERENCES Entidades(ENTID_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_TipoCotizacion FOREIGN KEY (TIPOS_CodTipoCotizacion) REFERENCES Tipos(TIPOS_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_TipoDocumento FOREIGN KEY (TIPOS_CodTipoDocumento) REFERENCES Tipos(TIPOS_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_TipoMedioPago FOREIGN KEY (TIPOS_CodMedioPago) REFERENCES Tipos(TIPOS_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_DOCV FOREIGN KEY (DOCVE_Codigo) REFERENCES Ventas.VENT_DocsVenta(DOCVE_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_PEDID FOREIGN KEY (PEDID_Codigo) REFERENCES Ventas.VENT_Pedidos(PEDID_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT R_511 FOREIGN KEY (PVENT_Id) REFERENCES PuntoVenta(PVENT_Id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_SUCR FOREIGN KEY (ZONAS_Codigo,SUCUR_Id) REFERENCES Sucursales(ZONAS_Codigo,SUCUR_Id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_Cotizacion
	ADD CONSTRAINT PROD_COTPFK_ALMAC FOREIGN KEY (ALMAC_Id) REFERENCES Almacenes(ALMAC_Id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_CotizacionDetAccesorios
	ADD CONSTRAINT PROD_COTPFK_CODP FOREIGN KEY (COTP_Codigo) REFERENCES Logistica.PROD_Cotizacion(COTP_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_CotizacionDetAccesorios
	ADD CONSTRAINT PROD_CDPAFK_ARTIC FOREIGN KEY (ARTIC_Codigo) REFERENCES Articulos(ARTIC_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_CotizacionDetServicios
	ADD CONSTRAINT PROD_CDPAFK_COTP FOREIGN KEY (COTP_Codigo) REFERENCES Logistica.PROD_Cotizacion(COTP_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Logistica.PROD_CotizacionDetServicios
	ADD CONSTRAINT PROD_CDPSFK_ARTIC FOREIGN KEY (ARTIC_Codigo) REFERENCES Articulos(ARTIC_Codigo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

