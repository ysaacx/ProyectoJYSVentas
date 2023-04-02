USE BDSisSCC
go
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[Logistica].[TRIGGER_ABASSS_ActualizacionArticulos]'))
   DROP TRIGGER [Logistica].[TRIGGER_ABASSS_ActualizacionArticulos]
GO

CREATE TRIGGER [Logistica].TRIGGER_ABASSS_ActualizacionArticulos
    ON [Logistica].[ABAS_DocsCompra]
   FOR INSERT, UPDATE AS
BEGIN

   DECLARE @DOCCO_Codigo VARCHAR(33)
         , @Usuario VARCHAR(20)

   SELECT @DOCCO_Codigo = Inserted.DOCCO_Codigo
        , @Usuario = Inserted.DOCCO_UsrCrea
     FROM Inserted 
   
   UPDATE dbo.Articulos
      SET ARTIC_NuevoIngreso = 1
        , ARTIC_UsrNuevoIngreso = @Usuario
        , ARTIC_FecNuevoIngreso = GETDATE()
     FROM Logistica.ABAS_DocsCompraDetalle DOCCD
    INNER JOIN Inserted INS ON INS.DOCCO_Codigo = DOCCD.DOCCO_Codigo
    WHERE DOCCD.ARTIC_Codigo = dbo.Articulos.ARTIC_Codigo

END
GO
--SELECT * FROM Articulos WHERE ARTIC_NuevoIngreso = 1
--UPDATE Articulos SET ARTIC_NuevoIngreso = 0 WHERE ARTIC_NuevoIngreso = 1

