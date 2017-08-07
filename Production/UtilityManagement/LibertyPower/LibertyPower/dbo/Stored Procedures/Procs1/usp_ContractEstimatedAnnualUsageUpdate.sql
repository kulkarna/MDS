/*******************************************************************************
 * usp_ContractEstimatedAnnualUsageUpdate
 * Updates estimated annual usage for specified contract number
 *
 * History
 *******************************************************************************
 * 3/30/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ContractEstimatedAnnualUsageUpdate]
	@ContractNumber			varchar(50),
	@EstimatedAnnualUsage	int
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	Libertypower..[Contract]
	SET		EstimatedAnnualUsage = @EstimatedAnnualUsage
	WHERE	Number = @ContractNumber

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
