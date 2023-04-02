GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaFacturasPendientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaFacturasPendientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaFacturasPendientes]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_Codigo VarChar(14) = Null
)
As

Select 
	(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar*TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) < @FecIni
					And CAJA_Estado <> 'X'
	 ), 0)) * TC.TIPOC_VentaSunat
	 Else (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) < @FecIni
					And CAJA_Estado <> 'X'
	 ), 0))
	 End As SaldoPendiente
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) < @FecFin
						And CAJA_Estado <> 'X'
	 ), 0)  * TC.TIPOC_VentaSunat
	 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) < @FecIni
					And CAJA_Estado <> 'X'
	 ), 0)	 
	 End
	 As DOCVE_TotalPagado
	 ,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End) As TotalDolares
	 ,ENTID_CodigoCliente
Into #Sal
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
Where Not Ven.ENTID_CodigoCliente In ('20100241022')
	And Convert(Date, Ven.DOCVE_FechaDocumento) < @FecIni
			And Ven.DOCVE_Estado <> 'X'
Order By Ven.DOCVE_Codigo

Select SUM(SaldoPendiente) As FLETE_TotIngreso --, SUM(DOCVE_TotalPagar), Sum(DOCVE_TotalPagado) As DOCVE_TotalPagado, SUM(TotalDolares)  
From #Sal
Where ENTID_CodigoCliente = ISNULL(@ENTID_Codigo, ENTID_CodigoCliente)

Select Ven.ENTID_CodigoCliente
	,Ent.ENTID_NroDocumento			
	,Ent.ENTID_RazonSocial				
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_FechaDocumento
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar*TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) <= @FecFin
					And CAJA_Estado <> 'X'
	 ), 0)) * TC.TIPOC_VentaSunat
	 Else (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) <= @FecFin
					And CAJA_Estado <> 'X'
	 ), 0))
	 End As SaldoPendiente
	,Ven.DOCVE_FechaDocumento
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado <> 'X'
	 ), 0)  * TC.TIPOC_VentaSunat
	 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where CAJA_NroDocumento = Ven.DOCVE_Codigo
					And Convert(Date, CAJA_Fecha) <= @FecFin
					And CAJA_Estado <> 'X'
	 ), 0)	 
	 End
	 As DOCVE_TotalPagado
	 ,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End) As TotalDolares
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
Where Not Ven.ENTID_CodigoCliente In ('20100241022')
	--And Fle.ENTID_Codigo = IsNull(@ENTID_Codigo, Fle.ENTID_Codigo)
	And Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
			And Ven.DOCVE_Estado <> 'X'
			And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_Codigo, Ven.ENTID_CodigoCliente)
Order By Ven.DOCVE_Codigo -- Fle.FLETE_Id 
	


GO 
/***************************************************************************************************************************************/ 

