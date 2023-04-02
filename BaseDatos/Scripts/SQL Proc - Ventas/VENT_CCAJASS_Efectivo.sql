--USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Efectivo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_Efectivo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Efectivo]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

Declare @Orden SmallInt	Set @Orden = 4

select @Orden As Orden
	,'Movimiento de Efectivo' As Titulo
	,'04.- Movimiento de Efectivo' As Title
	,Caj.CAJA_Fecha As Fecha
	,'Cancelación de Documento de Venta : '
	 + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
	 + ' / ' + Ven.ENTID_CodigoCliente
	 + ' - ' 
	 + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) 
	 As ENTID_RazonSocial
	,TPag.TIPOS_DescCorta + ' ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Doc.DPAGO_Id), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda	
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Doc.TIPOS_CodTipoMoneda When 'MND2' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpDolares
	,Case Doc.TIPOS_CodTipoMoneda When 'MND1' Then Doc.DPAGO_Importe Else Convert(Decimal(14, 2), 0.00) End As ImpSoles
	,Caj.ENTID_Codigo	
	,Caj.CAJA_Codigo As DOCVE_Codigo
	,Right('000' + RTRIM(@PVENT_Id), 3) As DOCVE_Serie
	,Doc.DPAGO_Id As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Doc.TIPOS_CodTipoDocumento
	,'' As CAJA_Codigo
	,'Cancelación de Documento de Venta : '
	 + TVen.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
	 + ' / Fecha Fac.: ' + Convert(VarChar(10), Ven.DOCVE_FechaDocumento, 103)	 
	 + ' / ' + TMonVen.TIPOS_DescCorta + ' ' + Convert(VarChar(20), CONVERT(money, Ven.DOCVE_TotalPagar), 1)
	 + ' / R.U.C. o D.N.I.: ' + Ven.ENTID_CodigoCliente
	 + ' / Raz. Soc.: ' 
	 + IsNull(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) 
	 As Detalle
	,'' As DocDetalle
	
from Tesoreria.TESO_DocsPagos As Doc
	Inner Join Tesoreria.TESO_CajaDocsPago As DCaj On DCaj.DPAGO_Id = Doc.DPAGO_Id
	Inner Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = DCaj.CAJA_Codigo
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Inner Join Tipos As TVen On TVen.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As TMonVen On TMonVen.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Doc.DPAGO_Fecha, 112)
Where Doc.TIPOS_CodTipoDocumento = 'DPG01'
	And Convert(Date, DPAGO_Fecha) Between @FecIni And @FecFin
Union All
Select @Orden As Orden
	,'Movimiento de Efectivo' As Titulo
	,'04.- Movimiento de Efectivo' As Title
	,Rec.RECIB_Fecha
	,'Egreso en Efectivo Para Cancelación de Documento / Resp.: ' 
	 + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
	 As ENTID_RazonSocial
	,TRec.TIPOS_Desc2 + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + Rtrim(Rec.RECIB_Numero), 7)
	,Mon.TIPOS_DescCorta 
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoRecibo 
		When 'CPDRE' Then (-Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
		When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
	 End
	 As ImpDolares
	,Case Rec.TIPOS_CodTipoRecibo 
		When 'CPDRE' Then (-Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
		When 'CPDRI' Then (Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End)
	 End ImpSoles
	,IsNull(Rec.ENTID_Codigo, '-')	 
	,RECIB_Codigo
	,Right('000' + RTRIM(@PVENT_Id), 3) As DOCVE_Serie
	,Rec.RECIB_Numero As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Rec.TIPOS_CodTipoRecibo As TIPOS_CodTipoDocumento
	,'' As CAJA_Codigo
	,'Egreso en Efectivo Para Cancelación de Documento / Responsable: ' 
	 + IsNull(Rec.RECIB_RecibiDe, Ent.ENTID_RazonSocial) 
	 + ' / Glosa: ' + Rec.RECIB_Concepto
	 + IsNull(' Doc. Ref : ' + TRDoc.TIPOS_DescCorta + ' ' + RDoc.DOCUS_Serie + '-' + Right('0000000' + RTrim(RDoc.DOCUS_Numero), 7) 
				+ ' / ' + RDoc.ENTID_Codigo + '-' + EntDoc.ENTID_RazonSocial
		, '')
	 As Detalle
	,'' As DocDetalle
From Tesoreria.TESO_Recibos As Rec
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Rec.ENTID_Codigo
	Inner Join Tipos As TRec On TRec.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As RDoc On RDoc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TRDoc On TRDoc.TIPOS_Codigo = RDoc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = RDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha)  Between @FecIni And @FecFin
	--And TIPOS_CodTipoRecibo In 'CPDRE'
	And Rec.RECIB_Estado <> 'X'
Order by Fecha


--Select * 
--From Tesoreria.TESO_CajaChicaIngreso As CC
--Where Convert(Date, CC.CAJAC_Fecha) Between @FecIni And @FecFin






GO 
/***************************************************************************************************************************************/ 

exec VENT_CCAJASS_Efectivo @FecIni='2018-07-06 00:00:00',@FecFin='2018-07-06 00:00:00',@PVENT_Id=1