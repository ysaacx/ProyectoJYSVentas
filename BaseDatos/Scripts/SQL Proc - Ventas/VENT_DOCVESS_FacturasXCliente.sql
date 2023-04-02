GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_FacturasXCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_DOCVESS_FacturasXCliente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_FacturasXCliente]
(
	@ENTID_Codigo VarChar(14)
	,@PVENT_Id BigInt
	,@Todos Bit = Null
)
As

Select Ven.ENTID_CodigoCliente
	,Ven.TIPOS_CodTipoDocumento
	,Ent.ENTID_NroDocumento			
	,Ent.ENTID_RazonSocial				
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_FechaDocumento
	,(Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else Ven.DOCVE_TotalPagar*TC.TIPOC_VentaSunat End) As DOCVE_TotalPagar
	,Case Ven.TIPOS_CodTipoDocumento When 'CPDLE' Then (Select DPAGO_Numero From Tesoreria.TESO_DocsPagos Where DOCVE_Codigo = Ven.DOCVE_Codigo)
		Else Ven.DOCVE_Serie
	 End As DOCVE_Serie
	,Ven.DOCVE_Numero
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where DOCVE_Codigo = Ven.DOCVE_Codigo
					And CAJA_Estado <> 'X'
	 ), 0)) * TC.TIPOC_VentaSunat
	 Else (Ven.DOCVE_TotalPagar
		- IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where DOCVE_Codigo = Ven.DOCVE_Codigo
					And CAJA_Estado <> 'X'
	 ), 0))
	 End As SaldoPendiente
	,Case TIPOS_CodTipoMoneda When 'MND2'
		Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
	 ), 0)  * TC.TIPOC_VentaSunat
	 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where DOCVE_Codigo = Ven.DOCVE_Codigo
					And CAJA_Estado <> 'X'
	 ), 0)	 
	 End
	 As DOCVE_TotalPagado
	 ,(Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0 End) As TotalDolares
Into #Facturas
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
Where Ven.ENTID_CodigoCliente = @ENTID_Codigo
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id


If IsNull(@Todos, 0) = 1 
Begin
	Select * From #Facturas
	Order By DOCVE_Codigo
End
Else
Begin
	Select * From #Facturas Where SaldoPendiente > 0
	Order By DOCVE_Codigo
End



GO 
/***************************************************************************************************************************************/ 

