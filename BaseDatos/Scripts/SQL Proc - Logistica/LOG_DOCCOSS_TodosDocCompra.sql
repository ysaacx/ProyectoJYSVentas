USE BDSisSCC
USE BDInkasFerro_Almudena
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
      AND ISNULL(DocCo.DOCCO_TipoRegistro, '-') = ISNULL((CASE WHEN @TipoRegistro = 'T' THEN 'I' ELSE @TipoRegistro END), ISNULL(DocCo.DOCCO_TipoRegistro, '-'))
    ORDER By DOCCO_Codigo ASC



GO 
/***************************************************************************************************************************************/ 
--exec LOG_DOCCOSS_TodosDocCompra @ZONAS_Codigo=N'83.00',@SUCUR_Id=1,@Cadena=N'',@Opcion=0,@Todos=0,@FecIni='2017-12-01 00:00:00',@FecFin='2017-12-10 00:00:00'

exec LOG_DOCCOSS_TodosDocCompra @ZONAS_Codigo=N'83.00',@SUCUR_Id=1,@Cadena=N'',@Opcion=0,@Todos=0,@FecIni='2017-12-01 00:00:00',@FecFin='2017-12-20 00:00:00',@TipoRegistro=N'T'
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
