USE BDSisSCC
go
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIGGER_ENROLSS_PermisoPorUsuarios]'))
   DROP TRIGGER [dbo].[TRIGGER_ENROLSS_PermisoPorUsuarios]
GO

CREATE TRIGGER [TRIGGER_ENROLSS_PermisoPorUsuarios]
    ON dbo.EntidadesRoles
   FOR INSERT, UPDATE, DELETE AS
BEGIN

   DECLARE @ENTID_Codigo VARCHAR(14)
         , @Usuario VARCHAR(20)
         , @ROLES_Id Id

   IF EXISTS(SELECT * FROM Inserted)
      BEGIN 
         SELECT @ENTID_Codigo = Inserted.ENTID_Codigo
              , @Usuario = ISNULL(Inserted.ENROL_UsrCrea, Inserted.ENROL_UsrMod)
              , @ROLES_Id = ROLES_Id
           FROM Inserted 
      END
   ELSE IF EXISTS(SELECT * FROM Deleted)
      BEGIN 
         SELECT @ENTID_Codigo = Deleted.ENTID_Codigo
              , @Usuario = ISNULL(Deleted.ENROL_UsrCrea, Deleted.ENROL_UsrMod)
              , @ROLES_Id = ROLES_Id
           FROM Deleted
      END
   
   PRINT 'Quitar Permiso => ' + @ENTID_Codigo
   DELETE FROM dbo.UsuariosPorPuntoVenta WHERE ENTID_Codigo = @ENTID_Codigo 

   IF (@ROLES_Id = 1) AND EXISTS(SELECT * FROM Inserted)
      BEGIN 
         PRINT 'Asignar Permiso'
         INSERT INTO dbo.UsuariosPorPuntoVenta
              ( ZONAS_Codigo , SUCUR_Id , PVENT_Id , ENTID_Codigo , USPTA_UsrCrea , USPTA_FecCrea )
         SELECT ZONAS_Codigo 
              , SUCUR_Id 
              , PVENT_Id 
              , ENTID_Codigo = @ENTID_Codigo 
              , USPTA_UsrCrea = @Usuario 
              , USPTA_FecCrea = GETDATE()
           FROM PuntoVenta
      END 
END

go

--INSERT INTO dbo.EntidadesRoles( ENTID_Codigo
--,ROLES_Id
--,ENROL_UsrCrea
--,ENROL_FecCrea
--) VALUES ( '10023862064'
--,1
--,'00000000'
--,'2017-01-31 22:55:24.673'
--)

-- DELETE FROM dbo.EntidadesRoles
-- WHERE     ENTID_Codigo = '10023862064'
--And ROLES_Id = 1



--SELECT * FROM dbo.UsuariosPorPuntoVenta WHERE ENTID_Codigo = '10023862064'