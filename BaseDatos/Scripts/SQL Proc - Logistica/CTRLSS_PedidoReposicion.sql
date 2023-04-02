GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CTRLSS_PedidoReposicion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[CTRLSS_PedidoReposicion] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 04/02/2014
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[CTRLSS_PedidoReposicion]
(
	 @FecFin DateTime
	,@ALMAC_Id SmallInt
	,@Linea VarChar(10) = Null
)
As


Select Det.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,Det.PDDET_Cantidad As Saldo
	,Ped.PEDID_Estado
Into #Pedidos
From Ventas.VENT_Pedidos As Ped 
	Inner Join Ventas.VENT_PedidosDetalle As Det On Det.PEDID_Codigo = Ped.PEDID_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like @Linea + '%'
	Inner Join PuntoVenta As PV On PV.ALMAC_Id = @ALMAC_Id
WHERE Ped.PVENT_Id = PV.PVENT_Id
	AND  Convert(Date, Ped.PEDID_FechaDocumento) <= @FecFin 
	AND Ped.PEDID_Tipo = 'R'
	ANd Ped.PVENT_IdOrigenPReposicion <> PV.PVENT_Id 

Insert Into #Pedidos
Select Det.ARTIC_Codigo
	,Art.ARTIC_Detalle
	,Det.PDDET_Cantidad
	,Ped.PEDID_Estado
From Ventas.VENT_Pedidos As Ped
	Inner Join Ventas.VENT_PedidosDetalle As Det On Det.PEDID_Codigo = Ped.PEDID_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like @Linea + '%'
Where Not Ped.PEDID_Estado In  ('C', 'X')
	And Ped.PEDID_FechaDocumento <= @FecFin
	And Ped.PEDID_Tipo = 'I'

Select ARTIC_Codigo, ARTIC_Detalle , SUM(Saldo) As Saldo, COUNT(*) 
From #Pedidos 
Where Not PEDID_Estado In  ('X', 'C') 
Group by ARTIC_Codigo, ARTIC_Detalle
Order By ARTIC_Codigo Desc


GO 
/***************************************************************************************************************************************/ 

