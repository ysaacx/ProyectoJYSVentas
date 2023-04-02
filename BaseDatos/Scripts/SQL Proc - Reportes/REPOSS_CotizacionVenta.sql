USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_CotizacionVenta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_CotizacionVenta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/07/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_CotizacionVenta]
(
	@PEDID_Codigo VarChar(12)
)
As


Select Left(Ped.PEDID_Codigo, 2) + ' ' + Right(Left(Ped.PEDID_Codigo, 5), 3) + '-' + Right(Ped.PEDID_Codigo, 7) As PEDID_Codigo
	,Ped.PEDID_FechaDocumento
	,IsNull(Ped.PEDID_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_Cliente
	,IsNull(Ped.PEDID_DireccionCliente, Ent.ENTID_Direccion) As PEDID_DireccionCliente
	,IsNull(Ped.PEDID_NroTelefono, Ent.ENTID_Telefono1) As PEDID_NroTelefono
	,IsNull(Ped.PEDID_EMail, Ent.ENTID_EMail) As PEDID_EMail
	,Us.ENTID_RazonSocial As Cotizador
	,TPag.TIPOS_Descripcion As TIPOS_CondicionPago
	,TMon.TIPOS_DescCorta As TIPOS_CodTipoMoneda
	,TMon.TIPOS_Descripcion As TIPOS_TipoMoneda
	,IsNull(Ped.PEDID_Condiciones, '-') As PEDID_Condiciones
	,IsNull(Ped.PEDID_CondicionEntrega, '-') As PEDID_CondicionEntrega
	,IsNull(Ped.PEDID_Nota, '-') As PEDID_Nota
	,PEDID_ImporteVenta
	,PEDID_TotalVenta
	,PEDID_TotalPagar
	,PEDID_PorcentajePercepcion
	,PEDID_Observaciones
	,PEDID_Dirigida
	,(Select SUM(ARTIC_Peso * PDDET_Cantidad) 
		From Ventas.VENT_PedidosDetalle As DPed 
			Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = DPed.ARTIC_Codigo
		Where PEDID_Codigo = @PEDID_Codigo) PEDID_TotalPeso
	,Us.ENTID_RazonSocial As ENTID_Vendedor
	,Ped.PVENT_IdOrigenPReposicion
	,Ped.PVENT_IdDestinoPReposicion
	,PVtaOri.PVENT_Descripcion As PVtaOrigen
From Ventas.VENT_Pedidos As Ped 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ped.ENTID_CodigoCliente
	Left Join dbo.Entidades As Us On Us.ENTID_Codigo = Ped.PEDID_UsrCrea 
	Inner join Tipos As TPag On TPag.TIPOS_Codigo = TIPOS_CodCondicionPago
	Inner join Tipos As TMon On TMon.TIPOS_Codigo = TIPOS_CodTipoMoneda
	Left Join Entidades As Ven On Ven.ENTID_Codigo = Ped.ENTID_CodigoVendedor
	Left Join PuntoVenta As PVtaOri ON PVtaOri.PVENT_Id = Ped.PVENT_IdOrigenPReposicion
WHERE   Ped.PEDID_Codigo = @PEDID_Codigo

Select Art.ARTIC_Descripcion As ARTIC_Descripcion
	,Art.ARTIC_Codigo As ARTIC_Codigo
	,Art.ARTIC_Peso As ARTIC_Peso
	,Art.ARTIC_Percepcion As ARTIC_Percepcion
	,Art.ARTIC_Peso As PDDET_PesoUnitario
	,Art.TIPOS_CodUnidadMedida As TIPOS_CodUnidadMedida
	,Uni.TIPOS_Descripcion As TIPOS_Descripcion
	,Uni.TIPOS_DescCorta As TIPOS_UnidadMedida
	,Alm.ALMAC_Descripcion As ALMAC_Descripcion
	,DPed.PDDET_Item
	,DPed.PDDET_Cantidad
	,DPed.PDDET_PrecioUnitario
	,DPed.PDDET_SubImporteVenta
	,DPed.PDDET_PRFaltante
	,DPed.PDDET_StockPrincipal
From Ventas.VENT_PedidosDetalle As DPed 
	Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = DPed.ARTIC_Codigo
	Inner Join dbo.Tipos As Uni On Uni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	Inner Join dbo.Almacenes As Alm On Alm.ALMAC_Id = DPed.ALMAC_Id 
WHERE DPed.PEDID_Codigo = @PEDID_Codigo


GO 
/***************************************************************************************************************************************/ 

exec REPOSS_CotizacionVenta @PEDID_Codigo=N'CT0010000032'