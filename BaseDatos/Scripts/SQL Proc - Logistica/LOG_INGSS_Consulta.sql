--use BDDACEROSLAM
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
/***************************************************************************************************************************************/ 
--exec LOG_INGSS_Consulta @Cadena=N'',@Opcion=0,@Todos=1,@FecIni='2019-09-01 00:00:00',@FecFin='2019-10-02 00:00:00'

----exec LOG_INGSS_Consulta @Cadena=N'',@Opcion=0,@Todos=0,@FecIni='2017-12-01 00:00:00',@FecFin='2017-12-12 00:00:00'

----SELECT * FROM Logistica.ABAS_DocsCompra WHERE DOCCO_Codigo IN ('010010000010', '010010000232', '010010010002', '010010015554')
----UPDATE Logistica.ABAS_DocsCompra SET DOCCO_TipoRegistro = 'R' WHERE DOCCO_Codigo IN ('010010000010', '010010000232', '010010010002', '010010015554')
--select * from Logistica.ABAS_IngresosCompra where DOCCO_Codigo = '0100010016475'
--select * from Logistica.ABAS_IngresosCompra where DOCCO_Codigo = '010010016475'
--select * from Logistica.ABAS_DocsCompra where DOCCO_Codigo = '010010016475'

update Logistica.ABAS_IngresosCompra set DOCCO_Codigo = '010010016475', INGCO_DCItem = 2 where INGCO_Id= 15
