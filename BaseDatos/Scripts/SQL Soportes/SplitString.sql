--USE Doral_2018
--USE ConsejerosNSCAsistencia
--USE Sermedi_2018
--USE ColegioSSCC_2018
--USE EMBIDSAC2010_2018
--USE BDInkaPeru
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SplitString]') AND Type = 'TF') 
       DROP FUNCTION [dbo].[SplitString] 
GO 
CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Tabla TABLE 
(Item VarChar(20))
AS
BEGIN

       Declare @individual varchar(20) = null
       --Declare @Tabla Table(Resultado VarChar(20))

       WHILE LEN(@Input) > 0
       BEGIN
             IF PATINDEX('%' + @Character + '%', @Input) > 0
             BEGIN
                      SET @individual = SUBSTRING(@Input, 0, PATINDEX('%' + @Character + '%', @Input))
                      --SELECT @individual

                      SET @Input = SUBSTRING(@Input, LEN(@individual + @Character) + 1, LEN(@Input))
                      INSERT INTO @Tabla Values(@individual)
             END
             ELSE
             BEGIN
                      SET @individual = @Input
                      SET @Input = NULL
                      INSERT INTO @Tabla Values(@individual)
                      --SELECT @individual
             END
       END

       --select * from @Tabla
       RETURN
END
GO
