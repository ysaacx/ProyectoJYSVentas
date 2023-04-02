--USE [BDInkaPeru]
GO
/****** Object:  Trigger [Logistica].[TRIGU_DIST_GuiasRemision]    Script Date: 8/02/2022 23:10:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 27/08/2012
-- Descripcion         : Historial 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
ALTER TRIGGER [Logistica].[TRIGU_DIST_GuiasRemision] ON [Logistica].[DIST_GuiasRemision]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

--Declare @AUDIT_Id BigInt
--Declare @GUIAR_Codigo VarChar(14)
--Set @GUIAR_Codigo = (Select Top 1 GUIAR_Codigo From DELETED)
--Set @AUDIT_Id = IsNull((Select Max(AUDIT_Id) From Historial.DIST_GuiasRemision Where GUIAR_Codigo = @GUIAR_Codigo), 0) + 1

Select PEDID.GUIAR_Codigo, AUDIT_Id = MAX(AUDIT_Id) INTO #TMP_ID
  From Historial.DIST_GuiasRemision PEDID
 INNER JOIN INSERTED ON INSERTED.GUIAR_Codigo = PEDID.GUIAR_Codigo
 GROUP BY PEDID.GUIAR_Codigo

INSERT INTO Historial.DIST_GuiasRemision(GUIAR_Codigo,
	PVENT_Id,						DOCVE_Codigo,				ORDEN_Codigo,				ALMAC_IdOrigen,
	PVENT_IdOrigen,					DIREC_IdDestino,			ALMAC_IdDestino,			PVENT_IdDestino,
	TIPOS_CodMotivoTraslado,		TIPOS_CodTipoDocumento,		ENTID_CodigoCliente,		ENTID_CodigoTransportista,
	ENTID_CodigoConductor,			PEDID_Codigo,				VEHIC_Id,					GUIAR_Serie,
	GUIAR_Numero,					GUIAR_DireccOrigen,			GUIAR_DireccDestino,		GUIAR_Descripcioncliente,
	GUIAR_FechaEmision,				GUIAR_FechaTraslado,		GUIAR_DescripcionTransportista,	GUIAR_DescripcionConductor,
	GUIAR_LicenciaConductor,		GUIAR_DescripcionVehiculo,	GUIAR_CertificadoVehiculo,	GUIAR_TotalPeso,				
	GUIAR_Observaciones,			GUIAR_Impresa,				GUIAR_Estado,				GUIAR_Salida,
	GUIAR_HoraSalida,				GUIAR_HoraLlegada,			GUIAR_UsrCrea,				GUIAR_FecCrea,
	GUIAR_UsrMod,					GUIAR_FecMod,				GUIAR_MotivoAnulacion,		TIPOS_CodTipoOrigen,
	GUIAR_FechaAnulacion,			GUIAR_AnuladoCaja,			GUIAR_StockDevuelto,		GUIAR_FechaIngreso,
	AUDIT_Id,
	AUDIT_Fecha,					AUDIT_HostName,				AUDIT_Operacion,			AUDIT_ServerName,
	AUDIT_DataBase,					AUDIT_BDUsuario,			AUDIT_Aplicacion
)
Select DELETED.GUIAR_Codigo,
	PVENT_Id,						DOCVE_Codigo,				ORDEN_Codigo,				ALMAC_IdOrigen,
	PVENT_IdOrigen,					DIREC_IdDestino,			ALMAC_IdDestino,			PVENT_IdDestino,
	TIPOS_CodMotivoTraslado,		TIPOS_CodTipoDocumento,		ENTID_CodigoCliente,		ENTID_CodigoTransportista,
	ENTID_CodigoConductor,			PEDID_Codigo,				VEHIC_Id,					GUIAR_Serie,
	GUIAR_Numero,					GUIAR_DireccOrigen,			GUIAR_DireccDestino,		GUIAR_Descripcioncliente,
	GUIAR_FechaEmision,				GUIAR_FechaTraslado,		GUIAR_DescripcionTransportista,	GUIAR_DescripcionConductor,
	GUIAR_LicenciaConductor,		GUIAR_DescripcionVehiculo,	GUIAR_CertificadoVehiculo,	GUIAR_TotalPeso,				
	GUIAR_Observaciones,			GUIAR_Impresa,				GUIAR_Estado,				GUIAR_Salida,
	GUIAR_HoraSalida,				GUIAR_HoraLlegada,			GUIAR_UsrCrea,				GUIAR_FecCrea,
	GUIAR_UsrMod,					GUIAR_FecMod,				GUIAR_MotivoAnulacion,		TIPOS_CodTipoOrigen,
	GUIAR_FechaAnulacion,			GUIAR_AnuladoCaja,			GUIAR_StockDevuelto,		GUIAR_FechaIngreso
    , AUDIT_Id = ROW_NUMBER() OVER( PARTITION BY Deleted.GUIAR_Codigo ORDER BY Deleted.GUIAR_Codigo) + ISNULL(TMP.AUDIT_Id, 0)
    , GETDATE(),						HOST_NAME(),				'UPDATE',					@@SERVERNAME,
	db_name(),						SUSER_SNAME(),				APP_NAME()
From DELETED
LEFT JOIN #TMP_ID TMP ON TMP.GUIAR_Codigo = Deleted.GUIAR_Codigo

END
