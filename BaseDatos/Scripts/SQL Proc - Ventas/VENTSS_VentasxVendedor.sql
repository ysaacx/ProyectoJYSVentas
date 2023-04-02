GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENTSS_VentasxVendedor]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENTSS_VentasxVendedor] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENTSS_VentasxVendedor]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ENTID_CodigoVendedor CodEntidad
	,@ENTID_CodigoCliente CodEntidad = Null
)
As

Declare @IGV Decimal(6, 2) 
Set @IGV = (Select Convert(Decimal (6,2), PARMT_Valor) from Parametros where PARMT_Id = 'PIGV')
Print @IGV

Select Ven.DOCVE_Codigo
	,TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTRIM(Ven.DOCVE_Numero), 7) As Doc
	,Ven.DOCVE_FechaDocumento
	,Ent.ENTID_NroDocumento
	,Ent.ENTID_RazonSocial
	,Art.ARTIC_Codigo
	,Det.DOCVD_Cantidad
	,IsNull(Art.ARTIC_Descripcion, Det.DOCVD_Detalle) As ARTIC_Descripcion
	,Det.DOCVD_PrecioUnitario
	,Det.DOCVD_SubImporteVenta
	,LP.LPREC_Codigo
	,LP.LPREC_Comision
	,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then DOCVD_SubImporteVenta/(@IGV/100 + 1) Else 0.00 End 
	 As ImporteSoles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then DOCVD_SubImporteVenta/(@IGV/100 + 1) Else 0.00 End As ImporteDolares
	,LP.LPREC_Comision * (Case Ven.TIPOS_CodTipoMoneda When 'MND1' 
							Then DOCVD_SubImporteVenta / ( @IGV/100 + 1 )
							Else 0
						  End)
		As ComisionSoles
	,LP.LPREC_Comision * (Case Ven.TIPOS_CodTipoMoneda When 'MND2' 
							Then DOCVD_SubImporteVenta / ( @IGV/100 + 1 )
							Else 0
						  End) As ComisionDolares 
From Ventas.VENT_DocsVenta As Ven
	Inner Join Ventas.VENT_DocsVentaDetalle As Det On Det.DOCVE_Codigo = Ven.DOCVE_Codigo	
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Left Join Ventas.VENT_ListaPrecios As LP On LP.LPREC_Id = Det.LPREC_Id And LP.ZONAS_Codigo = '54.00'
	Left Join TipoCambio As TC On CONVERT(VarChar, TC.TIPOC_Fecha, 112) =  CONVERT(VarChar, Ven.DOCVE_FechaDocumento, 112)
	Left Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo 
		And Not Art.ARTIC_Codigo In ('1301001', '1301002')
Where ENTID_CodigoVendedor = @ENTID_CodigoVendedor
	And CONVERT(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_CodigoCliente, Ven.ENTID_CodigoCliente)
	And Ven.DOCVE_Estado <> 'X'
	And Not Ven.TIPOS_CodTipoDocumento IN ('CPDLE')
Order By Ven.DOCVE_FechaDocumento, Doc, Ent.ENTID_RazonSocial

GO 
/***************************************************************************************************************************************/ 

