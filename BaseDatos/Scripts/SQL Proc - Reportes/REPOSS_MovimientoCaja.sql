GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_MovimientoCaja]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_MovimientoCaja] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_MovimientoCaja]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

--Declare @FecIni DateTime Set @FecIni = '07-11-2013'
--Declare @FecFin DateTime Set @FecFin = '07-11-2013'

Select CAJA_Fecha
	,'RC ' + Right('000' + RTrim(Caj.PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7) As Numero
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Cli.ENTID_Codigo + ' - ' + IsNull(Ven.DOCVE_DescripcionCliente, Cli.ENTID_RazonSocial) As RazonSocial
	,TPag.TIPOS_Descripcion As Detalle
	,ISNULL(Ven.DOCVE_TipoCambio, 0.00) As TipoCambio
	,Mon.TIPOS_DescCorta As Moneda
	,(Case Ven.TIPOS_CodTipoMoneda 
			When 'MND1' Then Caj.CAJA_Importe 
			Else Caj.CAJA_Importe * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaOficina Else Ven.DOCVE_TipoCambio End)
	  End) As Ingreso
	,CONVERT(Decimal(14, 4), 0.00) As Egreso
From Tesoreria.TESO_Caja As Caj
	Inner Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
Where Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.PVENT_Id = @PVENT_Id
Union All
Select Rec.RECIB_Fecha
	,IsNull(Rec.RECIB_NroDocumento, ' - ')
	,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + ' - ' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)
	,IsNull(Res.ENTID_Codigo + ' - ' + Res.ENTID_RazonSocial, IsNull(Rec.RECIB_RecibiDe, ' - '))
	,'Concepto : ' + Rec.RECIB_Concepto 
	 + IsNull(' / Recibo : ' + Rec.RECIB_NroDocumento, '')
	 + ISNULL((Case When Rec.DOCUS_Codigo Is Null Then '' 
				Else (' / Prov : ' + Res.ENTID_Codigo + ' - ' + Res.ENTID_RazonSocial
					+ ' / Doc : ' + TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
					  )
			   End),'-')
	,ISNULL(TC.TIPOC_VentaSunat, 0.00) As TCambioVenta
	,Mon.TIPOS_DescCorta
	,Case TIPOS_CodTipoRecibo When 'CPDRI' Then Rec.RECIB_Importe Else 0.00 End
	,Case TIPOS_CodTipoRecibo When 'CPDRE' Then Rec.RECIB_Importe Else 0.00 End
From Tesoreria.TESO_Recibos As Rec
	Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Rec.TIPOS_CodTipoRecibo
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo 
		And Doc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.PVENT_Id = @PVENT_Id
Order By CAJA_Fecha



GO 
/***************************************************************************************************************************************/ 



exec REPOSS_MovimientoCaja @FecIni='2019-04-06 00:00:00',@FecFin='2019-04-06 00:00:00',@PVENT_Id=1