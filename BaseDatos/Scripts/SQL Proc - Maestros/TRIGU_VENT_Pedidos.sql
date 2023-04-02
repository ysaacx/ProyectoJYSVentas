
GO
/****** Object:  Trigger [Ventas].[TRIGU_VENT_Pedidos]    Script Date: 8/02/2022 22:57:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/01/2013
-- Descripcion         : Historial 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
ALTER TRIGGER [Ventas].[TRIGU_VENT_Pedidos] ON [Ventas].[VENT_Pedidos]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

--Declare @AUDIT_Id BigInt
--Declare @PEDID_Codigo VarChar(14)
--Set @PEDID_Codigo = (Select Top 1 PEDID_Codigo From INSERTED)
--Set @AUDIT_Id = IsNull((Select Max(AUDIT_Id) From Historial.VENT_Pedidos Where PEDID_Codigo = @PEDID_Codigo), 0) + 1

Select PEDID.PEDID_Codigo, AUDIT_Id = MAX(AUDIT_Id) INTO #TMP_ID
  From Historial.VENT_Pedidos PEDID
 INNER JOIN INSERTED ON INSERTED.PEDID_Codigo = PEDID.PEDID_Codigo
 GROUP BY PEDID.PEDID_Codigo

INSERT INTO Historial.VENT_Pedidos(PEDID_Codigo,
	PVENT_Id,						ZONAS_Codigo,				SUCUR_Id,					DOCVE_Codigo,
	ENTID_CodigoCliente,			ENTID_CodigoVendedor,		TIPOS_CodTipoMoneda,		TIPOS_CodTipoDocumento,
	TIPOS_CodCondicionPago,			PEDID_Id,					DOCVE_PercepcionCliente,	PEDID_DescripcionCliente,
	PEDID_DireccionCliente,			PEDID_Numero,				PEDID_FechaDocumento,		PEDID_FechaTransaccion,
	PEDID_OrdenCompra,				PEDID_ImporteVenta,			PEDID_PorcentajeIGV,		PEDID_ImporteIGV,
	PEDID_TotalVenta,				PEDID_AfectoPercepcion,		PEDID_PorcentajePercepcion,	PEDID_ImportePercepcion,
	PEDID_ImpDocPercepcion,			PEDID_TotalPagar,			PEDID_TotalPeso,			PEDID_DocumentoPercepcion,
	PEDID_TipoCambio,				PEDID_TipoCambioSunat,		PEDID_ListaEspecial,		PEDID_ListaPredeterminada,
	PEDID_Tipo,						PEDID_ParaFacturar,			PEDID_EstEntrega,			PEDID_Observaciones,
	PEDID_Estado,					PEDID_UsrCrea,				PEDID_FecCrea,				PEDID_UsrMod,
	PEDID_FecMod,					PEDID_Plazo,				PEDID_Dirigida,				PEDID_NumeroOC,
	PEDID_NroTelefono,				PEDID_PlazoFecha,			PEDID_StockLocal,			PEDID_StockPrincipal,
	PEDID_PromedioVentas,			PEDID_GenerarGuia,			PEDID_CodRelacionado,		PVENT_IdRelacionado,
	ALMAC_IdRelacionado,			PEDID_EMail,				PEDID_Condiciones,			PEDID_CondicionEntrega,
	PEDID_Nota,						PEDID_ModReporte,			PEDID_AfectoPercepcionSoles,PEDID_ImportePercepcionSoles,
	PEDID_TCOfCompra,				PVENT_IdOrigen,				PVENT_IdDestinoPReposicion,	PVENT_IdOrigenPReposicion,
	PEDID_FechaAnulacion,			PEDID_MotivoAnulacion,		PEDID_AnuladoCaja,
	AUDIT_Id,
	AUDIT_Fecha,					AUDIT_HostName,				AUDIT_Operacion,			AUDIT_ServerName,
	AUDIT_DataBase,					AUDIT_BDUsuario,			AUDIT_Aplicacion
) 
Select DELETED.PEDID_Codigo,
	PVENT_Id,						ZONAS_Codigo,				SUCUR_Id,					DOCVE_Codigo,
	ENTID_CodigoCliente,			ENTID_CodigoVendedor,		TIPOS_CodTipoMoneda,		TIPOS_CodTipoDocumento,
	TIPOS_CodCondicionPago,			PEDID_Id,					DOCVE_PercepcionCliente,	PEDID_DescripcionCliente,
	PEDID_DireccionCliente,			PEDID_Numero,				PEDID_FechaDocumento,		PEDID_FechaTransaccion,
	PEDID_OrdenCompra,				PEDID_ImporteVenta,			PEDID_PorcentajeIGV,		PEDID_ImporteIGV,
	PEDID_TotalVenta,				PEDID_AfectoPercepcion,		PEDID_PorcentajePercepcion,	PEDID_ImportePercepcion,
	PEDID_ImpDocPercepcion,			PEDID_TotalPagar,			PEDID_TotalPeso,			PEDID_DocumentoPercepcion,
	PEDID_TipoCambio,				PEDID_TipoCambioSunat,		PEDID_ListaEspecial,		PEDID_ListaPredeterminada,
	PEDID_Tipo,						PEDID_ParaFacturar,			PEDID_EstEntrega,			PEDID_Observaciones,
	PEDID_Estado,					PEDID_UsrCrea,				PEDID_FecCrea,				PEDID_UsrMod,
	PEDID_FecMod,					PEDID_Plazo,				PEDID_Dirigida,				PEDID_NumeroOC,
	PEDID_NroTelefono,				PEDID_PlazoFecha,			PEDID_StockLocal,			PEDID_StockPrincipal,
	PEDID_PromedioVentas,			PEDID_GenerarGuia,			PEDID_CodRelacionado,		PVENT_IdRelacionado,
	ALMAC_IdRelacionado,			PEDID_EMail,				PEDID_Condiciones,			PEDID_CondicionEntrega,
	PEDID_Nota,						PEDID_ModReporte,			PEDID_AfectoPercepcionSoles,PEDID_ImportePercepcionSoles,
	PEDID_TCOfCompra,				PVENT_IdOrigen,				PVENT_IdDestinoPReposicion,	PVENT_IdOrigenPReposicion,
	PEDID_FechaAnulacion,			PEDID_MotivoAnulacion,		PEDID_AnuladoCaja
    , AUDIT_Id = ROW_NUMBER() OVER( PARTITION BY Deleted.PEDID_Codigo ORDER BY Deleted.PEDID_Codigo) + ISNULL(TMP.AUDIT_Id, 0)
    , GETDATE(),						HOST_NAME(),				'UPDATE',					@@SERVERNAME,
	db_name(),						SUSER_SNAME(),				APP_NAME()
From DELETED
LEFT JOIN #TMP_ID TMP ON TMP.PEDID_Codigo = Deleted.PEDID_Codigo


END
