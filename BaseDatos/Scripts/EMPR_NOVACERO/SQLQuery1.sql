sp_helptext EMPRSS_GetConexion


exec EMPRSS_GetConexion @APLI_Codigo=N'VTA',@EMPR_Codigo=N'JAYVI'

SELECT * FROM UsuariosAplicaciones WHERE EMPR_Codigo = 'JAYVI'
SELECT * FROM UsuariosAplicaciones WHERE EMPR_Codigo = 'NOVAC'

SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo = 'NOVAC'
SELECT * FROM dbo.UsuariosEmpresas WHERE EMPR_Codigo = 'JAYVI'

SELECT * FROM dbo.Empresas

SELECT * FROM #TMP
UPDATE #TMP SET EMPR_Codigo = 'JAYVI'

INSERT INTO UsuariosEmpresas 
SELECT * FROM #TMP

INSERT INTO dbo.UsuariosAplicaciones
        ( USER_IdUser ,
          EMPR_Codigo ,
          APLI_Codigo ,
          APLI_UsrCrea ,
          APLI_FecCrea
        )
VALUES  ( 104 , -- USER_IdUser - int
          'JAYVI' , -- EMPR_Codigo - char(5)
          'VTA' , -- APLI_Codigo - char(3)
          'sistemas' , -- APLI_UsrCrea - Usuario
          '2022-04-08'  -- APLI_FecCrea - Fecha
        ) 


USE BDNOVACERO


 SELECT  * 
 FROM dbo.UsuariosPorPuntoVenta
 WHERE 
  ZONAS_Codigo = '83.00' AND  SUCUR_Id = 1 AND  PVENT_Id = 1 AND  ENTID_Codigo = '00000000'

Select m_puntoventa.* , n_sucursales.SUCUR_Nombre As SUCUR_Nombre
, n_almacenes.ALMAC_Descripcion As ALMAC_Nombre
 From dbo.PuntoVenta As m_puntoventa 
 Inner Join dbo.Sucursales As n_sucursales On n_sucursales.SUCUR_Id = m_puntoventa.SUCUR_Id And n_sucursales.ZONAS_Codigo = m_puntoventa.ZONAS_Codigo
 Inner Join dbo.Almacenes As n_almacenes On n_almacenes.ALMAC_Id = m_puntoventa.ALMAC_Id And n_almacenes.ZONAS_Codigo = m_puntoventa.ZONAS_Codigo WHERE   ISNULL(m_PuntoVenta.PVENT_Activo, '') = 1 AND ISNULL(CONVERT(VARCHAR(100), m_PuntoVenta.PVENT_Descripcion), '') Like '%%'

 UPDATE PuntoVenta SET PVENT_BaseDatos = 'BDNOVACERO', PVENT_BaseDatosAC = 'BDNOVACERO'


         SELECT  * 
 FROM dbo.UsuariosPorPuntoVenta
 WHERE 
  ZONAS_Codigo = '83.00' AND  SUCUR_Id = 1 AND  PVENT_Id = 1 AND  ENTID_Codigo = '00000000'
