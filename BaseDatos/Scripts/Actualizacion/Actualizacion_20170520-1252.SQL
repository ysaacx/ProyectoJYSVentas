USE BDSisSCC
go

CREATE TYPE [dbo].[TablaStockInicial] AS TABLE
(      [PERIO_Codigo]            [CodigoTipo]
     , [ARTIC_Codigo]            [CodArticulo]
     , [STINI_Cantidad]          [DECIMAL](14, 4)
)

--SELECT * FROM Logistica.LOG_StockIniciales

/*====================================================================================================*/
go
IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_STOCKSI_UnReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[LOG_STOCKSI_UnReg]

GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 18/05/2017
-- Descripcion         : Procedimiento de Inserción de la tabla StockIniciales
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSI_UnReg]
(	@PERIO_Codigo CodigoTipo,
	@ARTIC_Codigo CodArticulo,
	@ALMAC_Id CodAlmacen,
--	@STINI_Id Id,
	@STINI_Cantidad decimal(14, 4),
--	@STINI_Fecha Fecha,
	@Usuario Usuario
)
AS

IF EXISTS(SELECT * FROM Logistica.LOG_StockIniciales 
           WHERE PERIO_Codigo = @PERIO_Codigo AND ARTIC_Codigo = @ARTIC_Codigo AND ALMAC_Id = @ALMAC_Id)
   BEGIN 
      PRINT 'UPDATE'
      UPDATE Logistica.LOG_StockIniciales
         SET [STINI_Cantidad] = @STINI_Cantidad
           , [STINI_Fecha]    = GETDATE()
           , [STINI_UsrMod]   = @Usuario
           , [SYINI_FecMod]   = GetDate()
       WHERE PERIO_Codigo = @PERIO_Codigo
         And ALMAC_Id = @ALMAC_Id
         And ARTIC_Codigo = @ARTIC_Codigo
   END
ELSE
   BEGIN 
      PRINT 'INSERT'
        INSERT INTO Logistica.LOG_StockIniciales
            (	PERIO_Codigo            ,	ARTIC_Codigo            ,	ALMAC_Id            ,	STINI_Cantidad
            ,	STINI_Fecha             ,	STINI_UsrCrea           ,	STINI_FecCrea)
            VALUES
            (	@PERIO_Codigo           ,	@ARTIC_Codigo           ,	@ALMAC_Id           ,	@STINI_Cantidad
            ,	GETDATE()               ,	@Usuario                ,	GetDate()
            )
   END




GO
/*====================================================================================================*/
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_STINISI_CargarStockInicial]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[LOG_STINISI_CargarStockInicial]
GO
-- =============================================            
-- Autor - Fecha Crea  : Ysaacx - 26/12/2016
-- Descripcion         : Generacion de Asientos
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================         
CREATE PROCEDURE [dbo].[LOG_STINISI_CargarStockInicial]
( @Tabla         [TablaStockInicial] READONLY
, @Usuario	     VARCHAR(20) 
) AS            
BEGIN   
   PRINT 'Levantar Stock Inicial'

   SELECT * FROM @Tabla

END 

GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Facturas]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_Facturas] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Facturas]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id Id
)
As

Declare @RUC VarChar(14)
Set @RUC = (Select PARMT_Valor From Parametros Where PARMT_Id = 'Empresa')
Declare @Excepcion1 VarChar(14) Set @Excepcion1 = '20100241022'
Declare @Excepcion2 VarChar(14) Set @Excepcion2 = '20191731434'
Declare @Excepcion3 VarChar(14) Set @Excepcion3 = '20133207482'

