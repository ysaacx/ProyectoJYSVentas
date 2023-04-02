USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_CuadreCaja_Egresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Egresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/03/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CAJASS_CuadreCaja_Egresos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

--Print @FecIni
--Print @FecFin
Declare @Orden SmallInt	Set @Orden = 3

/* Recibos de Egreso */
/* Egresos en Efectivo */
Select @Orden As Orden
	,'Recibo de Egresos - Egresos en Efectivo' As Titulo
	,'03.- Recibo de Egresos' As Title
	,RECIB_Fecha As Fecha
	,'Resp : '
	 + IsNull((Case Rec.ENTID_Codigo When Null Then Pro.ENTID_RazonSocial Else Res.ENTID_RazonSocial End), Rec.RECIB_RecibiDe)
	 + ' / Concepto : ' + Rec.RECIB_Concepto 
	 + IsNull(' / Recibo : ' + Rec.RECIB_NroDocumento, '')
	 + ISNULL((Case When Rec.DOCUS_Codigo Is Null Then '' 
				Else (' / Prov : ' + EntDoc.ENTID_Codigo + ' - ' + EntDoc.ENTID_RazonSocial
					+ ' / Doc : ' + TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
					  )
			   End),'-')
	 As ENTID_RazonSocial
	,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta 
	 As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,Rec.ENTID_Codigo As ENTID_Codigo
	,Rec.RECIB_Codigo As DOCVE_Codigo
	,Rec.RECIB_Serie As DOCVE_Serie
	,Rec.RECIB_Numero As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
	,'' As CAJA_Codigo
	,'' As Detalle
	,'' As DocDetalle
		,'' as   FlagRD
Into #Recibos
From Tesoreria.TESO_Recibos As Rec
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo 
		And Doc.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo	--And Rec.ENTID_Codigo = EntDoc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo = 'CPDRE'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* Depositos */
