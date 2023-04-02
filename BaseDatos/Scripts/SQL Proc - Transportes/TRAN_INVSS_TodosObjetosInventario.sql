GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_INVSS_TodosObjetosInventario]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_INVSS_TodosObjetosInventario] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/02/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_INVSS_TodosObjetosInventario]
(
	 @VEHIC_Id Id
)
As

--Declare @VEHIC_Id Id
Declare @VEHIN_Id Id
--Set @VEHIC_Id = 1
--Select * From Transportes.TRAN_Vehiculos
Select @VEHIN_Id = VEHIN_Id From Transportes.TRAN_VehiculosInventario
Where VEHIN_Id = (Select MAX(VEHIN_Id) From Transportes.TRAN_VehiculosInventario Where VEHIC_Id = @VEHIC_Id)
	And VEHIC_Id = @VEHIC_Id

--Select * 
--From Transportes.TRAN_VehiculosInventario 
--Where VEHIN_Id = @VEHIN_Id

Select Tip.TIPOS_Codigo As TIPOS_CodObjeto
	,Tip.TIPOS_Descripcion As TIPOS_Objeto
	,Convert(Bit, IsNull(VEHID_Existe, 0)) As VEHID_Existe
	,Convert(Bit, IsNull(VEHID_Existe, 0)) As Existe
	,InvD.Tipos_CodObjeto
	,@VEHIC_Id As VEHIC_Id
	,(Case Left(Tip.TIPOS_Codigo, 3) 
		When 'IAC' Then 'TCA001'
		When 'IHR' Then 'TCA003'
		When 'IAB' Then 'TCA002'
		When 'IOT' Then 'TCA004'
		Else 'TCA004'
	 End
	) As TIPOS_CodCategoria
	,TAC.TIPOS_Descripcion As TIPOS_Categoria
	,@VEHIN_Id As VEHIN_Id
	--,InvD.VEHID_Observacion
From Tipos As Tip
	Left Join Transportes.TRAN_VehiculosInventarioDetalle As InvD On InvD.TIPOS_CodObjeto = Tip.TIPOS_Codigo
		And InvD.VEHIC_Id = @VEHIC_Id
		And InvD.VEHIN_Id = @VEHIN_Id
	Left Join Tipos As TAC On TAC.TIPOS_Codigo =
		(Case Left(Tip.TIPOS_Codigo, 3) 
			When 'IAC' Then 'TCA001'
			When 'IHR' Then 'TCA003'
			When 'IAB' Then 'TCA002'
			When 'IOT' Then 'TCA004'
			Else 'TCA004'
		 End)
where Left(Tip.TIPOS_Codigo, 3) In  ('IAC', 'IHR', 'IAB', 'IOT')
Order By Tip.TIPOS_Codigo, TIPOS_Categoria
	

GO 
/***************************************************************************************************************************************/ 

