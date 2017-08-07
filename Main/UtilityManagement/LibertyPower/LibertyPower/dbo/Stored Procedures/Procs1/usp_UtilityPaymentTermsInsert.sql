CREATE PROCEDURE	[dbo].usp_UtilityPaymentTermsInsert
	 @utilityID INT
	,@MarketID INT
	,@BillingTypeID INT
    ,@AccountTypeID INT
	,@ARTerm INT
AS
BEGIN
	INSERT INTO [LibertyPower].[dbo].[UtilityPaymentTerms]
	(MarketID,UtilityId,ARTerms,BillingTypeID,AccountTypeID)	
	VALUES(@MarketID,@utilityID,@ARTerm,@BillingTypeID,@AccountTypeID)	
END
