USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_CuadreCaja_Facturas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Facturas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Facturas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
)
As

/* Facturas Disponibles */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	, ISNULL('[' + Ent.ENTID_NroDocumento + '] - ', '') + ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '-')  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImpSoles
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero	
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Ven.TIPOS_CodTipoDocumento <> 'CPDLE'
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '-')
	 As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImpSoles
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Case ISNUMERIC((Select DPAGO_Numero From Tesoreria.TESO_DocsPagos Where DOCVE_Codigo = Ven.DOCVE_Codigo)) When 1
		Then Right('0000000000' + (Select DPAGO_Numero From Tesoreria.TESO_DocsPagos Where DOCVE_Codigo = Ven.DOCVE_Codigo), 10)
		Else Ven.DOCVE_Numero End
	 As DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Ven.TIPOS_CodTipoDocumento = 'CPDLE'
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All /* Factura Anulada en otro Tiempo */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As ImpSoles
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni And Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All /* Facturas Anuladas */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,'ANULADO' As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,'' As Moneda
	,0.00 As TCambioVenta
	,0.00 As ImpDolares
	,0.00 As ImpSoles	
	,'' As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
/* Actualizar la Numeración de Fletes */
Update #Facturas
Set Titulo = (Select #Facturas.TIPOS_Descripcion + ' - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
				   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
						And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
				  )
Update #Facturas Set Title = '01.- ' + Titulo 


Select * From #Facturas 
Order By DOCVE_Codigo



GO 
/***************************************************************************************************************************************/ 