Select @Orden As Orden
	,'Recibo de Egresos - Depositos' As Titulo
	,'03.- Recibo de Egresos' As Title
	,CAJA_Fecha As Fecha
	,IsNull('Dep. / ' + IsNull(TDoc.TIPOS_DescCorta, '')
		+ ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') + ' (' + RTrim(DPag.DPAGO_Id) + ')'
		+ ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
		+ ' / Cta: ' + IsNull(RTrim(Cta.CUENT_Numero  + ' - ' + TCta.TIPOS_DescCorta), '') 		
		+ ' / Fecha: ' + ISNULL(CONVERT(Varchar, DPag.DPAGO_FechaVenc, 103), '') 
		+ ' / ' + IsNull(Ent.ENTID_RazonSocial, '')
		+ ' / Importe: ' + MTPag.TIPOS_DescCorta + ' ' +  CONVERT(varchar(30), CONVERT(money, DPag.DPAGO_Importe), 1) --Rtrim(DPag.DPAGO_Importe)
		+  Case DPag.TIPOS_CodTipoMoneda 
			When 'MND2' Then ' / T.C.: '  + CONVERT(varchar(30), CONVERT(money, (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End)))
		   Else '' End
		+ IsNull(' / Glosa: ' + DPag.DPAGO_Glosa, '')
	    , Caj.CAJA_Glosa) 
	 As ENTID_RazonSocial
	, ISNULL(IsNull(TDPag.TIPOS_DescCorta, 'DB') + ' - ' + Right('0000000000' + RTrim(DPag.DPAGO_Numero), 10) 
	        , TCaj.TIPOS_Desc2 + ' ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Caj.CAJA_Id), 7)) 
           + '-' + Caj.ENTID_Codigo
	       + ISNULL((select top 1  '-' + RIGHT(ltrim(cast('00' +  month(CAJA_Fecha) as varchar(2)) ),2)
	       + right(cast('00' +  day(CAJA_Fecha) as varchar(2))   ,2) As Documento
	
	
	 From  Tesoreria.TESO_Recibos As Rec
	--tablas relacionadas a los recibos
	Left Join Tipos As MonInt On MonInt.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As ResInt On ResInt.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As ProInt On ProInt.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TCInt On Convert(Varchar,TCInt.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As DocInt On DocInt.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TDocInt On TDocInt.TIPOS_Codigo = DocInt.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDocInt On EntDocInt.ENTID_Codigo = DocInt.ENTID_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPagInt On DPagInt.PVENT_Id = Rec.PVENT_Id And DPagInt.DPAGO_Id = Rec.DPAGO_Id
	Left Join Tipos As TDPagInt On TDPagInt.TIPOS_Codigo = DPagInt.TIPOS_CodTipoDocumento
	where (Rec.PVENT_Id = DPag.PVENT_Id And Rec.DPAGO_Id = DPag.DPAGO_Id and 
	--obteniendo los recibos relacionados
	Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDRA', 'CPDDE')
	And Rec.TIPOS_CodTransaccion In ('TRE02', 'TRE03')
	And Rec.RECIB_Estado <> 'X'	))
	,CAJA_Fecha)
	
	  As Documento 
	,Mon.TIPOS_DescCorta As Moneda
	,(Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End) As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			Caj.CAJA_Importe
		Else 
			(Case DPag.TIPOS_CodTipoMoneda 
				When 'MND1' Then 0.00
				When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe / (Case Caj.CAJA_TCPorUsuario When 0 Then Caj.CAJA_TCDocumento Else TC.TIPOC_VentaSunat End))
			 End
			)
		End 
	 ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
			)) End 
	 ImpSoles
	,Caj.ENTID_Codigo As ENTID_Codigo
	,Caj.DOCVE_Codigo As DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Caj.TIPOS_CodTipoDocumento
	,Caj.CAJA_Codigo + ' - ' + RTRIM(DPag.DPAGO_Numero)
	,'T.Proc.: '+ TEfe.TIPOS_DescCorta 
	 + ' / ' +  Caj.CAJA_Glosa
	 + IsNull(' / ' + (TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)), '')
	 + ' / C.Interno: ' + Caj.CAJA_Codigo + '/' + Rtrim(Caj.CAJA_Id)
	 + ' / ' + IsNull(Ent.ENTID_RazonSocial, '')
	 As Detalle
	 ,IsNull((TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)) 
	  , 'RC ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7))
	 As DocDetalle
	  , IsNull((select top 1 Rec.RECIB_Codigo 
	 From  Tesoreria.TESO_Recibos As Rec
	--tablas relacionadas a los recibos
	Left Join Tipos As MonInt On MonInt.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As ResInt On ResInt.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As ProInt On ProInt.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TCInt On Convert(Varchar,TCInt.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As DocInt On DocInt.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TDocInt On TDocInt.TIPOS_Codigo = DocInt.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDocInt On EntDocInt.ENTID_Codigo = DocInt.ENTID_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPagInt On DPagInt.PVENT_Id = Rec.PVENT_Id And DPagInt.DPAGO_Id = Rec.DPAGO_Id
	Left Join Tipos As TDPagInt On TDPagInt.TIPOS_Codigo = DPagInt.TIPOS_CodTipoDocumento
	where (Rec.PVENT_Id = DPag.PVENT_Id And Rec.DPAGO_Id = DPag.DPAGO_Id and 
	--obteniendo los recibos relacionados
	Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDRA', 'CPDDE')
	And Rec.TIPOS_CodTransaccion In ('TRE02', 'TRE03')
	And Rec.RECIB_Estado <> 'X'	))
	,'') as FlagRD
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
	Left Join Entidades As Ent on Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo And CDPag.PVENT_Id = @PVENT_Id
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id And DPag.PVENT_Id = @PVENT_Id 
	Inner Join Tipos As MTPag On MTPag.TIPOS_Codigo = DPag.TIPOS_CodTipoMoneda
	Inner Join Tipos As TDPag On TDPag.TIPOS_Codigo = DPag.TIPOS_CodTipoDocumento
	Left Join Cuentas As Cta On Cta.CUENT_Id = DPag.CUENT_Id
	Left Join Tipos As TCta On TCta.TIPOS_Codigo = Cta.TIPOS_CodTipoCuenta 
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
	
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	--And Not DPag.TIPOS_CodTipoDocumento In ('DPG03')
	And Not Caj.TIPOS_CodTransaccion In ('TPG01', 'TPG03', 'TPG05')
	And Convert(Date, CAJA_Fecha) Between @FecIni And @FecFin
	And Caj.CAJA_Estado <> 'X'
	And Caj.PVENT_Id = @PVENT_Id
Union All /* Depositos Anulados */
Select @Orden As Orden
	,'Recibo de Egresos - Depositos Anulados' As Titulo
	,'03.- Recibo de Egresos' As Title
	,CAJA_Fecha As Fecha
	,IsNull('Dep. / ' + IsNull(TDoc.TIPOS_DescCorta, '')
		+ ' / Op: ' + IsNull(RTrim(DPag.DPAGO_Numero), '') 
		+ ' / Bco: ' + IsNull(RTrim(Ban.BANCO_DescCorta), '') 
		+ ' / Fecha: ' + ISNULL(CONVERT(Varchar, DPag.DPAGO_FechaVenc, 103), '') 
		+ ' / ' + IsNull(Ent.ENTID_RazonSocial, '')
		+ ' / Importe: ' + Mon.TIPOS_DescCorta + ' ' +  CONVERT(varchar(50), CONVERT(money, DPag.DPAGO_Importe), 1) --Rtrim(DPag.DPAGO_Importe)
	  , Caj.CAJA_Glosa)
	 As ENTID_RazonSocial
	--,IsNull((TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) + ' (' + RTRIM(IsNull(DPag.DPAGO_Id, CAJA_Id)) + ')') 
	--  , 'RC ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7))
	,IsNull('DB ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(DPag.DPAGO_Id), 7)
	 ,TCaj.TIPOS_Desc2 + ' ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(Caj.CAJA_Id), 7))
	  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,(Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End) As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then Convert(Decimal(12, 4), Caj.CAJA_Importe)
		Else Convert(Decimal(14, 2), 0.00) End 
	 ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' 
		Then 
			(Convert(Decimal(12, 4), Caj.CAJA_Importe))
			* (Case Caj.CAJA_TCPorUsuario When 0 Then Ven.DOCVE_TipoCambio Else TC.TIPOC_VentaSunat End)
	 Else Convert(Decimal(12, 4), (Convert(Decimal(12, 4), Caj.CAJA_Importe)
			)) End 
	 ImpSoles
	,Caj.ENTID_Codigo As ENTID_Codigo
	,Caj.DOCVE_Codigo As DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,'Caj' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Caj.TIPOS_CodTipoDocumento
	,Caj.CAJA_Codigo + ' - ' + RTRIM(DPag.DPAGO_Numero)
	,'T.Proc.: '+ TEfe.TIPOS_DescCorta 
	 + ' / ' +  Caj.CAJA_Glosa
	 + IsNull(' / ' + (TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)), '')
	 + ' / C.Interno: ' + Caj.CAJA_Codigo + '/' + Rtrim(Caj.CAJA_Id)
	 As Detalle
	 ,IsNull((TFac.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)) 
	  , 'RC ' + Right('000' + RTRIM(@PVENT_Id), 3) + '-' + Right('0000000' + RTrim(CAJA_Id), 7))
	 As DocDetalle
	    ,''  as FlagRD
