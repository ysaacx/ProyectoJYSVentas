--USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_FacturasResumen]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_FacturasResumen] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_FacturasResumen]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor From Parametros Where PARMT_Id = 'Empresa')
Declare @Excepcion1 VarChar(14) Set @Excepcion1 = ''
Declare @Excepcion2 VarChar(14) Set @Excepcion2 = ''
Declare @Excepcion3 VarChar(14) Set @Excepcion3 = ''

/* Facturas Disponibles */
 SELECT 1 As Orden
	   , Convert(VarChar(250), '') As Titulo
	   , Convert(VarChar(50), '01.- Documentos ') As Title
	   , Ven.DOCVE_FechaDocumento As Fecha
	   , ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	   , IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	   , Mon.TIPOS_DescCorta As Moneda
	   , IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As TCambioVenta
	   , Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	   , Case Ven.TIPOS_CodTipoMoneda
	    	When 'MND1' Then  Ven.DOCVE_TotalPagar / (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
	    													Else Ven.DOCVE_TipoCambio
	    											  End)
	    	 Else  Ven.DOCVE_TotalPagar
	    	 End
	     As Dolares
	   , Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
	   , Case Ven.TIPOS_CodTipoMoneda
	    	When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
	    													Else Ven.DOCVE_TipoCambio
	    											  End)
	    	 Else  Ven.DOCVE_TotalPagar
	    	 End
	     As Soles
	   , Ven.ENTID_CodigoCliente As ENTID_Codigo
	   , Ven.DOCVE_Codigo
	   , Ven.DOCVE_Serie
	   , Ven.DOCVE_Numero
	   , TDoc.TIPOS_DescCorta As TipoDocumento
	   , TDoc.TIPOS_Descripcion
	   , Ven.TIPOS_CodTipoDocumento
   INTO #Facturas
   FROM Ventas.VENT_DocsVenta As Ven 
  INNER Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
  INNER Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
  WHERE Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	 AND Ven.DOCVE_Estado <> 'X'
	 AND Ven.PVENT_Id = @PVENT_Id
	 AND Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
  UNION All /* Factura Anulada en otro Tiempo */
 SELECT 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Soles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND1' Then  Ven.DOCVE_TotalPagar / TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Dolares
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni And Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* Facturas Anuladas */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,'ANULADO' As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,'' As Moneda
	,0.00 As TCambioVenta
	,0.00 As ImpDolares
	,0.00 As Dolares
	,0.00 As ImpSoles	
	,0.00 As Soles	
	,'' As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
/* Actualizar la Numeración de Fletes */
Update #Facturas
Set Titulo = (Select #Facturas.TIPOS_Descripcion + ' - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
				   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
						And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
				  )
Update #Facturas Set Title = '01.- ' + Titulo 


 SELECT Titulo, Title, Fecha = CONVERT(DATE, Fecha), Moneda
      , TCambioVenta = MAX(TCambioVenta)
      , Dolares = SUM(Dolares)
      , ImpSoles = SUM(ImpSoles)
      , Soles = SUM(Soles)
      , TipoDocumento, TIPOS_Descripcion, TIPOS_CodTipoDocumento
      , ENTID_RazonSocial = Titulo
  FROM #Facturas 
  WHERE ImpSoles > 0
  GROUP BY  Titulo, Title, CONVERT(DATE, Fecha), Moneda
      , TipoDocumento, TIPOS_Descripcion, TIPOS_CodTipoDocumento
--Order By DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 
GRANT EXECUTE
ON [dbo].[VENT_CCAJASS_Facturas]
TO [Ventas]
GO
/***************************************************************************************************************************************/ 

--Exec VENT_CCAJASS_Facturas '06-11-2013', '06-11-2013', 5
exec VENT_CCAJASS_FacturasResumen @FecIni='2018-12-31 00:00:00',@FecFin='2018-12-31 00:00:00',@PVENT_Id=1

--select * from Ventas.VENT_DocsVenta where Convert(date, DOCVE_FechaDocumento) = '06-17-2013'
--select * from Ventas.VENT_DocsVenta where DOCVE_Codigo Like 'PE%'
--select * from Ventas.VENT_DocsVenta where DOCVE_Codigo Like '%571'
