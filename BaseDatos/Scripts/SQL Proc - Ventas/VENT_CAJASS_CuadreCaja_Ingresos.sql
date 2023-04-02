--USE BDInkaPeru
--USE BDInkasFerro_Almudena
--USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_CuadreCaja_Ingresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Ingresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Ingresos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

Print @FecIni
Print @FecFin
Declare @Orden SmallInt	Set @Orden = 3

/* Otros Ingresos */
/* Ingresos por Cancelacion en Efectivo */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,RECIB_Fecha As Fecha
	,'Resp: '
	 + IsNull((Case Rec.ENTID_Codigo When Null Then Pro.ENTID_RazonSocial Else Res.ENTID_RazonSocial End), IsNull(Rec.RECIB_RecibiDe, ''))
	 + ' / Concepto: ' + IsNull(Rec.RECIB_Concepto, '')
	 + ' / Recibo: ' + IsNull(Rec.RECIB_NroDocumento, '')
	 + ISNULL((Case Rec.DOCUS_Codigo When Null Then '' 
				Else (' / Prov:' + EntDoc.ENTID_Codigo + ' ' + EntDoc.ENTID_RazonSocial
					+ ' / Doc:' + TDoc.TIPOS_DescCorta + ' - ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
					  )
			   End),'')
	 As ENTID_RazonSocial
	,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda 
		When 'MND1' Then Rec.RECIB_Importe 
		Else Rec.RECIB_Importe * TC.TIPOC_VentaSunat
	 End ImpSoles
	,Rec.ENTID_Codigo As ENTID_Codigo
	,Rec.RECIB_Codigo As DOCVE_Codigo
	,Rec.RECIB_Serie As DOCVE_Serie
	,Rec.RECIB_Numero As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
Into #OtrosIngresos
From Tesoreria.TESO_Recibos As Rec
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDRA')
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* Recibos de Pagos Anulados de Caja */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,Caj.CAJA_Fecha As Fecha
	,Ent.ENTID_RazonSocial + ' - Recibo de Ingreso por Anulación de Pago de ' 
						   + TDoc.TIPOS_Descripcion 
						   + ' Con ' + TPag.TIPOS_Descripcion
						   + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
						   + ' /  Anulada el ' 
						   + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
	,'' As ENTID_Codigo
	,'' As RECIB_Codigo
	,Caj.CAJA_Serie
	,Caj.CAJA_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Caj.TIPOS_CodTipoDocumento
From Tesoreria.TESO_Caja As Caj
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo And CDoc.PVENT_Id = @PVENT_Id
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id And DPago.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
Where Caj.CAJA_AnuladoCaja = 1
	And Convert(Date, Caj.CAJA_FechaAnulado) Between @FecIni And @FecFin
	And Caj.PVENT_Id = @PVENT_Id
	And Not Caj.TIPOS_CodTransaccion In ('TPG01', 'TPG05')

Select * From #OtrosIngresos
Order By Orden



GO 
/***************************************************************************************************************************************/ 

exec VENT_CAJASS_CuadreCaja_Ingresos @FecIni='2019-01-05',@FecFin='2019-01-05',@PVENT_Id=1