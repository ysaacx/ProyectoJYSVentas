--USE BDSisSCC
USE BDSisSCC

GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DOCCSS_UltimasCompras]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[DOCCSS_UltimasCompras] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtener las ultimas compras
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[DOCCSS_UltimasCompras]
(
	 @ARTIC_Codigo VarChar(12)
	,@Compras Int
)
As

Declare @IGV Decimal(5, 2)
Set @IGV = (Select PARMT_Valor from Parametros Where PARMT_Id = 'PIGV')

Select top (@Compras) Doc.DOCCO_Codigo
	,Doc.DOCCO_FechaDocumento
	,Doc.ENTID_CodigoProveedor
	,Ent.ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Doc.DOCCO_Serie + '-' + Right('0000000' + RTrim(Doc.DOCCO_Numero), 7) As Documento
	,TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
	,Art.ARTIC_Codigo
	,Art.ARTIC_Descripcion
	,Det.DOCCD_Cantidad
	,Det.DOCCD_PrecioUnitario * (1 + @IGV/100) As DOCCD_PrecioUnitario
	--,Det.DOCCD_SubPeso
	,Art.ARTIC_Peso
   , Doc.TIPOS_CodTipoMoneda
From Logistica.ABAS_DocsCompra As Doc
	Inner Join Logistica.ABAS_DocsCompraDetalle As Det On Det.DOCCO_Codigo = Doc.DOCCO_Codigo
		And Det.ENTID_CodigoProveedor = Doc.ENTID_CodigoProveedor
	Inner join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Inner join Tipos As TMon On TMon.TIPOS_Codigo = Doc.TIPOS_CodTipoMoneda
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Doc.ENTID_CodigoProveedor
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo
Where Det.ARTIC_Codigo = @ARTIC_Codigo
Order By Doc.DOCCO_FechaDocumento Desc

GO

exec DOCCSS_UltimasCompras @ARTIC_Codigo=N'0201032',@Compras=5

--Exec DOCCSS_UltimasCompras '0801012', 5

--exec DOCCSS_UltimasCompras @ARTIC_Codigo=N'0801012',@Compras=5

