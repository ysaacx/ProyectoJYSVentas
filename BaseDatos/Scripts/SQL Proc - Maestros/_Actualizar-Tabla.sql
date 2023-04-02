

ALTER TABLE Logistica.ABAS_Costeos ADD COSTE_TCalculo CHAR(1) NULL 

SELECT * FROM Logistica.ABAS_Costeos WHERE COSTE_TCalculo IS NOT NULL 


Select m_abas_costeos.* , n_entidades.ENTID_RazonSocial As ENTID_RazonSocial
 From Logistica.ABAS_Costeos As m_abas_costeos 
 Inner Join dbo.Entidades As n_entidades On n_entidades.ENTID_Codigo = m_abas_costeos.COSTE_CodigoProveedor WHERE   m_ABAS_Costeos.DOCCO_Codigo = '01F1570040641' AND  m_ABAS_Costeos.TIPOS_CodTipoCosteo = 'CTO03' AND  m_ABAS_Costeos.ENTID_CodigoProveedor = '20312372895' AND  ISNULL(m_ABAS_Costeos.COSTE_Item, '') < 0
