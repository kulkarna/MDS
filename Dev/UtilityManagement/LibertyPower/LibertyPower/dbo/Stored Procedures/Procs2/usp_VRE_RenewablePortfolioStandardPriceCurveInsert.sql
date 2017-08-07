
CREATE procedure [dbo].[usp_VRE_RenewablePortfolioStandardPriceCurveInsert] ( 
	 @FileContextGuid						UNIQUEIDENTIFIER
	,@Market                                VARCHAR(50)
	,@Month                                 INT	
	,@Year                                  INT
	,@Price                                 DECIMAL(18,6)
	,@CreatedBy								INT)
as

BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO VRERenewablePortfolioStandardPriceCurve (
		 FileContextGuid
		,Market
		,[Month]
		,[Year]
		,Price
		,CreatedBy)
	VALUES 
		(
		 @FileContextGuid
		,@Market
		,@Month
		,@Year
		,@Price
		,@CreatedBy)
	
	SELECT SCOPE_IDENTITY();
	
	SET NOCOUNT OFF;
	
End

-- Copywrite LibertyPower 01/27/2010

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RenewablePortfolioStandardPriceCurveInsert';

