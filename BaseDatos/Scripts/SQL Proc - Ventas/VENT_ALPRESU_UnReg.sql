GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_ALPRESU_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_ALPRESU_UnReg] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 15/11/2013
-- Descripcion         : Procedimiento de Actualización de la tabla VENT_ListaPreciosArticulos
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_ALPRESU_UnReg]
(	@ZONAS_Codigo CodigoZona,
	@LPREC_Id Id,
	@ARTIC_Codigo CodArticulo,
	@ALPRE_Constante Importe = null ,
	@ALPRE_PorcentaVenta Importe = null ,
	@Usuario Usuario
)

AS


UPDATE Ventas.[VENT_ListaPreciosArticulos]
SET [ALPRE_Constante] = @ALPRE_Constante
  , [ALPRE_PorcentaVenta] = @ALPRE_PorcentaVenta
  , [ALPRE_UsrMod] = @Usuario
  , [ALPRE_FecMod] = GetDate()

WHERE
 ZONAS_Codigo = @ZONAS_Codigo
  And LPREC_Id = @LPREC_Id
  And ARTIC_Codigo = @ARTIC_Codigo



GO 
/***************************************************************************************************************************************/ 

