GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ADMIN_REPOSS_VentasPorCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ADMIN_REPOSS_VentasPorCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 18/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ADMIN_REPOSS_VentasPorCliente]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_CodigoCliente VarChar(14)
	,@PVENT_Id BigInt = Null	
)
As

--Declare @FecIni DateTime Set @FecIni = '01-01-2013'
--Declare @FecFin DateTime Set @FecFin = '10-18-2013'
--Declare @ENTID_CodigoCliente VarChar(14) Set @ENTID_CodigoCliente = '20455777837'

Select ENTID_CodigoCliente
	,ENTID_CodigoCliente As ENTID_NroDocumento
	--,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	,DOCVE_DescripcionCliente As ENTID_Cliente
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As ImporteSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As IGVSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalVenta Else 0 End) As DOCVE_TotalVenta
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As TotalVenta
	,Ven.DOCVE_PorcentajePercepcion
	,Ven.DOCVE_AfectoPercepcionSoles
	,Ven.DOCVE_ImportePercepcionSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End) As TotalDolares
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat End) As TotalSoles
	,DOCVE_Codigo
	,PV.PVENT_Id
	,PV.PVENT_Descripcion As CAJA_Glosa
	,Ven.TIPOS_CodTipoDocumento
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,Ven.DOCVE_FechaDocumento
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TC.TIPOC_VentaSunat
	,Left(TDoc.TIPOS_DescCorta, 1) As TIPOS_TipoDocCorta
	,(Select Sum(DOCVD_Cantidad * Art.ARTIC_Peso)
		From Ventas.VENT_DocsVentaDetalle As D
			Inner Join Articulos As Art On Art.ARTIC_Codigo = D.ARTIC_Codigo
		Where DOCVE_Codigo = Ven.DOCVE_Codigo) As DOCVE_TotalPeso
	,'Nuevo' As Origen
Into #Ventas
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Inner Join PuntoVenta As PV On PV.PVENT_Id = Ven.PVENT_Id
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
Where DOCVE_FechaDocumento > '08-18-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.TIPOS_CodTipoDocumento In ('CPD01', 'CPD03')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.ENTID_CodigoCliente = @ENTID_CodigoCliente
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
Union All
Select ENTID_CodigoCliente
	,ENTID_CodigoCliente As ENTID_NroDocumento
	--,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	,DOCVE_DescripcionCliente
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteVenta Else Ven.DOCVE_ImporteVenta * TC.TIPOC_VentaSunat End) As ImporteSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_ImporteIgv Else Ven.DOCVE_ImporteIgv * TC.TIPOC_VentaSunat End) As IGVSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalVenta Else 0 End) As DOCVE_TotalVenta
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalVenta Else Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat End) As TotalVenta
	,Ven.DOCVE_PorcentajePercepcion
	,Ven.DOCVE_AfectoPercepcionSoles
	,Ven.DOCVE_ImportePercepcionSoles
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End) As TotalDolares
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat End) As TotalSoles
	,DOCVE_Codigo
	,PV.PVENT_Id
	,PV.PVENT_Descripcion
	,Ven.TIPOS_CodTipoDocumento
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,Ven.DOCVE_FechaDocumento
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TC.TIPOC_VentaSunat
	,Left(TDoc.TIPOS_DescCorta, 1) As TIPOS_TipoDocCorta
	,Ven.DOCVE_TotalPeso
	,'Antiguo' As Origen
From Data.VENT_DocsVenta As Ven
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Inner Join PuntoVenta As PV On PV.PVENT_Id = Ven.PVENT_Id
	Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = Convert(Date, Ven.DOCVE_FechaDocumento)
Where DOCVE_FechaDocumento < '08-18-2013'
	And Convert(Date, DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.TIPOS_CodTipoDocumento In ('CPD01', 'CPD03')
	And Ven.DOCVE_Estado <> 'X'
	And Ven.ENTID_CodigoCliente <> '20100241022'
	And Ven.ENTID_CodigoCliente = @ENTID_CodigoCliente
	And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
	--And Ven.PVENT_Id = ISNULL(@PVENT_Id, Ven.PVENT_Id)
--Group By Ven.ENTID_CodigoCliente
--	,Ent.ENTID_RazonSocial
--	,Vend.ENTID_RazonSocial
--	,Ven.PVENT_Id
Select * From #Ventas

Select * From Ventas.VENT_DocsVentaDetalle
Where DOCVE_Codigo In (Select DOCVE_Codigo From #Ventas)


GO 
/***************************************************************************************************************************************/ 

