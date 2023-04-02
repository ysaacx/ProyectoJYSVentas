USE BDAcerosFirme
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_VENTSS_RomperRelacionDocsVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas]
(
	 @DOCVE_Codigo VarChar(13)
	,@PVENT_Id BigInt
	,@XPago Bit
)
As

Begin Tran x

UPDATE Logistica.DIST_GuiasRemision
   SET DOCVE_Codigo = Null
 WHERE DOCVE_Codigo = @DOCVE_Codigo AND PVENT_Id = @PVENT_Id

UPDATE Logistica.DIST_Ordenes
   SET DOCVE_Codigo = Null
 WHERE DOCVE_Codigo = @DOCVE_Codigo AND PVENT_Id = @PVENT_Id
	
-- Eliminar Pago

--If @XPago = 1
--Begin 
	Declare @CAJA_Codigo VarChar(14)
	Declare @DPAGO_Id BigInt
	Set @CAJA_Codigo = (Select CAJA_Codigo From Tesoreria.TESO_Caja Where DOCVE_Codigo = @DOCVE_Codigo)
	Set @DPAGO_Id = (Select DPAGO_Id From Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo)
	--PRINT 'ELIMINAR Tesoreria.TESO_DocsPagos'
 --   PRINT @CAJA_Codigo
	Update Tesoreria.TESO_DocsPagos
	   SET DPAGO_Estado = 'X'
	 Where DPAGO_Id IN (Select DPAGO_Id From Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo)
      And PVENT_Id = @PVENT_Id

    DELETE FROM Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo
    DELETE FROM Tesoreria.TESO_DocsPagos Where DPAGO_Id = @DPAGO_Id AND PVENT_Id = @PVENT_Id
--End

DELETE FROM Tesoreria.TESO_Caja Where DOCVE_Codigo = @DOCVE_Codigo And PVENT_Id = @PVENT_Id
	
Commit Tran x



GO 
/***************************************************************************************************************************************/ 




GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_VENTSS_RomperRelacionDocsVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 24/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_VENTSS_RomperRelacionDocsVentas]
(
	 @DOCVE_Codigo VarChar(13)
	,@PVENT_Id BigInt
	,@XPago Bit
)
As

Begin Tran x

UPDATE Logistica.DIST_GuiasRemision
   SET DOCVE_Codigo = Null
 WHERE DOCVE_Codigo = @DOCVE_Codigo AND PVENT_Id = @PVENT_Id

UPDATE Logistica.DIST_Ordenes
   SET DOCVE_Codigo = Null
 WHERE DOCVE_Codigo = @DOCVE_Codigo AND PVENT_Id = @PVENT_Id
	
-- Eliminar Pago

--If @XPago = 1
--Begin 
	Declare @CAJA_Codigo VarChar(14)
	Declare @DPAGO_Id BigInt
	Set @CAJA_Codigo = (Select CAJA_Codigo From Tesoreria.TESO_Caja Where DOCVE_Codigo = @DOCVE_Codigo)
	Set @DPAGO_Id = (Select DPAGO_Id From Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo)
	--PRINT 'ELIMINAR Tesoreria.TESO_DocsPagos'
 --   PRINT @CAJA_Codigo
	Update Tesoreria.TESO_DocsPagos
	   SET DPAGO_Estado = 'X'
	 Where DPAGO_Id IN (Select DPAGO_Id From Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo)
      And PVENT_Id = @PVENT_Id

    DELETE FROM Tesoreria.TESO_CajaDocsPago Where CAJA_Codigo = @CAJA_Codigo
    DELETE FROM Tesoreria.TESO_DocsPagos Where DPAGO_Id = @DPAGO_Id AND PVENT_Id = @PVENT_Id
--End

DELETE FROM Tesoreria.TESO_Caja Where DOCVE_Codigo = @DOCVE_Codigo And PVENT_Id = @PVENT_Id

delete from Ventas.VENT_DocsRelacion where DOCVE_Codigo = @DOCVE_Codigo
	
Commit Tran x



GO 