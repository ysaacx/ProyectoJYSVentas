USE BDMaster
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MSTGENSS_EliminarImportados]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[MSTGENSS_EliminarImportados] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 13/11/2012
-- Descripcion         : Eliminar Todo lo Importado
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[MSTGENSS_EliminarImportados]
(   
      @EMPR_Codigo CHAR(5)
    , @FecIni DateTime
    , @FecFin DateTime
    , @SUCUR_Id tinyint
    , @Opcion SMALLINT
    , @PERIO_Codigo CHAR(4)
)
AS

--Begin Tran x


DECLARE @SQL nVARCHAR(MAX)
DECLARE @EMPR_BaseDatos VARCHAR(50) 
DECLARE @EMPR_Servidor VARCHAR(50)

SELECT @EMPR_BaseDatos = EMPR_BaseDatos , @EMPR_Servidor = EMPR_Servidor
  FROM BDSAdmin..Empresas WHERE EMPR_Codigo = @EMPR_Codigo

   IF OBJECT_ID('tempdb..##TMP_Sucursales') IS NOT NULL
      BEGIN 
         DROP TABLE ##TMP_Sucursales
      END 

   SET @SQL = 'SELECT * INTO ##TMP_Sucursales FROM ' + @EMPR_BaseDatos + '..Sucursales '
   EXECUTE sp_executesql @SQL        
 

INSERT INTO dbo.Almacenes
      ( EMPR_Codigo ,             Id_Sucursal ,             Descripcion ,             Base_Datos ,
         Direccion_IP ,            Activo ,                  Direccion_IPNuevo ,       Base_DatosNuevo)
SELECT EMPR_Codigo = @EMPR_Codigo
      , Id_Sucursal = SUCUR_Id
      , Descripcion = 'Almacen'
      , Base_Datos  = @EMPR_BaseDatos
      , Direccion_IP = @EMPR_Servidor
      , Activo = 1
      , Direccion_IPNuevo = @EMPR_Servidor
      , Base_DatosNuevo = @EMPR_BaseDatos
   FROM BDSAdmin..Sucursales
  WHERE SUCUR_Id NOT IN (SELECT Id_Sucursal FROM Almacenes WHERE EMPR_Codigo = @EMPR_Codigo)
    AND SUCUR_Id IN (SELECT SUCUR_Id FROM ##TMP_Sucursales)

   if OBJECT_ID('tempdb..##TMP_Sucursales') IS NOT NULL
      BEGIN 
         DROP TABLE ##TMP_Sucursales
      END 


if @Opcion = 0
   BEGIN 
       Delete from Ventas_Detalle Where Id_venta in (Select Id_venta from Ventas Where Fecha Between @FecIni And @FecFin And Id_Sucursal = @SUCUR_Id) AND EMPR_Codigo = @EMPR_Codigo
       Delete from Ventas Where Fecha Between @FecIni And @FecFin And Id_Sucursal = @SUCUR_Id AND EMPR_Codigo = @EMPR_Codigo
   END

ELSE IF @Opcion = 1
   BEGIN 
       Delete from Compras_Detalle Where Id_compra In (Select Id_compra from Compras Where Fecha_Documento Between @FecIni And @FecFin And Id_Sucursal = @SUCUR_Id) AND EMPR_Codigo = @EMPR_Codigo
       Delete from Compras Where Fecha_Documento Between @FecIni And @FecFin And Id_Sucursal = @SUCUR_Id AND EMPR_Codigo = @EMPR_Codigo
   END 
ELSE IF @Opcion = 3 -- Stock Inicial
   BEGIN
      DELETE FROM dbo.StockInicial WHERE EMPR_Codigo = @EMPR_Codigo AND Periodo = @PERIO_Codigo AND EMPR_Codigo = @EMPR_Codigo
   END 
   
--Commit Tran x



GO 
/***************************************************************************************************************************************/ 


BEGIN TRAN x

exec MSTGENSS_EliminarImportados @EMPR_Codigo=N'FISUR',@PERIO_Codigo=N'2019',@FecIni=NULL,@FecFin=NULL,@SUCUR_Id=1,@Opcion=3

--SELECT * FROM dbo.Almacenes
--SELECT * FROM dbo.StockInicial WHERE EMPR_Codigo = 'FISUR' AND Id_Producto = '0101010'
--delete FROM dbo.Almacenes WHERE Id_Sucursal = 2

--INSERT INTO dbo.StockInicial( EMPR_Codigo
--,Id_Sucursal
--,Periodo
--,Id_Producto
--,StockFisico
--,Fecha
--) VALUES ( 'FISUR'
--,1
--,'2019'
--,'0101001'
--,1.0000
--,'2018-12-31 00:00:00.000'
--)

ROLLBACK TRAN x

--delete FROM dbo.Almacenes
--SELECT * FROM BDSAdmin..Sucursales
--SELECT * FROM BDSAdmin..Sucursales
--SELECT * FROM BDCOMAFISUR..Sucursales

