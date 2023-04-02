GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VEN_CAJASS_FacturasXCancelar]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VEN_CAJASS_FacturasXCancelar] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VEN_CAJASS_FacturasXCancelar]
(
	@ENTID_Codigo CodEntidad
	,@PVENT_Id Id
)

AS

	Select Ven.DOCVE_Codigo
		,Case Ven.TIPOS_CodTipoDocumento When 'CPDLE' Then '000'
			Else Ven.DOCVE_Serie
		 End As DOCVE_Serie
		,Ven.DOCVE_Numero
		,Ven.DOCVE_FechaDocumento
		,Ven.TIPOS_CodTipoMoneda
		,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
		,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
		,TMon.TIPOS_Descripcion
		,Ven.DOCVE_TotalPagar
		,Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then
				IsNull((Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda)
								When 'MND1' Then CAJA_Importe
											Else CAJA_Importe * CAJA_TCambio
							End
						) 
					From Tesoreria.TESO_Caja As Caj
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
			When 'MND2' Then
				IsNull((Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda) 
								When 'MND1' Then CAJA_Importe / (Case CAJA_TCambio When 0 Then TC.TIPOC_VentaSunat Else CAJA_TCambio End)
											Else CAJA_Importe
							End
						) 
					From Tesoreria.TESO_Caja As Caj
						Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = CONVERT(Date, Caj.CAJA_Fecha)
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
		 End As DOCVE_TotalPagado
		,Ven.DOCVE_TotalPagar - IsNull(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then
				IsNull(
						(Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda)
								When 'MND1' Then CAJA_Importe
											Else CAJA_Importe * CAJA_TCambio
							End
							) 
							From Tesoreria.TESO_Caja As Caj
							Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
								And CAJA_Estado <> 'X'
								And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
			When 'MND2' Then
				IsNull((Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda) 
								When 'MND1' Then CAJA_Importe / (Case CAJA_TCambio When 0 Then TC.TIPOC_VentaSunat Else CAJA_TCambio End)
											Else CAJA_Importe
							End
						) 
					From Tesoreria.TESO_Caja As Caj
						Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = CONVERT(Date, Caj.CAJA_Fecha)
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
		 End, 0) As SaldoPendiente
		,Usr.ENTID_RazonSocial As Usuario
		,Ven.ENTID_CodigoCliente As ENTID_Codigo
		,Ven.ENTID_CodigoCliente
		,Ven.TIPOS_CodTipoDocumento
		,Ven.DOCVE_TipoCambio
		,Ven.DOCVE_TipoCambioSunat
		,Ven.DOCVE_UsrCrea
		--,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right(('0000000' + RTrim(Ven.DOCVE_Numero)), 7) As Documento
	From Ventas.VENT_DocsVenta As Ven
		Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
		Left Join Entidades As Usr On Usr.ENTID_NroDocumento = Ven.DOCVE_UsrCrea
		Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = IsNull(Ven.TIPOS_CodTipoDocumento, 'CPDFL')	
		Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)	
	Where Ven.ENTID_CodigoCliente = @ENTID_Codigo
		And Round(Abs(Ven.DOCVE_TotalPagar - IsNull(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then
				IsNull((Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda) 
								When 'MND1' Then CAJA_Importe
											Else CAJA_Importe * CAJA_TCambio
							End
						) 
					From Tesoreria.TESO_Caja As Caj
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
			When 'MND2' Then
				IsNull((Select Sum(
							Case IsNull(TIPOS_CodMonedaPago, TIPOS_CodTipoMoneda) 
								When 'MND1' Then CAJA_Importe / (Case CAJA_TCambio When 0 Then TC.TIPOC_VentaSunat Else CAJA_TCambio End)
											Else CAJA_Importe
							End
						) 
					From Tesoreria.TESO_Caja As Caj
						Left Join TipoCambio As TC On Convert(Date, TC.TIPOC_FechaC) = CONVERT(Date, Caj.CAJA_Fecha)
					Where Caj.DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Not TIPOS_CodTipoDocumento In ('CPDRI', 'CPDRE')
				), 0) 
		 End, 0)), 2) <> 0
		And Ven.DOCVE_Estado <> 'X'
		And Ven.PVENT_Id = @PVENT_Id
		And Ven.DOCVE_TotalPagar > 0 
		And Not Ven.TIPOS_CodTipoDocumento In ('CPD07')
	Order By Ven.DOCVE_Codigo

GO 
/***************************************************************************************************************************************/ 

