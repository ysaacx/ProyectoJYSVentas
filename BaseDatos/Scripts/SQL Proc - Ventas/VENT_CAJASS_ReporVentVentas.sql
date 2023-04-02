GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_ReporVentVentas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_ReporVentVentas] 
GO 

CREATE PROCEDURE [dbo].[VENT_CAJASS_ReporVentVentas]  
( 
   @FecIni DateTime 
  ,@FecFin DateTime  
  ,@Usuario VarChar(20)  
  ,@Serie varchar(3)
)  
As  

--DECLARE @FecIni DateTime  
--declare @FecFin DateTime  
--declare @Usuario VarChar(20) 
--declare @Serie as varchar(3)

--set @FecIni = '01/11/2013'
--set @FecFin = dateadd(day,1,'01/11/2013')
--set @Usuario = 'ADMIN'
--set @Serie = '010' --016

set @FecFin = dateadd(day,1,@FecFin)
-- Reporte de Ventas
--****************************************************************************************************************
-- VENTAS
------------------------------------------------------------------------------------------------------------------
select  @Usuario as Usuario
,V.ENTID_CodigoCliente,V.DOCVE_FechaDocumento,V.DOCVE_Serie,V.DOCVE_Numero,V.TIPOS_CodTipoDocumento
,V.TIPOS_CodTipoMoneda
,case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end as 'TIPCAM'
,case V.TIPOS_CodTipoMoneda when 'MND1' then  0 else V.DOCVE_TotalPagar end as 'MONDOL'
,round((V.DOCVE_TotalPagar)*(case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end),2) as 'MONSOL'
,V.ENTID_CodigoVendedor
,V.DOCVE_Estado
,V.DOCVE_FechaTransaccion 
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin and
V.TIPOS_CodTipoDocumento <>'07' 
and V.DOCVE_Serie=@Serie --016 , 017

union all

-- NOTAS CREDITO
------------------------------------------------------------------------------------------------------------------
select  @Usuario as Usuario
,V.ENTID_CodigoCliente,V.DOCVE_FechaDocumento,V.DOCVE_Serie,V.DOCVE_Numero,V.TIPOS_CodTipoDocumento
,V.TIPOS_CodTipoMoneda
,case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end as 'TIPCAM'
,case V.TIPOS_CodTipoMoneda when 'MND1' then  0 else V.DOCVE_TotalPagar end as 'MONDOL'
,round((V.DOCVE_TotalPagar)*(case V.TIPOS_CodTipoMoneda when 'MND1' then  1 else V.DOCVE_TipoCambioSunat end),2) as 'MONSOL'
,V.ENTID_CodigoVendedor
,V.DOCVE_Estado
,V.DOCVE_FechaTransaccion 
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin and
V.TIPOS_CodTipoDocumento = '07' 
and V.DOCVE_Serie= @Serie --016 , 017
and LEFT(right(V.docve_referencia,10),3) = @Serie -- 016 , 017

--****************************************************************************************************************

GO 
/***************************************************************************************************************************************/ 

