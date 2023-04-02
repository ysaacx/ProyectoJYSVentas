GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_VENTASS_ReporteVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[SP_VENTASS_ReporteVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Jimmy - 4/07/2011
-- Descripcion         : Reporte de Ventas
-- Autor - Fecha Modif : Ysaacx - 05/2011
-- Descripcion         : Terminacion
-- =============================================
CREATE Procedure SP_VENTASS_ReporteVentas
(
	 @Nro_Serie varchar(3) = Null
	,@Fec_Ini smalldatetime 
	,@Fec_Fin smalldatetime
	,@Notas Bit = Null
)
As
	
Select
	Left(TDoc.TIPOS_Descripcion, 1) + ' ' + Ven.DOCVE_Serie + '-' + Right(('0000000'+RTrim(Ven.DOCVE_Numero)), 7) As Documento
	,Convert(Date, Ven.DOCVE_FechaDocumento) As Fecha
	,Ent.ENTID_NroDocumento As Id_Cliente
	,Ent.ENTID_RazonSocial As Descripcion_Cliente
	,TMon.TIPOS_DescCorta As Simbolo_Moneda
	,Case Ven.TIPOS_CodTipoMoneda when 'MND2' Then 
		Ven.DOCVE_TotalVenta 
	 Else 
		0
	 End AS TotalDolares
	,Case Ven.TIPOS_CodTipoMoneda when 'MND1' Then 1.0 Else TC.TIPOC_VentaSunat End As Ven_Dol_Sunat
	,Case Ven.TIPOS_CodTipoMoneda when 'MND2' Then 
		Case When Ven.DOCVE_FechaDocumento < '01/03/2011' Then	
			ROUND(Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat/1.19, 2)
		Else
			ROUND(Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat/1.18, 2)
		End 
	 Else 
		Case When Ven.DOCVE_FechaDocumento < '01/03/2011' Then	
			ROUND(Ven.DOCVE_TotalVenta/1.19, 2)
		Else
			ROUND(Ven.DOCVE_TotalVenta/1.18, 2)
		End 		
	 End AS SubTotal
	,Case Ven.TIPOS_CodTipoMoneda when 'MND2' Then 
		Case When Ven.DOCVE_FechaDocumento < '01/03/2011' Then	
			ROUND((Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat/1.19)*0.19, 2)
		Else
			ROUND((Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat/1.18)*0.18, 2)
		End 
	 Else 
		Case When Ven.DOCVE_FechaDocumento < '01/03/2011' Then	
			ROUND((Ven.DOCVE_TotalVenta/1.19)*0.19, 2)
		Else
			ROUND((Ven.DOCVE_TotalVenta/1.18)*0.18, 2)
		End 		
	 End AS Igv
	,Case Ven.TIPOS_CodTipoMoneda when 'MND2' Then 
		ROUND(Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat, 2)
	 Else 
		Ven.DOCVE_TotalVenta
	 End AS Total
	--,ROUND(Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat/1.19, 2) As Total
	,0 As Doc_Percepcion
	,0 As Percepcion_Cliente
	,DOCVE_AfectoPercepcion As Afecto
	,DOCVE_ImportePercepcion As Percepcion
	,Case Ven.TIPOS_CodTipoMoneda when 'MND2' Then 
		ROUND(Ven.DOCVE_TotalVenta * TC.TIPOC_VentaSunat, 2)
	 Else 
		Ven.DOCVE_TotalVenta
	 End AS Pagar
	,Right('00' + Right(Ven.TIPOS_CodTipoDocumento, 2), 2) As Id_Tipo_Documento
	,DOCVE_Serie As Nro_Serie
	,RTrim(DOCVE_Numero) As Nro_Venta
	,Convert(Integer, Right(TIPOS_CodTipoMoneda, 1)) As Id_Moneda
	,DOCVE_ImporteVenta As Sub_Total
	,DOCVE_ImporteIgv As Total_IGV
	,DOCVE_TotalVenta As Total_Venta
	,Convert(Integer, Case DOCVE_Estado When 'X' Then 1 Else 0 End) As Anulada
	,Right('00' + Right(Ent.TIPOS_CodTipoDocumento, 1), 2) As DocCliente
	,Convert(Integer, 0) As Correlativo
	,DOCVE_Codigo As Id_Venta
	--,*
Into #Tabla
From Ventas.VENT_DocsVenta As Ven
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join TipoCambio As TC On Convert(Varchar, TC.TIPOC_Fecha, 112) = Convert(Varchar, Ven.DOCVE_FechaDocumento, 112)
where Ven.DOCVE_Serie = @Nro_Serie 
	And Convert(Date,Ven.DOCVE_FechaDocumento) Between @Fec_Ini And @Fec_Fin
Order By Ven.DOCVE_FechaDocumento

If IsNull(@Notas, 0) = 0
Begin
	Select * from #Tabla
End
Else
Begin
	Select Top 0 * from #Tabla
End


GO 
/***************************************************************************************************************************************/ 

