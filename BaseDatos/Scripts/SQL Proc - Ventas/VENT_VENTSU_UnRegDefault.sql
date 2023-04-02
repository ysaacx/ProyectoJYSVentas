--USE BDInkasFerro_Almudena
--USE BDSisSCC
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VENT_VENTSU_UnRegDefault]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[VENT_VENTSU_UnRegDefault]
GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 31/01/2018
-- Descripcion         : Procedimiento de Actualización de la tabla VENT_PVentDocumento
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_VENTSU_UnRegDefault]
(	@PVDOCU_Id Id,
	@ZONAS_Codigo CodigoZona,
	@SUCUR_Id CodSucursal,
	@TIPOS_CodTipoDocumento CodigoTipo,
	@Usuario Usuario
)
AS

   UPDATE Ventas.VENT_PVentDocumento
      SET [PVDOCU_Default] = 0
        , [PVDOCU_UsrMod] = @Usuario
        , [PVDOCU_FecMod] = GetDate()
    WHERE PVDOCU_Id <> @PVDOCU_Id
      AND [ZONAS_Codigo] = @ZONAS_Codigo
      AND [SUCUR_Id] = @SUCUR_Id
      AND [TIPOS_CodTipoDocumento] = @TIPOS_CodTipoDocumento

GO


EXEC VENT_VENTSU_UnRegDefault 9, '83.00', 2, 'CPD01', 'SISTEMAS'