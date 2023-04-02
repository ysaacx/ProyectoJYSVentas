USE BDMaster
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMPRAS_COMPRASSI_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[COMPRAS_COMPRASSI_UnReg]

GO

-- =============================================
-- Autor - Fecha Crea  : Generador - 2/06/2018
-- Descripcion         : Procedimiento de Inserción de la tabla Compras_Detalle
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[COMPRAS_COMPRASSI_UnReg]
(	@EMPR_Codigo CHAR(5),
   @Id_Compra varchar(13),
	@Id_Proveedor varchar(11),
	@Posicion SMALLINT,
	@Id_Sucursal SMALLINT,
	@Cuenta nvarchar(20) = null ,
	@Id_Producto varchar(11),
	@Cantidad_Producto float(53),
	@Sub_Importe float(53),
	@Sub_Igv float(53) = null ,
	@Sub_Total float(53) = null ,
	@PDescuento float(53) = null ,
	@Usuario VARCHAR(20)
)

AS


INSERT INTO [Compras_Detalle]
(	EMPR_Codigo
,  Id_Compra
,	Id_Proveedor
,	Posicion
,	Id_Sucursal
,	Cuenta
,	Id_Producto
,	Cantidad_Producto
,	Sub_Importe
,	Sub_Igv
,	Sub_Total
,	PDescuento
,	COMD_UsrCrea
,	COMD_FecCrea
)
VALUES
(	@EMPR_Codigo
,  @Id_Compra
,	@Id_Proveedor
,	@Posicion
,	@Id_Sucursal
,	@Cuenta
,	@Id_Producto
,	@Cantidad_Producto
,	ISNULL(@Sub_Importe, 0)
,	ISNULL(@Sub_Igv, 0)
,	ISNULL(@Sub_Total, 0)
,	ISNULL(@PDescuento, 0)
,	@Usuario
,	GetDate()
)
GO




