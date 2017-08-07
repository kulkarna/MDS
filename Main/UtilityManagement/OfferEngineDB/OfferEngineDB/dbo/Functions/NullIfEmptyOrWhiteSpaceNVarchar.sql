CREATE FUNCTION [dbo].[NullIfEmptyOrWhiteSpaceNVarchar]( @text NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS 
    BEGIN
        IF dbo.IsNullEmptyOrWhiteSpaceNVarchar(@text) = 1 
			RETURN NULL
		RETURN @text
    END

