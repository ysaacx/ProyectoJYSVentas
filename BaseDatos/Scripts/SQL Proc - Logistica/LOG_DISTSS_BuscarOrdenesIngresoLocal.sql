GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_BuscarOrdenesIngresoLocal]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_BuscarOrdenesIngresoLocal] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/11/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_BuscarOrdenesIngresoLocal]
(
	 @FecIni Datetime
	 ,@FecFin Datetime
	 ,@PVENT_IdDestino BigInt
	 ,@TIPOS_CodTipoOrden VarChar(6)
	 ,@Opcion SmallInt
	 ,@Cadena VarChar(50)
	 ,@Todos Bit
)
As

Select Alma.ALMAC_Descripcion As ALMAC_Origen
	, PVenD.PVENT_Descripcion As PVENT_Destino
	, PVenO.PVENT_Descripcion As PVENT_Origen
	, TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	,IsNull(TFDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + RIGHT('0000000' + Rtrim(Ven.DOCVE_Numero), 7) 
		  ,TFDoc2.TIPOS_DescCorta + ' ' + Left(Right(Orden.DOCVE_Codigo, 10), 3) + '-' + Right(Orden.DOCVE_Codigo, 7))
	 As DocVenta
	--,'OC' + Right('000' + RTrim(Orden.PVENT_IdOrigen), 3) + '-' + Right('0000000' + RTrim(Orden.ORDEN_Id), 7) As Documento
	,'OR' + ' ' + Left(Right(Orden.ORDEN_Codigo, 10), 3) + '-' + Right(Orden.ORDEN_Codigo, 7) As Documento
	,'OR' + ' ' + Left(Right(Orden.ORDEN_Codigo, 10), 3) + '-' + Right(Orden.ORDEN_Codigo, 7) As Codigo
	,GETDATE() As FechaImpresion
	,Orden.ORDEN_Id
	,Orden.ENTID_CodigoCliente
	,Orden.ORDEN_DireccionOrigen
	,Orden.ORDEN_DireccionDestino
	,Orden.ORDEN_DescripcionCliente
	,Orden.ORDEN_DescripcionCliente As Cliente
	,Orden.ORDEN_FechaDocumento
	,Orden.ORDEN_Estado
	,Orden.ORDEN_Codigo
	,Orden.TIPOS_CodTipoOrden
	,Us.ENTID_CodUsuario
	,Orden.ORDEN_Impresa
	,Orden.ORDEN_Impresiones
Into #Ordenes
From Logistica.DIST_Ordenes As Orden 
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = Orden.ALMAC_IdOrigen
	Left Join dbo.PuntoVenta As PVenD On PVenD.PVENT_Id = Orden.PVENT_IdDestino
	Inner Join dbo.PuntoVenta As PVenO On PVenO.PVENT_Id = Orden.PVENT_IdOrigen
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Orden.TIPOS_CodTipoOrden
	Inner Join Entidades As Cli On Cli.ENTID_Codigo = ENTID_CodigoCliente
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Orden.DOCVE_Codigo
	Left Join Tipos As TFDoc On TFDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join Tipos As TFDoc2 On TFDoc2.TIPOS_Codigo = ('CPD' + Left(Orden.DOCVE_Codigo, 2))
	Left Join Entidades As Us On Us.ENTID_Codigo = Orden.ORDEN_UsrCrea
WHERE  
	(Case @Opcion When 0 Then Orden.ORDEN_DescripcionCliente
				  When 1 Then Orden.ORDEN_Codigo
				  Else Orden.ORDEN_Descripcioncliente
	 End) Like '%' + @Cadena + '%' 
	AND  Orden.PVENT_IdDestino = @PVENT_IdDestino
	AND  Convert(Date, Orden.ORDEN_FechaDocumento) Between @FecIni AND @FecFin
	AND Orden.TIPOS_CodTipoOrden = @TIPOS_CodTipoOrden
	
If @Todos = 1
Begin 
	Select * From #Ordenes
End
Else
Begin 
	Select * From #Ordenes Where Not ORDEN_Estado In ('X', 'C')
End





GO 
/***************************************************************************************************************************************/ 

