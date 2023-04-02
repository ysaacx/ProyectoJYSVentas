GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_FacturasXCancelar]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_FacturasXCancelar] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_FacturasXCancelar]
(
	@ENTID_Codigo CodEntidad
	,@PVENT_Id Id
)

AS

	Select Ven.DOCVE_Codigo
		,Ven.DOCVE_Serie
		,Ven.DOCVE_Numero
		,Ven.DOCVE_FechaDocumento
		,Ven.TIPOS_CodTipoMoneda
		,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
		,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
		,TMon.TIPOS_Descripcion
		,Ven.DOCVE_TotalPagar
		,IsNull((Select Sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where CAJA_NroDocumento = Ven.DOCVE_Codigo
				And CAJA_Estado <> 'X'
		), 0) As DOCVE_TotalPagado
		,Ven.DOCVE_TotalPagar - IsNull((Select Sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where CAJA_NroDocumento = Ven.DOCVE_Codigo
				And CAJA_Estado <> 'X'
		), 0) As SaldoPendiente
		,Usr.ENTID_RazonSocial As Usuario
		,Ven.ENTID_CodigoCliente As ENTID_Codigo
		,Ven.ENTID_CodigoCliente
		,Ven.TIPOS_CodTipoDocumento
		--,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right(('0000000' + RTrim(Ven.DOCVE_Numero)), 7) As Documento
	From Ventas.VENT_DocsVenta As Ven
		Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
		Left Join Entidades As Usr On Usr.ENTID_NroDocumento = Ven.DOCVE_UsrCrea
		Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = IsNull(Ven.TIPOS_CodTipoDocumento, 'CPDFL')
	Where Ven.ENTID_CodigoCliente = @ENTID_Codigo
		And Abs(IsNull((Select Sum(CAJA_Importe) From Tesoreria.TESO_Caja 
			Where CAJA_NroDocumento = Ven.DOCVE_Codigo
				And CAJA_Estado <> 'X'
		), 0) - IsNull(Ven.DOCVE_TotalPagar, 0)) <> 0
		And Ven.DOCVE_Estado <> 'X'
		And Ven.PVENT_Id = @PVENT_Id
	Order By Ven.DOCVE_Codigo

GO 
/***************************************************************************************************************************************/ 

