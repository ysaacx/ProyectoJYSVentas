USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ADMIN_REPOSS_VentasTotales]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ADMIN_REPOSS_VentasTotales] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ADMIN_REPOSS_VentasTotales]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt = Null
	,@Linea VarChar(10) = Null
	,@Cargar Bit = Null
	,@ENTID_CodigoCliente VarChar(14) = Null
	,@ENTID_CodigoVendedor VarChar(14) = Null
	
)
As
--Declare @FecIni DateTime Set @FecIni = '01-08-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'

Select Ven.DOCVE_FechaDocumento
	,Art.ARTIC_Descripcion
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '-')  As Documento
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_PrecioUnitario Else Det.DOCVD_PrecioUnitario * TC.TIPOC_VentaSunat End) As DOCVD_PrecioUnitario
	,Det.DOCVD_Cantidad * Art.ARTIC_Peso As SubPeso
	,Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad As Importe
	,Det.DOCVD_CostoUnitarioSoles * Det.DOCVD_Cantidad As DOCVD_CostoUnitario
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_PrecioUnitario Else Det.DOCVD_PrecioUnitario * TC.TIPOC_VentaSunat End)
		* Det.DOCVD_Cantidad - Det.DOCVD_CostoUnitarioSoles * Det.DOCVD_Cantidad As Utilidad
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_SubImporteVenta Else Det.DOCVD_SubImporteVenta * TC.TIPOC_VentaSunat End) As DOCVD_SubImporteVenta
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad Else 0 End) As ImporteDolares
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad Else Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad * TC.TIPOC_VentaSunat End) As ImporteSoles
	
	,Ven.DOCVE_DescripcionCliente
	
	,L.LINEA_Nombre As Linea
	,sl.LINEA_Nombre As SubLinea
	,Det.DOCVE_Codigo
	,Det.ARTIC_Codigo
	,Det.DOCVD_Cantidad
	,Det.DOCVD_Importe
	,Ven.ENTID_CodigoVendedor
	,Det.DOCVD_CostoUnitario
	,Det.DOCVD_CostoUnitarioSoles
	,Det.DOCVD_TipoCambioCosto
	,Det.DOCVD_PesoUnitario
	,Vend.ENTID_RazonSocial As Vendedor
	,Art.LINEA_Codigo
	,Ven.TIPOS_CodTipoMoneda
	,Ven.DOCVE_TipoCambioSunat
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta as Ven
	Inner join Ventas.VENT_DocsVentaDetalle as Det on Ven.DOCVE_Codigo = Det.DOCVE_Codigo
	Inner join Entidades as Vend on Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Inner join Articulos as Art on Det.ARTIC_Codigo = Art.ARTIC_Codigo And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	Inner join Lineas as l on l.LINEA_Codigo = Left(Art.LINEA_Codigo, 2)
	Inner join Lineas as sl on Art.LINEA_Codigo = sl.LINEA_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
where Ven.DOCVE_Estado <> 'X' 
	--And Det.ARTIC_Codigo not in ('1301001', '1301002')
	And CONVERT(DATE, DOCVE_FechaDocumento) Between CONVERT(DATE, @FecIni) And CONVERT(DATE, @FecFin)
	And DOCVE_FechaDocumento > '08-18-2013'
	And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Ven.ENTID_CodigoCliente)
	And Ven.ENTID_CodigoVendedor = ISNULL(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
Union All
Select Ven.DOCVE_FechaDocumento
	,Art.ARTIC_Descripcion
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '-')  As Documento
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_PrecioUnitario Else Det.DOCVD_PrecioUnitario * TC.TIPOC_VentaSunat End) As DOCVD_PrecioUnitario
	,Det.DOCVD_Cantidad * Art.ARTIC_Peso As SubPeso
	,Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad As Importe
	,Det.DOCVD_CostoUnitarioSoles * Det.DOCVD_Cantidad As DOCVD_CostoUnitario
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_PrecioUnitario Else Det.DOCVD_PrecioUnitario * TC.TIPOC_VentaSunat End)
		* Det.DOCVD_Cantidad - Det.DOCVD_CostoUnitarioSoles * Det.DOCVD_Cantidad As Utilidad
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then  Det.DOCVD_SubImporteVenta Else Det.DOCVD_SubImporteVenta * TC.TIPOC_VentaSunat End) As DOCVD_SubImporteVenta
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad Else 0 End) As ImporteDolares
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad Else Det.DOCVD_PrecioUnitario * Det.DOCVD_Cantidad * TC.TIPOC_VentaSunat End) As ImporteSoles
	
	,Ven.DOCVE_DescripcionCliente
	
	,L.LINEA_Nombre
	,sl.LINEA_Nombre As SubLinea
	,Det.DOCVE_Codigo
	,Det.ARTIC_Codigo
	,Det.DOCVD_Cantidad
	,Det.DOCVD_Importe
	,Ven.ENTID_CodigoVendedor
	,Det.DOCVD_CostoUnitario
	,Det.DOCVD_CostoUnitarioSoles
	,Det.DOCVD_TipoCambioCosto
	,Det.DOCVD_PesoUnitario
	,Vend.ENTID_RazonSocial
	,Art.LINEA_Codigo
	,Ven.TIPOS_CodTipoMoneda
	,Ven.DOCVE_TipoCambioSunat
	,Ven.TIPOS_CodTipoDocumento
From Data.VENT_DocsVenta as Ven
	Inner join Data.VENT_DocsVentaDetalle as Det on Ven.DOCVE_Codigo = Det.DOCVE_Codigo
	Inner join Entidades as Vend on Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Inner join Articulos as Art on Det.ARTIC_Codigo = Art.ARTIC_Codigo And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	Inner join Lineas as l on l.LINEA_Codigo = Left(Art.LINEA_Codigo, 2)
	Inner join Lineas as sl on Art.LINEA_Codigo = sl.LINEA_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
where Ven.DOCVE_Estado <> 'X' 
	--And Det.ARTIC_Codigo not in ('1301001', '1301002')
	And CONVERT(DATE, DOCVE_FechaDocumento) Between CONVERT(DATE, @FecIni) And CONVERT(DATE, @FecFin)
	And DOCVE_FechaDocumento < '08-19-2013'
	And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Ven.ENTID_CodigoCliente)
	And Ven.ENTID_CodigoVendedor = ISNULL(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
order by Vendedor, Linea, SubLinea, ARTIC_Descripcion, DOCVE_FechaDocumento desc
	


GO 
/***************************************************************************************************************************************/ 

exec ADMIN_REPOSS_VentasTotales @FecIni='2018-07-01 00:00:00',@FecFin='2018-07-31 00:00:00',@PVENT_Id=1,@Linea=NULL,@Cargar=0,@ENTID_CodigoCliente=NULL,@ENTID_CodigoVendedor=NULL