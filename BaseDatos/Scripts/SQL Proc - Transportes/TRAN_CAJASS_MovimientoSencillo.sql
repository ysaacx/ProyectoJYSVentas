GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_MovimientoSencillo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_MovimientoSencillo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_MovimientoSencillo]
(
	 @FecIni As DateTime
	,@PVENT_Id As Id
)
As
Select CAJA_Fecha
	,T.TIPOS_Descripcion As TIPOS_Transaccion
	,CAJA_Id
	,Caj.CAJA_Glosa
	,IsNull(CAJA_Importe, 0) As CAJA_Importe 
	,Us.ENTID_RazonSocial As Usuario	
	,Caj.CAJA_NroDocumento
From Tesoreria.TESO_Caja As Caj
	Left Join Tipos As T On T.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Left Join Entidades As Us On Us.ENTID_NroDocumento = Caj.CAJA_UsrCrea
Where TIPOS_CodTipoOrigen = 'ORI05'
	And Convert(Date, CAJA_Fecha) = @FecIni
	And Caj.CAJA_Estado <> 'X'
	And PVENT_Id = @PVENT_Id


GO 
/***************************************************************************************************************************************/ 

