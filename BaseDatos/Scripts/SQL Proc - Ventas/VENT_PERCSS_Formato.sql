GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PERCSS_Formato]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PERCSS_Formato] 
GO 

CREATE procedure [dbo].[VENT_PERCSS_Formato]
(
	 @dIni DateTime
	,@dFin DateTime
	,@cSerie varchar(4)
	,@cNumero numeric(18,0)
	,@cTipo varchar(6)
	,@iTodos smallint
)
--	,@PVENT_Id BigInt
As
Select 
case when len(Cli.ENTID_Codigo )=11 then '6' when len(Cli.ENTID_Codigo )=8 then '1'  else '' end as TipDocCli,
Cli.ENTID_Codigo ,
case when len(Cli.ENTID_Codigo )=11 then Cli.ENTID_RazonSocial 
when len(Cli.ENTID_Codigo )=8 then '' else '' end As ENTID_Cliente,
case when len(Cli.ENTID_Codigo )=8 then
 case when len(Cli.ENTID_PtrApeMaterno) = 1 then '' else  Cli.ENTID_PtrApeMaterno  end 
 else '' end As ApePaterno,
case when len(Cli.ENTID_Codigo )=8 then 
 case when Cli.ENTID_PtrApeMaterno = 0 then '' else  Cli.ENTID_PtrApeMaterno  end 
 else '' end as ApeMaterno,
case when len(Cli.ENTID_Codigo )=8 then Cli.ENTID_PtrNombre1 else '' end as Nombres,
m_cont_docspercepcion.DOCPE_Serie , 
m_cont_docspercepcion.DOCPE_Numero ,
m_cont_docspercepcion.DOCPE_FecEmision,
--detalle si es factura, nota credito, nota debito es 1 y no si es boleta
IsNull(Sun.TIPOS_CreFis,'0')  as DocInv,
'0' as Materiales,
 case when LEN(m_entidadespadrones.ENTID_Codigo)>0 then 1 else IsNull(m_entidadespadrones.ENTID_Codigo,0) end as CliPercepcion ,
(select sum(m_cont_docspercepciondetalleT.DOCPD_MontoTotal) from Contabilidad.CONT_DocsPercepcionDetalle as m_cont_docspercepciondetalleT 
  where m_cont_docspercepciondetalleT.DOCPE_Codigo = m_cont_docspercepcion.DOCPE_Codigo ) as MontoTotal
,
substring(m_cont_docspercepciondetalle.TIPOS_CodTipoDocumento,4,2) as CodTipoDocumento, -- tabla 10
m_cont_docspercepciondetalle.DOCPD_SerieDoc,
m_cont_docspercepciondetalle.DOCPD_NumeroDoc,
m_cont_docspercepciondetalle.DOCPD_FecEmision,
m_cont_docspercepciondetalle.DOCPD_PrecVenta 

From Contabilidad.CONT_DocsPercepcion As m_cont_docspercepcion  
inner join Contabilidad.CONT_DocsPercepcionDetalle as m_cont_docspercepciondetalle 
     left join dbo.TipoSunat as Sun On m_cont_docspercepciondetalle.TIPOS_CodTipoDocumento = Sun.Tipos_Codigo
     Inner Join dbo.Tipos As TDocDetalle On TDocDetalle.TIPOS_Codigo = m_cont_docspercepciondetalle.TIPOS_CodTipoDocumento
on  m_CONT_DocsPercepcionDetalle.DOCPE_Codigo = m_cont_docspercepcion.DOCPE_Codigo 

Inner Join dbo.Entidades As Cli
Left Join dbo.EntidadesPadrones As m_entidadespadrones on (m_EntidadesPadrones.ENTID_Codigo = Cli.ENTID_Codigo AND m_entidadespadrones.TIPOS_CodTipoPadron = 'PDR03')

 On Cli.ENTID_Codigo = m_cont_docspercepcion.ENTID_Codigo 
Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = m_cont_docspercepcion.TIPOS_CodTipoDocumento 
Inner Join dbo.Tipos As TMon On TMon.TIPOS_Codigo = m_cont_docspercepcion.TIPOS_CodTipoMoneda 
WHERE   ISNULL(m_CONT_DocsPercepcion.DOCPE_Estado, '') <> 'X' 
AND  ( ISNULL(m_CONT_DocsPercepcion.DOCPE_FecEmision, '') Between @dIni And @dFin or @iTodos =1 )
and (m_cont_docspercepcion.DOCPE_Serie = @cSerie or @cSerie='' )
and (m_cont_docspercepcion.DOCPE_Numero = @cNumero or @cNumero=0 )
and (m_cont_docspercepcion.TIPOS_CodTipoDocumento =@cTipo or @cTipo= '')

	

GO 
/***************************************************************************************************************************************/ 

