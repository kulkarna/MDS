


CREATE PROCEDURE [dbo].[usp_VRE_AccountsSelect]
	@AccountNumberList varchar(4000),
	@UtilityCodeList varchar(4000)
AS
BEGIN
	SET NOCOUNT ON

    Declare @pos int
    Declare @pos2 int
    Declare @CurAccount varchar(100)
	Declare @CurUtility varchar(50)	

    Set @pos = 0;

	Declare @tempAccountsTable Table
	(
		accountNumber varchar(100),
        utilityCode varchar(50))
        
		WHILE CHARINDEX(',' , @AccountNumberList) > 0
			BEGIN
				SET @pos = CHARINDEX(',' , @AccountNumberList) ;
                SET @CurAccount = RTRIM(SUBSTRING(@AccountNumberList , 1 , @pos - 1)) ;

                SET @pos2 = CHARINDEX(',' , @UtilityCodeList) ;
                SET @CurUtility = RTRIM(SUBSTRING(@UtilityCodeList , 1 , @pos2 - 1)) ;

                Insert Into @tempAccountsTable (accountNumber, utilityCode) Values (@CurAccount, @CurUtility)
                Set @AccountNumberList = SUBSTRING(@AccountNumberList , @pos + 1 , 4000)
                Set @UtilityCodeList = SUBSTRING(@UtilityCodeList , @pos2 + 1 , 4000)
            END

	Select
		Account.AccountID,		
		Account.AccountIdLegacy as LegacyAccountId,		
		Por_Option = CASE WHEN Account.PorOption = 1 THEN 'YES' ELSE 'NO' END,
		Account.AccountNumber,		
		AccountType.AccountType,		
		ISNULL(AccountUsage.AnnualUsage, 0) as AnnualUsage,	
		[Contract].Number as ContractNumber, 		
		'' as ContractType, 
		ISNULL(AccountContractRate2.RateStart, CONVERT(datetime, '1900-1-1')) as ContractStartDate,
		ISNULL(AccountContractRate2.RateEnd, CONVERT(datetime, '1900-1-1')) as ContractEndDate,
		ISNULL(AccountService2.StartDate, CONVERT(datetime, '1900-1-1')) as FlowStartDate,		
		ISNULL(AccountService2.EndDate, CONVERT(datetime, '1900-1-1')) as DeenrollmentDate,
		AccountContractRate2.Term,			
		Utility.UtilityCode,				
		AccountContractRate2.LegacyProductID as ProductId,			
		AccountContractRate2.Rate,							
		AccountContractRate2.RateID,
		Account.Icap,
		Account.Tcap,
		Account.BillingGroup as BillCycleID, 
		Market.MarketCode as RetailMarketCode,
		Account.Zone as ZoneCode, 
		Account.ServiceRateClass as RateClass, 
		ISNULL(AccountEtfWaive.WaiveEtf, 0) as WaiveEtf,
		AccountEtfWaive.WaivedEtfReasonCodeID, 
		ISNULL(AccountEtfWaive.IsOutgoingDeenrollmentRequest, 0) as IsOutgoingDeenrollmentRequest,		
		AccountStatus.[Status] as EnrollmentStatus,
		AccountStatus.SubStatus as EnrollmentSubStatus,		
		account_name2.full_name as BusinessName, 
		ISNULL([Contract].SubmitDate, CONVERT(datetime, '1900-1-1')) as DateSubmit,
		ISNULL([Contract].SignedDate, CONVERT(datetime, '1900-1-1')) as DateDeal,		
		SalesChannel.ChannelDescription as SalesChannelId,		
		[Contract].SalesRep,
		AccountEtfWaive.CurrentEtfID,
		(Select dbo.ufn_EtfGetZoneAndClassFromProduct(Account.AccountID)) as PricingZoneAndClass,
		CreditAgency.Name as credit_agency,
		0 as credit_score,		
		(Select dbo.GetLossFactor(Utility.UtilityCode, Account.ServiceRateClass, Account.Zone)) as LossFactor,
		BillingType.[Type] as BillingType
	From		
		dbo.Account WITH (NOLOCK)
		
		Left Join dbo.AccountEtfWaive WITH (NOLOCK)
		On Account.AccountID = AccountEtfWaive.AccountID
				
		Inner Join dbo.AccountType WITH (NOLOCK)
		On AccountType.ID = Account.AccountTypeID
				
		Inner Join dbo.[Contract] WITH (NOLOCK)
		On [Contract].ContractID = Account.CurrentContractID
						
		Inner Join dbo.AccountUsage WITH (NOLOCK)
		On AccountUsage.AccountID = Account.AccountID and AccountUsage.EffectiveDate = [Contract].StartDate
		
		Inner Join dbo.Utility WITH (NOLOCK)
		On Utility.ID = Account.UtilityID
		
		Inner Join dbo.AccountContract WITH (NOLOCK)
		On AccountContract.ContractID = Account.CurrentContractID and AccountContract.AccountID = Account.AccountID
		
		Inner Join dbo.AccountStatus WITH (NOLOCK)
		On AccountStatus.AccountContractID = AccountContract.AccountContractID
		
		Inner Join dbo.SalesChannel WITH (NOLOCK)
		On SalesChannel.ChannelID = [Contract].SalesChannelID
		
		Inner Join dbo.Customer WITH (NOLOCK)
		On Customer.CustomerID = Account.CustomerID
		
		Left Join dbo.CreditAgency WITH (NOLOCK)
		On CreditAgency.CreditAgencyID = Customer.CreditAgencyID
		
		Inner Join dbo.BillingType WITH (NOLOCK)
		On BillingType.BillingTypeID = Account.BillingTypeID
		
		Left Join (Select Max(account_name.AccountNameID) as MaxAccountNameID,account_id From lp_account.dbo.account_name WITH (NOLOCK) Group By account_id) account_name1
	    On account_name1.account_id = Account.AccountIdLegacy
	    
		Left Join lp_account.dbo.account_name as account_name2 WITH (NOLOCK)
		On account_name2.AccountNameID = account_name1.MaxAccountNameID
				
		Inner Join @tempAccountsTable T 
		On Account.AccountNumber = T.accountNumber and Utility.UtilityCode = T.utilityCode 
		
		Inner Join dbo.Market WITH (NOLOCK)
		On Market.ID = Account.RetailMktID
		
		Inner Join (Select Max(AccountContractRateID) as MaxAccountContractRateID,AccountContractID From dbo.AccountContractRate WITH (NOLOCK) Group By AccountContractID) AccountContractRate1
	    On AccountContractRate1.AccountContractID = AccountContract.AccountContractID
	    
	    Inner Join dbo.AccountContractRate as AccountContractRate2 WITH (NOLOCK)
	    On AccountContractRate2.AccountContractRateID = AccountContractRate1.MaxAccountContractRateID	    
	    
	    Inner Join (Select Max(AccountServiceID) as MaxAccountServiceID,account_id From dbo.AccountService WITH (NOLOCK) Group By account_id) AccountService1
	    On AccountService1.account_id = Account.AccountIdLegacy
	    	    
		Inner Join dbo.AccountService as AccountService2 WITH (NOLOCK)
		On AccountService2.AccountServiceID = AccountService1.MaxAccountServiceID
	Where
		[Contract].ContractTemplateID != 2
	Order By 
		Account.AccountNumber
		
SET NOCOUNT OFF
      
END                                                                                                                                              




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_AccountsSelect';

