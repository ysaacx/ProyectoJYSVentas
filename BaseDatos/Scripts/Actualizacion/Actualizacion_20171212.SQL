GO
UPDATE dbo.Parametros SET PARMT_Valor = '3.3.1.5' WHERE PARMT_Id = 'pg_Version'
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ABASSD_EliminarStockIngresoMerc]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 05/06/2017
-- Descripcion         : Eliminar Stock Ingresado
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_ABASSD_EliminarStockIngresoMerc]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 
    
   DELETE  
     FROM Logistica.LOG_Stocks 
    WHERE INGCO_Id IN (SELECT INGCO_Id 
                         FROM Logistica.ABAS_IngresosCompra 
                        WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor)

   DECLARE @ALMAC_Id SMALLINT
         , @INGCO_Id INTEGER
   
   SELECT @ALMAC_Id = ALMAC_Id
        , @INGCO_Id = INGCO_Id
     FROM Logistica.ABAS_IngresosCompra 
    WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

    PRINT 'DELETE Logistica.ABAS_IngresosCompraDetalle'
   DELETE FROM Logistica.ABAS_IngresosCompraDetalle
    WHERE ALMAC_Id = @ALMAC_Id AND  INGCO_Id = @INGCO_Id

    PRINT '=================================='
    PRINT '@ALMAC_Id = ' + ISNULL(RTRIM(@ALMAC_Id), '*')
    PRINT '@INGCO_Id = ' + ISNULL(RTRIM(@INGCO_Id), '*')
    PRINT '=================================='
END 



GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSD_EliminarDetalle]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle] 
GO 
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 10/12/2017
-- Descripcion         : Eliminar detalle de los documentos de compra
-- Autor - Fecha Modif : 
-- Autor-Fec.Mod-Desc  : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_DOCCOSD_EliminarDetalle]
( @DOCCO_Codigo VARCHAR(33)
, @ENTID_CodigoProveedor VARCHAR(14)
) AS
BEGIN 

    PRINT 'DELETE Logistica.ABAS_DocsCompraDetalle'
    DELETE FROM Logistica.ABAS_DocsCompraDetalle 
     WHERE DOCCO_Codigo = @DOCCO_Codigo AND ENTID_CodigoProveedor = @ENTID_CodigoProveedor

END 



GO 
/***************************************************************************************************************************************/ 

/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSS_TodosDocCompra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Documentos de Compra
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra]
(
     @ZONAS_Codigo VarChar(5)
    ,@SUCUR_Id SmallInt
    ,@Cadena VarChar(50)
    ,@Opcion SmallInt
    ,@Todos Bit
    ,@FecIni DateTime
    ,@FecFin DATETIME
    ,@TipoRegistro CHAR(1) = NULL 
)
As

   SELECT Ent.ENTID_RazonSocial As ENTID_Proveedor
        , Alma.ALMAC_Descripcion As ALMAC_Descripcion
        , TDoc.TIPOS_DescCorta As TIPOS_Documento
        , TMone.TIPOS_DescCorta As TIPOS_TipoMoneda
        , TPag.TIPOS_Descripcion As TIPOS_TipoPago
        , RTrim(DocCo.DOCCO_Numero) As DOCCO_Numero
        , EstadoCosteo = CASE WHEN (SELECT COUNT(*) FROM Logistica.ABAS_Costeos COST 
                                     WHERE COST.DOCCO_Codigo = DocCo.DOCCO_Codigo
                                       AND COST.ENTID_CodigoProveedor = DocCo.ENTID_CodigoProveedor) > 0
                              THEN 'C' 
                              ELSE 'N' 
                         END 
        , CASE DocCo.DOCCO_TipoRegistro 
			   WHEN 'I' THEN 'Registro e Ingreso'
               WHEN 'R' THEN 'Solo Registro'
               ELSE ''
          END AS DOCCO_TipoRegistro_Text
        , CASE WHEN exists(SELECT * FROM Logistica.ABAS_IngresosCompra INGCO WHERE INGCO.DOCCO_Codigo = DocCo.DOCCO_Codigo AND INGCO.ENTID_CodigoProveedor = DocCo.ENTID_CodigoProveedor)
               THEN CONVERT(BIT, 1)
               ELSE CONVERT(BIT, 0)
          END AS RegistroCompra
        , DocCo.*
     FROM Logistica.ABAS_DocsCompra As DocCo 
    INNER JOIN dbo.Entidades As Ent On Ent.ENTID_Codigo = DocCo.ENTID_CodigoProveedor
    INNER JOIN dbo.Almacenes As Alma On Alma.ALMAC_Id = DocCo.ALMAC_Id
    INNER JOIN dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = DocCo.TIPOS_CodTipoDocumento
    INNER JOIN dbo.Tipos As TMone On TMone.TIPOS_Codigo = DocCo.TIPOS_CodTipoMoneda
    INNER JOIN dbo.Tipos As TPag On TPag.TIPOS_Codigo = DocCo.TIPOS_CodTipoPago 
    WHERE Alma.SUCUR_Id = @SUCUR_Id
      AND Alma.ZONAS_Codigo = @ZONAS_Codigo
      AND Convert(Date, DocCo.DOCCO_FechaDocumento) Between @FecIni AND @FecFin
      AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
                      When 1 Then DocCo.DOCCO_Codigo
                      Else Ent.ENTID_RazonSocial 
           END) Like '%' + @Cadena + '%' 
      AND DocCo.DOCCO_Estado In (Case @Todos When 1 Then (DocCo.DOCCO_Estado) Else ('I') End) 
      AND ISNULL(DocCo.DOCCO_TipoRegistro, '-') = isnull(@TipoRegistro, ISNULL(DocCo.DOCCO_TipoRegistro, '-'))
    ORDER By DOCCO_Codigo ASC



GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_INGSS_Consulta]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_INGSS_Consulta] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 28/12/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_INGSS_Consulta]
(
	 @Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime	
)
As

Select  Ent.ENTID_RazonSocial As ENTID_Proveedor
	, Alma.ALMAC_Descripcion As ALMAC_Descripcion
	, TDoc.TIPOS_DescCorta As TIPOS_Documento
	, IsNull((TDocC.TIPOS_DescCorta + ' ' + DC.DOCCO_Serie + '-' + Right('0000000' + RTRIM(DC.DOCCO_Numero), 7))
		, (TDocC2.TIPOS_DescCorta + ' '+ Left(Right(IComp.DOCCO_Codigo, 10), 3)) + '-' + RIGHT(IComp.DOCCO_Codigo, 7)) As Compra
	,(Case When DC.DOCCO_Codigo Is Null 
	  Then CONVERT(Bit, 0) Else CONVERT(Bit, 1) End) As CompraReg
	, 'OC ' + OC.ORDCO_Serie + '-' + Right('0000000' + RTRIM(OC.ORDCO_Numero), 7) As Orden
	,IComp.DOCCO_Codigo
	,IComp.INGCO_Serie
	,IComp.INGCO_Numero
	,IComp.ENTID_CodigoProveedor
	,IComp.INGCO_FechaDocumento
	,IComp.ALMAC_Id
	,IComp.INGCO_Id
	,IComp.INGCO_Estado
	--,IComp.* 
Into #Ingresos
From Logistica.ABAS_IngresosCompra As IComp 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = IComp.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = IComp.ALMAC_Id
	Inner Join dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = IComp.TIPOS_CodTipoDocumento
	Left Join Logistica.ABAS_OrdenesCompra As OC On OC.ORDCO_Codigo = IComp.ORDCO_Codigo
	Left Join Logistica.ABAS_DocsCompra As DC On DC.DOCCO_Codigo = IComp.DOCCO_Codigo
		And DC.ENTID_CodigoProveedor = IComp.ENTID_CodigoProveedor
	Left Join Tipos As TDocC On TDocC.TIPOS_Codigo = DC.TIPOS_CodTipoDocumento
	Left Join Tipos As TDocC2 On TDocC2.TIPOS_Codigo = 'CPD' + LEFT(IComp.DOCCO_Codigo, 2)
 WHERE Convert(date, IComp.INGCO_FechaDocumento) Between @FecIni AND @FecFin
		AND DC.DOCCO_TipoRegistro = 'R'
        AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
						  When 1 Then RTrim(IComp.INGCO_Id)
						  When 2 Then IComp.DOCCO_Codigo
						  When 3 Then IComp.INGCO_Codigo
						  Else Ent.ENTID_RazonSocial
			 End)
			Like '%' + @Cadena + '%' 
		
IF @Todos = 1
    BEGIN 
	    Select * From #Ingresos Order By INGCO_FechaDocumento Desc
    END
