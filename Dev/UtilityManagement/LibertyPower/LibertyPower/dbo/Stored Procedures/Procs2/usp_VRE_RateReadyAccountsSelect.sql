

CREATE PROCEDURE [dbo].[usp_VRE_RateReadyAccountsSelect]  
	@UtilityId varchar(50),	
	@SplitDate datetime,
	@LeadDays int
AS

Set NoCount On

Declare @LeadDate datetime
Declare @LeadDateMinus1Month datetime 

Set @LeadDate = DateAdd(DAY,@LeadDays,@SplitDate)
Set @LeadDateMinus1Month = DateAdd(MONTH,-1,@LeadDate)
Set @UtilityId = Upper(@UtilityId)

Select
	CustId,
	CustNo,
	CustName,
	RateCode,
	PlanType,
	PremNo,
	Duns,
	MeterNo,
	LastMeterRead as DateFrom,
	ScheduledMeterRead as DateTo,
	BegRead,
	EndRead,
	kWh,
	Demand,
	TripNumber,
	DaysTillNextMeterRead,
	DaysSinceLastRateUpdate
From
	(
	Select
		Account.CustomerID as CustId,
		'' as CustNo,
		'' as CustName,		
		'' as RateCode,
		'3' as PlanType,	
		Account.AccountNumber as PremNo, 
		u.DunsNumber as Duns,	
		'' as MeterNo,
		MRC1.read_date as LastMeterRead, -- Last read date
		MRC2.read_date as ScheduledMeterRead, -- Scheduled meter ready date		
		'0' as BegRead, -- Not used
		'0' as EndRead, -- Not used
		'0' as kWh,     -- Calculated later in code
		'0' as Demand,  -- Not used		
		Account.BillingGroup as TripNumber,	
		(Select DateDiff(Day, @SplitDate, MRC2.read_date)) AS DaysTillNextMeterRead,
		dbo.DaysSinceLastRateChangeUpdate(Account.AccountNumber,@SplitDate) as DaysSinceLastRateUpdate
	From		
		dbo.Account WITH (NOLOCK)
		Inner Join Utility U WITH (NOLOCK)
		On Upper(U.ID) = Account.UtilityID   
	    
		Left Join lp_common.dbo.meter_read_calendar MRC1 WITH (NOLOCK)
		On (MRC1.utility_id = U.UtilityCode And MRC1.read_cycle_id = Account.BillingGroup And MRC1.calendar_year = YEAR(@LeadDateMinus1Month) And  MRC1.calendar_month = MONTH(@LeadDateMinus1Month))
		
		Left Join lp_common.dbo.meter_read_calendar MRC2 WITH (NOLOCK)
		On (MRC2.utility_id = U.UtilityCode And MRC2.read_cycle_id = Account.BillingGroup And MRC2.calendar_year = YEAR(@LeadDate) And  MRC2.calendar_month = MONTH(@LeadDate))
	    	    	    		
	    Inner Join dbo.AccountContract WITH (NOLOCK)
	    On AccountContract.AccountID = Account.AccountID and AccountContract.ContractID = Account.CurrentContractID
	    
	    Inner Join dbo.AccountStatus WITH (NOLOCK)
	    On AccountStatus.AccountContractID = AccountContract.AccountContractID
	    	    	    
	    Inner Join dbo.BillingType WITH (NOLOCK)
	    On BillingType.BillingTypeID = Account.BillingTypeID
	    
	    Inner Join (Select Max(AccountContractRateID) as MaxAccountContractRateID,AccountContractID From dbo.AccountContractRate WITH (NOLOCK) Group By AccountContractID) AccountContractRate1
	    On AccountContract.AccountContractID = AccountContractRate1.AccountContractID
	    
	    Inner Join dbo.AccountContractRate as AccountContractRate2 WITH (NOLOCK)
	    On AccountContractRate2.AccountContractRateID = AccountContractRate1.MaxAccountContractRateID
	    
	Where										
		AccountStatus.[Status] in ('906000','905000') and			
		Upper(U.UtilityCode) = @UtilityID And		
		BillingType.[Type] = 'RR' And		
		AccountContractRate2.IsContractedRate = 0		
	) as Result
Where	
	LastMeterRead is not Null And
	ScheduledMeterRead is not Null And
	(DaysSinceLastRateUpdate > 15 Or DaysSinceLastRateUpdate is null) and	
	ScheduledMeterRead > DateAdd(DAY,1,@SplitDate) and
	ScheduledMeterRead < @LeadDate


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RateReadyAccountsSelect';

