USE BDDACEROSLAM
go

select * from Logistica.ABAS_IngresosCompra where INGCO_Id = 15
select * from Logistica.ABAS_IngresosCompraDetalle where INGCO_Id = 15

select * from  Logistica.LOG_Stocks where INGCO_Id = 15



Select m_abas_ingresoscompra.* , Ent.ENTID_RazonSocial As ENTID_Proveedor
, Ent.ENTID_Codigo As ENTID_CodigoProveedor
, Ent.ENTID_NroDocumento As ENTID_NroDocumento
 From Logistica.ABAS_IngresosCompra As m_abas_ingresoscompra 
 Inner Join dbo.Entidades As Ent On Ent.ENTID_Codigo = m_abas_ingresoscompra.ENTID_CodigoProveedor
  WHERE   ISNULL(m_ABAS_IngresosCompra.ALMAC_Id, '') = 1 AND  ISNULL(m_ABAS_IngresosCompra.INGCO_Id, '') = 22


 Select m_abas_ingresoscompradetalle.* , Art.ARTIC_Descripcion As ARTIC_Descripcion
, Art.ARTIC_Id As ARTIC_Id
, TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
, TUni.TIPOS_Codigo As TIPOS_CodUnidadMedida
 From Logistica.ABAS_IngresosCompraDetalle As m_abas_ingresoscompradetalle 
 Inner Join dbo.Articulos As Art On Art.ARTIC_Codigo = m_abas_ingresoscompradetalle.ARTIC_Codigo
 Inner Join dbo.Tipos As TUni On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida WHERE   ISNULL(m_ABAS_IngresosCompraDetalle.ALMAC_Id, '') = 1 AND  ISNULL(m_ABAS_IngresosCompraDetalle.INGCO_Id, '') = 22

select * from  Logistica.ABAS_IngresosCompra  where INGCO_Id = 25
select * from Logistica.ABAS_IngresosCompraDetalle where INGCO_Id = 25

select * from Logistica.LOG_Stocks where INGCO_Id = 22

select * from  Logistica.ABAS_IngresosCompra  where INGCO_Id = 22
select * from Logistica.ABAS_IngresosCompraDetalle where convert(date, INGCD_FecCrea) = '2019-09-30' --where INGCO_Id = 22

--select * from  Logistica.ABAS_IngresosCompra  where tip


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
 WHERE DC.DOCCO_TipoRegistro = 'R'



 delete from Logistica.LOG_Stocks where INGCO_Id in (select INGCO_Id  from #Ingresos)
 delete from Logistica.ABAS_IngresosCompraDetalle  where INGCO_Id in (select INGCO_Id  from #Ingresos)
 delete from Logistica.ABAS_IngresosCompra  where INGCO_Id in (select INGCO_Id  from #Ingresos)