USE BDInkaPeru
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPOSS_VentasTodos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[REPOSS_VentasTodos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 12/08/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[REPOSS_VentasTodos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
	,@Opcion SmallInt
	,@ENTID_Codigo VarChar(14) = Null
)
As

 SELECT 1 As Orden
	   , Convert(VarChar(250), '') As Titulo
	   , Ven.DOCVE_FechaDocumento
	   , ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	      --,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	   , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
	   , IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As DOCVE_TipoCambio
	   , Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImporteDolares
	   , CASE Ven.DOCVE_Estado WHEN 'X'
             THEN 0.00
             ELSE CASE Ven.TIPOS_CodTipoMoneda
	    	              WHEN 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
	    													            Else Ven.DOCVE_TipoCambio
	    											              End)
	    	         ELSE  Ven.DOCVE_TotalPagar
	    	         END
        END 
	     As ImporteSoles
	   , Ven.ENTID_CodigoCliente
	   , Ven.DOCVE_Codigo
	   , Ven.DOCVE_Serie
	   , Ven.DOCVE_Numero
	   , TDoc.TIPOS_DescCorta As TIPOS_TipoDocCorta
	   , TDoc.TIPOS_Descripcion
	   , Ven.TIPOS_CodTipoDocumento
	   , Ven.DOCVE_Estado
	   , Ven.DOCVE_AnuladoCaja
	   , Ven.DOCVE_FecAnulacion
   INTO #Facturas
   FROM Ventas.VENT_DocsVenta As Ven 
  INNER Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
  INNER Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
  WHERE Convert(Date, Ven.DOCVE_FechaTransaccion) Between @FecIni And @FecFin
	     --And Ven.DOCVE_Estado <> 'X'
	 And Ven.PVENT_Id = @PVENT_Id
	 And Ven.TIPOS_CodTipoDocumento <> 'CPDLE'
	 And Ven.ENTID_CodigoCliente = ISNULL(@ENTID_codigo, Ven.ENTID_CodigoCliente)

Update #Facturas
Set Titulo = (Select #Facturas.TIPOS_Descripcion + '/s - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
				   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
						And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
				  )
--Update #Facturas Set Title = '01.- ' + Titulo 
If @Opcion = 1 -- Todas las Ventas
	Select * From #Facturas Order By DOCVE_Codigo
If @Opcion = 2 -- Todas las Anuladas 
	Select * From #Facturas Where DOCVE_Estado = 'X' Order By DOCVE_Codigo
If @Opcion = 3 -- Anuladas Despues de la Fecha de Creacion
	Select * From #Facturas Where DOCVE_Estado = 'X' And DOCVE_AnuladoCaja = 1 Order By DOCVE_Codigo
If @Opcion = 4 -- Correlatividad
Begin
	Select * From #Facturas Order By DOCVE_Codigo
	Select TIPOS_CodTipoDocumento, DOCVE_Serie, TIPOS_TipoDocCorta From #Facturas Group By TIPOS_CodTipoDocumento, DOCVE_Serie, TIPOS_TipoDocCorta Order By TIPOS_CodTipoDocumento
End
If @Opcion = 5 -- Todas las Ventas
	Select * From #Facturas Order By DOCVE_Codigo



GO 
/***************************************************************************************************************************************/ 

exec REPOSS_VentasTodos @FecIni='2018-01-07 00:00:00',@FecFin='2018-07-07 00:00:00',@PVENT_Id=1,@Opcion=5,@ENTID_Codigo=N'20602257631'