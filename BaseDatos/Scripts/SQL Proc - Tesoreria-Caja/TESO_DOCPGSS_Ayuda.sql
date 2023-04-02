USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_DOCPGSS_Ayuda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_DOCPGSS_Ayuda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_DOCPGSS_Ayuda]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_Codigo VarChar(14) = Null
)
As

Select DPAGO_Id As Interno
	,TDoc.TIPOS_Descripcion As [Documento]
	,IsNull(Pag.DPAGO_Numero, Pag.DPAGO_NumeroCheque) As Numero
	,DPAGO_Fecha As [Fecha Giro/Deposito]
	,DPAGO_Importe - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As C
								Inner Join Tesoreria.TESO_CajaDocsPago As TP On TP.CAJA_Codigo = C.CAJA_Codigo 
									And TP.DPAGO_Id = Pag.DPAGO_Id 
									And Not C.TIPOS_CodTipoDocumento = 'CPDRA'
									And Entid_Codigo = IsNull(@ENTID_Codigo, Entid_Codigo)
							 Where CAJA_Estado <> 'X'
							), 0) 
	 As [Importe Pendiente]
	,DPAGO_Importe As Importe
	,Ban.BANCO_Descripcion As Banco
	,Cu.CUENT_Numero As Cuenta
	,TMon.TIPOS_DescCorta As Moneda
	,DPAGO_FechaVenc As [Fecha Cobro/Venc.]
	,DPAGO_TipoCambio As [Tipo Cambio]  
	,IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As C
				Inner Join Tesoreria.TESO_CajaDocsPago As TP On TP.CAJA_Codigo = C.CAJA_Codigo 
					And TP.DPAGO_Id = Pag.DPAGO_Id
			 Where CAJA_Estado <> 'X'
			), 0) 
	 As [Importe Usado]
	,Ent.ENTID_RazonSocial As [Razon Social]
	,Ent.ENTID_Codigo As [RUC / DNI]
Into #Pagos
From Tesoreria.TESO_DocsPagos As Pag
	Inner Join Bancos As Ban On Ban.BANCO_Id = Pag.BANCO_Id
	Left Join Cuentas As Cu On Cu.CUENT_Id = Pag.CUENT_Id
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Pag.TIPOS_CodTipoDocumento 
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Pag.TIPOS_CodTipoMoneda
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Pag.ENTID_Codigo
Where Convert(Date, DPAGO_Fecha) Between @FecIni And @FecFin
	And DPAGO_Importe - IsNull((Select SUM(CAJA_Importe) From Tesoreria.TESO_Caja As C
								Inner Join Tesoreria.TESO_CajaDocsPago As TP On TP.CAJA_Codigo = C.CAJA_Codigo 
									And TP.DPAGO_Id = Pag.DPAGO_Id 
									And Not C.TIPOS_CodTipoDocumento = 'CPDRA'
									And Entid_Codigo = IsNull(@ENTID_Codigo, Entid_Codigo)
							 Where CAJA_Estado <> 'X'
							), 0) > 0
	And Pag.DPAGO_Estado <> 'X'
	And Pag.ENTID_Codigo = IsNull(@ENTID_Codigo, Pag.ENTID_Codigo)
	And Pag.TIPOS_CodTipoDocumento <> 'DPG03'
Order By Interno

If (@ENTID_Codigo Is Null)
	Select Interno
		,Documento
		,Numero
		,[RUC / DNI]
		,[Razon Social]
		,[Fecha Giro/Deposito]
		,[Importe Pendiente]
		,Importe
		,Banco
		,Cuenta
		,Moneda
		,[Fecha Cobro/Venc.]
		,[Tipo Cambio]
		,[Importe Usado]
	From #Pagos
Else
	Select Interno
		,Documento
		,Numero
		,[Fecha Giro/Deposito]
		,[Importe Pendiente]
		,Importe
		,Banco
		,Cuenta
		,Moneda
		,[Fecha Cobro/Venc.]
		,[Tipo Cambio]
		,[Importe Usado]
	From #Pagos

GO 
/***************************************************************************************************************************************/ 

