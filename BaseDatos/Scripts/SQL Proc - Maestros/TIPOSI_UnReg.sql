GO 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TIPOSI_UnReg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) 
	DROP PROCEDURE [dbo].[TIPOSI_UnReg] 
GO 


-- =============================================
-- Autor - Fecha Crea  : Generador - 14/07/2010
-- Descripcion         : Procedimiento de Inserción de la tabla Tipos
-- Autor - Fecha Modif : 
-- Descripcion         : 
-- =============================================
CREATE PROCEDURE [dbo].[TIPOSI_UnReg]
(	@TIPOS_CODIGO CodigoTipo,
	@TIPOS_DESCRIPCION Descripcion = null ,
	@TIPOS_DESCCorta DescCorta = null ,
	@TIPOS_NUMERO DECIMAL(10,4) = null ,
	@TIPOS_ESTADO Estado = null ,
	@TIPOS_PROTEGIDO bit = null ,
	@Usuario Usuario
)

AS

Declare @Codigo As Integer
declare @nro as Integer
declare @tip as varchar(6)
if Exists(Select * from Tipos where TIPOS_CODIGO Like (RTrim(@TIPOS_CODIGO) + '%'))
Begin
	set @tip = (select max(TIPOS_Codigo) from Tipos where TIPOS_Codigo like (@TIPOS_CODIGO+'%'))
	set @nro = (select datalength(@tip))
	if (@nro = 6)
	 begin
			Set @Codigo = (Select MAX(Convert(Integer, right(tipos_Codigo, 3))) 
							from Tipos 
							where TIPOS_CODIGO Like (RTrim(@TIPOS_CODIGO) + '%')) + 1
	 end

	else 
	begin
		if(@nro = 5)
		begin
			Set @Codigo = (Select MAX(Convert(Integer, right(tipos_Codigo, 2))) 
							from Tipos 
							where TIPOS_CODIGO Like (RTrim(@TIPOS_CODIGO) + '%')) + 1
		end
		else
		begin
			Set @Codigo = (Select MAX(Convert(Integer, right(tipos_Codigo, 1))) 
							from Tipos 
							where TIPOS_CODIGO Like (RTrim(@TIPOS_CODIGO) + '%')) + 1							
	 	end
	end

End
Else
Begin
	Set @Codigo = 1
End

Set @TIPOS_CODIGO = RTrim(@TIPOS_CODIGO) + Right('000' + RTrim(@Codigo), @nro - 3)

INSERT INTO [Tipos]
(	TIPOS_CODIGO
,	TIPOS_DESCRIPCION
,	TIPOS_DESCCorta
,	TIPOS_NUMERO
,	TIPOS_ESTADO
,	TIPOS_PROTEGIDO
,	TIPOS_UsrCrea
,	TIPOS_FecCrea
)
VALUES
(	@TIPOS_CODIGO
,	@TIPOS_DESCRIPCION
,	@TIPOS_DESCCorta
,	@TIPOS_NUMERO
,	@TIPOS_ESTADO
,	@TIPOS_PROTEGIDO
,	@Usuario
,	GetDate()
)

GO 
/***************************************************************************************************************************************/ 

