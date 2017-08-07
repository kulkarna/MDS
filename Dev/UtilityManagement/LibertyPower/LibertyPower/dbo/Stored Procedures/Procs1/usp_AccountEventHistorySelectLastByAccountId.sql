
/*******************************************************************************
 * usp_AccountEventHistorySelectLastByAccountId
 * Select last account event record by account id
 *
 * History
 *******************************************************************************
 * 5/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountEventHistorySelectLastByAccountId]                                                                                    
	@AccountId	char(12)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, ContractNumber, AccountId, ProductId, RateID, Rate, 
			RateEndDate, EventID, EventEffectiveDate, ContractType, ContractDate, 
			ContractEndDate, DateFlowStart, Term, AnnualUsage, GrossMarginValue, 
			AnnualGrossProfit, TermGrossProfit, AnnualGrossProfitAdjustment, 
			TermGrossProfitAdjustment, AnnualRevenue, TermRevenue, 
			AnnualRevenueAdjustment, TermRevenueAdjustment, AdditionalGrossMargin,
			SubmitDate, DealDate, SalesChannelId, SalesRep, EventDate, ProductTypeID
	FROM	AccountEventHistory WITH (NOLOCK)
	WHERE	ID = (	SELECT	ISNULL(MAX(ID), 0) 
					FROM	AccountEventHistory WITH (NOLOCK) 
					WHERE	AccountId = @AccountId ) 

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

