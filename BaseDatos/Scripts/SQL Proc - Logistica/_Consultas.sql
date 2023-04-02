--USE BDSisSCC
--USE BDInkaPeru
USE BDJAYVIC
GO
exec ARTICSS_UnRegistro @ARTIC_Codigo=N'0101001',@ZONAS_Codigo=N'84.00'



exec VENTSS_ObtenerArticulos @PERIO_Codigo=N'2022',@ALMAC_Id=1,@ZONAS_Codigo=N'84.00',@LINEA_Codigo=N'0101'