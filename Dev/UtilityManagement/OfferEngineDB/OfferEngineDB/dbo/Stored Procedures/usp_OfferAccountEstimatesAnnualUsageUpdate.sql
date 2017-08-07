
/*******************************************************************************
 * [usp_OfferAccountEstimatesAnnualUsageUpdate]
 * To update estimated annual usage and usage end date for account
 *
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountEstimatesAnnualUsageUpdate]
	@UtilityCode	varchar(50),
	@AccountNumber	varchar(50),
	@EstimatedAnnualUsage bigint,
	@ClearEstimatedAnnualUsage bit
AS
	
IF @ClearEstimatedAnnualUsage = 0
BEGIN
	UPDATE dbo.OE_ACCOUNT WITH (ROWLOCK) SET EstimatedAnnualUsage = @EstimatedAnnualUsage, IsAnnualUsageEstimated = 1
	WHERE UTILITY = @UtilityCode
	AND ACCOUNT_NUMBER = @AccountNumber
END 
ELSE 
BEGIN
	UPDATE dbo.OE_ACCOUNT WITH (ROWLOCK) SET EstimatedAnnualUsage = NULL, IsAnnualUsageEstimated = 0
	WHERE UTILITY = @UtilityCode
	AND ACCOUNT_NUMBER = @AccountNumber

END	




