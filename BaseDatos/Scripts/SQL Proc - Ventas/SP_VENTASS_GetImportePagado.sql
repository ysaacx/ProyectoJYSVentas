GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_VENTASS_GetImportePagado]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[SP_VENTASS_GetImportePagado] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 4/10/2011
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE Procedure SP_VENTASS_GetImportePagado
(
	 @NroFac varchar(14)
	,@Fecha datetime
)
As

Declare @TCambio Decimal(14, 4)
Declare @TCambioSunat Decimal(14, 4)

Select @TCambio = Tc.TIPOC_VentaSunat
	,@TCambioSunat = V.DOCVE_TipoCambioSunat
From Ventas.VENT_DocsVenta As V
	Left Join TipoCambio As Tc On Convert(varchar, Tc.TIPOC_FechaC, 112) = Convert(varchar, V.DOCVE_FechaDocumento, 112)
Where DOCVE_Codigo = @NroFac
	And DOCVE_Estado <> 'X'

Print @TCambio
Print @TCambioSunat

select 
 IsNull(Round(Sum(Case S.TIPOS_CodTipoMoneda When 'MND1' Then IsNull(S.DOCVE_TotalPagar, 0) Else IsNull(S.DOCVE_TotalPagar * @TCambio, 0) End), 2), 0) 
,IsNull(Round(Sum(Case S.TIPOS_CodTipoMoneda When 'MND2' Then IsNull(S.DOCVE_ImportePercepcion, 0) Else 0 End), 2), 0) As PerDolares 
,IsNull(Round(Sum(Case S.TIPOS_CodTipoMoneda When 'MND1' Then IsNull(S.DOCVE_ImportePercepcionSoles * @TCambio, 0) Else 0 End), 2), 0) As PerSoles 
From Ventas.VENT_DocsVenta as S
	Inner Join Tesoreria.TESO_Caja As C On C.DOCVE_Codigo = S.DOCVE_Codigo And Not C.TIPOS_CodTransaccion In ('TPG03', 'DPG03')
	Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = C.CAJA_Codigo
	Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
Where S.DOCVE_Codigo = @NroFac And Convert(Date, DPag.DPAGO_FechaVenc) < @Fecha
	

--Select * From Tesoreria.TESO_Caja Where DOCVE_Codigo = @NroFac
--select *
--From Ventas.VENT_DocsVenta as S
--	Inner Join Tesoreria.TESO_Caja As C On C.DOCVE_Codigo = S.DOCVE_Codigo And C.TIPOS_CodTransaccion In ('TPG02', 'DPG02')
--	Inner Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = C.CAJA_Codigo
--	Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id
--Where S.DOCVE_Codigo = @NroFac


GO 
/***************************************************************************************************************************************/ 

