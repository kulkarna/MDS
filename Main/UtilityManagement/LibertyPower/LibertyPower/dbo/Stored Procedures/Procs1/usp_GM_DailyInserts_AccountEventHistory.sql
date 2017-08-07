-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GM_DailyInserts_AccountEventHistory] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- per INF97 going into PROD this stored procedure has been disabled.
	-- 10/22/2009 (Hector Gomez)
	return
-------------------------------------------------
-- The following statement will update the
-- Annual Usage in the AccountEventHistory
-- table only for those that have a proxy value
-- This step will also update the other fields
-- that need to be calculated in order to have
-- everything accurate.
-------------------------------------------------
-- Added by: Hector Gomez
-- Date: July 9, 2009
-------------------------------------------------
	UPDATE 
		LIBERTYPOWER.dbo.AccountEventHistory
	SET	
		ANNUALUSAGE = Acct.AnnualUsage
		, AnnualGrossProfit = ((GrossMarginValue * ACCT.AnnualUsage)/1000)  
		, TermGrossProfit = (((ACCT.AnnualUsage * GrossMarginValue * ContractTerm)/12)/1000)  
		, AnnualRevenue = (ACCT.AnnualUsage * Rate) 
		, TermRevenue = (((ACCT.AnnualUsage * Rate) * ContractTerm)/12) 
	FROM 
		LibertyPower.dbo.AccountEventHistory AEH,
		LP_Account.dbo.tblAccounts_vw Acct
	WHERE 
		accountid=account_id AND aeh.contractNumber =acct.contractNumber
		
		AND aeh.annualusage in ( -- Proxy Values
								SELECT Usage
								FROM LibertyPower.dbo.GrossMarginUsageProxy GMUP
								)
								
		 
		AND Acct.AnnualUsage > 0	-- Only Annual usage that actually has a value greater than zero.
		AND Acct.AnnualUsage <> AEH.AnnualUsage	-- Only Annual Usage that is different, this means that the usage was updated in Deal Capture.
		
	
	
	
	
	
