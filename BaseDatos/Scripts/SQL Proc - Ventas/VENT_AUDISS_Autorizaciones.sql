GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_AUDISS_Autorizaciones]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_AUDISS_Autorizaciones] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 16/06/2012
-- Descripcion         : Ver las Autorizaciones
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_AUDISS_Autorizaciones]
(
	 @AUDIT_CodigoReferencia VarChar(12)
)
As

Select Oto.ENTID_RazonSocial As ENTID_Otorgado
	, Conf.ENTID_RazonSocial As ENTID_Confirmado
	, TProc.TIPOS_Descripcion As TIPOS_Proceso
	, Suc.SUCUR_Nombre As Sucursal
	, TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + Rtrim(Ven.DOCVE_Numero), 7) As Documento
	,m_auditoria.* 
From dbo.Auditoria As m_auditoria 
	Inner Join dbo.Entidades As Oto On Oto.ENTID_Codigo = m_auditoria.ENTID_CodigoOtorgado
	Left Join dbo.Entidades As Conf On Conf.ENTID_Codigo = m_auditoria.ENTID_CodigoConfirmado
	Inner Join dbo.Tipos As TProc On TProc.TIPOS_Codigo = m_auditoria.TIPOS_CodTipoProceso
	Inner Join dbo.Sucursales As Suc On Suc.SUCUR_Id = m_auditoria.SUCUR_Id 
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = m_auditoria.AUDIT_DocAutorizado
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
WHERE   m_Auditoria.AUDIT_CodigoReferencia = @AUDIT_CodigoReferencia 
	AND  ISNULL(m_Auditoria.AUDIT_Estado, '') <> 'X'


GO 
/***************************************************************************************************************************************/ 

