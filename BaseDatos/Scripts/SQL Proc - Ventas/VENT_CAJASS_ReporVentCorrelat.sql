GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CAJASS_ReporVentCorrelat]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CAJASS_ReporVentCorrelat] 
GO 

CREATE PROCEDURE [dbo].[VENT_CAJASS_ReporVentCorrelat]  
( 
   @FecIni DateTime 
  ,@FecFin DateTime  
  ,@Serie VarChar(3)
)  
As  

--DECLARE @FecIni DateTime  
--declare @FecFin DateTime  
--declare @Serie VarChar(20) 

--set @FecIni = '01/01/2012'
--set @FecFin = '01/11/2013'
--set @Serie = '010'

set @FecFin = dateadd(day,1,@FecFin)

-- Reporte de Ventas Correlatividad
--****************************************************************************************************************

select V.TIPOS_CodTipoDocumento,V.DOCVE_Serie,V.DOCVE_Numero
from ventas.VENT_DocsVenta as V   
where V.DOCVE_FechaDocumento between @FecIni and @FecFin
and V.DOCVE_Serie = @Serie
order by V.TIPOS_CodTipoDocumento,V.DOCVE_Serie,V.DOCVE_Numero


--****************************************************************************************************************

GO 
/***************************************************************************************************************************************/ 

