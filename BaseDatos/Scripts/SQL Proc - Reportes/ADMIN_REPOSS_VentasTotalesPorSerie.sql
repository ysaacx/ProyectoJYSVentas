GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ADMIN_REPOSS_VentasTotalesPorSerie]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ADMIN_REPOSS_VentasTotalesPorSerie] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 02/01/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ADMIN_REPOSS_VentasTotalesPorSerie]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt = Null
	,@ENTID_CodigoVendedor VarChar(14) = Null
)
As

--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'

Select Ven.DOCVE_Serie
	,SUM(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As DOCVE_ImporteVenta
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As DOCVE_ImporteIgv
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalVenta
	,Sum(Ven.DOCVE_ImportePercepcionSoles) As DOCVE_ImportePercepcion
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,IsNull((Select Sum(Art.ARTIC_Peso * D.DOCVD_Cantidad)
		From Ventas.VENT_DocsVentaDetalle As D
			Inner Join Articulos As Art On Art.ARTIC_Codigo = D.ARTIC_Codigo
		Where D.DOCVE_Codigo = Ven.DOCVE_Codigo
	 ), 0) As DOCVE_TotalPeso
	,Ven.PVENT_Id
	,PVen.PVENT_Descripcion As CAJA_Glosa
	,'Old' As Origen
Into #Ventas
From Ventas.VENT_DocsVenta As Ven
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
	Inner Join PuntoVenta As PVen On PVen.PVENT_Id = Ven.PVENT_Id And PVen.PVENT_Id = @PVENT_Id
Where DOCVE_FechaDocumento > '08-18-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.TIPOS_CodTipoDocumento In ('CPD01', 'CPD03')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
	And Ven.ENTID_CodigoVendedor = IsNull(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
Group By Ven.PVENT_Id
	,Ven.DOCVE_Serie
	,PVen.PVENT_Descripcion
	,Ven.DOCVE_Codigo
Union All
Select Ven.DOCVE_Serie
	,SUM(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As DOCVE_ImporteVenta
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As DOCVE_ImporteIgv
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalVenta
	,Sum(Ven.DOCVE_ImportePercepcionSoles) As DOCVE_ImportePercepcion
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Sum(IsNull(DOCVE_TotalPeso, 0)) As DOCVE_TotalPeso
	,Ven.PVENT_Id
	,PVen.PVENT_Descripcion As CAJA_Glosa
	,'New' As Origen
From Data.VENT_DocsVenta As Ven
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
	Inner Join PuntoVenta As PVen On PVen.PVENT_Id = Ven.PVENT_Id And PVen.PVENT_Id = @PVENT_Id
Where DOCVE_FechaDocumento < '08-19-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.TIPOS_CodTipoDocumento In ('CPD01', 'CPD03')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
	And Ven.ENTID_CodigoVendedor = IsNull(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
Group By Ven.PVENT_Id
	,Ven.DOCVE_Serie
	,PVen.PVENT_Descripcion
	,Ven.DOCVE_Codigo

Select DOCVE_Serie
	,SUM(DOCVE_ImporteVenta) As DOCVE_ImporteVenta
	,Sum(DOCVE_ImporteIgv) As DOCVE_ImporteIgv
	,Sum(DOCVE_TotalVenta) As DOCVE_TotalVenta
	,Sum(DOCVE_ImportePercepcion) As DOCVE_ImportePercepcion
	,Sum(DOCVE_TotalPagar) As DOCVE_TotalPagar
	,SUM(DOCVE_TotalPeso)/1000 As DOCVE_TotalPeso
	,PVENT_Id
	,CAJA_Glosa
From #Ventas
Group By PVENT_Id
	,DOCVE_Serie
	,CAJA_Glosa
Order By DOCVE_TotalVenta Desc

Select * From #Ventas where docve_serie = '010'
Drop Table #Ventas


GO 
/***************************************************************************************************************************************/ 

