GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DISTSS_ReporVentXCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DISTSS_ReporVentXCliente] 
GO 

CREATE PROCEDURE [dbo].[LOG_DISTSS_ReporVentXCliente]  
( 
   @FecIni DateTime 
  ,@FecFin DateTime  
  ,@Usuario VarChar(20)  
  ,@Cliente varchar(11)
)  
As

--DECLARE @FecIni DateTime  
--declare @FecFin DateTime  
--declare @Usuario VarChar(20) 
--declare @Cliente as varchar(11)

--set @FecIni = '01/01/2013'
----set @FecFin = dateadd(day,1,'11/01/2013')
--set @FecFin = '06/04/2013'
--set @Usuario = 'ADMIN'
--set @Cliente = '20100240301'


select  @Usuario as Usuario
,V.ENTID_CodigoCliente,V.DOCVE_FechaDocumento,V.DOCVE_Serie,V.DOCVE_Numero,V.TIPOS_CodTipoDocumento
,V.TIPOS_CodTipoMoneda
,case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end as 'TIPCAM'
,case V.TIPOS_CodTipoMoneda when 'MND1' then  0 else V.DOCVE_TotalPagar end as 'MONDOL'
,round((V.DOCVE_TotalPagar)*(case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end),2) as 'MONSOL'
,V.ENTID_CodigoVendedor
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin
and V.ENTID_CodigoCliente = @Cliente


GO 
/***************************************************************************************************************************************/ 