From Tesoreria.TESO_Caja As Caj
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
	Left Join Entidades As Ent on Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo And CDPag.PVENT_Id = @PVENT_Id
	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id And DPag.PVENT_Id = @PVENT_Id
	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
	--And Not DPag.TIPOS_CodTipoDocumento In ('DPG03')
	And Not Caj.TIPOS_CodTransaccion In ('TPG01', 'TPG03', 'TPG05')
	And Caj.CAJA_Estado = 'X'
	And Convert(Date, CAJA_Fecha) <= @FecIni
	And Convert(Date, CAJA_Fecha) >= @FecFin
	And Convert(Date, CAJA_FechaAnulado) > DateAdd(Day, 0, @FecIni) 
	And Caj.CAJA_AnuladoCaja = 1
	And Caj.PVENT_Id = @PVENT_Id
Union All /* Parte del Deposito */
Select @Orden As Orden
	,'Recibo de Egresos - Parte del Deposito' As Titulo
	,'03.- Recibo de Egresos' As Title
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
	 + ' / C.Interno: ' + RECIB_Codigo
	 As ENTID_RazonSocial
	,
	
	
	
	IsNull(TDPag.TIPOS_DescCorta, 'DB') + ' - ' + Right('0000000000' + RTrim(DPag.DPAGO_Numero), 10)
	+
	'-' + rec.ENTID_Codigo  + '-' 
		+
		right((cast('00' +  month(IsNull(Rec.RECIB_Fecha,GETDATE())) as varchar(2)) ),2)
	+
	 	right(cast('00' +  day(IsNull(Rec.RECIB_Fecha,getdate())) as varchar(2)) ,2)
	 	
	 	 
	 
	 As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Rec.RECIB_Importe * TC.TIPOC_VentaSunat End ImpSoles
	,Rec.ENTID_Codigo As ENTID_Codigo
	,Rec.RECIB_Codigo As DOCVE_Codigo
	,Rec.RECIB_Serie As DOCVE_Serie
	,Rec.RECIB_Numero As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
	,''
	,Rec.RECIB_Concepto
	,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7)
	,ISNULL(Rec.RECIB_Codigo,'') as FlagRD
