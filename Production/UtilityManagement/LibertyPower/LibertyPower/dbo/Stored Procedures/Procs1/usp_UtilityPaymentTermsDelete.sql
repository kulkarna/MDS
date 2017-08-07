CREATE PROCEDURE	[dbo].usp_UtilityPaymentTermsDelete
	 @rowID INT
AS
BEGIN
	DELETE FROM [LibertyPower].[dbo].[UtilityPaymentTerms]
	WHERE ID = @rowID
END
