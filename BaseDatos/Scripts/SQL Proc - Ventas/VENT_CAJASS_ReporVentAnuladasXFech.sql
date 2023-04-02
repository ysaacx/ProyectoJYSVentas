GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_ReporVentAnuladasXFech]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_ReporVentAnuladasXFech] 
GO 

CREATE PROCEDURE [dbo].[VENT_CAJASS_ReporVentAnuladasXFech]  
( 
   @FecIni DateTime 
  ,@FecFin DateTime  
  ,@Usuario VarChar(20)    
)  
As  

--DECLARE @FecIni DateTime  
--declare @FecFin DateTime  
--declare @Usuario VarChar(20) 

--set @FecIni = '01/01/2012'
--set @FecFin = '01/11/2013'
--set @Usuario = 'ADMIN'

set @FecFin = dateadd(day,1,@FecFin)

-- Reporte de Ventas Anuladas X Fecha
--****************************************************************************************************************

select  @Usuario as Usuario
,V.ENTID_CodigoCliente,V.DOCVE_FechaDocumento,V.DOCVE_FechaDocumento as 'FechaPago',V.DOCVE_Serie,V.DOCVE_Numero
,V.TIPOS_CodTipoDocumento,V.TIPOS_CodTipoMoneda
,case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end as 'TIPCAM'
,case V.TIPOS_CodTipoMoneda when 'MND1' then  0 else V.DOCVE_TotalPagar end as 'MONDOL'
,round((V.DOCVE_TotalPagar)*(case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end),2) as 'MONSOL'
,V.ENTID_CodigoVendedor
,'A' as 'libro'
--,V.DOCVE_Estado
--,V.DOCVE_AnuladoCaja
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin
and V.DOCVE_Estado = 'X' and V.DOCVE_AnuladoCaja = 0

union all

select  @Usuario as Usuario
,V.ENTID_CodigoCliente,V.DOCVE_FechaDocumento,V.DOCVE_FecAnulacion as 'FechaPago',V.DOCVE_Serie,V.DOCVE_Numero
,V.TIPOS_CodTipoDocumento,V.TIPOS_CodTipoMoneda
,case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end as 'TIPCAM'
,case V.TIPOS_CodTipoMoneda when 'MND1' then  0 else V.DOCVE_TotalPagar end as 'MONDOL'
,round((V.DOCVE_TotalPagar)*(case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end),2) as 'MONSOL'
,V.ENTID_CodigoVendedor
,'B' as 'libro'
--,V.DOCVE_Estado
--,V.DOCVE_AnuladoCaja
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin and V.DOCVE_AnuladoCaja = 1

--****************************************************************************************************************

GO 
/***************************************************************************************************************************************/ 

