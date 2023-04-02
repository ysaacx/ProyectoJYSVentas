USE BDMaster
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MOVISS_ActualizarDetalles]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[MOVISS_ActualizarDetalles] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 17/01/2012
-- Descripcion         : Procedimiento de Inserción de la tabla Departamento
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MOVISS_ActualizarDetalles]
(   
     @FecIni DateTime
    ,@FecFin DATETIME
    , @EMPR_Codigo CHAR(5)
)
AS

--Begin Tran X
/***********************************************************************************************************************************/
/* Actualizar los tipos de cambio */
/*=================================================================================================================================*/

DECLARE @FecIni_txt VARCHAR(12) = '''' + CONVERT(VARCHAR(10), @FecIni, 120) + ''''
DECLARE @FecFin_txt VARCHAR(12) = '''' + CONVERT(VARCHAR(10), @FecFin, 120) + ''''

DECLARE @SQL nVARCHAR(MAX)
DECLARE @EMPR_BaseDatos VARCHAR(50) = (SELECT EMPR_BaseDatos FROM BDSAdmin..Empresas WHERE EMPR_Codigo = @EMPR_Codigo)

SET @SQL = ''
SET @SQL = @SQL + 'Update Movimientos ' + CHAR(10)
SET @SQL = @SQL + 'Set Tipo_Cambio = (Select TIPOC_VentaSunat from ' + @EMPR_BaseDatos +  '.dbo.TipoCambio' + CHAR(10)
SET @SQL = @SQL + '                    Where Convert(varchar, TIPOC_Fecha, 112) = Convert(varchar, Movimientos.Fecha, 112))' + CHAR(10)
SET @SQL = @SQL + 'Where Fecha between + ' + @FecIni_txt + ' And ' + @FecFin_txt +  CHAR(10)
SET @SQL = @SQL + '    And Id_Moneda = 2' + CHAR(10)
SET @SQL = @SQL + '    And IsNull(Tipo_Cambio, 0) = 0' + CHAR(10)

PRINT @SQL  
EXECUTE sp_executesql @SQL  
/*=================================================================================================================================*/
Update Movimientos
Set Tipo_Cambio = 1
Where Fecha between @FecIni And @FecFin
    And Id_Moneda = 1
    And IsNull(Tipo_Cambio, 0) = 0

/*=================================================================================================================================*/

UPDATE Moneda SET ID_Moneda = 1 WHERE ID_Moneda = 1
--Commit Tran X



GO 
/***************************************************************************************************************************************/ 

--SELECT * FROM dbo.Moneda
--UPDATE Moneda SET ID_Moneda = 1 WHERE ID_Moneda = 1
--exec ARTISS_Consulta @Periodo=2016
--DELETE FROM dbo.Movimientos_Detalle where EMPR_Codigo = 'SCCYR'
--DELETE FROM Movimientos where EMPR_Codigo = 'SCCYR'
--TRUNCATE TABLE dbo.StockInicial


--SELECT * FROM BDCOMAFISUR.Logistica.LOG_StockIniciales
--SELECT * FROM BDMaster..StockInicial WHERE ISNULL(costoinicialcontable, 0) > 0
