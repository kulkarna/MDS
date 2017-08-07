USE [Libertypower]
GO

/*******************************************************************************
 * 10/22/2014 - Thiago Nogueira
 * Modfify
 * Bug 51719 - Changed query to remove all corporate contracts
 *******************************************************************************
 * 10/28/2014 - Thiago Nogueira
 * Modfify
 * Bug 51108 - Converting billing cycle id to decimal
*********************************************************************************
* 12/11/2014 - Rick Deigsler
* Added LossFactor
*********************************************************************************
* 2/20/2015 - Rick Deigsler
* Changed utility parameter to iso, added utility ID in select
 ********************************************************************************
 * 3/6/2015 - Rick Deigsler
 * TFS 55666 - Removed some fields as they have been moved to UtilityManagementWcfService 
 ******************************************************************************
 ********************************************************************************
 * 5/12/2015 - Satchi Jena
 * TFS 69993 - Added logic for CT-PURA Accounts. @LeadDays is only needed for NON-CTPURA Accounts.
 *******************************************************************************/

ALTER PROCEDURE [dbo].[usp_VRE_RateReadyAccountsSelect]  
	@IsoID		int,	
	@SplitDate	datetime,
	@LeadDays		int
AS
BEGIN

Set NoCount On
-- exec usp_VRE_RateReadyAccountsSelect 4,NULL,30
--DECLARE	  @IsoID AS INT = 4, 
--		  @SplitDate AS DATETIME = GETDATE(),
--		  @LeadDays int =7
IF @SplitDate IS NULL
    set @SplitDate=GETDATE();
    
DECLARE @CTPURA_AccountTypeIds as Table(id int)
DECLARE @CT_Utilities as Table(id int)


INSERT INTO @CTPURA_AccountTypeIds
	   SELECT 
	   id FROM AccountType (NOLOCK) where AccountType in ('RES','SOHO'); --RES and SOHO

INSERT INTO @CT_Utilities Select u.id from LibertyPower..Utility u (NOLOCK)
		 join Market m (NOLOCK)on m.ID=u.MarketID where m.MarketCode='CT';

Select	
		MeterTypeCode,
		CustId,
		PremNo,
		Duns,
		TripNumber,          
		DaysSinceLastRateUpdate,
		LossFactor,
		UtilityID,
		DaysInAdvance,
		IsCTPura,
		CurrentLegacyProductId,
		RolloverLegacyProductId
