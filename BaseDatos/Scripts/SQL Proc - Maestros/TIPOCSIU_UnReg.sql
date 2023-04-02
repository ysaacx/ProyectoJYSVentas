--USE BDInkasFerro_Almudena
--USE BDInkasFerro_Parusttacca
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TIPOCSIU_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[TIPOCSIU_UnReg]

GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 18/08/2018
-- Descripcion         : Procedimiento de Inserción de la tabla TipoCambio
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TIPOCSIU_UnReg]
(	@TIPOC_Fecha CodTipoCambio out,
	@TIPOC_FechaC Fecha,
	@TIPOC_CompraOficina Importe4D = null ,
	@TIPOC_VentaOficina Importe4D = null ,
	@TIPOC_CompraRenta Importe4D = null ,
	@TIPOC_VentaRenta Importe4D = null ,
	@TIPOC_CompraSunat Importe4D = null ,
	@TIPOC_VentaSunat Importe4D = null ,
	@Usuario Usuario
)
AS

   SET @TIPOC_Fecha = CONVERT(VARCHAR(19), @TIPOC_FechaC, 112)

IF NOT EXISTS(SELECT * FROM TipoCambio WHERE TIPOC_Fecha = @TIPOC_Fecha)
   BEGIN
      PRINT 'INSERT'
      INSERT INTO [TipoCambio]
      (	TIPOC_Fecha
      ,	TIPOC_FechaC
      ,	TIPOC_CompraOficina
      ,	TIPOC_VentaOficina
      ,	TIPOC_CompraRenta
      ,	TIPOC_VentaRenta
      ,	TIPOC_CompraSunat
      ,	TIPOC_VentaSunat
      ,	TIPOC_UsrCrea
      ,	TIPOC_FecCrea
      )
      VALUES
      (	@TIPOC_Fecha
      ,	@TIPOC_FechaC
      ,	@TIPOC_CompraOficina
      ,	@TIPOC_VentaOficina
      ,	@TIPOC_CompraRenta
      ,	@TIPOC_VentaRenta
      ,	@TIPOC_CompraSunat
      ,	@TIPOC_VentaSunat
      ,	@Usuario
      ,	GetDate()
      )

   END
ELSE
   BEGIN 
      PRINT 'UPDATE'
      UPDATE [TipoCambio]
      SET [TIPOC_FechaC] = @TIPOC_FechaC
        , [TIPOC_CompraOficina] = @TIPOC_CompraOficina
        , [TIPOC_VentaOficina] = @TIPOC_VentaOficina
        , [TIPOC_CompraRenta] = @TIPOC_CompraRenta
        , [TIPOC_VentaRenta] = @TIPOC_VentaRenta
        , [TIPOC_CompraSunat] = @TIPOC_CompraSunat
        , [TIPOC_VentaSunat] = @TIPOC_VentaSunat
        , [TIPOC_FecMod] = GetDate()
        , [TIPOC_UsrMod] = @Usuario

      WHERE
       TIPOC_Fecha = @TIPOC_Fecha

   END 


GO

--declare @p1 nvarchar(8)
--set @p1=NULL
--exec TIPOCSIU_UnReg @TIPOC_Fecha=@p1 output,@TIPOC_FechaC='2018-08-01 00:00:00',@TIPOC_CompraOficina=0,@TIPOC_VentaOficina=0,@TIPOC_CompraRenta=0,@TIPOC_VentaRenta=0,@TIPOC_CompraSunat=3.5800,@TIPOC_VentaSunat=3.2900,@Usuario=N'00000000'
--select @p1

BEGIN TRAN x

declare @p1 nvarchar(8)
set @p1=NULL
exec TIPOCSIU_UnReg @TIPOC_Fecha=@p1 output,@TIPOC_FechaC='2018-08-01 00:00:00',@TIPOC_CompraOficina=0,@TIPOC_VentaOficina=0,@TIPOC_CompraRenta=0,@TIPOC_VentaRenta=0,@TIPOC_CompraSunat=3.5800,@TIPOC_VentaSunat=3.2900,@Usuario=N'00000000'
select @p1

ROLLBACK TRAN x