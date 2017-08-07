/***************************** [dbo].[usp_UtilityIdrEdiSelect] ********************/
CREATE PROCEDURE [dbo].[usp_UtilityIdrEdiSelect]
				@UtilityCode as varchar(15)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	isIDR_EDI_Capable
	FROM	Utility WITH (NOLOCK)
	WHERE	UtilityCode = @UtilityCode

    SET NOCOUNT OFF;
END