From
	(
	Select 
		U.ID AS UtilityID,
		mt.MeterTypeCode,
		acct.CustomerID as CustId,
		--'' as CustNo,
		--'' as CustName,		
		--'' as RateCode,
		--'3' as PlanType,
		acct.AccountNumber as PremNo, 
		u.DunsNumber as Duns,	
		--'' as MeterNo,
		-- TFS 55666 - moved to UtilityManagementWcfService 
		--MRC1.read_date as LastMeterRead, -- Last read date
		--MRC2.read_date as ScheduledMeterRead, -- Scheduled meter ready date		
		--'0' as BegRead, -- Not used
		--'0' as EndRead, -- Not used
		--'0' as kWh,     -- Calculated later in code
		--'0' as Demand,  -- Not used		
		acct.BillingGroup as TripNumber,
		-- TFS 55666 - moved to UtilityManagementWcfService 
		--(Select DateDiff(Day, @SplitDate, MRC2.read_date)) AS DaysTillNextMeterRead,
		dbo.DaysSinceLastRateChangeUpdate(acct.AccountNumber,@SplitDate) as DaysSinceLastRateUpdate,
		(SELECT dbo.GetLossFactor(U.UtilityCode, acct.ServiceRateClass, acct.Zone)) as LossFactor,
		DATEDIFF(Day,@SplitDate,AccountContractRate2.RateEnd) as DaysInAdvance,
		0 as IsCTPura,
		cp.product_id as CurrentLegacyProductId,
		cp.default_expire_product_id as RolloverLegacyProductId
	From		
		dbo.Account acct WITH (NOLOCK)		
		INNER JOIN Utility U WITH (NOLOCK)On U.ID = acct.UtilityID   		    
		-- TFS 63451 -----------------------------------------------------------------------
		INNER JOIN LibertyPower..Market  m WITH (NOLOCK) ON u.MarketID = m.ID
		INNER JOIN LibertyPower..WholesaleMarket  w WITH (NOLOCK) ON m.WholesaleMktId = w.ID
		------------------------------------------------------------------------------------
	    
	    Inner Join dbo.[Contract] WITH (NOLOCK)
		On [Contract].ContractID = acct.CurrentContractID
	    
		-- TFS 55666 - moved to UtilityManagementWcfService 
		--Left Join lp_common.dbo.meter_read_calendar MRC1 WITH (NOLOCK)
		--On (MRC1.utility_id = U.UtilityCode And MRC1.read_cycle_id = Account.BillingGroup And MRC1.calendar_year = YEAR(@LeadDateMinus1Month) And  MRC1.calendar_month = MONTH(@LeadDateMinus1Month))
		
		--Left Join lp_common.dbo.meter_read_calendar MRC2 WITH (NOLOCK)
		--On (MRC2.utility_id = U.UtilityCode And MRC2.read_cycle_id = Account.BillingGroup And MRC2.calendar_year = YEAR(@LeadDate) And  MRC2.calendar_month = MONTH(@LeadDate))
	    	    	    		
	    Inner Join dbo.AccountContract WITH (NOLOCK)
	    On AccountContract.AccountID = acct.AccountID and AccountContract.ContractID = acct.CurrentContractID
	    
	    Inner Join dbo.AccountStatus WITH (NOLOCK)
	    On AccountStatus.AccountContractID = AccountContract.AccountContractID
	    	    	    
	    Inner Join dbo.BillingType WITH (NOLOCK)
	    On BillingType.BillingTypeID = acct.BillingTypeID
	    
	    Inner Join (Select Max(AccountContractRateID) as MaxAccountContractRateID,AccountContractID 
				    From dbo.AccountContractRate WITH (NOLOCK) Group By AccountContractID) AccountContractRate1
	    On AccountContract.AccountContractID = AccountContractRate1.AccountContractID
	    
	    Inner Join dbo.AccountContractRate AS AccountContractRate2 WITH (NOLOCK)
	    On AccountContractRate2.AccountContractRateID = AccountContractRate1.MaxAccountContractRateID
	    
	    LEFT JOIN Libertypower..MeterType mt WITH (NOLOCK) ON acct.MeterTypeID = mt.ID
		LEFT JOIN
			Lp_common..common_product cp WITH (NOLOCK) ON AccountContractRate2.LegacyProductID = cp.product_id	    
	Where
	 										
		AccountStatus.[Status] in ('906000','905000') and			
		w.ID = @IsoID And -- TFS 63451
		BillingType.[Type] = 'RR' And		
		AccountContractRate2.IsContractedRate = 0 And
		[Contract].ContractTemplateID != 2 
		and 
		--Exclude CT-PURA Related Accounts from Original Logic (Include only NON-CTPURA Accounts)		
		( acct.UtilityID not in (SELECT ID FROM @CT_Utilities) or 
		  (acct.UtilityID in(SELECT ID FROM @CT_Utilities) 
			 and acct.AccountTypeID not in(SELECT id FROM @CTPURA_AccountTypeIds)))
	
	
	) as Result
-- TFS 55666 - moved to UtilityManagementWcfService
Where	
--	LastMeterRead is not Null And
--	ScheduledMeterRead is not Null And
	(DaysSinceLastRateUpdate > 15 Or DaysSinceLastRateUpdate is null)
	and DaysInAdvance <=@LeadDays and DaysInAdvance>=0
	
--	ScheduledMeterRead > DateAdd(DAY,1,@SplitDate) and
--	ScheduledMeterRead < @LeadDate

UNION ALL


