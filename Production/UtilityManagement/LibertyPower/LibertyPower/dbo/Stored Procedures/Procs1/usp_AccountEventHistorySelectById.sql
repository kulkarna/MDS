
/*******************************************************************************
 * usp_AccountEventHistorySelectById
 * Select account event record by record id
 *
 * History
 *******************************************************************************
 * 4/8/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountEventHistorySelectById]                                                                                    
	@Id	int
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
	WHERE	ID = @Id

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

