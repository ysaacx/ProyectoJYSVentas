USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_DPAGSS_ObtenerDocPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_DPAGSS_ObtenerDocPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 01/04/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_DPAGSS_ObtenerDocPagos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Opcion SmallInt
	,@Cadena VarChar(50)
	,@OptFecha SmallInt = Null
)
As

Select Distinct Doc.DPAGO_Id
	,Doc.DPAGO_Numero
	,Doc.DPAGO_Importe
	,Doc.DPAGO_Fecha
	,Ban.BANCO_DescCorta
	,Ban.BANCO_Descripcion
	,Ent.ENTID_RazonSocial
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,TDoc.TIPOS_Descripcion As TIPOS_TipoDocumento
	,Doc.DPAGO_Estado
	,Doc.TIPOS_CodTipoMoneda
	--,Doc.* 
From Tesoreria.TESO_DocsPagos As Doc
	Left Join Bancos As Ban On Doc.BANCO_Id = Ban.BANCO_Id
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.DPAGO_Id = Doc.DPAGO_Id
	Left Join Tesoreria.TESO_Caja As Caj On Caj.CAJA_Codigo = CDoc.CAJA_Codigo
Where (Case IsNull(@OptFecha, 0)
		When 0 Then Convert(Date, Doc.DPAGO_Fecha) 
		When 1 Then Convert(Date, Caj.CAJA_Fecha) 
		Else Convert(Date, Doc.DPAGO_Fecha) 
	   End) Between @FecIni And @FecFin
	And (Case @Opcion 
			When 0 Then Ent.ENTID_RazonSocial
			When 1 Then DPAGO_Numero
			When 2 Then DPAGO_Glosa
			When 3 Then Ban.BANCO_Descripcion
			Else Ent.ENTID_RazonSocial
		 End) Like '%' + @Cadena + '%'
	And Doc.DPAGO_Estado <> 'X'
Order By DPAGO_Fecha

GO 
/***************************************************************************************************************************************/ 

