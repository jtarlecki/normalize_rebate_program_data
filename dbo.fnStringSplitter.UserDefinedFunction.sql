USE [RebatePrograms]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jay Tarlecki
-- Create date: 05/05/2014
-- Description:	Pass in a string and a delimeter
--				The string is split by the delimeter
--				And a table list of strings is returned
-- =============================================
CREATE FUNCTION [dbo].[fnStringSplitter] 
(
	@argsstring VARCHAR(MAX)	-- String to be split
	,@delimeter VARCHAR(50)		-- Delimiter
)
RETURNS @tmp TABLE (token VARCHAR(MAX) NOT NULL)
AS
BEGIN

DECLARE @tokenstring VARCHAR(MAX)
	,@currdelpos INT
	,@nextdelpos INT
	,@tempstring VARCHAR(MAX)

IF @argsstring IS NOT NULL AND LEN(@argsstring) > 0
BEGIN
	SET @tempstring = @argsstring + @delimeter
	SET @currdelpos = CHARINDEX(@delimeter, @tempstring)
	WHILE @currdelpos > 0
	BEGIN
		SET @tokenstring = SUBSTRING(@tempstring, 1, @currdelpos - 1)
		INSERT INTO @tmp(token) VALUES(RTRIM(LTRIM(@tokenstring)))
		SET @tempstring = SUBSTRING(@tempstring, @currdelpos + 1, LEN(@tempstring))
		SET @currdelpos = CHARINDEX(@delimeter, @tempstring)
	END
END

RETURN

END
GO
