GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ABAS_GENREPSS_ComprasProveedoresFecha]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ABAS_GENREPSS_ComprasProveedoresFecha] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 07/01/2011
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ABAS_GENREPSS_ComprasProveedoresFecha]
(
	 @ENTID_CodigoProveedor As VarChar(14)
	,@AnhoIni As Integer
	,@MesIni As Integer
	,@AnhoFin As Integer
	,@MesFin As Integer
)

AS

--Declare @AnhoIni As Integer	Set @AnhoIni = 2010
--Declare @MesIni As Integer	Set @MesIni = 6
--Declare @AnhoFin As Integer	Set @AnhoFin = 2012
--Declare @MesFin As Integer	Set @MesFin = 6
Declare @FecIni As DateTime Set @FecIni = RTrim(@AnhoIni) + '-01-' + RTrim(@MesIni) 
Declare @FecFin As DateTime Set @FecFin = RTrim(@AnhoFin) + '-01-' + RTrim(@MesFin) 

Create Table #Fechas(Anho Integer, Mes Integer)

While (@AnhoIni < @AnhoFin)
Begin
	If @MesIni = 13
	Begin
		Set @MesIni = 1
	End
	While (@MesIni < 13)
	Begin
		Insert Into #Fechas(Anho, Mes) Values (@AnhoIni, @MesIni)
		Set @MesIni = @MesIni + 1
	End
	Set @AnhoIni = @AnhoIni + 1
End

Declare @i as Integer
Set @i = 1
While (@i <= @MesFin)
Begin
	Insert Into #Fechas(Anho, Mes) Values (@AnhoIni, @i)
	Set @i = @i + 1
End
-- Cargar Articulos
Select Det.ARTIC_Codigo, Art.ARTIC_Descripcion Into #Artic From [Logistica].[ABAS_DocsCompra] As Cab
	Inner Join [Logistica].[ABAS_DocsCompraDetalle] As Det
		On Det.DOCCO_Codigo = Cab.DOCCO_Codigo And Det.ENTID_CodigoProveedor = Cab.ENTID_CodigoProveedor
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
Where Not Cab.DOCCO_Estado = 'X'
	And Cab.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
Group By Det.ARTIC_Codigo, Art.ARTIC_Descripcion

Select * From #Fechas
Select * From #Artic
-- Cargar Articulos
Select Det.ARTIC_Codigo, Art.ARTIC_Descripcion
	,Cab.DOCCO_FechaDocumento, Cab.ENTID_CodigoProveedor, Det.DOCCD_Cantidad From [Logistica].[ABAS_DocsCompra] As Cab
	Inner Join [Logistica].[ABAS_DocsCompraDetalle] As Det
		On Det.DOCCO_Codigo = Cab.DOCCO_Codigo And Det.ENTID_CodigoProveedor = Cab.ENTID_CodigoProveedor
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
Where Not Cab.DOCCO_Estado = 'X'
	And Cab.ENTID_CodigoProveedor = @ENTID_CodigoProveedor
	And Cab.DOCCO_FechaDocumento Between @FecIni And DateAdd(Month, 1, @FecFin)



GO 
/***************************************************************************************************************************************/ 

