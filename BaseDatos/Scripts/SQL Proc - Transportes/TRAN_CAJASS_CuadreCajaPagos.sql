USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 27/02/2012
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaPagos]
(
	@DOCVE_Codigo VarChar(13)
)

AS

Select Caj.CAJA_Id
	,Caj.CAJA_Serie + '-' + Right('0000000' + RTrim(CAJA_Numero), 7) As Documento
	,CAJA_OrdenDocumento
	,CAJA_Fecha
	,CAJA_Hora
	,CAJA_FechaPago
	,CAJA_Importe
	,TDoc.TIPOS_Descripcion As TIPOS_Transaccion
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TPag.TIPOS_Descripcion
	,IsNull('Cod: ' + RTrim(DPag.DPAGO_Id) +' - Op/Num: ' + RTrim(DPag.DPAGO_Numero) 
		+ IsNull(' - Banco: ' + Ban.BANCO_Descripcion, '')
		+ ' - ' + TDoc.TIPOS_Descripcion
		, 'Cancelación en Efectivo')
	As Glosa
	--,DPag.DPAGO_Fecha
	,IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
	,DPag.DPAGO_Id
	,DPag.DPAGO_Numero
	,DPag.DPAGO_FechaVenc As DPAGO_Fecha
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tesoreria.TESO_Caja As Caj On CAJA_NroDocumento = Ven.DOCVE_Codigo 
		And Caj.CAJA_Estado <> 'X'
	Left Join Tesoreria.TESO_CajaDocsPago As TC On TC.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = TC.DPAGO_Id
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
	Left Join Tipos As TMon On TMon.TIPOS_Codigo = IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
	Left Join Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
Where Ven.DOCVE_Codigo = @DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

