USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_ConsultaCajaChica]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_ConsultaCajaChica] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/01/2012
-- Descripcion         : Buscar Los registros de caja Chica
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_ConsultaCajaChica]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Cadena VarChar(50)
	,@PVENT_Id Id
	,@Todos Bit
	,@Fecha Bit
)
As

Select 
	CC.ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,CC.CAJAC_Fecha
	,CC.CAJAC_Detalle
	,CC.CAJAC_Importe
	,CC.TIPOS_CodTipoMoneda
	,CC.CAJAC_Estado
	,CC.PVENT_Id
	,CC.CAJAC_Id
	,Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,CC.CAJAC_Importe - IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos 
								Where CAJAC_Id = CC.CAJAC_Id And PVENT_Id = CC.PVENT_Id And CAJAP_Estado <> 'X'), 0)
	 As Saldo
Into #CajaChica
From Tesoreria.TESO_CajaChicaIngreso As CC
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = CC.ENTID_Codigo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CC.TIPOS_CodTipoMoneda
Where CC.PVENT_Id = @PVENT_Id
	And Ent.ENTID_RazonSocial Like '%' + @Cadena + '%'
	And Abs(CC.CAJAC_Importe - IsNull((Select SUM(CAJAP_Importe) From Tesoreria.TESO_CajaChicaPagos 
									   Where CAJAC_Id = CC.CAJAC_Id And PVENT_Id = CC.PVENT_Id And CAJAP_Estado <> 'X'), 0)) > 0
If @Fecha = 1
Begin
	If @Todos = 1
		Select * From #CajaChica Where Convert(Date, CAJAC_Fecha) Between @FecIni And @FecFin
	Else
		Select * From #CajaChica Where CAJAC_Estado <> 'X' And Convert(Date, CAJAC_Fecha) Between @FecIni And @FecFin
End
Else
Begin
	If @Todos = 1
		Select * From #CajaChica 
	Else
		Select * From #CajaChica Where CAJAC_Estado <> 'X'
End


GO 
/***************************************************************************************************************************************/ 

