--USE BDInkasFerro_Almudena
USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ActualizarVersion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_Busqueda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 10/02/2018
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ActualizarVersion]
(
	 @Version VARCHAR(10)
)
As

    UPDATE dbo.Parametros 
       SET PARMT_Valor = @Version 
     WHERE PARMT_Id = 'pg_Version'


go