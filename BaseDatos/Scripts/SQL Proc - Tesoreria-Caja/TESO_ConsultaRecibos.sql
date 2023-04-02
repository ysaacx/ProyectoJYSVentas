USE BDInkasFerro
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TESO_ConsultaRecibos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TESO_ConsultaRecibos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 14/01/2012
-- Descripcion         : Buscar Los registros de caja Chica
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TESO_ConsultaRecibos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Cadena VarChar(50)
	,@PVENT_Id Id
	,@Todos Bit
)
As


Select 
	Re.RECIB_Codigo
	,Re.ENTID_Codigo
	,Re.RECIB_Fecha
	,IsNull(Re.ENTID_Codigo + ' - ' + Ent.ENTID_RazonSocial, Re.RECIB_RecibiDe) As RECIB_RecibiDe
	--,Re.ENTID_Codigo
	,Re.TIPOS_CodTipoMoneda
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Re.TIPOS_CodTipoRecibo
	,Re.PVENT_Id
	,TRe.TIPOS_DescCorta + ' ' + Re.RECIB_Serie + '-' + Right('0000000' + RTrim(RECIB_Numero), 7) As Documento
	,Re.RECIB_Importe
	,Re.RECIB_Estado
	,Re.RECIB_Concepto
	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCUS_Serie  + '-' + Right('0000000' + Doc.DOCUS_Numero, 7) As DocumentoDoc
	,Doc.ENTID_Codigo As ENTID_CodigoProveedor
	,EntDoc.ENTID_RazonSocial As ENTID_RazonSocialProveedor
Into #Recibos
From Tesoreria.TESO_Recibos As Re
	Inner Join Tipos As TRe On TRe.TIPOS_Codigo = Re.TIPOS_CodTipoRecibo
	Left Join Entidades As Ent On Ent.ENTID_Codigo = Re.ENTID_Codigo
	Inner Join Tipos As TMon On TMon.TIPOS_Codigo = Re.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Re.DOCUS_Codigo And Doc.ENTID_Codigo = Re.ENTID_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo
Where Re.PVENT_Id = @PVENT_Id
	And Convert(Date, RECIB_Fecha) Between @FecIni And @FecFin
	And IsNull(Re.RECIB_RecibiDe, Ent.ENTID_RazonSocial) Like '%' + @Cadena + '%'

If @Todos = 1
	Select * From #Recibos 
Else
	Select * From #Recibos Where RECIB_Estado <> 'X'


GO 
/***************************************************************************************************************************************/ 

