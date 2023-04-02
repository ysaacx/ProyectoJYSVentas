GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_SaldoInicialEfectivo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_SaldoInicialEfectivo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_SaldoInicialEfectivo]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As
--Declare @PVENT_Id BigInt Set @PVENT_Id = 5

select Sum(Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Caj.CAJA_Importe Else 0 End) As Importe
	,Sum(Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Caj.CAJA_Importe Else 0 End) As ImporteDol
	,'Ingresos en Efectivo - Cancelaciones de Documentos de Venta' As Glosa
Into #Inicial
from Tesoreria.TESO_DocsPagos As Doc
	Inner Join Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
Where Doc.TIPOS_CodTipoDocumento = 'DPG01'
	And Convert(Date, DPAGO_Fecha) < @FecIni
Union All
Select -SUM(Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then RECIB_Importe Else 0.00 End)
	,-SUM(Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then RECIB_Importe Else 0.00 End)
	,'Egresos en Efectivo'
From Tesoreria.TESO_Recibos As Rec
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) < @FecIni
	And TIPOS_CodTipoRecibo = 'CPDRE'
	And Rec.RECIB_Estado <> 'X'
Union All
Select Case TIPOS_CodTipoMoneda When 'MND1' Then SINIC_Importe Else 0.00 End
	,Case TIPOS_CodTipoMoneda When 'MND2' Then SINIC_Importe Else 0.00 End
	,SINIC_Glosa	
From Tesoreria.TESO_SIniciales Where PVENT_Id = @PVENT_Id And SINIC_Tipo = 'S'

Select SUM(Importe) Ingreso, SUM(ImporteDol) IngresoDol From #Inicial 




GO 
/***************************************************************************************************************************************/ 

