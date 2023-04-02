USE BDJAYVIC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTISS_ObtenerDireccion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTISS_ObtenerDireccion] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 10/06/2013
-- Descripcion         : Obtener la direccion del cliente con su respectivo ubigeo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTISS_ObtenerDireccion]
(
	 @ENTID_Codigo VARcHAR(14)
)
As

Select 
	Ent.ENTID_Codigo
	,Ent.UBIGO_Codigo
	,ENTID_Direccion = Ent.ENTID_Direccion --+ ' - ' + UDep.UBIGO_Descripcion + ' / ' +  UProv.UBIGO_Descripcion + ' / ' + UDis.UBIGO_Descripcion
from Entidades As Ent
	Left Join Ubigeos As UDep On UDep.UBIGO_Codigo = Left(Ent.UBIGO_Codigo, 2)
	Left Join Ubigeos As UProv On UProv.UBIGO_Codigo = Left(Ent.UBIGO_Codigo, 5)
	Left Join Ubigeos As UDis On UDis.UBIGO_Codigo = Ent.UBIGO_Codigo
Where Ent.ENTID_Codigo = @ENTID_Codigo


GO 
/***************************************************************************************************************************************/ 

