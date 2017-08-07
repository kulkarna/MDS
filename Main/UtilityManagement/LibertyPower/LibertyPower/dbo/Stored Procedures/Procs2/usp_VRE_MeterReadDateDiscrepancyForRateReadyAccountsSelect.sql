


CREATE PROCEDURE [dbo].[usp_VRE_MeterReadDateDiscrepancyForRateReadyAccountsSelect]  
	@RateReadyUtilityId varchar(50),
	@MeterReadStartingDate datetime,
	@MeterReadEndingDate datetime
AS

Set NoCount On

Select 		
	(Select Top 1 AN.full_name From lp_account.dbo.account_name AN Where AN.account_id = Account.AccountIdLegacy) as BusinessName,
	Account.AccountNumber as AccountNumber,
	Utility.UtilityCode as Utility,
	Market.MarketCode as Market,
	Account.BillingGroup as TripNumber,			
	Convert(nvarchar(20),MRC.read_date,101) as ScheduledReadDate,
	Convert(nvarchar(20),uc.ToDate,101) as ActualReadDate,	 
	DATEDIFF(DAY,MRC.read_date,uc.ToDate) as Discrepancy	
From
	dbo.Account	
	
	Inner Join dbo.Utility WITH (NOLOCK)
	On Utility.ID = Account.UtilityID
	
	Inner Join UsageConsolidated UC
	On UC.UtilityCode = Utility.UtilityCode and UC.AccountNumber = Account.AccountNumber
	
	Inner Join lp_common.dbo.meter_read_calendar MRC
	On (MRC.utility_id = Utility.UtilityCode And MRC.read_cycle_id = Account.BillingGroup And MRC.calendar_year = YEAR(uc.ToDate) And  MRC.calendar_month = MONTH(uc.ToDate))	
				
	Inner Join dbo.Market WITH (NOLOCK)
	On Market.ID = Account.RetailMktID
	
	Inner Join dbo.BillingType WITH (NOLOCK)
	On BillingType.BillingTypeID = Account.BillingTypeID
	
	Inner Join dbo.AccountContract WITH (NOLOCK)
	On AccountContract.ContractID = Account.CurrentContractID and AccountContract.AccountID = Account.AccountID
		
	Inner Join dbo.AccountStatus WITH (NOLOCK)
	On AccountStatus.AccountContractID = AccountContract.AccountContractID
		
	Inner Join dbo.[Contract] WITH (NOLOCK)
	On [Contract].ContractID = Account.CurrentContractID
		
	Inner Join dbo.ContractType WITH (NOLOCK)
	On ContractType.ContractTypeID = [Contract].ContractTypeID
		
Where 
	uc.UtilityCode = @RateReadyUtilityId and 
	uc.ToDate >= @MeterReadStartingDate and 
	uc.ToDate < @MeterReadEndingDate and 
	uc.Active = 1 and
	Upper(ContractType.[Type]) <> 'CORPORATE' and
	Upper(BillingType.[Type]) = 'RR' and
	AccountStatus.[Status] IN ('906000','905000') --and
Order By
	BusinessName,
	AccountNumber,
	ScheduledReadDate,
	ActualReadDate

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_MeterReadDateDiscrepancyForRateReadyAccountsSelect';

