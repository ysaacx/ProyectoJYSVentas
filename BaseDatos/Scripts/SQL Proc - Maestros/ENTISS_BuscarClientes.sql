USE BDImportacionesZegarra
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTISS_BuscarClientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTISS_BuscarClientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : Obtener los clientes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTISS_BuscarClientes]
(
	 @Cadena VarChar(200)
	 ,@Opcion SmallInt
)
As

If @Opcion < 2
Begin 
	Select Top 1000
		TDoc.TIPOS_DescCorta As TIPOS_DocumentoCorto
		,TDoc.TIPOS_Descripcion As TIPOS_Documento
		,(Select Count(*) 
		  From Ventas.VENT_DocsVenta As V 
		  Where V.ENTID_CodigoCliente = Ent.ENTID_Codigo) 
		 As NroDocumentos
		,IsNull(Ent.ENTID_RazonSocial, IsNull(Ent.ENTID_Nombres, Ent.ENTID_NombreComercial)) As ENTID_RazonSocial
		,Ent.* 
	From dbo.Entidades As Ent 
		--Left Join Ventas.VENT_DocsVenta As Vent On Vent.ENTID_CodigoCliente = Ent.ENTID_Codigo
		Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ent.TIPOS_CodTipoDocumento 
	WHERE  ISNULL(Ent.ENTID_RazonSocial, '') Like '%' + @Cadena + '%'
		Or ISNULL(Ent.ENTID_NombreComercial, '') Like '%' + @Cadena + '%'
		Or ISNULL(Ent.ENTID_Nombres, '') Like '%' + @Cadena + '%'
	Order By Ent.ENTID_RazonSocial
End
Else
Begin 
	Select Top 1000
		TDoc.TIPOS_DescCorta As TIPOS_DocumentoCorto
		,TDoc.TIPOS_Descripcion As TIPOS_Documento
		,(Select Count(*) 
		  From Ventas.VENT_DocsVenta As V 
		  Where V.ENTID_CodigoCliente = Ent.ENTID_Codigo) 
		 As NroDocumentos
		,IsNull(Ent.ENTID_RazonSocial, IsNull(Ent.ENTID_Nombres, Ent.ENTID_NombreComercial)) As ENTID_RazonSocial
		,Ent.* 
	From dbo.Entidades As Ent 
		--Left Join Ventas.VENT_DocsVenta As Vent On Vent.ENTID_CodigoCliente = Ent.ENTID_Codigo
		Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = Ent.TIPOS_CodTipoDocumento 
	WHERE  
	(Case @Opcion When 2 Then LTrim(Rtrim(Ent.ENTID_Codigo))
		Else ISNULL(Ent.ENTID_RazonSocial, '')
	End)  Like '%' + @Cadena + '%'
	Order By Ent.ENTID_RazonSocial
End


GO 
/***************************************************************************************************************************************/ 

