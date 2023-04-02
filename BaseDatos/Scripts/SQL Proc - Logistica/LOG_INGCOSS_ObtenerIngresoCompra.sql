--USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_INGCOSS_ObtenerIngresoCompra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_INGCOSS_ObtenerIngresoCompra] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 20/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_INGCOSS_ObtenerIngresoCompra]
(
	 @ALMAC_Id SmallInt
	 ,@INGCO_Id BigInt
)
As

Select ALMAC_Id
	,INGCO_Id
	,Ing.ENTID_CodigoProveedor
	,Ent.ENTID_RazonSocial As ENTID_Proveedor
	,Ing.TIPOS_CodTipoDocumento
	,Ing.INGCO_Serie
	,Ing.INGCO_Numero
	,Ing.DOCCO_Codigo
	,Ing.INGCO_Estado
	--,TDoc.TIPOS_DescCorta + ' ' + Ing.INGCO_Serie + Right('0000000' + RTrim(Ing.INGCO_Numero), 7) As DocCompra
	,LEFT(Ing.ORDCO_Codigo, 2) + ' ' + Right(LEFT(Ing.ORDCO_Codigo, 5), 3) + '-' + Right(Ing.ORDCO_Codigo, 7) As OrdCompra
From Logistica.ABAS_IngresosCompra As Ing
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ing.ENTID_CodigoProveedor
	--Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = 'CPD' + LEFT(Ing.DOCCO_Codigo, 2)
Where INGCO_Estado IN ('I', 'C', 'X')
	And ALMAC_Id = @ALMAC_Id 
	And INGCO_Id = @INGCO_Id


--Select * from Tipos where TIPOS_Codigo Like 'CPD%'

Select Det.ALMAC_Id
	,Det.INGCO_Id
	,Det.ARTIC_Codigo
	,Det.INGCD_Cantidad
	,INGCD_PesoUnitario
	,Art.ARTIC_Descripcion	
	,Det.INGCD_Item
	,St.STOCK_CantidadIngreso
From Logistica.ABAS_IngresosCompraDetalle As Det
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
	Inner Join Logistica.LOG_Stocks As St On St.INGCO_Id = Det.INGCO_Id And St.ARTIC_Codigo = Det.ARTIC_Codigo
		And St.INGCD_Item = Det.INGCD_Item
Where --ALMAC_Id = @ALMAC_Id 
	Det.INGCO_Id = @INGCO_Id

GO 
/***************************************************************************************************************************************/ 



exec LOG_INGCOSS_ObtenerIngresoCompra @ALMAC_Id=1,@INGCO_Id=329

--SELECT * FROM Logistica.ABAS_IngresosCompra WHERE ingco_id = 329