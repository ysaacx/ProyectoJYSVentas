USE BDInkasFerro_Almudena
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_DOCVESS_CajaPagos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[VENT_DOCVESS_CajaPagos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Generador - 05/03/2013
-- Descripcion         : Procedimiento de Selección según las primary keys de todos de la tabla TRAN_Fletes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_DOCVESS_CajaPagos]
(
    @DOCVE_Codigo VarChar(13)
)

AS

 SELECT  Caj.CAJA_Id
       , Caj.CAJA_Serie + '-' + Right('0000000' + RTrim(CAJA_Numero), 7) As Documento
       , CAJA_OrdenDocumento
       , CAJA_Fecha
       , CAJA_Hora
       , CAJA_FechaPago
       , Case TIPOS_CodMonedaPago 
                When 'MND1' Then CAJA_Importe / 
                    (Case IsNull(CAJA_TCambio, 1) When 0 Then TCam.TIPOC_VentaSunat Else CAJA_TCambio End)
                When 'MND2' Then CAJA_Importe 
         End As CAJA_ImporteDolares
       , Case TIPOS_CodMonedaPago 
                When 'MND1' Then CAJA_Importe
                When 'MND2' Then CAJA_Importe * CAJA_TCambio
         End As CAJA_ImporteSoles
       , CAJA_Importe
       , TDoc.TIPOS_Descripcion As TIPOS_Transaccion
       , TMon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , TPag.TIPOS_Descripcion
       , IsNull('Cod: ' + RTrim(DPag.DPAGO_Id) +' - Op/Num: ' + RTrim(DPag.DPAGO_Numero) 
           + IsNull(' - Banco: ' + Ban.BANCO_Descripcion, '')
           + ' - ' + TDoc.TIPOS_Descripcion
           , 'Cancelación en Efectivo')
         AS Glosa
       --,DPag.DPAGO_Fecha
       , IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
       , DPag.DPAGO_Id
       , DPag.DPAGO_Numero
       , DPag.DPAGO_FechaVenc As DPAGO_Fecha
       , Ven.ENTID_CodigoCliente
       , Ven.DOCVE_Codigo
       , Caj.CAJA_Codigo
         --,*
   FROM Ventas.VENT_DocsVenta As Ven
  INNER JOIN Tesoreria.TESO_Caja As Caj On Caj.DOCVE_Codigo = Ven.DOCVE_Codigo 
    AND Caj.CAJA_Estado <> 'X'  And Caj.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tesoreria.TESO_CajaDocsPago As TC On TC.CAJA_Codigo = Caj.CAJA_Codigo And TC.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tesoreria.TESO_DocsPagos As DPag On DPag.DPAGO_Id = TC.DPAGO_Id And DPag.PVENT_Id = Ven.PVENT_Id
   LEFT JOIN Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
   LEFT JOIN Bancos As Ban On Ban.BANCO_Id = DPag.BANCO_Id
   LEFT JOIN Tipos As TMon On TMon.TIPOS_Codigo = IsNull(DPag.TIPOS_CodTipoMoneda, Ven.TIPOS_CodTipoMoneda)
   LEFT JOIN Tipos As TPag On TPag.TIPOS_Codigo = Caj.TIPOS_CodTipoOrigen
   LEFT JOIN TipoCambio As TCam On Convert(VarChar, TCam.TIPOC_FechaC, 113) = Convert(VarChar, Caj.CAJA_Fecha, 113)
Where Ven.DOCVE_Codigo = @DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 
--exec VENT_DOCVESS_CajaPagos @DOCVE_Codigo=N'010110000001'
exec VENT_DOCVESS_CajaPagos @DOCVE_Codigo=N'03F0010000001'

--SELECT * FROM Tesoreria.TESO_Caja
--SELECT  * FROM Tesoreria.TESO_DocsPagos
--SELECT * FROM dbo.Zonas

