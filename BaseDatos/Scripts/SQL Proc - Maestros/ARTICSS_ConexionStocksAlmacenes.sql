--USE BDInkasFerro_Almudena
--USE BDInkasFerro_Parusttacca
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_ConexionStocksAlmacenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_ConexionStocksAlmacenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 11/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_ConexionStocksAlmacenes]
(
	  @PVENT_Id Id
)
As

Select Distinct
	 Stock.ALMAC_Id
	,Alm.ALMAC_Descripcion As ALMAC_Nombre
	,PVRemoto.PVENT_BaseDatos
	,PVRemoto.PVENT_DireccionIP
	,Stock.VSPVA_ParaPedidos
From VerStockPtoVenta As Stock 
	Inner Join Almacenes As Alm On Alm.ALMAC_Id = Stock.ALMAC_Id
	Inner Join PuntoVenta As PVRemoto On PVRemoto.ALMAC_Id = Stock.ALMAC_Id
Where Stock.PVENT_Id = @PVENT_Id
	And PVRemoto.PVENT_Principal = 1
	And VSPVA_Activo = 1
	

GO 
/***************************************************************************************************************************************/ 

exec ARTICSS_ConexionStocksAlmacenes @PVENT_Id=1
--SELECT PVENT_Principal, PVENT_Activo, * FROM dbo.PuntoVenta
--SELECT * FROM dbo.Almacenes
--SELECT * FROM VerStockPtoVenta

--Select Distinct
--	 Stock.ALMAC_Id
--	,Alm.ALMAC_Descripcion As ALMAC_Nombre
--	,PVRemoto.PVENT_BaseDatos
--	,PVRemoto.PVENT_DireccionIP
--	,Stock.VSPVA_ParaPedidos
--From VerStockPtoVenta As Stock 
--	left Join Almacenes As Alm On Alm.ALMAC_Id = Stock.ALMAC_Id
--	left Join PuntoVenta As PVRemoto On PVRemoto.ALMAC_Id = Stock.ALMAC_Id
--Where Stock.PVENT_Id = 2
--	And PVRemoto.PVENT_Principal = 1
--	And VSPVA_Activo = 1

--UPDATE VerStockPtoVenta SET VSPVA_Activo = 1 WHERE PVENT_Id = 2