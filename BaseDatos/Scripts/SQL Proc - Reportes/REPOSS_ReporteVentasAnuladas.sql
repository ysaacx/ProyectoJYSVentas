GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_ReporteVentasAnuladas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_ReporteVentasAnuladas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_ReporteVentasAnuladas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As
--Declare @FecIni DateTime Set @FecIni = '07-11-2013'
--Declare @FecFin DateTime Set @FecFin = '07-11-2013'


Select Ven.DOCVE_FechaDocumento
	,Case Cli.ENTID_Codigo When '11000000000' Then '-' Else Cli.ENTID_Codigo End As RUC
	,IsNull(Ven.DOCVE_DescripcionCliente, Cli.ENTID_RazonSocial) As ENTID_RazonSocial
	,'RC ' + Right('000' + RTrim(Caj.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7) As Numero
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Ven.DOCVE_TipoCambio As TipoCambio
	,Mon.TIPOS_DescCorta As Moneda
	,Ven.DOCVE_TotalPagar As TotalPagar
	,(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then Ven.DOCVE_TotalPagar
			Else Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaOficina Else Ven.DOCVE_TipoCambio End)
	  End) As TotalPagarSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2'
		Then IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
					  Where DOCVE_Codigo = Ven.DOCVE_Codigo
						And CAJA_Estado <> 'X'
						And Convert(Date, CAJA_Fecha) < @FecFin
	 ), 0)  * Ven.DOCVE_TipoCambio
	 Else IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja
				  Where DOCVE_Codigo = Ven.DOCVE_Codigo
					And CAJA_Estado <> 'X'
					And Convert(Date, CAJA_Fecha) <= @FecFin
	 ), 0)	 
	 End As TotalPagado
	,TPag.TIPOS_Descripcion As TipoPago
	,Ven.DOCVE_Estado As Estado
	,TDoc.TIPOS_Descripcion As TipoDocumento
	--,(Select * From Tesoreria.TESO_Caja Where DOCVE_Codigo = Ven.DOCVE_Codigo)
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Ven.ENTID_CodigoCliente
	
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_Caja As Caj On Caj.DOCVE_Codigo = Ven.DOCVE_Codigo And Caj.PVENT_Id = @PVENT_Id
	Left Join Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
Where Convert(Date, DOCVE_FecAnulacion) Between @FecIni And @FecFin
	And Ven.PVENT_Id = @PVENT_Id
	And DOCVE_Estado = 'X'
Order by TPag.TIPOS_Descripcion, Ven.DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 