/* Facturas Disponibles */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,ISNULL(Ven.DOCVE_DescripcionCliente, Ent.ENTID_RazonSocial) As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7), '')  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,IsNull(Ven.DOCVE_TipoCambio, TC.TIPOC_VentaSunat) As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND1' Then  Ven.DOCVE_TotalPagar / (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Dolares
	,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * (Case IsNull(Ven.DOCVE_TipoCambio, 0) When 0 Then TC.TIPOC_VentaSunat 
														Else Ven.DOCVE_TipoCambio
												  End)
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Soles
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
Into #Facturas
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado <> 'X'
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* Factura Anulada en otro Tiempo */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,Ent.ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Ven.TIPOS_CodTipoMoneda When 'MND2' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpDolares
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND2' Then  Ven.DOCVE_TotalPagar * TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Soles
	,Case Ven.TIPOS_CodTipoMoneda When 'MND1' Then Ven.DOCVE_TotalPagar Else 0.00 End As ImpSoles
	,Case Ven.TIPOS_CodTipoMoneda
		When 'MND1' Then  Ven.DOCVE_TotalPagar / TC.TIPOC_VentaSunat
		 Else  Ven.DOCVE_TotalPagar
		 End
	 As Dolares
	,Ven.ENTID_CodigoCliente As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven 
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Ven.ENTID_CodigoCliente
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Ven.TIPOS_CodTipoMoneda
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
	Left Join TipoCambio As TC On Convert(VarChar, TC.TIPOC_Fecha, 112) = Convert(VarChar, Ven.DOCVE_FechaDocumento, 112)
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And Ven.DOCVE_Estado = 'X'
	And Convert(Date, Ven.DOCVE_FecAnulacion) > @FecIni And Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
	And Not Ven.ENTID_CodigoCliente In (@RUC, @Excepcion1, @Excepcion2, @Excepcion3)
Union All /* Facturas Anuladas */
Select 1 As Orden
	,Convert(VarChar(250), '') As Titulo
	,Convert(VarChar(50), '01.- Documentos ') As Title
	,Ven.DOCVE_FechaDocumento As Fecha
	,'ANULADO' As ENTID_RazonSocial
	,IsNull(TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7)
		, '')  As Documento
	,'' As Moneda
	,0.00 As TCambioVenta
	,0.00 As ImpDolares
	,0.00 As Dolares
	,0.00 As ImpSoles	
	,0.00 As Soles	
	,'' As ENTID_Codigo
	,Ven.DOCVE_Codigo
	,Ven.DOCVE_Serie
	,Ven.DOCVE_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Ven.TIPOS_CodTipoDocumento
From Ventas.VENT_DocsVenta As Ven
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Ven.TIPOS_CodTipoDocumento
Where Convert(Date, Ven.DOCVE_FechaDocumento) Between @FecIni And @FecFin
	And DOCVE_Estado = 'X'
	And Not Ven.DOCVE_AnuladoCaja = 1
	And Ven.PVENT_Id = @PVENT_Id
/* Actualizar la Numeración de Fletes */
Update #Facturas
Set Titulo = (Select #Facturas.TIPOS_Descripcion + ' - (' + #Facturas.DOCVE_Serie + ') ' + RTrim(Min(DOCVE_Numero)) + ' - ' + RTrim(Max(DOCVE_Numero))
				   From #Facturas As Fle Where DOCVE_Serie = #Facturas.DOCVE_Serie
						And TIPOS_CodTipoDocumento = #Facturas.TIPOS_CodTipoDocumento
				  )
Update #Facturas Set Title = '01.- ' + Titulo 


Select * From #Facturas 
Order By DOCVE_Codigo


GO 
/***************************************************************************************************************************************/ 
GRANT EXECUTE
ON [dbo].[VENT_CCAJASS_Facturas]
TO [Ventas]
GO
/*====================================================================================================*/
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_STOCKSS_TodosPorPeriodo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[LOG_STOCKSS_TodosPorPeriodo]
GO
-- =============================================
-- Autor - Fecha Crea  : Generador - 18/05/2017
-- Descripcion         : Procedimiento de Selección de todos de la tabla StockIniciales
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_STOCKSS_TodosPorPeriodo]
(@PERIO_Codigo CodigoTipo)
AS

BEGIN 

SELECT STOCK.PERIO_Codigo
     , ARTIC.ARTIC_Codigo
     , ARTIC.ARTIC_Descripcion
     , STOCK.ALMAC_Id
     , ALMAC.ALMAC_Descripcion
     , STOCK.STINI_Cantidad     
  FROM Logistica.LOG_StockIniciales STOCK 
 INNER JOIN dbo.Articulos ARTIC ON ARTIC.ARTIC_Codigo = STOCK.ARTIC_Codigo
 INNER JOIN dbo.Almacenes ALMAC ON ALMAC.ALMAC_Id = STOCK.ALMAC_Id
 WHERE STOCK.PERIO_Codigo = @PERIO_Codigo
 ORDER BY PERIO_Codigo, ARTIC_Codigo

 
