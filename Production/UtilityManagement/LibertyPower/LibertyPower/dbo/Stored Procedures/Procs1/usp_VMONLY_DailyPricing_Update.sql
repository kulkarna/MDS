

/*******************************************************************************
 * THIS PROC IS TO BE EXECUTED BY ITS CORRESPONDING JOB ONLY 
 *    IN THE VM ENVIRONMENT TO UPDATE PRICING FOR TESTING
 *
 * Updated: 1.31.2011
 * Al Tafur
 *  
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_VMONLY_DailyPricing_Update]
	
AS
BEGIN

/*
First update the current priceset
*/

update libertypower.dbo.productcrosspriceset
   set EffectiveDate = convert(varchar(20), getdate(), 101) + ' 00:00:00'										--TODAY'S DATE
     , ExpirationDate = convert(varchar(20),dateadd(d,1,convert(varchar(10), getdate(), 101) + ' 23:59:59' ))	-- TOMORROW'S DATE AT MIDNIGHT
 where ProductCrossPriceSetId = (select max(ProductCrossPriceSetId) 
								   from libertypower.dbo.productcrosspriceset (NOLOCK) 
								)

/*
NEXT UPDATE THE LEGACY PRODUCT/PRICE TABLE
*/

update lp_common..common_product_rate
   set eff_date = convert(varchar(20), getdate(), 101)																--TODAY'S DATE
     , due_date = convert(varchar(20),dateadd(d,1,convert(varchar(10), getdate(), 101) + ' 23:59:59' ))			-- TOMORROW'S DATE AT MIDNIGHT
     , inactive_ind = 0
 where 
   (
   eff_date > '1-15-2011'			--ENTER HERE THE DATE BEFORE THE REFRESH
   and Len(rate_id) > 5 
   and GrossMargin > 0
   )
   or product_id like '%flex%'

/*
CONFIRM THE PRICESET CONFIGURATION WORKS BY RUNNING THIS PROC 
EXPECTED RESULT SHOULD BE ONE RECORD (THE ONE YOU JUST UPDATED)
*/

exec usp_ProductCrossPriceSetGetCurrent

/*
CREATE A NEW CONTRACT IN DEAL CAPTURE AND VERIFY YOU SEE PRICING
*/

SELECT  TOP 1 [ProductCostRuleSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductCostRuleSet]
	WHERE EffectiveDate = (Select max(EffectiveDate)
							From ProductCostRuleSet 
							Where EffectiveDate <= getdate()
							AND [ExpirationDate] > getdate())
	AND [ExpirationDate] > getdate()	

	ORDER BY UploadedDate Desc    	;

/*
Now update the rule set
*/


update [LibertyPower].[dbo].[ProductCostRuleSet]
SET EffectiveDate = getdate() - 1 , ExpirationDate = getdate() + 1
where ProductCostRuleSetID =
(
	SELECT TOP 1 MAX(ProductCostRuleSetID)
	FROM  [LibertyPower].[dbo].[ProductCostRuleSet]

)
-- test rule set here , should come up with one row
exec usp_ProductCostRuleSetGetCurrent;
	
-- Copyright 2010 Liberty Power
End