ELSE
    BEGIN
	    Select * From #Ingresos Where ISNULL(INGCO_Estado, '') = 'I' Order By INGCO_FechaDocumento DESC
    END

GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_ORDCOSS_TodosOrdenes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Ordenes
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_ORDCOSS_TodosOrdenes]
(
	 @ZONAS_Codigo VarChar(5)
	,@SUCUR_Id SmallInt
	,@Cadena VarChar(50)
	,@Opcion SmallInt
	,@Todos Bit
	,@FecIni DateTime
	,@FecFin DateTime
)
As


Select Ent.ENTID_RazonSocial As ENTID_Proveedor
	,Alma.ALMAC_Descripcion As ALMAC_Descripcion
	,OrdCo.*
From Logistica.ABAS_OrdenesCompra As OrdCo 
	Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = OrdCo.ENTID_CodigoProveedor
	Inner Join dbo.Almacenes As Alma On Alma.ALMAC_Id = OrdCo.ALMAC_Id 
	
WHERE Alma.SUCUR_Id = @SUCUR_Id
	AND  Alma.ZONAS_Codigo = @ZONAS_Codigo
	AND  Convert(Date, OrdCo.ORDCO_FechaDocumento) Between @FecIni AND @FecFin
	AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
					  When 1 Then OrdCo.COTCO_Codigo
					  Else Ent.ENTID_RazonSocial 
		 End) Like '%' + @Cadena + '%' 
	AND OrdCo.ORDCO_Estado In (Case @Todos When 1 Then (OrdCo.ORDCO_Estado) Else ('I') End) 


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TRAN_GUIASS_RepRecCemento]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TRAN_GUIASS_RepRecCemento] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 08/11/2012
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TRAN_GUIASS_RepRecCemento]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@Opcion SmallInt
)
As

