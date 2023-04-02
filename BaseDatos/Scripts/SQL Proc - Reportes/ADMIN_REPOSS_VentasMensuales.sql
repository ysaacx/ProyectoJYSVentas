USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ADMIN_REPOSS_VentasMensuales]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ADMIN_REPOSS_VentasMensuales] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ADMIN_REPOSS_VentasMensuales]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Linea VarChar(10) = Null
	,@Cargar Bit
	,@ENTID_CodigoCliente VarChar(14) = Null
	,@ENTID_CodigoVendedor VarChar(14) = Null
)
As
--Select * From Data.VENT_DocsVenta
--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'

Select Det.ARTIC_Codigo 
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta As TIPOS_UnidadMedida
	,Sum(Det.DOCVD_Cantidad) As DOCVD_Cantidad
	,Sum(Det.DOCVD_Cantidad * Art.ARTIC_Peso) As SubPeso
	,0 As DOCVE_TotalPagar
	,Year(Cab.DOCVE_FechaDocumento) As Anho
	,Month(Cab.DOCVE_FechaDocumento) As Mes
	,SUM(Det.DOCVD_SubTotal) As DOCVD_SubImporteVenta
	,Sum(Det.DOCVD_Cantidad *  Det.DOCVD_PrecioUnitario) As DOCVD_SubImporteVent
	,'Old' As Base
Into #VentasDetalle
From Data.VENT_DocsVentaDetalle As Det
	Inner Join Data.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = Det.DOCVE_Codigo
		And Cab.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Cab.ENTID_CodigoCliente)
		And Cab.ENTID_CodigoVendedor = ISNULL(@ENTID_CodigoVendedor, Cab.ENTID_CodigoVendedor)
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
WHERE CONVERT(DATE, DOCVE_FechaDocumento) Between CONVERT(DATE, @FecIni) And CONVERT(DATE, @FecFin)
	And Not Cab.DOCVE_Codigo In (Select DOCVE_Codigo From Ventas.VENT_DocsVenta)
	And Cab.DOCVE_Estado <> 'X'
Group By Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Year(Cab.DOCVE_FechaDocumento)
	,Month(Cab.DOCVE_FechaDocumento)
Union All
Select
	Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Sum(Det.DOCVD_Cantidad)
	,Sum(Det.DOCVD_Cantidad * Art.ARTIC_Peso)
	,0 As DOCVE_TotalPagar
	,Year(Cab.DOCVE_FechaDocumento) As Anho
	,Month(Cab.DOCVE_FechaDocumento) As Mes
	,SUM(Det.DOCVD_SubImporteVenta)
	,Sum(Convert(decimal(12, 4), Det.DOCVD_Cantidad) *  Det.DOCVD_PrecioUnitario)
	,'New' As Base
From Ventas.VENT_DocsVentaDetalle As Det
	Inner Join Ventas.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = Det.DOCVE_Codigo
		And Cab.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Cab.ENTID_CodigoCliente)
		And Cab.ENTID_CodigoVendedor = ISNULL(@ENTID_CodigoVendedor, Cab.ENTID_CodigoVendedor)
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like IsNull(@Linea, Art.LINEA_Codigo) + '%'
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where CONVERT(DATE, DOCVE_FechaDocumento) Between CONVERT(DATE, @FecIni) And CONVERT(DATE, @FecFin)
	And Cab.DOCVE_Estado <> 'X'
Group By Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Year(Cab.DOCVE_FechaDocumento)
	,Month(Cab.DOCVE_FechaDocumento)
Order By ARTIC_Codigo, Anho, Mes

Select ARTIC_Codigo, ARTIC_Descripcion, TIPOS_UnidadMedida From #VentasDetalle Group By ARTIC_Codigo, ARTIC_Descripcion, TIPOS_UnidadMedida
Order by ARTIC_Descripcion
--If @Cargar = 1
	Select * From #VentasDetalle


GO 
/***************************************************************************************************************************************/ 

exec ADMIN_REPOSS_VentasMensuales @FecIni='2018-01-01 00:00:00',@FecFin='2018-05-31 00:00:00',@Linea=NULL,@Cargar=1,@ENTID_CodigoCliente=NULL,@ENTID_CodigoVendedor=NULL

