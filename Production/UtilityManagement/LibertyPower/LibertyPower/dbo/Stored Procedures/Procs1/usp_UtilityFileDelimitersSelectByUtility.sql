
CREATE PROCEDURE [dbo].[usp_UtilityFileDelimitersSelectByUtility]
@Code varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT	ID, UtilityCode, RowDelimiter, FieldDelimiter
    FROM	UtilityFileDelimiters WITH (NOLOCK)
    WHERE	UtilityCode = @Code

    SET NOCOUNT OFF;
END

