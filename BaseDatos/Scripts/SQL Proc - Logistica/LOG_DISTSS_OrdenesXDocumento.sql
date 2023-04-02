GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_OrdenesXDocumento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_OrdenesXDocumento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DISTSS_OrdenesXDocumento]
(
	 @DOCVE_Codigo VarChar(14)	
	 ,@PVENT_Id BigInt
)
As

Select 'OR ' + ORDEN_Serie + '-' + Right('0000000' + RTrim(ORDEN_Numero), 7) As Documento
	--,TDoc.TIPOS_DescCorta + ' ' + Right(Left(DOCVE_Codigo, 5), 3) + '-' + Right(DOCVE_Codigo, 7) As DocVenta
	,PDes.PVENT_Descripcion As PVENT_Destino
	,POri.PVENT_Descripcion As PVENT_Origen
	,(Select Sum(Art.ARTIC_Peso * Det.ORDET_Cantidad) From Logistica.DIST_OrdenesDetalle As Det
		Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	  Where DOCVE_Codigo = Cab.DOCVE_Codigo
	 ) As Peso
	,ORDEN_FechaDocumento
	,Cab.ORDEN_Estado
From Logistica.DIST_Ordenes As Cab
	--Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = 'CPD' + Left(Cab.DOCVE_Codigo, 2)
	Inner Join PuntoVenta As PDes On PDes.PVENT_Id = Cab.PVENT_IdDestino
	Inner Join PuntoVenta As POri On POri.PVENT_Id = Cab.PVENT_IdOrigen
Where DOCVE_Codigo = @DOCVE_Codigo
	And Cab.PVENT_Id = @PVENT_Id





GO 
/***************************************************************************************************************************************/ 

