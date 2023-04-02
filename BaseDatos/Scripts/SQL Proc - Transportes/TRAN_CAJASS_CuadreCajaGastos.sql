GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_CAJASS_CuadreCajaGastos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaGastos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_CAJASS_CuadreCajaGastos]
(
	 @FecIni DateTime
	,@FecFin DateTime
)
As

Select SUM(VGAST_Monto) From Transportes.TRAN_ViajesGastos
Where Convert(Date, VGAST_Fecha) Between @FecIni And @FecFin

Select * From Transportes.TRAN_ViajesGastos
Where Convert(Date, VGAST_Fecha) Between @FecIni And @FecFin


GO 
/***************************************************************************************************************************************/ 

