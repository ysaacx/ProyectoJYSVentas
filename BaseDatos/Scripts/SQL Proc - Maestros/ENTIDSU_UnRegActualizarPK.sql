USE BDInkaPeru
GO
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTIDSU_UnRegActualizarPK]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ENTIDSU_UnRegActualizarPK] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : Obtener los clientes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ENTIDSU_UnRegActualizarPK]
(
	 @ENTID_Codigo VarChar(14)
	,@ENTID_NroDocumento VarChar(14)
)
AS
BEGIN

    PRINT ' ACTUALIZAR PK'
    -- ================================================================================================ --
    SELECT * INTO #TMP_Entidad FROM dbo.Entidades WHERE ENTID_Codigo = @ENTID_Codigo

    DECLARE @Id BIGINT =  ISNULL((SELECT Max(ENTID_Id) As Id From dbo.Entidades), 0) + 1

    UPDATE dbo.Entidades SET ENTID_NroDocumento = @ENTID_Codigo WHERE ENTID_Codigo = @ENTID_Codigo
    UPDATE #TMP_Entidad SET ENTID_Codigo = @ENTID_NroDocumento, ENTID_Id = @Id, ENTID_NroDocumento = @ENTID_NroDocumento

    --SELECT * FROM dbo.Entidades WHERE ENTID_NroDocumento = @ENTID_NroDocumento
    -- ================================================================================================ --
    --PRINT 'CREAR ENTIDAD'
    INSERT INTO dbo.Entidades
    SELECT * FROM #TMP_Entidad

    --SELECT * FROM Ventas.VENT_Pedidos WHERE ENTID_CodigoCliente = @ENTID_Codigo
    --SELECT * FROM Ventas.VENT_DocsVenta WHERE ENTID_CodigoCliente = @ENTID_Codigo

    UPDATE Ventas.VENT_Pedidos SET ENTID_CodigoCliente = @ENTID_NroDocumento WHERE ENTID_CodigoCliente = @ENTID_Codigo
    UPDATE Ventas.VENT_DocsVenta SET ENTID_CodigoCliente = @ENTID_NroDocumento WHERE ENTID_CodigoCliente = @ENTID_Codigo
    UPDATE Tesoreria.TESO_DocsPagos SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo
    UPDATE Tesoreria.TESO_Caja SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo

    UPDATE Logistica.DIST_GuiasRemision SET ENTID_CodigoCliente = @ENTID_NroDocumento WHERE ENTID_CodigoCliente = @ENTID_Codigo
    
    --UPDATE Logistica.ABAS_DocsCompraDetalle SET ENTID_CodigoProveedor = @ENTID_NroDocumento WHERE ENTID_CodigoProveedor = @ENTID_Codigo
    UPDATE Logistica.ABAS_DocsCompra SET ENTID_CodigoProveedor = @ENTID_NroDocumento WHERE ENTID_CodigoProveedor = @ENTID_Codigo    
    UPDATE Logistica.ABAS_IngresosCompra SET ENTID_CodigoProveedor = @ENTID_NroDocumento WHERE ENTID_CodigoProveedor = @ENTID_Codigo    
    UPDATE Logistica.ABAS_Costeos SET ENTID_CodigoProveedor = @ENTID_NroDocumento WHERE ENTID_CodigoProveedor = @ENTID_Codigo    

    UPDATE EntidadesRoles SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo
    UPDATE Clientes SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo
    UPDATE Proveedores SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo
    UPDATE dbo.Conductores SET ENTID_Codigo = @ENTID_NroDocumento WHERE ENTID_Codigo = @ENTID_Codigo
    -- ================================================================================================ --
    DELETE FROM dbo.Entidades WHERE ENTID_Codigo = @ENTID_Codigo
END 

GO

BEGIN TRAN X
----------------------------------------------------------------------------------------------
-- VENTAS / PEDIDOS
EXEC dbo.ENTIDSU_UnRegActualizarPK @ENTID_Codigo = '10251851846', -- varchar(14)
    @ENTID_NroDocumento = '10251851845' -- varchar(14)

--EXEC dbo.ENTIDSU_UnRegActualizarPK @ENTID_Codigo = '10456237581', -- varchar(14)
--    @ENTID_NroDocumento = '10456237580' -- varchar(14)
----------------------------------------------------------------------------------------------
-- GUIAS
--EXEC dbo.ENTIDSU_UnRegActualizarPK @ENTID_Codigo = '20563876094', -- varchar(14)
--    @ENTID_NroDocumento = '20563876095' -- varchar(14)
----------------------------------------------------------------------------------------------
-- COMPRAS
--EXEC dbo.ENTIDSU_UnRegActualizarPK @ENTID_Codigo = '20312372895', -- varchar(14)
--    @ENTID_NroDocumento = '20312372899' -- varchar(14)

ROLLBACK TRAN X

--Select Max(AUDIT_Id) From Historial.VENT_Pedidos Where PEDID_Codigo 

--SELECT * FROM dbo.Entidades WHERE ENTID_NroDocumento = '10251851844'
--SELECT * FROM Logistica.DIST_GuiasRemision WHERE ENTID_CodigoCliente

--SELECT ENTID_CodigoCliente, CC = COUNT(*) FROM Ventas.VENT_DocsVenta GROUP BY ENTID_CodigoCliente  HAVING COUNT(*) > 5 ORDER BY CC DESC
--SELECT ENTID_CodigoCliente, CC = COUNT(*) FROM Logistica.DIST_GuiasRemision GROUP BY ENTID_CodigoCliente  HAVING COUNT(*) > 5 ORDER BY CC DESC

--SELECT ENTID_CodigoProveedor, CC = COUNT(*) FROM Logistica.ABAS_IngresosCompra GROUP BY ENTID_CodigoProveedor  HAVING COUNT(*) > 5 ORDER BY CC DESC

