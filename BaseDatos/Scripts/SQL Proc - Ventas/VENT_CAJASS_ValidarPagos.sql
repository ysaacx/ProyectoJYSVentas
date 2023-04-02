GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_ValidarPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_ValidarPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 03/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJASS_ValidarPagos]
(
	@FecFin DateTime
	,@PVENT_Id Id
	,@ENTID_RazonSocial VarChar(150)
)
As


--Declare @PVENT_Id BigInt  Set @PVENT_Id = 5
--Declare @FecFin DateTime  Set @FecFin = '10-03-2013'

select RTRim(Ven.ENTID_CodigoCliente) As ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,CONVERT(Bit, 0 ) As Seleccion
	,DOCVE_FechaPago
	,DOCVE_FechaPago As DOCVE_FechaPago_Old
	,Ven.DOCVE_Codigo
	,ISNULL(TDoc.TIPOS_DescCorta, 'Fle') As TipoDocumento
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_FechaDocumento
	,Ven.TIPOS_CodTipoMoneda
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
		Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
					 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
																	Else Ven.DOCVE_TipoCambio
							   End)
		 Else (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						--And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) > @FecFin
					 ), 0))
		 End
	 As PendienteSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (Ven.DOCVE_TotalPagar
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado <> 'X'
					 ), 0)
			- IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
					  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
						And CAJA_Estado = 'X'
						And CAJA_AnuladoCaja = 1
						And Convert(Date, CAJA_FechaAnulado) >= @FecFin
					 ), 0))
			
		 Else 0.00
		 End
	 As PendienteDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
						  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
						 ), 0)) * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
																		Else Ven.DOCVE_TipoCambio
								   End)
		 Else (IsNull((Select SUM(ABS(CAJA_Importe)) From Tesoreria.TESO_Caja As Caj
						  Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
							And Convert(Date, CAJA_Fecha) <= @FecFin
							And CAJA_Estado <> 'X'
						 ), 0))
		 End
	 As Pago
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImpSoles
	,(Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
				   End) As TCambioVenta
	,Ven.ENTID_CodigoVendedor + ' - ' + Vend.ENTID_RazonSocial As ENTID_RazonSocialVendedor
	,Ven.TIPOS_CodTipoDocumento
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Entidades As Vend On Vend.ENTID_Codigo = Ven.ENTID_CodigoVendedor
Where --Convert(Date, Ven.DOCVE_FechaTransaccion) >= @FecFin
	Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
	And Ent.ENTID_RazonSocial Like '%' + @ENTID_RazonSocial + '%'
	And Convert(Date, Ven.DOCVE_FechaPago) <= @FecFin

Select * From #Facturas 
Where TIPOS_CodTipoDocumento <> 'CPD07'
	And PendienteSoles > 0
Order By ENTID_RazonSocial, DOCVE_FechaDocumento, DOCVE_Codigo

Drop table #Facturas


GO 
/***************************************************************************************************************************************/ 