From Tesoreria.TESO_Recibos As Rec
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo
	Inner Join Tesoreria.TESO_DocsPagos As DPag On DPag.PVENT_Id = Rec.PVENT_Id And DPag.DPAGO_Id = Rec.DPAGO_Id
	Inner Join Tipos As TDPag On TDPag.TIPOS_Codigo = DPag.TIPOS_CodTipoDocumento
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo In ('CPDRI', 'CPDRA', 'CPDDE')
	And Rec.TIPOS_CodTransaccion In ('TRE02', 'TRE03')
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* Recibos de Facturas Anuladas */
Select @Orden As Orden
	,'Recibo de Egresos - Recibos de Facturas Anuladas' As Titulo
	,'03.- Recibo de Egresos' As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_RazonSocial + ' - Recibo de Egreso por Anulación de Factura /  Anulada el ' + CONVERT(VarChar(12), Ven.DOCVE_FecAnulacion, 103)  As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat) Else Convert(Decimal(14, 4), Ven.DOCVE_TotalPagar) End ImpSoles
	,'' As ENTID_Codigo
	,'' As DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
	,'' As CAJA_Codigo
	,'' As Detalle
	,'' As DocDetalle
	,''  as FlagRD
From Ventas.VENT_DocsVenta As Ven
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
	And Ven.PVENT_Id = @PVENT_Id