--##################################################
--Section to Add CT-PURA Accounts
--################################################## 
   
    --SELECT * from #CT_Utilities;	 
   SELECT 
		 MeterTypeCode,
		 CustId,
           PremNo,
           Duns,
           TripNumber,          
           DaysSinceLastRateUpdate,
           LossFactor,
           UtilityID,
           DaysInAdvance,
           IsCTPura,
		   CurrentLegacyProductId,
		   RolloverLegacyProductId
   FROM   (SELECT acct.CustomerID AS CustId,
                   acct.AccountNumber AS PremNo,
                   u.DunsNumber AS Duns,					
                   acct.BillingGroup AS TripNumber,                   
                   dbo.DaysSinceLastRateChangeUpdate(acct.AccountNumber, @SplitDate) AS DaysSinceLastRateUpdate,
                   (SELECT dbo.GetLossFactor(U.UtilityCode, acct.ServiceRateClass, acct.Zone)) AS LossFactor,
                   u.ID AS UtilityID,
                   DateDiff(Day,@SplitDate,AccountContractRate2.RateEnd) AS DaysInAdvance,
                   ISNULL(mt.MeterTypeCode,'') as MeterTypeCode,
                   1 as IsCTPura,
				   cp.product_id as CurrentLegacyProductId,
				   cp.default_expire_product_id as RolloverLegacyProductId
            FROM   dbo.Account acct WITH (NOLOCK)
                   INNER JOIN
				    Utility AS U WITH (NOLOCK) ON Upper(U.ID) = acct.UtilityID
                   INNER JOIN
				    LibertyPower..Market AS m WITH (NOLOCK) ON u.MarketID = m.ID
                   INNER JOIN
				    LibertyPower..WholesaleMarket AS w WITH (NOLOCK)ON m.WholesaleMktId = w.ID
                   INNER JOIN
				    dbo.[Contract] WITH (NOLOCK) ON [Contract].ContractID = acct.CurrentContractID
                   INNER JOIN
				dbo.AccountContract WITH (NOLOCK) ON 
					   AccountContract.AccountID = acct.AccountID
					   AND AccountContract.ContractID = acct.CurrentContractID
                   INNER JOIN
				    dbo.AccountStatus WITH (NOLOCK) ON AccountStatus.AccountContractID = AccountContract.AccountContractID
                   INNER JOIN 
				    dbo.BillingType WITH (NOLOCK) ON BillingType.BillingTypeID = acct.BillingTypeID
                   INNER JOIN
				   (SELECT   Max(AccountContractRateID) AS MaxAccountContractRateID,
						   AccountContractID
				    FROM     dbo.AccountContractRate WITH (NOLOCK)
				    GROUP BY AccountContractID) AS AccountContractRate1
				    ON AccountContract.AccountContractID = AccountContractRate1.AccountContractID
                   INNER JOIN
                   dbo.AccountContractRate AS AccountContractRate2 WITH (NOLOCK)
                   ON AccountContractRate2.AccountContractRateID = AccountContractRate1.MaxAccountContractRateID
                   LEFT OUTER JOIN
						Libertypower..MeterType mt WITH (NOLOCK) ON acct.MeterTypeID = mt.ID
                   LEFT JOIN
						Lp_common..common_product cp WITH (NOLOCK) ON AccountContractRate2.LegacyProductID = cp.product_id
            WHERE  AccountStatus.[Status] IN ('906000', '905000')
                   AND w.ID = @IsoID
                   AND BillingType.[Type] = 'RR' -- TFS 63451                   
                   AND [Contract].ContractTemplateID != 2
                   AND 
				(
                         (
                                AccountContractRate2.IsContractedRate = 1                    
                                AND DATEDIFF(day,@SplitDate,AccountContractRate2.RateEnd)<=46                    
                                AND DATEDIFF(day,@SplitDate,AccountContractRate2.RateEnd)>0
                         )
                         OR
                         (
                                AccountContractRate2.IsContractedRate = 0
                                --AND cp.ProductBrandID<>35
                                AND DATEDIFF(day,@SplitDate,AccountContractRate2.RateEnd)<=21 
                                AND DATEDIFF(day,@SplitDate,AccountContractRate2.RateEnd)>0
                         )
				)                   
                   
                   AND acct.UtilityID in(SELECT ID FROM @CT_Utilities)
                   AND acct.AccountTypeID in (SELECT ID FROM @CTPURA_AccountTypeIds)                   
                   
                   ) AS Result
  
    SET NOCOUNT OFF;   

    
END
