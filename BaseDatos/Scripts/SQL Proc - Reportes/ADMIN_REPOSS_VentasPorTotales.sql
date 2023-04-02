GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ADMIN_REPOSS_VentasPorTotales]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ADMIN_REPOSS_VentasPorTotales] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ADMIN_REPOSS_VentasPorTotales]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt = Null
	,@ENTID_CodigoVendedor VarChar(14) = Null
)
As
--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'

Select Ven.ENTID_CodigoCliente
	,Ent.ENTID_RazonSocial As DOCVE_DescripcionCliente
	,Vend.ENTID_RazonSocial As Vendedor
	,SUM(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As DOCVE_ImporteVenta
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As DOCVE_ImporteIgv
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalVenta
	,Sum(Ven.DOCVE_ImportePercepcionSoles) As DOCVE_ImportePercepcion
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Ven.PVENT_Id
Into #Ventas
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
Where DOCVE_FechaDocumento > '08-18-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.TIPOS_CodTipoDocumento In ('CPD01', 'CPD03')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
	And Ven.ENTID_CodigoVendedor = IsNull(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
Group By Ven.ENTID_CodigoCliente
	,Ent.ENTID_RazonSocial
	,Vend.ENTID_RazonSocial
	,Ven.PVENT_Id
Union All
Select Ven.ENTID_CodigoCliente
	,Ent.ENTID_RazonSocial As DOCVE_DescripcionCliente
	,Vend.ENTID_RazonSocial As Vendedor
	,SUM(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As DOCVE_ImporteVenta
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As DOCVE_ImporteIgv
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalVenta
	,Sum(Ven.DOCVE_ImportePercepcionSoles) As DOCVE_ImportePercepcion
	,Sum(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Ven.PVENT_Id
From Data.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
Where DOCVE_FechaDocumento < '08-19-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Not Ven.TIPOS_CodTipoDocumento In ('CPDLE')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
	And Ven.ENTID_CodigoVendedor = IsNull(@ENTID_CodigoVendedor, Ven.ENTID_CodigoVendedor)
Group By Ven.ENTID_CodigoCliente
	,Ent.ENTID_RazonSocial
	,Vend.ENTID_RazonSocial
	,Ven.PVENT_Id
Order By DOCVE_DescripcionCliente


Select ENTID_CodigoCliente
	,DOCVE_DescripcionCliente
	,SUM(DOCVE_ImporteVenta) As DOCVE_ImporteVenta
	,Sum(DOCVE_ImporteIgv) As DOCVE_ImporteIgv
	,Sum(DOCVE_TotalVenta) As DOCVE_TotalVenta
	,Sum(DOCVE_ImportePercepcion) As DOCVE_ImportePercepcion
	,Sum(DOCVE_TotalPagar) As DOCVE_TotalPagar
	,PVENT_Id
From #Ventas
Group By ENTID_CodigoCliente
	,DOCVE_DescripcionCliente
	,PVENT_Id
Order By DOCVE_TotalVenta Desc
Drop Table #Ventas


GO 
/***************************************************************************************************************************************/ 

