USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountEventHistorySelectLastByEventId]    Script Date: 10/08/2012 16:50:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountEventHistorySelectLastByEventId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountEventHistorySelectLastByEventId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountEventHistorySelectLastByEventId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_AccountEventHistorySelectLastByEventId
 * Select last account event record by event
 *
 * History
 *******************************************************************************
 * 6/25/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountEventHistorySelectLastByEventId]  
	@ContractNumber	char(12),    
	@AccountId		char(12),                                                                                
	@EventId		int
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
					WHERE	@ContractNumber	= ContractNumber
					AND		AccountId		= @AccountId
					AND		EventID			= @EventId) 
					
    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

' 
END
GO