SELECT GTRAN_Codigo = RTRIM(DINGC.INGCO_Id) --DOCCO.DOCCO_Codigo
	, GTRAN_Serie = INGCO.INGCO_Serie --DOCCO.DOCCO_Serie
	, GTRAN_Numero = INGCO.INGCO_Numero --DOCCO.DOCCO_Numero
	, TDoc.TIPOS_DescCorta + ' ' + DOCCO.DOCCO_Serie + '-' + Right('0000000' + RTrim(DOCCO.DOCCO_Numero), 7) As DocCompra
	--, CanComprada = (Select Sum(GDet.DOCCD_Cantidad) From Logistica.ABAS_DocsCompraDetalle As GDet Where DOCCO_Codigo = DOCCO.DOCCO_Codigo)
	, CanComprada = Sum(DDOCO.DOCCD_Cantidad) 
	, DOCCO_FechaDocumento = DOCCO.DOCCO_FechaDocumento
	, TDocC.TIPOS_DescCorta As TIPOS_TipoDocumentoCorta
	--,TDoc.TIPOS_DescCorta + ' ' + Guia.GTRAN_Serie + '-' + Right('0000000' + RTRIM(Guia.GTRAN_Numero), 7) As DocTraslado
	, GTRAN_Fecha = DOCCO.DOCCO_FechaDocumento
	--,GTRAN_NroComprobantePago
	--,Guia.GTRAN_NroPedido
	--,Guia.TIPOS_CodTipoDocumento
	, TDoc.TIPOS_Descripcion
	, GTRAN_RucProveedor = Ori.ENTID_NroDocumento
	, ISNULL(Ori.ENTID_RazonSocial, Ori.ENTID_RazonSocial) As ENTID_RazonSocialProveedor
	, GTRAN_DireccionProveedor = Ori.ENTID_Direccion
	, DINGC.INGCO_Id
	--,Guia.ENTID_CodigoDestinatario
	--,Dest.ENTID_RazonSocial As ENTID_RazonSocialDestinatario
	--,Guia.GTRAN_DireccionDestinatario
	
	--,Guia.ENTID_CodigoTransportista
	--,Trans.ENTID_RazonSocial As ENTID_RazonSocialTransportista
	--,Guia.ENTID_CodigoConductor
	--,Cond.ENTID_RazonSocial As ENTID_RazonSocialConductor
	--,Guia.GTRAN_DescripcionVehiculo
	--,IsNull(Guia.GTRAN_CertificadosVehiculo
	--	,(Select Vehi.VEHIC_Certificado From Transportes.TRAN_Vehiculos As Vehi Where Vehi.VEHIC_Id = Guia.VEHIC_Id)
	-- ) As GTRAN_CertificadosVehiculo
	----,Guia.ENTID_Di
	----,Guia.*
	--,(SELECT SUM(DINCG.INGCD_Cantidad) FROM Logistica.ABAS_IngresosCompra INGCO
	--   INNER JOIN Logistica.ABAS_IngresosCompraDetalle DINCG ON DINCG.ALMAC_Id = INGCO.ALMAC_Id AND DINCG.INGCO_Id = INGCO.INGCO_Id
	--   WHERE INGCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo)
		, SUM(DINGC.INGCD_Cantidad) AS Cantidad
	,GTRAN_PesoTotal = SUM(DINGC.INGCD_PesoUnitario * DINGC.INGCD_Cantidad)
	, ARTIC.ARTIC_Descripcion
 FROM Logistica.ABAS_DocsCompra As DOCCO ---On DOCCO.DOCCO_Codigo = Guia.GTRAN_NroComprobantePago
	INNER JOIN Tipos As TDoc On TDoc.TIPOS_Codigo = DOCCO.TIPOS_CodTipoDocumento
	INNER JOIN Logistica.ABAS_IngresosCompra INGCO ON INGCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo
	INNER JOIN Logistica.ABAS_IngresosCompraDetalle DINGC ON DINGC.ALMAC_Id = INGCO.ALMAC_Id AND DINGC.INGCO_Id = INGCO.INGCO_Id
	--Inner Join Entidades As Dest ON Dest.ENTID_Codigo = DOCCO.ENTID_CodigoDestinatario
	--Inner Join Entidades As Trans ON Trans.ENTID_Codigo = DOCCO.ENTID_CodigoTransportista
	--Inner Join Entidades As Cond ON Cond.ENTID_Codigo = DOCCO.ENTID_CodigoConductor
	INNER JOIN Logistica.ABAS_DocsCompraDetalle DDOCO ON DDOCO.DOCCO_Codigo = DOCCO.DOCCO_Codigo 
	  AND DDOCO.ENTID_CodigoProveedor = DOCCO.ENTID_CodigoProveedor
	INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = DDOCO.ARTIC_Codigo AND ARTIC.ARTIC_Codigo = DINGC.ARTIC_Codigo
	Left Join Entidades As Ori ON Ori.ENTID_Codigo = DOCCO.ENTID_CodigoProveedor
	--Inner Join Logistica.ABAS_DocsCompra As DComp On DDOCCO.DOCCO_Codigo = Guia.GTRAN_NroComprobantePago
	Inner Join Tipos As TDocC On TDocC.TIPOS_Codigo = INGCO.TIPOS_CodTipoDocumento
Where Case @Opcion 
		When 0 Then CONVERT(DATE, DOCCO.DOCCO_FechaDocumento)
		When 1 Then CONVERT(DATE, DOCCO.DOCCO_FechaDocumento)
		Else DOCCO.DOCCO_FechaDocumento
	  End
	Between @FecIni And @FecFin
	And DOCCO.DOCCO_Estado <> 'X'
	--AND DOCCO.DOCCO_Codigo IN ('010010010002', '010010010001')
GROUP BY INGCO.INGCO_Id,  INGCO.INGCO_Serie, INGCO.INGCO_Numero, DOCCO.DOCCO_FechaDocumento, TDoc.TIPOS_DescCorta, DOCCO.DOCCO_FechaDocumento
	,TDoc.TIPOS_Descripcion, Ori.ENTID_NroDocumento, Ori.ENTID_RazonSocial, Ori.ENTID_Direccion
	, DINGC.INGCO_Id
	, DOCCO.DOCCO_Codigo, DOCCO.DOCCO_Serie, DOCCO.DOCCO_Numero
	, TDocC.TIPOS_DescCorta, ARTIC.ARTIC_Descripcion
HAVING SUM(DINGC.INGCD_Cantidad) <> Sum(DDOCO.DOCCD_Cantidad)  --(Select Sum(GDet.DOCCD_Cantidad) From Logistica.ABAS_DocsCompraDetalle As GDet Where DOCCO_Codigo = DOCCO.DOCCO_Codigo)
ORDER By  GTRAN_Serie, Ori.ENTID_NroDocumento

GO
/*====================================================================================================*/

