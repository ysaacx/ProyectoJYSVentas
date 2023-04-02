
SELECT * FROM bdvelsoft..MAES_Articulos

USE BDVelSoft
USE BDJYM


SELECT * FROM BDVelSoft..MAES_Articulos
SELECT * FROM BDVelSoft..MAES_Lineas
--DELETE FROM BDJYM..Lineas



INSERT INTO dbo.Lineas
        ( LINEA_Codigo ,
          LINEA_CodPadre ,
          TIPOS_CodTipoComision ,
          LINEA_Nombre ,
          LINEA_UsrCrea ,
          LINEA_FecCrea ,
          LINEA_Activo
        )
   SELECT LINEA_Codigo ,
          LINEA_CodPadre = CASE WHEN LEN(LINEA_Codigo) = 2 THEN NULL ELSE LEFT(LINEA_Codigo, 2) END ,
          TIPOS_CodTipoComision =  NULL,
          LINEA_Nombre = LINEA_Descripcion,
          LINEA_UsrCrea = 'SISTEMAS',
          LINEA_FecCrea = GETDATE(),
          LINEA_Activo = 1
FROM BDVelSoft..MAES_Lineas

--SELECT * FROM TIPOS WHERE TIPOS_Codigo LIKE 'PRO%'
GO
INSERT INTO dbo.Articulos
        (  [ARTIC_Codigo]                               , [LINEA_Codigo]                               , [TIPOS_CodTipoProducto]                               , [TIPOS_CodCategoria]                               
, [TIPOS_CodUnidadMedida]                               , [TIPOS_CodTipoColor]                               , [ARTIC_Id]                               , [ARTIC_Peso]                               
, [ARTIC_Detalle]                               , [ARTIC_Descripcion]                               , [ARTIC_Percepcion]                               , [ARTIC_Descontinuado]                               
, [ARTIC_Localizacion]                               , [ARTIC_Orden]                               , [ARTIC_ExistenciaMin]                               , [ARTIC_ExistenciaMax]                               
, [ARTIC_PuntoReorden]                               , [ARTIC_Estado]                               , [ARTIC_CodigoAnterior]                               , [ARTIC_UsrCrea]                               
, [ARTIC_FecCrea]                               , [ARTIC_UsrMod]                               , [ARTIC_FecMod]                               , [ARTIC_Numero]                               
, [RCVDT_Id]                               , [ARTIC_NuevoIngreso]                               , [ARTIC_UsrNuevoIngreso]                               , [ARTIC_FecNuevoIngreso]                               
        )
SELECT 
   ARTIC_Codigo     
, LINEA_Codigo     
, TIPOS_CodTipoProducto     = 'PRO1'
, TIPOS_CodCategoria        = 'CTP1'
, TIPOS_CodUnidadMedida     = 'UND07'
, TIPOS_CodTipoColor        = 'CLR000'
, ARTIC_Id     
, ARTIC_Peso     
, ARTIC_Detalle             = ARTIC_Descripcion
, ARTIC_Descripcion     
, ARTIC_Percepcion     
, ARTIC_Descontinuado     
, ARTIC_Localizacion       = 'ZONA A'
, ARTIC_Orden              = 1
, ARTIC_ExistenciaMin      = 0
, ARTIC_ExistenciaMax      = 500
, ARTIC_PuntoReorden       = 0
, ARTIC_Estado             = 'I'
, ARTIC_CodigoAnterior     = ARTIC_Id
, ARTIC_UsrCrea            = 'SISTEMAS'
, ARTIC_FecCrea            = GETDATE()
, ARTIC_UsrMod             = NULL
, ARTIC_FecMod             = NULL
, ARTIC_Numero             = ARTIC_Id
, RCVDT_Id                 = NULL
, ARTIC_NuevoIngreso       = NULL
, ARTIC_UsrNuevoIngreso    = NULL
, ARTIC_FecNuevoIngreso    = NULL
FROM BDVelSoft..MAES_Articulos

INSERT INTO dbo.Precios
        (  [ZONAS_Codigo]                               , [ARTIC_Codigo]                               , [TIPOS_CodTipoMoneda]                               , [PRECI_Precio]                               
, [PRECI_TipoCambio]                               , [PRECI_UsrCrea]                               , [PRECI_FecCrea]                               , [PRECI_UsrMod]                               
, [PRECI_FecMod]                               
        )
 
 SELECT 
 ZONAS_Codigo              = '54.00'
, ARTIC_Codigo     
, TIPOS_CodTipoMoneda      = CASE TIPOS_MON WHEN 'MON02' THEN 'MND2' ELSE 'MND1' END
, PRECI_Precio             = ARTIC_Costo
, PRECI_TipoCambio         = 3.0
, PRECI_UsrCrea            = 'SISTEMAS'
, PRECI_FecCrea            = GETDATE()
, PRECI_UsrMod             = NULL 
, PRECI_FecMod             = NULL 
FROM BDVelSoft..MAES_Articulos


INSERT INTO Ventas.VENT_ListaPreciosArticulos
        (  [ZONAS_Codigo]                               , [LPREC_Id]                               , [ARTIC_Codigo]                               , [ALPRE_Constante]                               
         , [ALPRE_PorcentaVenta]                               , [ALPRE_UsrCrea]                               , [ALPRE_FecCrea]                               
        )
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante       = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 0
UNION
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante     = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 1
UNION
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante     = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 2
UNION
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante     = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 3
UNION
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante     = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 4
UNION
SELECT   ZONAS_Codigo     = '54.00'
, LPREC_Id     
, ARTIC_Codigo     = ART.ARTIC_Codigo
, ALPRE_Constante     = 5
, ALPRE_PorcentaVenta    = 5 
, ALPRE_UsrCrea         = 'SISTEMAS'
, ALPRE_FecCrea         = GETDATE()
FROM   BDVelSoft..MAES_Articulos ART
LEFT JOIN Ventas.VENT_ListaPrecios LPRE ON LPRE.LPREC_Id = 5

SELECT * FROM Ventas.VENT_ListaPrecios

SELECT * FROM BDVelSoft..MAES_Articulos
SELECT * FROM BDVelSoft..MAES_Tipos WHERE TIPOS_Codigo LIKE 'mon%'



SELECT * FROM dbo.Zonas

SELECT * FROM dbo.Precios
exec ARTICSS_CargarPrecios @ZONAS_Codigo=N'54.00',@Linea=N'0201',@Cadena=N'',@TipoConsulta=N'P',@PERIO_Codigo=N'2018',@ALMAC_Id=1


SELECT * FROM dbo.Periodos

UPDATE Periodos SET PERIO_Codigo = '2018', PERIO_Descripcion = 'PERIODO 2018' WHERE PERIO_Codigo ='2017'

--SELECT * FROM dbo.Articulos WHERE 
UPDATE Articulos SET ARTIC_Descontinuado = 0