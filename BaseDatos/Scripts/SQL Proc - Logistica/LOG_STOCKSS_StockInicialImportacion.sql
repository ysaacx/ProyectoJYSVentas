GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_STOCKSS_StockInicialImportacion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_STOCKSS_StockInicialImportacion] 
GO 

-- =============================================
-- Autor - Fecha Crea  : SRosas - 25/08/2014
-- Descripcion         : Obtener el stock inicial
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
create PROCEDURE [dbo].[LOG_STOCKSS_StockInicialImportacion]
(
	 @PERIO_Codigo VarChar(6)
	)
As

	Select Si.PERIO_Codigo as Periodo,Art.ARTIC_CodigoAnterior as Id_Producto, STINI_Cantidad as StockFisico,STINI_Fecha as Fecha, Art.ARTIC_Codigo as Id_Producto2 
	From Logistica.LOG_StockIniciales As SI
	inner join dbo.Articulos As Art On Art.ARTIC_Codigo = SI.ARTIC_Codigo 
	And PERIO_Codigo = @PERIO_Codigo
GO 
/***************************************************************************************************************************************/ 

