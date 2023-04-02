GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SUCURSS_TodasSucursalesIPBD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[SUCURSS_TodasSucursalesIPBD] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/02/2013
-- Descripcion         : Obtiene todas las sucursales con las direcciones IP de cada sucursal
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[SUCURSS_TodasSucursalesIPBD]
	@ZONAS_Codigo VarChar(5) = Null
	,@SUCUR_Id SmallInt
As

Select Suc.SUCUR_Id
	,Suc.SUCUR_Nombre
	,Suc.ZONAS_Codigo
	,PVen.PVENT_Id
	,PVen.ALMAC_Id
	,PVen.PVENT_DireccionIP
	,PVen.PVENT_BaseDatos
	,PVen.ALMAC_Id
From Sucursales As Suc
	Inner Join PuntoVenta As PVen On PVen.SUCUR_Id = Suc.SUCUR_Id And PVen.PVENT_Principal = 1
Where Suc.ZONAS_Codigo = ISNULL(@ZONAS_Codigo, Suc.ZONAS_Codigo)
	And Not Suc.SUCUR_Id = @SUCUR_Id
Union All
Select Suc.SUCUR_Id
	,Suc.SUCUR_Nombre + ' - Transportes'
	,Suc.ZONAS_Codigo
	,PVen.PVENT_Id
	,PVen.ALMAC_Id
	,PVen.PVENT_DireccionIP
	,PVen.PVENT_BaseDatos
	,PVen.ALMAC_Id
From Sucursales As Suc
	Inner Join PuntoVenta As PVen On PVen.SUCUR_Id = Suc.SUCUR_Id
Where Suc.ZONAS_Codigo = ISNULL(@ZONAS_Codigo, Suc.ZONAS_Codigo)
	And Not Suc.SUCUR_Id = @SUCUR_Id
	And PVen.PVENT_Id = 9
Order By SUCUR_Nombre


GO 
/***************************************************************************************************************************************/ 

