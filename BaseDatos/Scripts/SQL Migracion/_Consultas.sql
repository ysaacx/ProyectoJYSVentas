USE BDAdmin
GO

SELECT *  FROM dbo.Procesos WHERE PROC_Codigo = 'PADPC'


SELECT * 
 FROM dbo.Clientes
 WHERE 
ENTID_Codigo = '20454595433'

USE BDAmbientaDecora

			Select m_Ent.* , IsNUll(ENTID_Direccion,'') + ' - ' + IsNull(Dis.UBIGO_Descripcion + ' / ' + Pro.UBIGO_Descripcion + ' / ' + Dep.UBIGO_Descripcion, '') As Direccion
			From dbo.Entidades As m_Ent 
				Left Join Ubigeos As Dep On Dep.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 2)
				Left Join Ubigeos As Pro On Pro.UBIGO_Codigo = LEFT(m_Ent.UBIGO_Codigo, 5)
				Left Join Ubigeos As Dis On Dis.UBIGO_Codigo = m_Ent.UBIGO_Codigo
			WHERE   m_Ent.ENTID_NroDocumento = '20454595433'
      
      


SELECT  * 
 FROM dbo.Clientes
 WHERE 
  ENTID_Codigo = '20454595433'




 SELECT  * 
 FROM dbo.Sucursales
 WHERE 
  ISNULL(SUCUR_Activo, '') = 1

  USE bdacnet

