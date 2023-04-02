USE BDDACEROSLAM
go


   UPDATE PuntoVenta
      SET PVENT_DireccionIP =  '(LOCAL)\SQL12'
        , PVENT_DireccionIPAC = '(LOCAL)\SQL12'
     --   , PVENT_Direccion = @PVENT_Direccion    
    --WHERE PVENT_Id = @PVENT_Id