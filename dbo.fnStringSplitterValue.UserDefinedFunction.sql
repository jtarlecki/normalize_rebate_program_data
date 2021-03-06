USE [RebatePrograms]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jay Tarlecki
-- Create date: 05/05/2014
-- Description:	Pass in a string and a delimeter and a positon
--				The string is split by the delimeter
--				And returns a single sting, basd on position passed in
-- =============================================
CREATE FUNCTION [dbo].[fnStringSplitterValue] 
(
	-- Add the parameters for the function here
	@argsstring VARCHAR(MAX),	-- string to be split
	@delimeter VARCHAR(50),		-- delimeter
	@valuepos INT = 1			-- value to be returned in this position
								-- starting position is 1
								-- if the position is greater than the number of split
								-- values, it will return the last one.
)
RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @val VARCHAR(MAX)
DECLARE @tokenstring VARCHAR(MAX)
DECLARE @currdelpos INT
DECLARE @nextdelpos INT
DECLARE @tempstring VARCHAR(MAX)
DECLARE @tempvalpos INT

SET @tempvalpos = 0

IF @argsstring IS NOT NULL AND LEN(@argsstring) > 0
BEGIN
	SET @tempstring = @argsstring + @delimeter
	SET @currdelpos = CHARINDEX(@delimeter, @tempstring)
	WHILE(@currdelpos > 0 AND @tempvalpos < @valuepos)
	BEGIN
		SET @tokenstring = SUBSTRING(@tempstring, 1, @currdelpos - 1)
		SET @val = @tokenstring;
		SET @tempstring = SUBSTRING(@tempstring, @currdelpos + 1, LEN(@tempstring))
		SET @currdelpos = CHARINDEX(@delimeter, @tempstring)
		SET @tempvalpos = @tempvalpos + 1
	END
END

RETURN @val

END
GO
