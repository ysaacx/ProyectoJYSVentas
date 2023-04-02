

SELECT * FROM Logistica.ABAS_IngresoPorPiezas

SELECT * FROM Logistica.ABAS_IngresoPorPiezasDetalle

INSERT INTO Logistica.ABAS_IngresoPorPiezasDetalle
        ( ARTIC_Codigo ,
          INGCO_Id ,
          INGCD_Item ,
          ALMAC_Id ,
          INPZA_Codigo ,
          INPZD_Item ,
          PEDID_Codigo ,
          PDDET_Item ,
          DOCVD_Item ,
          DOCVE_Codigo ,
          INPZD_CantidadIngreso ,
          INPZD_CantidadSalida ,
          INPZD_Fecha ,
          INPZD_Estado ,
          INPZD_UsrCrea ,
          INPZD_FecCrea ,
          INPZD_UsrMod ,
          INPZD_FecMod ,
          PEDPZ_Item
        )
SELECT ARTIC_Codigo ,
          INGCO_Id ,
          INGCD_Item ,
          ALMAC_Id ,
          INPZA_Codigo ,
          INPZD_Item = 1,
          PEDID_Codigo = NULL,
          PDDET_Item = NULL,
          DOCVD_Item = NULL,
          DOCVE_Codigo = NULL,
          INPZD_CantidadIngreso = INPZA_CantidadIngreso,
          INPZD_CantidadSalida = 0,
          INPZD_Fecha =  NULL,
          INPZD_Estado = 'I',
          INPZD_UsrCrea = 'SISTEMAS',
          INPZD_FecCrea = GETDATE(),
          INPZD_UsrMod = NULL,
          INPZD_FecMod = NULL,
          PEDPZ_Item = NULL
FROM Logistica.ABAS_IngresoPorPiezas
WHERE NOT INGCO_Id IN (4, 5)

UPDATE Logistica.ABAS_IngresoPorPiezasDetalle SET INPZD_Estado = 'I'

