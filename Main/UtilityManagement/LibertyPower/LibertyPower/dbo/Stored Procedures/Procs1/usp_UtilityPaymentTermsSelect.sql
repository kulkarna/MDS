CREATE PROCEDURE	[dbo].usp_UtilityPaymentTermsSelect
	@utilityCode Varchar(50)  = '0',
	@marketID Int = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	   upt.ID
	  ,upt.[UtilityId]
      ,upt.[MarketId]
      ,upt.[ARTerms]
      ,upt.[BillingTypeID]
      ,upt.[AccountTypeID]            
	FROM 
		[LibertyPower].[dbo].[UtilityPaymentTerms] upt
		inner join LibertyPower.dbo.Utility u On u.ID = upt.utilityID
		inner join LibertyPower.dbo.Market m On m.ID = upt.MarketId
	WHERE 
		(u.UtilityCode = @utilityCode OR @utilityCode = '0') 
		AND
		(m.ID = @marketID OR @marketID = 0)
	SET NOCOUNT OFF
END
