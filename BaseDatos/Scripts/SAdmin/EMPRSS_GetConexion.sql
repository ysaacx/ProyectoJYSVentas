USE BDSAdmin
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EMPRSS_GetConexion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[EMPRSS_GetConexion]
GO
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 23/12/2017
-- Descripcion         : Procedimiento de Inserción de la tabla UsuariosPlantillas
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[EMPRSS_GetConexion]
(	@APLI_Codigo char(3),
	@EMPR_Codigo char(5)
)

AS

SELECT DISTINCT EMPR.EMPR_Servidor
     , EMPR.EMPR_BaseDatos
  FROM dbo.UsuariosAplicaciones UAPP
 INNER JOIN dbo.Empresas EMPR ON EMPR.EMPR_Codigo = UAPP.EMPR_Codigo
 WHERE UAPP.EMPR_Codigo = @EMPR_Codigo AND UAPP.APLI_Codigo = @APLI_Codigo
 
GO

EXEC EMPRSS_GetConexion @EMPR_Codigo = 'NOVAC',  @APLI_Codigo = 'VTA'


SELECT * FROM UsuariosAplicaciones
UPDATE UsuariosAplicaciones SET EMPR_Codigo = 'NOVAC'
SELECT * FROM dbo.Empresas