---------------------------------------------	
-- NORMAL PROCESS TO UPDATE THE GM Values
---------------------------------------------	
	INSERT INTO LibertyPower.dbo.AccountEventHistory(
			ContractNumber, AccountId, ProductId, RateID, Rate, RateEndDate
			, EventID, EventEffectiveDate, ContractType, ContractDate, ContractEndDate
			, DateFlowStart, Term, AnnualUsage, GrossMarginValue, AnnualGrossProfit
			, TermGrossProfit, AnnualGrossProfitAdjustment, TermGrossProfitAdjustment
			, AnnualRevenue, TermRevenue, AnnualRevenueAdjustment, TermRevenueAdjustment
			, EventDate,SUbmitDate,DealDate,SalesChannelID,salesrep
		)

		SELECT DISTINCT
			ContractNumber, Account_ID, Product, RateID, Rate, RateEndDate
			, EventID, EventEffectiveDate, ContractType, ContractDate, ContractEndDate
			, DateFlowStart, ContractTerm, AnnualUsage, GrossMarginValue 
			,((GrossMarginValue * AnnualUsage)/1000)  AnnualGrossProfit
			, (((AnnualUsage * GrossMarginValue * ContractTerm)/12)/1000)  TermGrossProfit
			, AnnualGrossProfitAdjustment, TermGrossProfitAdjustment
			
			, (AnnualUsage * Rate) AnnualRevenue
			, (((AnnualUsage * Rate) * ContractTerm)/12) TermRevenue
			
			, AnnualRevenueAdjustment, TermRevenueAdjustment
			, EventDate
			,SubmitDate,DealDate,SalesChannelID,salesrep
			
			
		FROM (

				SELECT
				submitdate,			 
					ContractNumber
					, Account_ID
					, Product
					, Rate_ID RateID
					, product_category	
					, CASE
							WHEN Product_Category = 'FIXED' THEN PriceRate 
							ELSE PriceRate --0	-- Variable
					End Rate
					,COALESCE((
								SELECT	TOP 1 read_date
								FROM	lp_common..meter_read_calendar
								WHERE	calendar_year	= DATEPART(yyyy, Acct.Date_End)
								AND		calendar_month	= DATEPART(mm, Acct.Date_End)
								AND		utility_id		= Acct.Utility
								AND		read_cycle_id	= Acct.TripNumber
							),Acct.Date_End) RateEndDate
					--, CASE
					--	WHEN ContractType NOT LIKE '%RENEWAL%' THEN 1
					--	Else 2	-- Renewal event
					--END 
					,11 EventID	-- Initial Load
					, CASE
						WHEN ContractType NOT LIKE '%RENEWAL%' THEN Contract_Eff_Start_Date
						Else FlowStartDate
					END EventEffectiveDate	-- This is based off of the 
					, ContractType
					, Contract_Eff_Start_Date ContractDate
					, Date_End ContractEndDate
					, FlowStartDate DateFlowStart
					, ContractTerm
					, CASE
						WHEN Acct.AnnualUsage = 0 THEN
							-- Then get a proxy value
							COALESCE(
								(
									SELECT Usage
									FROM LibertyPower.dbo.GrossMarginUsageProxy GMUP
									WHERE GMUP.AccountType = Acct.AccountType
								)
								,0)
						ELSE Acct.AnnualUsage
					END AnnualUsage
		
		
		
	-- need to implement a logic that will look into the PRODUCT table and see if the field
	-- IS_CUSTOM is positive then get the grossmargin from the product otherwise continue with the
	-- flow below
		-- The following case definition was provided by Douglas
					, CASE
-- REMOVED 8/20/2009 per Douglas (by Hector), the following commented code was a temporary solution (for the initial load)					
					--WHEN product='CONED_FX_LCI' AND rate_id=9 THEN 0.25
					--	WHEN product='AEPCE_FA' AND rate_id=1 THEN 6.89
					--	WHEN product='AEPNO_MCPE_NOMC_ABC' AND rate_id=2461 THEN 6.89
					--	WHEN product='ALLEGMD_FA' AND rate_id=1 THEN 5.5
					--	WHEN product='ALLEGMD_FA' AND rate_id=3 THEN 5.75
					--	WHEN product='ALLEGMD_FA' AND rate_id=4 THEN 6.78
					--	WHEN product='BGE_FA' AND rate_id=1 THEN 5.5
					--	WHEN product='BGE_FA' AND rate_id=4 THEN 5.75
					--	WHEN product='BGE_FA' AND rate_id=5 THEN 6.78
					--	WHEN product='CENHUD_FA' AND rate_id=1 THEN 6.78
					--	WHEN product='CENHUD_FA_LCI' AND rate_id=1 THEN 0.5
					--	WHEN product='CLP_FA' AND rate_id=1 THEN 8.81
					--	WHEN product='COMED_IP_ABC' AND rate_id=3664 THEN 5.61
					--	WHEN product='COMED_IP_ABC' AND rate_id=3666 THEN 4
					--	WHEN product='CONED_FA_LCI' AND rate_id=7 THEN 0.5
					--	WHEN product='CONED_IP_ABC' AND rate_id=3611 THEN 8
					--	WHEN product='CONED_IP_ABC' AND rate_id=3612 THEN 5
					--	WHEN product='CTPEN_MCPE_NOMC_ABC' AND rate_id=2462 THEN 5
					--	WHEN product='CTPEN_MCPE_NOMC_ABC' AND rate_id=2463 THEN 6.89
					--	WHEN product='DELMD_FA' AND rate_id=1 THEN 5.5
					--	WHEN product='DELMD_FA' AND rate_id=2 THEN 5.75
					--	WHEN product='DELMD_FA' AND rate_id=3 THEN 6.78
					--	WHEN product='NECO_FX_LCI' AND rate_id=1 THEN 2
					--	WHEN product='NIMO_FA_ABC' AND rate_id=1204 THEN 5.75
					--	WHEN product='NIMO_FA_ABC' AND rate_id=1207 THEN 6.78
					--	WHEN product='NIMO_FA_LCI' AND rate_id=2 THEN 0.5
					--	WHEN product='NIMO_FX_LCI' AND rate_id=1 THEN 0.25
					--	WHEN product='NSTARCOMM_IP_ABC' AND rate_id=3661 THEN 6
					--	WHEN product='NYSEG_FA_ABC' AND rate_id=1204 THEN 6.78
					--	WHEN product='NYSEG_FA_LCI' AND rate_id=2 THEN 0.5
					--	WHEN product='NYSEG_FA_LCI' AND rate_id=3 THEN 0.5
					--	WHEN product='O&R_FA' AND rate_id=1 THEN 6.78
					--	WHEN product='O&R_FA_LCI' AND rate_id=1 THEN 0.5
					--	WHEN product='PEPCOMD_FA' AND rate_id=1 THEN 5.5
					--	WHEN product='PEPCOMD_FA' AND rate_id=4 THEN 6.78
					--	WHEN product='PEPCOMD_FA' AND rate_id=3 THEN 5.75
					--	WHEN product='RGE_FA' AND rate_id=1 THEN 6.78
					--	WHEN product='RGE_FA_LCI' AND rate_id=6 THEN 0.5
					--	WHEN product='TXNMP_FA' AND rate_id=1 THEN 6.89
					--	WHEN product='TXNMP_FX' AND rate_id=2 THEN 5.52
					--	WHEN product='TXU_FA' AND rate_id=1 THEN 6.89
					--	WHEN product='TXU_FX' AND rate_id=7 THEN 4.83
					--	WHEN product='TXU_FX' AND rate_id=8 THEN 5.52
					--	WHEN product='TXU_FX_LCI' AND rate_id=2435 THEN 5
					--	WHEN product='TXU_FX_LCI' AND rate_id=2440 THEN 1
					--	WHEN product='TXU_MCPE_NOMC_ABC' AND rate_id=2462 THEN 5
	WHEN product='CONED-PWRM-3' and zone='J' THEN 47
	WHEN product='CONED-PWRM-3' and zone='I' THEN 40
	WHEN product='CONED-PWRM-3' and zone='H' THEN 40
						ELSE 
						
						
						
	-- LOOK FOR ACCOUNTS THAT HAVE NOT BEEN MAPPED TO THE ABOVE CUSTOM DEAL DEFINITION
	-- BASED ON SUBMIT DATE IT WILL PICK UP THEIR RATE
	CASE
		WHEN CP.IsCustom = 1 THEN 
			COALESCE(	
						(
							SELECT 
								grossmargin
							FROM 
								lp_common.dbo.common_product_rate CPR 
							WHERE 
								CPR.Product_id = CP.Product_id
								AND CPR.Rate_id = Acct.Rate_id
								AND COALESCE(CPR.grossmargin,0) > 0	
						),0)
		ELSE
		


							COALESCE(
								(
								
									--select 
									--	GrossMargin 
 								--	from 
									--	lp_common.dbo.common_product_rate PRH 
									--where 
									--	PRH.product_id=Acct.product 
									--	AND PRH.rate_id =Acct.Rate_id
									--	AND PRH.eff_date= Acct.SubmitDate
									--	--AND PRH.Product_Rate_History_ID = (
									--	--							SELECT MAX(PRH2.Product_Rate_History_ID)
									--	--							FROM lp_common.dbo.product_rate PRH2
									--	--							WHERE 
									--	--								PRH.product_id=PRH2.product_id
									--	--								AND PRH.rate_id =PRH2.Rate_id
									--	--								AND PRH.eff_date= PRH2.eff_date
									--	--							)							
								
									select 
										GrossMargin 
 									from 
										lp_common.dbo.product_rate_history PRH 
									where 
										PRH.product_id=Acct.product 
										AND PRH.rate_id =Acct.Rate_id
										AND PRH.eff_date= Acct.SubmitDate
										AND PRH.Product_Rate_History_ID = (
																	SELECT MAX(PRH2.Product_Rate_History_ID)
																	FROM lp_common.dbo.product_rate_history PRH2
																	WHERE 
																		PRH.product_id=PRH2.product_id
																		AND PRH.rate_id =PRH2.Rate_id
																		AND PRH.eff_date= PRH2.eff_date
																	)
								),0)
	END
	--and grossmargin is not null

					END 
					GrossMarginValue
			
					, 0 AnnualGrossProfitAdjustment
					, 0 TermGrossProfitAdjustment
				
					, 0 AnnualRevenueAdjustment
					, 0 TermRevenueAdjustment
					, GetDate() EventDate	
					--,SubmitDate
					,date_deal DealDate
					,SalesChannelid			
					,salesrep
 				FROM
--					(SELECT * FROM 
lp_account.dbo.tblAccounts_vw 
--WHERE ACCOUNTNUMBER IN (SELECT ACCOUNTNUMBER FROM LIBERTYPOWER.DBO.AEHPPLUpdates020510)) 
Acct
					LEFT JOIN lp_common.dbo.Common_Product CP ON Acct.Product=CP.Product_id 
				WHERE 
					SubmitDate >= '1/1/2009'
					--AND 
					--0 = (
					---- Accounts that do not have a historical record in the Account Event History table
					--			Select Count(*) 
					--			FROM libertypower.dbo.accounteventhistory AEH
					--			WHERE AccountID = Account_ID
					--				And AEH.ContractNumber = Acct.ContractNumber
					--		)
			) MQ
		WHERE --account_id='2006-0001736' and
		--account_id IN (select account_id from lp_account.dbo.tblaccounts_vw where product='PEPCOMD_FA' and  customername = 'THE GAP INC' and rate_id=4)
		MQ.GrossMarginValue > 0
		AND AnnualUsage >0 
		
		
	-------------------------------------------------------
	-- Identify if there are any dups within the table,
	-- it has been noticed that there were some dups
	-- and the possible reason was because the GM reports
	-- that kickoff this stored procedure was running at the 
	-- same time, therefore creating duplicates.
	-- This section will search for dups and delete them
	-- from the table.
	-------------------------------------------------------
	DECLARE @dups_found Integer

	SELECT @dups_found = Count(*) 
	FROM 
		(
			SELECT accountid, contractnumber, count(*) DUPS
			FROM libertypower.dbo.AccountEventHistory
			GROUP BY
				accountid, contractnumber
		) Master_QDups
	WHERE
		DUPS > 1



	IF @dups_found > 0 
		BEGIN
			----------------------------------------------
			-- Table has dups, need to delete them
			----------------------------------------------
			DELETE FROM libertypower.dbo.accounteventhistory 
			WHERE
				ID =  (
						SELECT MAX(ID) 
						FROM 
							LibertyPower.dbo.AccountEventHistory AEH2
						WHERE 
							AEH2.ContractNumber=accounteventhistory.ContractNumber
							AND AEH2.AccountID = accounteventhistory.AccountID
							AND AEH2.ProductID = accounteventhistory.ProductID
							AND AEH2.RateID = accounteventhistory.RateID
							AND AEH2.Rate = accounteventhistory.Rate
							AND AEH2.RateEndDate = accounteventhistory.RateEndDate
							AND AEH2.EventID = accounteventhistory.EventID
							AND AEH2.EventEffectiveDate = accounteventhistory.EventEffectiveDate
							AND AEH2.ContractType = accounteventhistory.ContractType
							AND AEH2.ContractDate = accounteventhistory.ContractDate
							AND AEH2.ContractEndDate = accounteventhistory.ContractEndDate
							AND AEH2.DateFlowStart = accounteventhistory.DateFlowStart
							AND AEH2.Term = accounteventhistory.Term
							AND AEH2.AnnualUsage = accounteventhistory.AnnualUsage
							AND AEH2.GrossMarginValue = accounteventhistory.GrossMarginValue
							AND AEH2.AnnualGrossProfit = accounteventhistory.AnnualGrossProfit
							AND AEH2.TermGrossProfit = accounteventhistory.TermGrossProfit
							AND AEH2.AnnualGrossProfitAdjustment  = accounteventhistory.AnnualGrossProfitAdjustment
							AND AEH2.TermGrossProfitAdjustment = accounteventhistory.TermGrossProfitAdjustment
							AND AEH2.AnnualRevenue = accounteventhistory.AnnualRevenue
							AND AEH2.TermRevenue = accounteventhistory.TermRevenue
							AND AEH2.AnnualRevenueAdjustment = accounteventhistory.AnnualRevenueAdjustment
							AND AEH2.TermRevenueAdjustment = accounteventhistory.TermRevenueAdjustment
					)
			AND		
				1 < (
						SELECT COUNT(*) 
						FROM 
							LibertyPower.dbo.AccountEventHistory AEH2
						WHERE 
							AEH2.ContractNumber=accounteventhistory.ContractNumber
							AND AEH2.AccountID = accounteventhistory.AccountID
							AND AEH2.ProductID = accounteventhistory.ProductID
							AND AEH2.RateID = accounteventhistory.RateID
							AND AEH2.Rate = accounteventhistory.Rate
							AND AEH2.RateEndDate = accounteventhistory.RateEndDate
							AND AEH2.EventID = accounteventhistory.EventID
							AND AEH2.EventEffectiveDate = accounteventhistory.EventEffectiveDate
							AND AEH2.ContractType = accounteventhistory.ContractType
							AND AEH2.ContractDate = accounteventhistory.ContractDate
							AND AEH2.ContractEndDate = accounteventhistory.ContractEndDate
							AND AEH2.DateFlowStart = accounteventhistory.DateFlowStart
							AND AEH2.Term = accounteventhistory.Term
							AND AEH2.AnnualUsage = accounteventhistory.AnnualUsage
							AND AEH2.GrossMarginValue = accounteventhistory.GrossMarginValue
							AND AEH2.AnnualGrossProfit = accounteventhistory.AnnualGrossProfit
							AND AEH2.TermGrossProfit = accounteventhistory.TermGrossProfit
							AND AEH2.AnnualGrossProfitAdjustment  = accounteventhistory.AnnualGrossProfitAdjustment
							AND AEH2.TermGrossProfitAdjustment = accounteventhistory.TermGrossProfitAdjustment
							AND AEH2.AnnualRevenue = accounteventhistory.AnnualRevenue
							AND AEH2.TermRevenue = accounteventhistory.TermRevenue
							AND AEH2.AnnualRevenueAdjustment = accounteventhistory.AnnualRevenueAdjustment
							AND AEH2.TermRevenueAdjustment = accounteventhistory.TermRevenueAdjustment
					)
		END

END
