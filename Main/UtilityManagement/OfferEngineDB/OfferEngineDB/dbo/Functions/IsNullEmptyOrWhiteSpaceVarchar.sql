CREATE FUNCTION [dbo].[IsNullEmptyOrWhiteSpaceVarchar]( @text VARCHAR(MAX) )
RETURNS BIT
AS 
    BEGIN
		IF @text IS NULL
			RETURN 1
        SET @text = RTRIM(LTRIM(@text));
        IF DATALENGTH(@text) = 0
			RETURN 1
		RETURN 0
    END

