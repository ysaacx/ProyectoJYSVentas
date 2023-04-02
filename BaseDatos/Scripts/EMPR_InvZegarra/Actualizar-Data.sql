USE BDImportacionesZegarra
GO

--SELECT * FROM dbo.Tipos WHERE TIPOS_Codigo LIKE 'DID%'
--SELECT * FROM dbo.Entidades WHERE ENTID_Nombres LIKE '%BLANCO%'
--Select m_entidadespadrones.* , n_tipos.TIPOS_Numero As TIPOS_TipoPadron
-- From dbo.EntidadesPadrones As m_entidadespadrones 
-- Inner Join dbo.Tipos As n_tipos On n_tipos.TIPOS_Codigo = m_entidadespadrones.TIPOS_CodTipoPadron WHERE   m_EntidadesPadrones.ENTID_Codigo = '11000000000'
    
UPDATE dbo.Entidades SET TIPOS_CodTipoDocumento = 'DID1', ENTID_TipoEntidadPDT = 'N' WHERE ENTID_Codigo = '11000000000'
UPDATE dbo.Entidades SET TIPOS_CodTipoDocumento = 'DID1', ENTID_TipoEntidadPDT = 'N' WHERE ENTID_Codigo = '10000000001'
