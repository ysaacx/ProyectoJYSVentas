GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_VEHICSS_Ayuda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_VEHICSS_Ayuda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_VEHICSS_Ayuda]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
)
As

Select 
	Veh.VEHIC_Id As Codigo
	,VEHIC_Placa As Placa
	,TVeh.TIPOS_Descripcion  As [Tipo Vehiculo]
	,TMar.TIPOS_Descripcion As [Marca]
	,TCom.TIPOS_Descripcion As [Combustible]
	,Veh.VEHIC_NumeroEjes As [Nro. Ejes]
	,Veh.VEHIC_NroNeumaticos As [Nro. Neumaticos]
	,Veh.VEHIC_KmInicial As [Km. Inicial]
	,Veh.VEHIC_GeneraViajes AS [Permite Viajes]
	,Veh.VEHIC_Certificado As Certificado
	,Ran.RANFL_Placa As [Placa Ranfla]
	,TMarR.TIPOS_Descripcion As [Marca Ranfla]
	,Ran.RANFL_Certificado As [Certificado Ranfla]
From Transportes.TRAN_Vehiculos As Veh
	Inner Join Tipos As TVeh On TVeh.TIPOS_Codigo = Veh.TIPOS_CodTipoVehiculo
	Inner Join Tipos As TMar On TMar.TIPOS_Codigo = Veh.TIPOS_CodMarca
	Inner Join Tipos As TCom On TCom.TIPOS_Codigo = Veh.TIPOS_CodTipoCombustible
	Left Join [Transportes].[TRAN_VehiculosRanflas] As VRa On VRa.VEHIC_Id = Veh.VEHIC_Id And VRa.VEHRN_Estado = 'A'
	Left Join [Transportes].[TRAN_Ranflas] As Ran On Ran.RANFL_Id = Vra.RANFL_Id	 
	Left Join Tipos As TMarR On TMarR.TIPOS_Codigo = Ran.TIPOS_CodMarca 
Where
	(Case @Opcion When 0 Then RTrim(Veh.VEHIC_Id)
				  When 1 Then VEHIC_Placa 
				  Else VEHIC_Placa
	 End) Like '%' + @Cadena + '%'



GO 
/***************************************************************************************************************************************/ 

