USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ABAS_INPZASS_ObtenerStockPiezas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ABAS_INPZASS_ObtenerStockPiezas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/05/2016
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ABAS_INPZASS_ObtenerStockPiezas]
(	 @ARTIC_Codigo CodArticulo
   , @ALMAC_Id BigInt = Null)
AS

  SELECT DPZA.ARTIC_Codigo, DPZA.INGCO_Id, DPZA.INGCD_Item, DPZA.ALMAC_Id, DPZA.INPZA_Codigo
       , DPZA.Cantidad
	   , CodigoLote = DPZA.ARTIC_Codigo  + RIGHT('00000' + RTRIM(DPZA.INGCO_Id), 4) + RIGHT('00' + RTRIM(DPZA.INGCD_Item), 2)
   FROM Logistica.ABAS_IngresoPorPiezas PZA
   INNER JOIN (SELECT ARTIC_Codigo, INGCO_Id, INGCD_Item, ALMAC_Id, INPZA_Codigo
                    , SUM(INPZD_CantidadIngreso) - SUM(INPZD_CantidadSalida) AS Cantidad
                 FROM Logistica.ABAS_IngresoPorPiezasDetalle
                GROUP BY ARTIC_Codigo, INGCO_Id, INGCD_Item, ALMAC_Id, INPZA_Codigo
               HAVING SUM(INPZD_CantidadIngreso) - SUM(INPZD_CantidadSalida) > 0
              )  DPZA ON DPZA.ARTIC_Codigo = PZA.ARTIC_Codigo AND PZA.INGCO_Id = DPZA.INGCO_Id
                  AND PZA.INGCD_Item = DPZA.INGCD_Item AND PZA.ALMAC_Id = dpza.ALMAC_Id
                  AND PZA.INPZA_Codigo = DPZA.INPZA_Codigo
   WHERE PZA.ARTIC_Codigo = @ARTIC_Codigo
     AND PZA.ALMAC_Id = @ALMAC_Id

GO 
/***************************************************************************************************************************************/ 
--EXEC ABAS_INPZASS_ObtenerStockPiezas '0101001', 1
EXEC ABAS_INPZASS_ObtenerStockPiezas '0102001', 1
--exec ARTICSS_ConexionStocksAlmacenes @PVENT_Id=1
--exec VENTSS_ObtenerArticulos @PERIO_Codigo=N'2017',@ALMAC_Id=1,@ZONAS_Codigo=N'83.00',@LINEA_Codigo=N'1005'


