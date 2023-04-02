--USE BDInkasFerro
--USE BDJYM
--USE BDInkaPeru
--USE BDInkasFerro_Almudena
--USE BDInkasFerro_Parusttacca
--USE BDSisSCC
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_Busqueda]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_Busqueda] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 10/02/2018
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_Busqueda]
(
    @Linea VarChar(10) = Null
  , @Cadena VARCHAR(100)
)
As

  SELECT  ARTIC_Codigo                 , ARTIC_Peso                   
        , ARTIC_Detalle                , ARTIC_Descripcion            
        , Linea = LINEA.LINEA_Nombre
        , SubLinea = SUBLI.LINEA_Nombre
        , ARTIC.ARTIC_Descontinuado
        , TIPOS_UnidadMedida = UND.TIPOS_Descripcion
        , ARTIC.LINEA_Codigo
    FROM dbo.Articulos ARTIC
   INNER JOIN dbo.Lineas LINEA ON LINEA.LINEA_Codigo = LEFT(ARTIC.LINEA_Codigo, 2)
   INNER JOIN dbo.Lineas SUBLI ON SUBLI.LINEA_Codigo = ARTIC.LINEA_Codigo
   INNER JOIN dbo.Tipos UND ON UND.TIPOS_Codigo = ARTIC.TIPOS_CodUnidadMedida
   WHERE ARTIC.ARTIC_Descripcion LIKE '%' + @Cadena + '%'
     AND ARTIC.LINEA_Codigo Like IsNull(@Linea, ARTIC.LINEA_Codigo) + '%'
GO 
/***************************************************************************************************************************************/ 

exec ARTICSS_Busqueda @Linea=N'000',@Cadena=N''
--exec ARTICSS_Busqueda @Cadena=N'barra', @Linea='0103'
--exec VENTSS_ObtenerArticulos @PERIO_Codigo=N'2018',@ALMAC_Id=2,@ZONAS_Codigo=N'83.00',@LINEA_Codigo=NULL




