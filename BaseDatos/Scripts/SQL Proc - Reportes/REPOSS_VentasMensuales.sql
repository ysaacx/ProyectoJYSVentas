GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_VentasMensuales]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_VentasMensuales] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_VentasMensuales]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As
--Select * From Data.VENT_DocsVenta
--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'

Select Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Sum(Det.DOCVD_Cantidad) As DOCVD_Cantidad
	,Sum(Det.DOCVD_Cantidad * Art.ARTIC_Peso) As Peso
	,SUM(Cab.DOCVE_TotalPagar) As DOCVE_TotalPagar
	,Year(Cab.DOCVE_FechaDocumento) As Anho
	,Month(Cab.DOCVE_FechaDocumento) As Mes
From Data.VENT_DocsVentaDetalle As Det
	Inner Join Data.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = Det.DOCVE_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where DOCVE_FechaDocumento Between @FecIni And @FecFin
	And Not Cab.DOCVE_Codigo In (Select DOCVE_Codigo From Ventas.VENT_DocsVenta)
Group By Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Year(Cab.DOCVE_FechaDocumento)
	,Month(Cab.DOCVE_FechaDocumento)
Union All
Select Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Sum(Det.DOCVD_Cantidad)
	,Sum(Det.DOCVD_Cantidad * Art.ARTIC_Peso)
	,SUM(Cab.DOCVE_TotalPagar) As DOCVE_TotalPagar
	,Year(Cab.DOCVE_FechaDocumento) As Anho
	,Month(Cab.DOCVE_FechaDocumento) As Mes
From Ventas.VENT_DocsVentaDetalle As Det
	Inner Join Ventas.VENT_DocsVenta As Cab On Cab.DOCVE_Codigo = Det.DOCVE_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where DOCVE_FechaDocumento Between @FecIni And @FecFin
Group By Det.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,TUni.TIPOS_DescCorta
	,Year(Cab.DOCVE_FechaDocumento)
	,Month(Cab.DOCVE_FechaDocumento)
Order By Anho, Mes


GO 
/***************************************************************************************************************************************/ 