END 

GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VENT_CCAJASS_Ingresos]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[VENT_CCAJASS_Ingresos] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 22/06/2013
-- Descripcion         : 
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[VENT_CCAJASS_Ingresos]
(
	 @FecIni DateTime
	,@FecFin DateTime
	,@PVENT_Id BigInt
)
As

Print @FecIni
Print @FecFin
Declare @Orden SmallInt	Set @Orden = 3

/* Otros Ingresos */
/* Ingresos por Cancelacion en Efectivo */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,RECIB_Fecha As Fecha
	,'Resp: '
	 + IsNull((Case Rec.ENTID_Codigo When Null Then Pro.ENTID_RazonSocial Else Res.ENTID_RazonSocial End), IsNull(Rec.RECIB_RecibiDe, ''))
	 + ' / Concepto: ' + IsNull(Rec.RECIB_Concepto, '')
	 + ' / Recibo: ' + IsNull(Rec.RECIB_NroDocumento, '')
	 + ISNULL((Case Rec.DOCUS_Codigo When Null Then '' 
				Else (' / Prov:' + EntDoc.ENTID_Codigo + ' ' + EntDoc.ENTID_RazonSocial
					+ ' / Doc:' + TDoc.TIPOS_DescCorta + ' - ' + Doc.DOCUS_Serie + '-' + Right('0000000' + RTrim(Doc.DOCUS_Numero), 7)
					  )
			   End),'')
	 As ENTID_RazonSocial
	,Right(Rec.TIPOS_CodTipoRecibo, 2) + ' ' + Rec.RECIB_Serie + '-' + Right('0000000' + RTrim(Rec.RECIB_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Rec.TIPOS_CodTipoMoneda When 'MND2' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpDolares
	,Case Rec.TIPOS_CodTipoMoneda
		When 'MND1' Then  Rec.RECIB_Importe / TC.TIPOC_VentaSunat 												  
		 Else  Rec.RECIB_Importe
		End
	 As Dolares	
	,Case Rec.TIPOS_CodTipoMoneda When 'MND1' Then Rec.RECIB_Importe Else Convert(Decimal(14, 2), 0.00) End ImpSoles
	,Case Rec.TIPOS_CodTipoMoneda
		When 'MND2' Then  Rec.RECIB_Importe * TC.TIPOC_VentaSunat 												  
		 Else  Rec.RECIB_Importe
		End
	 As Soles
	,Rec.ENTID_Codigo As ENTID_Codigo
	,Rec.RECIB_Codigo As DOCVE_Codigo
	,Rec.RECIB_Serie As DOCVE_Serie
	,Rec.RECIB_Numero As DOCVE_Numero
	,'' As TipoDocumento
	,'' As TIPOS_Descripcion
	,Rec.TIPOS_CodTransaccion As TIPOS_CodTipoDocumento
Into #OtrosIngresos
From Tesoreria.TESO_Recibos As Rec
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Rec.TIPOS_CodTipoMoneda
	Left Join Entidades As Res On Res.ENTID_Codigo = Rec.ENTID_Codigo
	Left Join Entidades As Pro On Pro.ENTID_Codigo = Rec.ENTID_CodigoProveedor
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Rec.RECIB_Fecha, 112)
	Left Join Tesoreria.TESO_Documentos As Doc On Doc.DOCUS_Codigo = Rec.DOCUS_Codigo
	Left Join Tipos As TDoc On TDoc.TIPOS_Codigo = Doc.TIPOS_CodTipoDocumento
	Left Join Entidades As EntDoc On EntDoc.ENTID_Codigo = Doc.ENTID_Codigo
Where Convert(Date, Rec.RECIB_Fecha) Between @FecIni And @FecFin
	And Rec.TIPOS_CodTipoRecibo = 'CPDRI'
	And Rec.PVENT_Id = @PVENT_Id
	And Rec.RECIB_Estado <> 'X'
Union All /* Recibos de Pagos Anulados de Caja */
Select 2 As Orden
	,'Recibos de Ingresos' As Titulo
	,'02.- Recibos de Ingresos' As Title
	,Caj.CAJA_Fecha As Fecha
	,Ent.ENTID_RazonSocial + ' - Recibo de Ingreso por Anulación de Pago de ' 
						   + TDoc.TIPOS_Descripcion 
						   + ' Con ' + TPag.TIPOS_Descripcion
						   + ' Nro: ' + RTrim(DPago.DPAGO_Numero)
						   + ' /  Anulada el ' 
						   + CONVERT(VarChar(12), Caj.CAJA_FechaAnulado, 103) As ENTID_RazonSocial
	,TDoc.TIPOS_DescCorta + ' ' + Ven.DOCVE_Serie + '-' + Right('0000000' + RTrim(Ven.DOCVE_Numero), 7) As Documento
	,Mon.TIPOS_DescCorta As Moneda
	,TC.TIPOC_VentaSunat As TCambioVenta
	,Case Caj.TIPOS_CodTipoMoneda When 'MND2' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpDolares
	,Case Caj.TIPOS_CodTipoMoneda
		When 'MND1' Then  Caj.CAJA_Importe / TC.TIPOC_VentaSunat 												  
		 Else Caj.CAJA_Importe
		End
	 As Dolares	
	,Case Caj.TIPOS_CodTipoMoneda When 'MND1' Then Convert(Decimal(12, 4), Caj.CAJA_Importe) Else Convert(Decimal(14, 4), 0.00) End ImpSoles
	,Case Caj.TIPOS_CodTipoMoneda
		When 'MND2' Then  Caj.CAJA_Importe * TC.TIPOC_VentaSunat 												  
		 Else Caj.CAJA_Importe
		End
	 As Soles
	,'' As ENTID_Codigo
	,'' As RECIB_Codigo
	,Caj.CAJA_Serie
	,Caj.CAJA_Numero
	,TDoc.TIPOS_DescCorta As TipoDocumento
	,TDoc.TIPOS_Descripcion
	,Caj.TIPOS_CodTipoDocumento
From Tesoreria.TESO_Caja As Caj
	Inner Join Entidades As Ent On Ent.ENTID_Codigo = Caj.ENTID_Codigo
	Inner Join Tipos As TDoc On TDoc.TIPOS_Codigo = Caj.TIPOS_CodTipoDocumento
	Inner Join Tipos As TPag On Tpag.TIPOS_Codigo = Caj.TIPOS_CodTransaccion
	Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Caj.TIPOS_CodTipoMoneda
	Left Join Tesoreria.TESO_CajaDocsPago As CDoc On CDoc.CAJA_Codigo = Caj.CAJA_Codigo
	Left Join Ventas.VENT_DocsVenta As Ven On Ven.DOCVE_Codigo = Caj.DOCVE_Codigo
	Left Join Tesoreria.TESO_DocsPagos As DPago On DPago.DPAGO_Id = CDoc.DPAGO_Id
	Left Join TipoCambio As TC On Convert(Varchar,TC.TIPOC_Fecha, 112) = Convert(Varchar, Caj.CAJA_Fecha, 112)
Where Caj.CAJA_AnuladoCaja = 1
	And Convert(Date, Caj.CAJA_FechaAnulado) Between @FecIni And @FecFin
	And Caj.PVENT_Id = @PVENT_Id

Select * From #OtrosIngresos
Order By Orden


GO 
/***************************************************************************************************************************************/ 

GRANT EXECUTE
ON [dbo].[VENT_CCAJASS_Ingresos]
TO [Ventas]
GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[HIST_ARTICSS_ObtenerHistorialPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[HIST_ARTICSS_ObtenerHistorialPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[HIST_ARTICSS_ObtenerHistorialPrecios]
(
     @ARTIC_Codigo CodArticulo
     ,@ZONAS_Codigo vARcHAR(5)
     ,@Cantidad Integer
)
As

Select Top (@Cantidad)
     *
From Historial.Precios
Where ARTIC_Codigo = @ARTIC_Codigo
Order By PRECI_Id Desc

Declare @Precio Integer
Set @Precio = (Select COUNT(*) From Ventas.VENT_ListaPrecios)


--Select LPREC_Id, LPREC_Codigo, LPREC_Descripcion, LPREC_Comision From Ventas.VENT_ListaPrecios Where ZONAS_Codigo = @ZONAS_Codigo

  SELECT TOP (@Cantidad * @Precio)
         Pre.PRECI_Id
       , Pre.ARTIC_Codigo   
       , Lista.LPREC_Id
       --,Pre.PRECI_Precio
       , (LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PRECI_Precio
       , LArt.ALPRE_PorcentaVenta
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Pre.TIPOS_CodTipoMoneda
       , LArt.ALPRE_Constante
    FROM Historial.Precios As Pre 
   Inner Join Articulos As Art On Art.ARTIC_Codigo = Pre.ARTIC_Codigo
   Inner Join Historial.VENT_ListaPreciosArticulos As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo
    And Pre.PRECI_Id = LArt.PRECI_Id
   Inner Join Ventas.VENT_ListaPrecios As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
   Inner Join Tipos As Mon On Mon.TIPOS_Codigo = Pre.TIPOS_CodTipoMoneda
   WHERE Pre.ARTIC_Codigo = @ARTIC_Codigo
   ORDER By PRECI_Id Desc, ARTIC_Codigo


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ARTICSS_CargarPrecios]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[ARTICSS_CargarPrecios] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 05/02/2013
-- Descripcion         : Obtiene Obtiene los precios de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[ARTICSS_CargarPrecios]
(
      @ZONAS_Codigo VarChar(5)
    , @Linea CodigoLinea = Null
    , @Cadena VarChar(50)
    , @Fecha DateTime = NULL
    , @TipoConsulta CHAR(1) = NULL    
)
As

/*
   M => Modificados
   P => Productos
*/

Declare @TipoCambio Decimal(10, 4)
Set @TipoCambio = (Select TIPOC_VentaOficina From TipoCambio Where TIPOC_Fecha = (Select MAX(TIPOC_Fecha) From TipoCambio Where IsNull(TIPOC_VentaOficina, 0) > 0))

 SELECT Art.ARTIC_Codigo
      , ARTIC_Descripcion
      , Pre.PRECI_Precio 
      , CASE Pre.TIPOS_CodTipoMoneda When 'MND2' Then Pre.PRECI_Precio Else Pre.PRECI_Precio / Pre.PRECI_TipoCambio End PrecioDolares
        --, Pre.PRECI_Precio
        --,Pre.PRECI_TipoCambio
      , @TipoCambio As PRECI_TipoCambio
      , Pre.PRECI_FecMod
   INTO #ART
   FROM Articulos As Art
  INNER JOIN Precios As Pre ON Pre.ARTIC_Codigo = Art.ARTIC_Codigo 
    AND ZONAS_Codigo = @ZONAS_Codigo
    AND Convert(Date, IsNull(Pre.PRECI_FecMod, Pre.PRECI_FecCrea)) >= IsNull(@Fecha, Convert(Date, IsNull(Pre.PRECI_FecMod, Pre.PRECI_FecCrea)))
  WHERE LINEA_Codigo Like CASE ISNULL(@TipoConsulta, 'P') 
                                             WHEN 'P' THEN ISNULL(@Linea, LINEA_Codigo) + '%'
                                             WHEN 'M' THEN '%'
                                        END 
                                        --ISNULL(@Linea, LINEA_Codigo) + '%'
    AND ARTIC_Descripcion Like '%' + @Cadena + '%'
    AND ARTIC_Descontinuado <> 1
    AND ISNULL(ARTIC_NuevoIngreso, 0) = CASE ISNULL(@TipoConsulta, 'P') 
                                             WHEN 'P' THEN 0
                                             WHEN 'M' THEN 1
                                        END 
  ORDER BY Art.ARTIC_Orden
    
 SELECT * FROM #ART

 SELECT LPREC_Id, LPREC_Codigo, LPREC_Descripcion, LPREC_Comision 
      FROM VENTAS.VENT_ListaPrecios Where ZONAS_Codigo = @ZONAS_Codigo

  SELECT Pre.ARTIC_Codigo
       , Lista.LPREC_Id
         --,Pre.PRECI_Precio
       , (LArt.ALPRE_PorcentaVenta + 100) * Pre.PRECI_Precio/100 As PRECI_Precio
       , LArt.ALPRE_PorcentaVenta
       , Mon.TIPOS_DescCorta As TIPOS_TipoMoneda
       , Pre.TIPOS_CodTipoMoneda
       , LArt.ALPRE_Constante
    into #LPrecios
    FROM Precios As Pre 
   INNER JOIN Articulos As Art On Art.ARTIC_Codigo = Pre.ARTIC_Codigo And Art.ARTIC_Descontinuado <> 1
   INNER JOIN Ventas.VENT_ListaPreciosArticulos As LArt On LArt.ARTIC_Codigo = Art.ARTIC_Codigo And LArt.ZONAS_Codigo = @ZONAS_Codigo
   INNER JOIN Ventas.VENT_ListaPrecios As Lista On Lista.LPREC_Id = LArt.LPREC_Id And Lista.ZONAS_Codigo = LArt.ZONAS_Codigo
   INNER JOIN Tipos As Mon On Mon.TIPOS_Codigo = Pre.TIPOS_CodTipoMoneda
   WHERE 
            --Art.LINEA_Codigo Like CASE ISNULL(@TipoConsulta, 'P') 
            --                        WHEN 'P' THEN IsNull(@Linea, LINEA_Codigo) + '%'
            --                        WHEN 'M' THEN '%'
            --                   END 
            --                   --IsNull(@Linea, LINEA_Codigo) + '%'
    --ARTIC_Descripcion Like '%' + @Cadena + '%'
        Pre.ZONAS_Codigo = @ZONAS_Codigo
    AND Art.ARTIC_Codigo IN (SELECT ARTIC_Codigo FROM #ART)
  ORDER BY Pre.ARTIC_Codigo, Lista.LPREC_Id


    
       --AND ZONAS_Codigo + '-' + rtrim(LPREC_Id) in (SELECT ZONAS_Codigo + '-' + rtrim(LPREC_Id) FROM #LPrecios)

  SELECT * FROM #LPrecios


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSS_ObtenerSaldoEntrega]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DOCCOSS_ObtenerSaldoEntrega] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 21/05/2013
-- Descripcion         : Obtener el stock actual de un articulo
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DOCCOSS_ObtenerSaldoEntrega]
(
	 @DOCCO_Codigo VarChar(12)
)
As

Select Art.ARTIC_Codigo
	,DetOrd.DOCCD_Item
	,Art.ARTIC_Descripcion, TUni.TIPOS_Descripcion As TIPOS_UnidadMedida
	,DetOrd.DOCCD_Cantidad As INGCD_CantidadTotal
	,Art.TIPOS_CodUnidadMedida As TIPOS_CodUnidadMedida
	,IsNull(Det.INGCD_Cantidad, 0.0) As Entregado
	,IsNull(DetOrd.DOCCD_Cantidad, 0.0) - IsNull(Det.INGCD_Cantidad, 0.0) As INGCD_Cantidad
	,IsNull(DetOrd.DOCCD_PesoUnitario, 0.0) As INGCD_PesoUnitario
From Logistica.ABAS_DocsCompraDetalle As DetOrd
	Left Join (
		Select ARTIC_Codigo, Sum(Det.INGCD_Cantidad) As INGCD_Cantidad
			from Logistica.ABAS_IngresosCompra As Ing
				Inner Join Logistica.ABAS_IngresosCompraDetalle As Det
					On Det.INGCO_Id = Ing.INGCO_Id
						And Det.ALMAC_Id = Ing.ALMAC_Id
						And Not INGCO_Estado = 'X'
			Where Ing.ORDCO_Codigo = @DOCCO_Codigo
		Group By ARTIC_Codigo
	) As Det 
		On Det.ARTIC_Codigo = DetOrd.ARTIC_Codigo
	Inner Join Articulos As Art
		On Art.ARTIC_Codigo = DetOrd.ARTIC_Codigo
	Inner Join Tipos As TUni
		On TUni.TIPOS_Codigo = Art.TIPOS_CodUnidadMedida
Where DetOrd.DOCCO_Codigo = @DOCCO_Codigo


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[HIST_PRECISI_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
    DROP PROCEDURE [dbo].[HIST_PRECISI_UnReg] 
GO 

-- =============================================
-- Autor - Fecha Crea  : Generador - 06/02/2013
-- Descripcion         : Procedimiento de Inserción de la tabla Precios
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[HIST_PRECISI_UnReg]
(   @ZONAS_Codigo CodigoZona,
    @PRECI_Id Id,
    @ARTIC_Codigo CodArticulo,
    @TIPOS_CodTipoMoneda CodigoTipo = null ,
    @PRECI_Precio Importe = null ,
    @PRECI_TipoCambio Importe4D = null ,
    @Usuario Usuario
)

AS


INSERT INTO Historial.Precios
(   PRECI_Id                        , ZONAS_Codigo           , ARTIC_Codigo     , TIPOS_CodTipoMoneda
,   PRECI_Precio                    , PRECI_TipoCambio       , PRECI_UsrCrea    , PRECI_FecCrea
,   AUDIT_Fecha                     , AUDIT_HostName            , AUDIT_Operacion    , AUDIT_ServerName
,   AUDIT_DataBase                  , AUDIT_BDUsuario           , AUDIT_Aplicacion

)
VALUES
(   @PRECI_Id
,   @ZONAS_Codigo
,   @ARTIC_Codigo
,   @TIPOS_CodTipoMoneda
,   @PRECI_Precio
,   @PRECI_TipoCambio
,   @Usuario
,   GetDate()
,   Getdate()                       ,HOST_NAME()                ,'DELETED'          ,@@SERVERNAME 
,   db_name()                       ,SUSER_SNAME()              ,APP_NAME()
)

   UPDATE dbo.Articulos
      SET ARTIC_NuevoIngreso = 0
        , ARTIC_UsrMod = @Usuario
        , ARTIC_FecMod = GETDATE()
    WHERE ARTIC_Codigo = @ARTIC_Codigo


GO
/*====================================================================================================*/
GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LOG_DOCCOSS_TodosDocCompra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra] 
GO 
-- =============================================
-- Autor - Fecha Crea  : Ysaacx - 06/09/2012
-- Descripcion         : Obtener el listado de Documentos de Compra
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[LOG_DOCCOSS_TodosDocCompra]
(
     @ZONAS_Codigo VarChar(5)
    ,@SUCUR_Id SmallInt
    ,@Cadena VarChar(50)
    ,@Opcion SmallInt
    ,@Todos Bit
    ,@FecIni DateTime
    ,@FecFin DateTime
)
As

   SELECT Ent.ENTID_RazonSocial As ENTID_Proveedor
        , Alma.ALMAC_Descripcion As ALMAC_Descripcion
        , TDoc.TIPOS_DescCorta As TIPOS_Documento
        , TMone.TIPOS_DescCorta As TIPOS_TipoMoneda
        , TPag.TIPOS_Descripcion As TIPOS_TipoPago
        , RTrim(DocCo.DOCCO_Numero) As DOCCO_Numero
        , EstadoCosteo = CASE WHEN (SELECT COUNT(*) FROM Logistica.ABAS_Costeos COST 
                                     WHERE COST.DOCCO_Codigo = DocCo.DOCCO_Codigo
                                       AND COST.ENTID_CodigoProveedor = DocCo.ENTID_CodigoProveedor) > 0
                              THEN 'C' 
                              ELSE 'N' 
                         END 
        , DocCo.*
     FROM Logistica.ABAS_DocsCompra As DocCo 
    INNER JOIN dbo.Entidades As Ent On Ent.ENTID_Codigo = DocCo.ENTID_CodigoProveedor
    INNER JOIN dbo.Almacenes As Alma On Alma.ALMAC_Id = DocCo.ALMAC_Id
    INNER JOIN dbo.Tipos As TDoc On TDoc.TIPOS_Codigo = DocCo.TIPOS_CodTipoDocumento
    INNER JOIN dbo.Tipos As TMone On TMone.TIPOS_Codigo = DocCo.TIPOS_CodTipoMoneda
    INNER JOIN dbo.Tipos As TPag On TPag.TIPOS_Codigo = DocCo.TIPOS_CodTipoPago 
    WHERE Alma.SUCUR_Id = @SUCUR_Id
      AND Alma.ZONAS_Codigo = @ZONAS_Codigo
      AND Convert(Date, DocCo.DOCCO_FechaDocumento) Between @FecIni AND @FecFin
      AND (Case @Opcion When 0 Then Ent.ENTID_RazonSocial 
                      When 1 Then DocCo.DOCCO_Codigo
                      Else Ent.ENTID_RazonSocial 
           END) Like '%' + @Cadena + '%' 
      AND DocCo.DOCCO_Estado In (Case @Todos When 1 Then (DocCo.DOCCO_Estado) Else ('I') End) 
    ORDER By DOCCO_Codigo ASC



GO
/*====================================================================================================*/

