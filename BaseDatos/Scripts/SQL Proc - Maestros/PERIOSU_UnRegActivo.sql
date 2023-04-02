

GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERIOSU_UnRegActivo]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[PERIOSU_UnRegActivo]
GO
-- =========================================================
-- Autor - Fecha Crea  : YSAACX - 15/07/2022
-- Descripcion         : Procedimiento de Actualización de la tabla periodos
-- Autor-Fec.Mod.-Desc : 
-- Autor-Fec.Mod.-Desc : 
-- =========================================================
CREATE PROCEDURE [dbo].[PERIOSU_UnRegActivo]
( @PERIO_Codigo VARCHAR(6)
, @PERIO_UsrMod Usuario
) AS 
BEGIN

   UPDATE dbo.Periodos
      SET PERIO_UsrMod = @PERIO_UsrMod
        , PERIO_Activo = 0
        , PERIO_StockActivo = 0
    WHERE PERIO_Codigo <> @PERIO_Codigo

END
GO

--UPDATE dbo.Periodos Set  PERIO_Codigo = '2023'
--,PERIO_Descripcion = 'Periodo 2023'
--,PERIO_StockActivo = 0
--,PERIO_Lock = 0
--,PERIO_UsrCrea = '00000000'
--,PERIO_FecCrea = '2022-07-15 23:25:24.333'
--,PERIO_UsrMod = '00000000'
--,PERIO_FecMod = '2022-07-15 23:58:18.023'
--,PERIO_Activo = 0
-- Where   ISNULL(PERIO_Codigo, '') = '2023'

--exec PERIOSU_UnRegActivo @PERIO_Codigo=N'2023',@PERIO_UsrMod=N'00000000'
--SELECT * FROM dbo.Periodos
