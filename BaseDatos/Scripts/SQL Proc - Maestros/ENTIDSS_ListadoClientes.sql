GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTIDSS_ListadoClientes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTIDSS_ListadoClientes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : Obtener los clientes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTIDSS_ListadoClientes]
(
     @ENTID_RazonSocial VarChar(200)
    ,@ROLES_Id SmallInt
)
As


    Select 
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
        --INNER JOIN dbo.EntidadRelacion EREL ON EREL.ENTID_Codigo = Ent.ENTID_Codigo
        INNER JOIN dbo.EntidadesRoles EROL ON EROL.ENTID_Codigo = Ent.ENTID_Codigo
    WHERE  
      EROL.ROLES_Id = @ROLES_Id
    AND Ent.ENTID_RazonSocial LIKE ISNULL(@ENTID_RazonSocial, '') +  '%'
    Order By Ent.ENTID_RazonSocial




GO 
/***************************************************************************************************************************************/ 