Where Ven.DOCVE_AnuladoCaja = 1
	And Convert(Date, Ven.DOCVE_FecAnulacion) Between @FecIni And @FecFin
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (Select ENTID_Codigo From Tesoreria.TESO_CCExcluidos Where CCEXC_Activo = 1)
Union All /* Documento Pagados de Pendientes */
Select @Orden As Orden
	,'Recibo de Egresos - Documenos Pagados pendientes' As Titulo
	,'03.- Recibo de Egresos' As Title
	,CCp.CAJAP_Fecha As Fecha
	,'Resp : '
	 + CCh.ENTID_Codigo + ' - ' + EntR.ENTID_RazonSocial
	 + ' / Concepto : ' + CCp.CAJAP_Descripcion
	 + IsNull(' / Recibo : ' + Right('00000' + RTrim(CCP.CAJAC_Id), 4) + Right('00' + RTrim(CCP.CAJAP_Item), 2), '')
	 + ISNULL((Case When CCp.DOCUS_Codigo Is Null Then '' 
				Else (' / Prov : ' + EntDoc.ENTID_Codigo + ' - ' + EntDoc.ENTID_RazonSocial
					+ ' / Doc : ' + EntTDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
					  )
			   End),' - ')
	 As ENTID_RazonSocial
	,'RC ' + Right('000' + Rtrim(CCp.PVENT_Id), 3) + '-' + Right('00000' + RTrim(CCP.CAJAC_Id), 5) + Right('00' + RTrim(CCP.CAJAP_Item), 2) As Documento
	,Mon.TIPOS_DescCorta 
	 As Moneda
	,0.00 As TCambioVenta
	,Case CCh.TIPOS_CodTipoMoneda When 'MND2' Then CCp.CAJAP_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case CCh.TIPOS_CodTipoMoneda When 'MND1' Then CCp.CAJAP_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,CCp.ENTID_Codigo As ENTID_Codigo
	,'' As DOCVE_Codigo
	,'' As DOCVE_Serie
	,0 As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,CCp.TIPOS_CodTipoPago As TIPOS_CodTipoDocumento
	,'' As CAJA_Codigo
	,'' As Detalle
	,'' As DocDetalle
		,''  as FlagRD
From Tesoreria.TESO_CajaChicaPagos As CCp
	Inner Join Tesoreria.TESO_CajaChicaIngreso As CCh On CCh.CAJAC_Id = CCp.CAJAC_Id And CCh.PVENT_Id = @PVENT_Id
	Left Join Entidades As EntR On EntR.ENTID_Codigo = CCh.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = CCp.TIPOS_CodTipoPago
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = CCh.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = CCp.DOCUS_Codigo 
		And Doc.ENTID_Codigo = CCp.ENTID_Codigo
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = CCp.ENTID_Codigo
	Left Join Tipos As EntTDoc On EntTDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
where TIPOS_CodTipoPago = 'TPC01'
	And Convert(Date, CCp.CAJAP_Fecha) Between @FecIni And @FecFin
	And CCp.PVENT_Id = @PVENT_Id
	And CCp.CAJAP_Estado <> 'X'
	And CCp.CAJAP_Estado <> 'X'

Select * From #Recibos
Order By Orden, DOCVE_Codigo, Fecha


--Select 
--	Caj.CAJA_AnuladoCaja, Caj.CAJA_FechaAnulado, Caj.CAJA_Fecha
--	,Caj.*
--From Tesoreria.TESO_Caja As Caj
--	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
--	Inner Join Tipos As TEfe On TEfe.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
--	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
--	Inner Join Tipos As TCaj On TCaj.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
--	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo And Ven.PVENT_Id = @PVENT_Id
--	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, IsNull(Ven.DOCVE_FechaDocumento, Caj.CAJA_Fecha), 112)
--	Left Join Entidades As Ent on Ent.ENTID_Codigo = Caj.ENTID_Codigo
--	Left Join Tipos As TFac On TFac.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
--	Left Join Tesoreria.TESO_CajaDocsPago As CDPag On CDPag.CAJA_Codigo = Caj.CAJA_Codigo And CDPag.PVENT_Id = @PVENT_Id
--	Left Join Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = CDPag.DPAGO_Id And DPag.PVENT_Id = @PVENT_Id
--	Left Join Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
--Where TIPOS_CodTipoOrigen In ('ORI08', 'ORI09', 'ORI10')
--	And Caj.TIPOS_CodTransaccion <> 'TPG01'
--	And Caj.CAJA_Estado = 'X'
--	And Caj.CAJA_AnuladoCaja = 1
--	And Convert(Date, CAJA_Fecha) >= DateAdd(Day, 0, @FecFin)
--	And Convert(Date, CAJA_FechaAnulado) > DateAdd(Day, 0, @FecIni) 
--	And Caj.PVENT_Id = @PVENT_Id

Print @FecIni


GO 
/***************************************************************************************************************************************/ 

