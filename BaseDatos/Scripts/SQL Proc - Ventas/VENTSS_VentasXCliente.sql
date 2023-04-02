
--USE BDInkasFerro_Almudena
USE BDDACEROSLAM
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENTSS_VentasXCliente]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENTSS_VentasXCliente] 
GO 
CREATE PROCEDURE [dbo].[VENTSS_VentasXCliente]
(
	  @FecIni DATETIME = NULL
	, @FecFin DATETIME = NULL 
	, @ENTID_Codigo VarChar(15)
	, @Linea VarChar(15) = NULL
    , @ARTIC_Codigo CodArticulo = NULL
)
As

   SELECT Ven.DOCVE_Codigo
	    , IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '-')  As Documento
	    , Ven.DOCVE_FechaDocumento
	    , Ven.ENTID_CodigoCliente
	    , Ven.DOCVE_DescripcionCliente
	    , Det.ARTIC_Codigo
	    , Art.ARTIC_Descripcion
	    , Det.DOCVD_Cantidad
	    , Det.DOCVD_PrecioUnitario
	    , Det.DOCVD_SubImporteVenta
	    , Case Ven.TIPOS_CodTipoMoneda
		     When 'MND2' Then  Det.DOCVD_SubImporteVenta * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
		 												    Else Ven.DOCVE_TipoCambio
		 										      End)
		      Else  Det.DOCVD_SubImporteVenta
		      End
	      As ImporteSoles
	    , Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Det.DOCVD_SubImporteVenta Else 0.00 End As ImporteDolares
	    , Det.DOCVD_Cantidad * Art.ARTIC_Peso As SubPeso
	    , Det.DOCVD_PesoUnitario
	    , TUni.TIPOS_Descripcion
     FROM Ventas.VENT_DocsVenta As Ven
	 LEFT Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Inner Join Ventas.VENT_DocsVentaDetalle As Det On Det.DOCVE_Codigo = Ven.DOCVE_Codigo
	Inner Join Articulos As Art On Art.ARTIC_Codigo = Det.ARTIC_Codigo And Art.LINEA_Codigo Like IsNull(@Linea, '') + '%'
	Inner Join Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
	 LEFT Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
    WHERE ENTID_CodigoCliente = @ENTID_Codigo
  	  AND ven.DOCVE_Estado='I'
	  AND Convert(Date, Ven.DOCVE_FechaDocumento) Between ISNULL(@FecIni, Convert(Date, Ven.DOCVE_FechaDocumento)) And ISNULL(@FecFin, Convert(Date, Ven.DOCVE_FechaDocumento))
      AND Det.ARTIC_Codigo = ISNULL(@ARTIC_Codigo, Det.ARTIC_Codigo)
    ORDER By Ven.DOCVE_FechaDocumento DESC, Documento

GO 
/***************************************************************************************************************************************/ 

--exec VENTSS_VentasXCliente @FecIni='2018-01-01 00:00:00',@FecFin='2018-02-15 00:00:00',@ENTID_Codigo=N'20490766732',@Linea=NULL, @ARTIC_Codigo = '1201003'

--exec VENTSS_VentasXCliente @FecIni=NULL,@FecFin=NULL,@ENTID_Codigo=N'20527870331',@Linea=NULL,@ARTIC_Codigo=NULL
exec VENTSS_VentasXCliente @FecIni='2019-03-01 00:00:00',@FecFin='2019-03-16 12:10:47.987',@ENTID_Codigo=N'45517657',@Linea=NULL,@ARTIC_Codigo=NULL
