GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DIST_CuadrePendientesIntegrado]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DIST_CuadrePendientesIntegrado] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/08/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DIST_CuadrePendientesIntegrado]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@ALMAC_Id SmallInt
	,@PVENT_Id BigInt = Null
	,@ARTIC_Codigo VarChar(14) = Null
	,@ENTID_Codigo VarChar(14) = Null
	,@Fecha Bit = Null
	,@DesBloqueo Bit = Null
)
As
/**/
Create Table #Pendientes(DOCVE_Codigo VarChar(30)
,Documento VarChar(50)
,DOCVE_FechaDocumento DateTime
,ENTID_CodigoCliente VarChar(20)
,DOCVE_DescripcionCliente VarChar(200)
,DOCVD_Item SmallInt
,ARTIC_Codigo VarChar(12)
,ARTIC_Detalle VarChar(200)
,DOCVD_Cantidad Decimal(14, 2)
,Saldo Decimal(14, 2)
,DOCVE_EstEntrega varChar(10)
,DOCVD_PesoUnitario Decimal(14, 4)
,PVENT_Id BigInt
,PVENT_IdOrigen BigInt
,PVENT_IdDestino BigInt
)
/**/
--Delete From #Pendientes

Insert Into #Pendientes
exec LOG_DIST_CuadrePendientesVentas @FecIni, @FecFin, @ALMAC_Id, @PVENT_Id, @ARTIC_Codigo, @ENTID_Codigo, @Fecha, @DesBloqueo 

Insert Into #Pendientes
Exec LOG_DIST_CuadrePendientesOrdenes @FecIni, @FecFin, @ALMAC_Id, @PVENT_Id, @ARTIC_Codigo, @ENTID_Codigo, @Fecha, @DesBloqueo 

Select * From #Pendientes


GO 
/***************************************************************************************************************************************/ 

