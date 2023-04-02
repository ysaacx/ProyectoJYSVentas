







-- CREAR ARTICULO DE PARUSSTACA
 --======================================================================================================================--
   -- MOVER ARTICULO A NUEVO CODIGO
   PRINT 'MOVER'
   PRINT '--------------------------------------------------------'
   PRINT 'Ventas.VENT_DocsVentaDetalle'
   UPDATE Ventas.VENT_DocsVentaDetalle
      SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
    WHERE ARTIC_Codigo = @ARTIC_CODIGO
    PRINT '--------------------------------------------------------'
    PRINT 'Ventas.VENT_PedidosDetalle'
    UPDATE Ventas.VENT_PedidosDetalle
       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
     WHERE ARTIC_Codigo = @ARTIC_CODIGO
     PRINT '--------------------------------------------------------'
     PRINT 'Logistica.DIST_GuiasRemisionDetalle'
    UPDATE Logistica.DIST_GuiasRemisionDetalle
       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
     WHERE ARTIC_Codigo = @ARTIC_CODIGO
     PRINT '--------------------------------------------------------'
     PRINT 'Logistica.LOG_Stocks'
    UPDATE Logistica.LOG_Stocks
       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
     WHERE ARTIC_Codigo = @ARTIC_CODIGO
     PRINT '--------------------------------------------------------'
     PRINT 'Logistica.LOG_StockIniciales'
    UPDATE Logistica.LOG_StockIniciales
       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
     WHERE ARTIC_Codigo = @ARTIC_CODIGO
     PRINT '--------------------------------------------------------'
     PRINT 'Logistica.CTRL_ArreglosDetalle'
    UPDATE Logistica.CTRL_ArreglosDetalle
       SET ARTIC_Codigo = @ARTIC_CODIGO_NEW
     WHERE ARTIC_Codigo = @ARTIC_CODIGO
   --======================================================================================================================--