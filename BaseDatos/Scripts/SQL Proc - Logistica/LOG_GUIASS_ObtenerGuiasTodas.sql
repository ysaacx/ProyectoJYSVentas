GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_GUIASS_ObtenerGuiasTodas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_GUIASS_ObtenerGuiasTodas] 
GO 
CREATE PROCEDURE [dbo].[LOG_GUIASS_ObtenerGuiasTodas]
(
	 @FecIni Datetime
	 ,@FecFin Datetime
)
As

--declare @FecIni as datetime
--declare @FecFin as datetime
--set @FecIni = '01-01-2013'
--set @FecFin = '11-30-2013'


select gr.GUIAR_Codigo 'Codigo', gr.GUIAR_Serie 'Serie', gr.GUIAR_Numero 'Numero', t.TIPOS_Descripcion 'Motivo', gr.GUIAR_FechaEmision 'Fecha_Emision',
gr.ENTID_CodigoCliente 'RUC', gr.GUIAR_Descripcioncliente 'Descipcion_Cliente', gr.ENTID_CodigoTransportista 'Cod_Transportista', gr.GUIAR_DescripcionTransportista 'Descripción_Transportista',
gr.GUIAR_Estado 'Estado'
--,gr.*
from Logistica.DIST_GuiasRemision as gr
inner join Logistica.DIST_GuiasRemisionDetalle as grd on gr.GUIAR_Codigo = grd.GUIAR_Codigo
inner join Tipos as t on gr.TIPOS_CodMotivoTraslado = t.TIPOS_Codigo
where gr.GUIAR_FechaEmision between @FecIni and @FecFin
order by gr.GUIAR_Codigo

GO 
/***************************************************************************************************************************************/ 

