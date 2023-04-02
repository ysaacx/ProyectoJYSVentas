USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_DOCPSS_ConsutaNotaCredito]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_DOCPSS_ConsutaNotaCredito] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_DOCPSS_ConsutaNotaCredito]
(
	@TipoDoc VarChar(6)
	,@PVENT_Id BigInt
	,@Opcion SmallInt
	,@Cadena VarChar(50)
	,@FecIni DateTime
	,@FecFin DateTime
	
)
As

Select 
	DPag.PVENT_Id
	,DPag.DPAGO_Id
	,DPag.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,IsNull(DPag.ENTID_Codigo, Ven.ENTID_CodigoCliente) As ENTID_Codigo
	,Ent.ENTID_RazonSocial
	,Ven.DOCVE_FechaDocumento
	,DPag.DPAGO_Fecha
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As DocVenta
	,DPag.DPAGO_Glosa
	,DPag.DPAGO_Importe
From Tesoreria.TESO_DocsPagos As DPag
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = DPag.DOCVE_Codigo
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = DPag.TIPOS_CodTipoMoneda
Where DPag.TIPOS_CodTipoDocumento = @TipoDoc
	And DPag.PVENT_Id = @PVENT_Id
	And CONVERT(Date, DPag.DPAGO_Fecha) Between @FecIni And @FecFin
	And (Case @Opcion 
			When 0 Then Ent.ENTID_RazonSocial
			When 1 Then DPAGO_Numero
			When 2 Then DPAGO_Glosa
			Else Ent.ENTID_RazonSocial
		 End) Like '%' + @Cadena + '%'
	And DPag.DPAGO_Estado <> 'X'


GO 
/***************************************************************************************************************************************/ 

