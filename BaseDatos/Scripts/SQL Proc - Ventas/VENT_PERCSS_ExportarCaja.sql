GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_PERCSS_ExportarCaja]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_PERCSS_ExportarCaja] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 20/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_PERCSS_ExportarCaja]
(
	 @ZONAS_Codigo VarChar(5)
	,@SUCUR_Id Integer
	,@PVENT_Id BigInt
	,@Fecha DateTime
	,@Usuario VarChar(35)
	,@DOCPE_Codigo VarChar(12)
)
As

Declare @TCOficina Decimal(10, 4)
Select @TCOficina = TIPOC_VentaOficina From TipoCambio where TIPOC_Fecha = (Select Max(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0)
Declare @TCSunat Decimal(10, 4)
Set @TCSunat = (Select Top 1 TIPOC_VentaSunat From TipoCambio where Convert(Varchar(10), TIPOC_FechaC, 112) = Convert(Varchar(10), @Fecha, 112))

Declare @Vendedor VarChar(12)
Set @Vendedor = (Select Top 1 PARMT_Valor From Parametros Where PARMT_Id = 'pg_VendedorDefa' And APLIC_Codigo = 'VTA' And SUCUR_Id = 1)

INSERT INTO 
  Ventas.VENT_DocsVenta
(
  DOCVE_Codigo,
  ZONAS_Codigo,
  SUCUR_Id,
  PEDID_Codigo,
  PVENT_Id,
  ENTID_CodigoCliente,
  ENTID_CodigoVendedor,
  TIPOS_CodTipoMoneda,
  TIPOS_CodTipoDocumento,
  TIPOS_CodCondicionPago,
  TIPOS_CodTipoMotivo,
  DOCVE_Id,
  DOCVE_Serie,
  DOCVE_Numero,
  DOCVE_DireccionCliente,
  DOCVE_DescripcionCliente,
  DOCVE_FechaDocumento,
  DOCVE_FechaTransaccion,
  DOCVE_OrdenCompra,
  DOCVE_ImporteVenta,
  DOCVE_PorcentajeIGV,
  DOCVE_ImporteIgv,
  DOCVE_TotalVenta,
  DOCVE_Referencia,
  DOCVE_AfectoPercepcion,
  DOCVE_PorcentajePercepcion,
  DOCVE_ImportePercepcion,
  DOCVE_TotalPagar,
  DOCVE_TotalPagado,
  DOCVE_TotalPeso,
  DOCVE_DocumentoPercepcion,
  DOCVE_TipoCambio,
  DOCVE_TipoCambioSunat,
  DOCVE_FecAnulacion,
  DOCVE_EstEntrega,
  DOCVE_Observaciones,
  DOCVE_NotaPie,
  DOCVE_Estado,
  DOCVE_Guias,
  DOCVE_IncIGV,
  DOCVE_Plazo,
  DOCVE_PlazoFecha,
  DOCVE_Dirigida,
  DOCVE_NroTelefono,
  DOCVE_AnuladoCaja,
  DOCVE_PrecIncIVG,
  DOCVE_UsrCrea,
  DOCVE_FecCrea,
  DOCVE_UsrMod,
  DOCVE_FecMod,
  DOCVE_Motivo
) 
Select 
  DOCPE_Codigo As DOCVE_Codigo,
  @ZONAS_Codigo As ZONAS_Codigo,
  @SUCUR_Id As SUCUR_Id,
  Null As PEDID_Codigo,
  @PVENT_Id As PVENT_Id,
  Per.ENTID_Codigo As ENTID_CodigoCliente,
  @Vendedor As ENTID_CodigoVendedor,
  TIPOS_CodTipoMoneda,
  Per.TIPOS_CodTipoDocumento,
  NUll As TIPOS_CodCondicionPago,
  Null As TIPOS_CodTipoMotivo,
  (Select Max(DOCVE_Id) From Ventas.VENT_DocsVenta Where PVENT_Id = @PVENT_Id) + 1 As DOCVE_Id,
  DOCPE_Serie As DOCVE_Serie,
  DOCPE_Numero As DOCVE_Numero,
  NUll As DOCVE_DireccionCliente,
  Ent.ENTID_RazonSocial As DOCVE_DescripcionCliente,
  @Fecha As DOCVE_FechaDocumento,
  GETDATE() As DOCVE_FechaTransaccion,
  Null As DOCVE_OrdenCompra,
  DOCPE_TotalPercepcion  As DOCVE_ImporteVenta,
  (Select Top 1 PARMT_Valor From Parametros Where PARMT_Id = 'PIGV') DOCVE_PorcentajeIGV,
  0.00 As DOCVE_ImporteIgv,
  DOCPE_TotalPercepcion As DOCVE_TotalVenta,
  Null As DOCVE_Referencia,
  0.00 As DOCVE_AfectoPercepcion,
  0.00 As DOCVE_PorcentajePercepcion,
  0.00 As DOCVE_ImportePercepcion,
  DOCPE_TotalPercepcion  As DOCVE_TotalPagar,
  0.00 As DOCVE_TotalPagado,
  0.00 As DOCVE_TotalPeso,
  NUll As DOCVE_DocumentoPercepcion,
  @TCOficina As DOCVE_TipoCambio,
  @TCSunat As DOCVE_TipoCambioSunat,
  Null As DOCVE_FecAnulacion,
  'E' As DOCVE_EstEntrega,
  NUll As DOCVE_Observaciones,
  NUll As DOCVE_NotaPie,
  'I' As DOCVE_Estado,
  NUll As DOCVE_Guias,
  NUll As DOCVE_IncIGV,
  NUll As DOCVE_Plazo,
  NUll As DOCVE_PlazoFecha,
  NUll As DOCVE_Dirigida,
  NUll As DOCVE_NroTelefono,
  NUll As DOCVE_AnuladoCaja,
  NUll As DOCVE_PrecIncIVG,
  @Usuario As  DOCVE_UsrCrea,
  GETDATE() DOCVE_FecCrea,
  NUll As DOCVE_UsrMod,
  NUll As DOCVE_FecMod,
  NUll As DOCVE_Motivo
from Contabilidad.CONT_DocsPercepcion As per
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = per.ENTID_Codigo
Where DOCPE_Codigo = @DOCPE_Codigo

Print 'Proceso Terminado'


GO 
/***************************************************************************************************************************************/ 

