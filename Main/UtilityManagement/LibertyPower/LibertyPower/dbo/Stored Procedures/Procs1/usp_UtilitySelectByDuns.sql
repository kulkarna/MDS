
CREATE PROCEDURE [dbo].[usp_UtilitySelectByDuns]
@Duns Varchar (50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	d.UtilityCode, d.MarketCode, f.FieldDelimiter,f.RowDelimiter
	FROM	UtilityDuns d
	INNER	JOIN UtilityFileDelimiters f
	ON		d.UtilityCode = f.UtilityCode
	WHERE	d.DunsNumber = @Duns


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

