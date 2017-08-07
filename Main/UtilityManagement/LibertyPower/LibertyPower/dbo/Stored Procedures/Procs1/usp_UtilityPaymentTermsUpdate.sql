
CREATE PROCEDURE	[dbo].usp_UtilityPaymentTermsUpdate
	 @rowID INT	
	,@BillingTypeID INT
    ,@AccountTypeID INT
	,@ARTerm INT
AS
BEGIN
	UPDATE  
		[LibertyPower].[dbo].[UtilityPaymentTerms]
	SET	
       [BillingTypeID] = @BillingTypeID
      ,[AccountTypeID] = @AccountTypeID
      ,[ARTerms] = @ARTerm		
	WHERE (ID = @rowID)
END
