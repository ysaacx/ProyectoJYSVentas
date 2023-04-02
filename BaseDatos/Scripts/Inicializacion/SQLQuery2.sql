USE BDInkasFerro_Almudena
GO

BEGIN TRAN X

INSERT INTO Ventas.VENT_DocsVenta( DOCVE_Codigo
,ZONAS_Codigo
,SUCUR_Id
,PEDID_Codigo
,PVENT_Id
,ENTID_CodigoCliente
,ENTID_CodigoVendedor
,TIPOS_CodTipoMoneda
,TIPOS_CodTipoDocumento
,TIPOS_CodCondicionPago
,DOCVE_Id
,DOCVE_Serie
,DOCVE_Numero
,DOCVE_DireccionCliente
,DOCVE_DescripcionCliente
,DOCVE_FechaDocumento
,DOCVE_FechaTransaccion
,DOCVE_ImporteVenta
,DOCVE_PorcentajeIGV
,DOCVE_ImporteIgv
,DOCVE_TotalVenta
,DOCVE_PorcentajePercepcion
,DOCVE_TotalPagar
,DOCVE_TotalPagado
,DOCVE_TotalPeso
,DOCVE_DocumentoPercepcion
,DOCVE_TipoCambio
,DOCVE_EstEntrega
,DOCVE_Observaciones
,DOCVE_Estado
,DOCVE_IncIGV
,DOCVE_PlazoFecha
,DOCVE_AnuladoCaja
,DOCVE_PrecIncIVG
,DOCVE_StockDevuelto
,ENTID_CodigoCotizador
,DOCVE_NCAceptada
,DOCVE_NCPendienteCaja
,DOCVE_NCPendienteDespachos
,DOCVE_RCRevisado
,DOCVE_FechaPago
,RCTCT_Id
,DOCVE_PerGenGuia
,DOCVE_UsrCrea
,DOCVE_FecCrea
) VALUES ( '03F0010000001'
,'83.00'
,2
,'CT0020000005'
,2
,'40975980'
,'00000000000'
,'MND1'
,'CPD03'
,'PGO01'
,3
,'F001'
,1
,'Av. Tucuman #233 - AREQUIPA / AREQUIPA / JACOBO HUNTER'
,'MAMANI ALIAGA J. YSAAC'
,'2017-12-12 23:02:53.975'
,'2017-12-12 23:02:53.986'
,27.71
,18.00
,4.99
,32.70
,2.00
,32.70
,32.70
,10.00
,1
,3.2700
,'E'
,'
'
,'I'
,0
,'2017-12-12 22:59:23.867'
,0
,0
,0
,'00000000'
,0
,0
,0
,0
,'2017-12-12 22:59:38.795'
,1
,0
,'00000000'
,'2017-12-12 23:03:21.620'
)

ROLLBACK TRAN X



