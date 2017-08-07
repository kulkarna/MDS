CREATE FUNCTION [dbo].[NullIfEmptyOrWhiteSpaceVarchar]( @text VARCHAR(MAX) )
RETURNS VARCHAR(MAX)
AS 
    BEGIN
        IF dbo.IsNullEmptyOrWhiteSpaceVarchar(@text) = 1 
			RETURN NULL
		RETURN @text
    END

