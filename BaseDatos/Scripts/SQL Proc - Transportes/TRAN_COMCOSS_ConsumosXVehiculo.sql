GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_COMCOSS_ConsumosXVehiculo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_COMCOSS_ConsumosXVehiculo] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/06/2012
-- Descripcion         : Consumo de Combustible
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_COMCOSS_ConsumosXVehiculo]
(
	 @VEHIC_Id BigInt
)
As

Select TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,EPro.ENTID_RazonSocial
	,IsNull(ECon.ENTID_RazonSocial, ECond.ENTID_RazonSocial) As Conductor
	,IsNull(Con.COMCO_FechaConsumo, COMCO_Fecha) As COMCO_FechaConsumo
	,Veh.VEHIC_Placa
	, Doc.DOCUS_Serie As DOCUS_Serie
	, Doc.DOCUS_Numero As DOCUS_Numero
	, Doc.TIPOS_CodTipoDocumento As DOCUS_CodTipoDocumento
	, TipoDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	, TipoDoc.TIPOS_DescCorta As CompTipoDocumento
	,Con.* 
From Transportes.TRAN_CombustibleConsumo As Con
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Con.TIPOS_CodTipoMoneda
	Inner Join Entidades As EPro On EPro.ENTID_Codigo = Con.ENTID_CodigoProveedor
	Left Join Entidades As ECon On ECon.ENTID_Codigo = Con.ENTID_CodigoConductor
	Left Join Transportes.TRAN_Viajes As Via On Via.VIAJE_Id = Con.VIAJE_Id
	Left Join Transportes.TRAN_VehiculosConductores As VCond On VCond.VHCON_Id = Via.VHCON_Id
	Inner Join Transportes.TRAN_Vehiculos As Veh On Veh.VEHIC_Id = Con.VEHIC_Id
	Left Join Entidades As ECond on ECond.ENTID_Codigo = VCond.ENTID_Codigo
	Left Join Conductores As Cond On Cond.ENTID_Codigo = ECond.ENTID_Codigo
	Left Join Transportes.TRAN_Documentos As Doc On Doc.DOCUS_Codigo = Con.DOCUS_Codigo And Doc.ENTID_Codigo = Con.ENTID_CodigoProveedor
	Left Join dbo.Tipos As TipoDoc On TipoDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
Where Con.VEHIC_Id = @VEHIC_Id
	--And VEHIC_Estado <> 'X'
	And Con.COMCO_Estado <> 'X'
Order By COMCO_Fecha Desc


GO 
/***************************************************************************************************************************************/ 

