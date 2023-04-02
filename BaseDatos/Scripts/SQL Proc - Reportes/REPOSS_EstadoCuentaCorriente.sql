USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_EstadoCuentaCorriente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_EstadoCuentaCorriente] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/08/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_EstadoCuentaCorriente]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_Codigo VarChar(14)
	,@PVENT_Id Id
)
As

Select '' As DOCVE_Codigo
	,DateAdd(DAY, -1, @FecIni) DOCVE_FechaDocumento
	,'' As TIPOS_TipoDocCorta
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'Saldo Inicial Al ' + CONVERT(VarChar(10), DateAdd(DAY, -1, @FecIni), 103) As ENTID_RazonSocial
	,'' As TIPOS_TipoMoneda
	,0.00 As DOCVE_TipoCambio
	,Sum(Cargo)	 As Cargo
	,0.00 As Abono
	,'' As DOCVE_Estado
From (
	Select Sum(Case Ven.TIPOS_CodTipoMoneda
			When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
															Else Ven.DOCVE_TipoCambio
													  End)
			 Else  Ven.DOCVE_TotalPagar
			 End)
		As Cargo
		From Ventas.VENT_DocsVenta As Ven
			Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
		Where Convert(Date, Ven.DOCVE_FechaTransaccion) < @FecIni
			And Ven.DOCVE_Estado <> 'X'
			And Ven.PVENT_Id = @PVENT_Id
			And Ven.TIPOS_CodTipoDocumento <> 'CPDLE'
			And Ven.ENTID_CodigoCliente = @ENTID_Codigo
		Union All
		Select -1*IsNull(Sum(CAJA_Importe), 0) As Abono
		From Tesoreria.TESO_Caja As Caj
			Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
			Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
		Where ENTID_Codigo = @ENTID_Codigo
			And Convert(Date, CAJA_Hora) < @FecIni
			And Caj.CAJA_Estado <> 'X') As SaldoInicial
			
Union All
Select Ven.DOCVE_Codigo
	,Ven.DOCVE_FechaDocumento
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_Descripcion + '' As ENTID_RazonSocial
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As DOCVE_TipoCambio
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Cargo
	,0.00 Abono
	,Ven.DOCVE_Estado
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Ven.TIPOS_CodTipoDocumento <> 'CPDLE'
	And Ven.ENTID_CodigoCliente = @ENTID_Codigo
Union All
Select Caj.CAJA_Codigo
	,CAJA_Hora
	,'Caj'
	,CAJA_Serie
	,CAJA_Numero
	,TCaj.TIPOS_Descripcion 
		+ IsNull(' - Banco: ' + Ban.BANCO_DescCorta 
				 + ' - Fecha: ' + Convert(VarChar(10), DPag.DPAGO_Fecha, 103)
				 + ' - Operacion: ' + DPag.DPAGO_Numero
		, '')
	 + ' / Cancelación : '  
	 + IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')
	 As ENTID_RazonSocial
	--,'Caj ' + CAJA_Serie + ' - ' + Right('0000000' + RTrim(CAJA_Numero), 7)
	,Caj.TIPOS_CodTipoMoneda
	,CAJA_TCambio
	--,CAJA_Importe
	,0.00
	,CAJA_Importe As Salida
	,CAJA_Estado
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.DOCVE_Estado <> 'X'
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As TDPag On TDPag.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = TDPag.DPAGO_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where Caj.ENTID_Codigo = @ENTID_Codigo
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
Order By DOCVE_FechaDocumento Asc, TIPOS_TipoDocCorta
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

exec REPOSS_EstadoCuentaCorriente @FecIni='2018-01-07 00:00:00',@FecFin='2018-07-07 00:00:00',@ENTID_Codigo=N'20602257631',@PVENT_Id=1