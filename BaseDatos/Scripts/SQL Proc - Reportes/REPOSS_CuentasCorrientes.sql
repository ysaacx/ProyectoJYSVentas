GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_CuentasCorrientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_CuentasCorrientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/10/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_CuentasCorrientes]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_Codigo VarChar(14) = Null
	,@PVENT_Id Id
	,@Fecha Bit
)
As

Print @Fecha
Print Convert(Date, '01-01-2000')
Print @FecIni
If @Fecha = 0
	Set @FecIni = Convert(Date, '01-01-2010')

Select DPag.DPAGO_Numero
	,DPag.DPAGO_Id
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_DescripcionCliente As ENTID_RazonSocial
	,DPag.DPAGO_Fecha	
	,DPag.DPAGO_Importe 
	,Caj.CAJA_Fecha
	,TPag.TIPOS_Descripcion As TIPOS_TipoPago
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_FechaDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	--,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	,TDoc.TIPOS_DescCorta As TIPOS_DocCorta
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,Caj.TIPOS_CodMonedaPago
	,Caj.TIPOS_CodTipoMoneda
	,MTPag.TIPOS_DescCorta As TIPOS_TipoMonedaPago
	,Ven.TIPOS_CodTipoMoneda
	,Ven.DOCVE_TotalPagar
	,Caj.CAJA_Importe
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImporteSoles
	,Case Caj.TIPOS_CodTransaccion 
		When 'TPG09' Then 
		(Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
						  Where DOCVE_Codigo = Ven.DOCVE_Codigo
							And CAJA_Estado <> 'X'
							And TIPOS_CodTransaccion = 'TPG09'
							And Convert(Date, CAJA_Fecha) < @FecFin
			 ), 0)  * (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
		 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And TIPOS_CodTransaccion = 'TPG09'
						And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0)	 
		 End)
		When 'TPG10' Then 
		(Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
						  Where DOCVE_Codigo = Ven.DOCVE_Codigo
							And CAJA_Estado <> 'X'
							And TIPOS_CodTransaccion = 'TPG10'
							And CAJA_Codigo = CDPag.CAJA_Codigo
							And Convert(Date, CAJA_Fecha) < @FecFin
			 ), 0)  * (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
		 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And TIPOS_CodTransaccion = 'TPG10'
						And CAJA_Codigo = CDPag.CAJA_Codigo
						And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0)	 
		 End)
		Else
		 (Case Ven.TIPOS_CodTipoMoneda When 'MND2'
			Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
						  Where DOCVE_Codigo = Ven.DOCVE_Codigo
							And CAJA_Estado <> 'X'
							And CAJA_Codigo = CDPag.CAJA_Codigo
							And Convert(Date, CAJA_Fecha) < @FecFin
			 ), 0)  * (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)
		 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Codigo = CDPag.CAJA_Codigo
						And CAJA_Estado <> 'X'
						And Convert(Date, CAJA_Fecha) <= @FecFin
		 ), 0)	 
		 End)
		End
	 As TotalPagado
	,(Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End) As DOCVE_TipoCambio
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			Caj.CAJA_Importe
		Else 
			(Case DPag.TIPOS_CodTipoMoneda 
				When 'MND1' Then 0.00
				When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe / (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End))
			 End
			)
		End As TotalPagadoDolares
	--,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
	--	Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
	--				  Where DOCVE_Codigo = Ven.DOCVE_Codigo
	--					And CAJA_Estado <> 'X'
	--					And Convert(Date, CAJA_Fecha) <= @FecFin
	-- ), 0)  
	-- Else 0.00	 
	-- End As TotalPagadoDolares
	,IsNull('Dep. / ' + IsNull(TPag.TIPOS_Descripcion, '')
		+ ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') 
		+ ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
		+ ' / Cta: ' + IsNull(RTrim(Cta.CUENT_Numero  + ' - ' + TCta.TIPOS_DescCorta), '') 		
		+ ' / Fecha: ' + ISNULL(CONVERT(Varchar, DPag.DPAGO_FechaVenc, 103), '') 
		+ ' / ' + IsNull(Ent.ENTID_RazonSocial, '')
		+ ' / Importe: ' + MTPag.TIPOS_DescCorta + ' ' +  CONVERT(varchar(30), CONVERT(money, DPag.DPAGO_Importe), 1) --Rtrim(DPag.DPAGO_Importe)
		+  Case DPag.TIPOS_CodTipoMoneda When 'MND2' Then ' / T.C.: '  + CONVERT(varchar(30), CONVERT(money, (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End), 2))
		   Else '' End
	 ,Caj.CAJA_Glosa)  As Glosa
	 ,Caj.CAJA_Glosa
From Tesoreria.TESO_DocsPagos As DPag
	Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.DPAGO_Id = DPag.DPAGO_Id And CDPag.PVENT_Id = DPag.PVENT_Id
	Inner Join Tesoreria.TESO_Caja As Caj on Caj.CAJA_Codigo = CDPag.CAJA_Codigo And Caj.PVENT_Id = CDPag.PVENT_Id
	
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = DPag.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
	Left Join Cuentas As Cta On Cta.CUENT_Id = DPag.CUENT_Id
	Inner Join Tipos As MTPag On MTPag.TIPOS_Codigo = DPag.TIPOS_CodTipoMoneda
	Left Join Tipos As TCta On TCta.TIPOS_Codigo = Cta.TIPOS_CodTipoCuenta 
	
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = DPag.ENTID_Codigo
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Caj.CAJA_Fecha) Between @FecIni And @FecFin
	--And Ven.DOCVE_Estado <> 'X'
	--And Ven.PVENT_Id = @PVENT_Id
	--And Ven.TIPOS_CodTipoDocumento <> 'CPDLE'
	And DPag.ENTID_Codigo = IsNull(@ENTID_Codigo, DPag.ENTID_Codigo)
Order By Caj.CAJA_Fecha, DPAGO_Numero, DOCVE_FechaDocumento
--Update #Facturas
--Set Titulo = (Select #Facturas.TIPOS_Descripcion + '/s - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
--				   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
--						And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
--				  )
--Update #Facturas Set Title = '01.- ' + Titulo 

--Select * From #Facturas 
--Order By DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

