CREATE  proc [dbo].[spGenie_Import_TEST] as

Begin

/* 
==========================================================================================
	AUTHOR: Suresh Guddanti
	Create Date: 11/15/2011
	NAME:	spGenie_Import
	DESCRIPTION:
		Import Tablet Contract Data from 
			ST_GenieImport 
		into following tables
			deal_address 
			deal_account_address 
			deal_contact
			deal_account_contact
			deal_name
			deal_account_name
			deal_contract
			deal_contract_account
	REVISION HISTORY:	
		11/15/2011 Suresh Guddanti, version 1
		12/15/2011 Suresh Guddanti, version 2.  added insertion code into LP_accounts
		12/25/2011 SG version 3.  added Document version
		1/1/2011  SG version 4.1  additional_id_nbr_type set to NONE
		1/5/2011  SG version 4.2  additional_id_nbr_type set to SSN/TAX ID
		1/5/2011  SG version 4.3  attachment-a ID and T&C Id update
		1/8/2011  SG version 4.4  Combined Contract items
		1/8/2011  SG version 4.5  Fix for SSN/TaxID
		1/9/2011  SG/NW version 4.6  Fix for T&C version to go as doc version
		2/21/2012 SG Version 4.7 Flag existing Accounts
=========================================================================================

EXEC [spGenie_Import_TEST]


*/



	set nocount on
	BEGIN TRANSACTION

/*
-- Clear old data
declare @TMP1 table (contract_nbr varchar(20))
declare @TMP2 table (Account_ID varchar(20))

insert into @TMP1 Select contract_nbr  from deal_contract where origin='Genie'
insert into @TMP2 select Account_id  from deal_contract_account  where Contract_nbr in (Select contract_nbr from @TMP1)

delete  from dbo.deal_address where contract_nbr in (Select contract_nbr from @TMP1)
Delete  from dbo.deal_account_address where account_id in (Select account_id from @TMP2)
delete  from dbo.deal_contact where contract_nbr in (Select contract_nbr from @TMP1)
delete  from dbo.deal_account_contact where account_id in (Select account_id from @TMP2)
delete from dbo.deal_name  where contract_nbr in (Select contract_nbr from @TMP1)
delete  from dbo.deal_account_name where account_id in (Select account_id from @TMP2)
delete  from dbo.deal_contract_account where contract_nbr in (Select contract_nbr from @TMP1)
delete  from dbo.deal_contract where origin='Genie'
*/

	print 'Start process';
	declare @key varchar(20)
	declare @i int, @ContractCount int, @SACount INT
	
	
	--======================
	-- need to use cursor to be able to call stored procedure to check for existing accounts
	declare @TblAccountExists TABLE (HasAccount int)
	declare @HasAccount int
	DECLARE csr Cursor for Select ContractID, UtilityCode, ServiceAccountNumber from ST_GenieImport
	declare @ContractID int, @UtilityCode varchar(50), @ServiceAccountNumber varchar(36)
	open csr
	fetch next from csr into @ContractID, @UtilityCode, @ServiceAccountNumber
	While (@@FETCH_STATUS<>-1)
	Begin

	delete from @TblAccountExists
	insert into @TblAccountExists 
		exec lp_deal_capture.dbo.usp_account_number_exists @ServiceAccountNumber, @UtilityCode
	Select @HasAccount=HasAccount from @TblAccountExists
	if (@HasAccount=1) Update ST_GenieImport Set DealCaptureStatus=2 where ContractID=@ContractID

	fetch next from csr into @ContractID, @UtilityCode, @ServiceAccountNumber
	End
	Close csr
	Deallocate csr

	-- Select * from ST_GenieImport
--=====================

	

	Select @ContractCount=COUNT(distinct ContractID) from ST_GenieImport where DealCaptureStatus=0 
	Select @SACount=COUNT(distinct ServiceAccountID) from ST_GenieImport where DealCaptureStatus=0 

	declare @TBLContract table(id int identity(1,1) PRIMARY KEY, Ukey varchar(20))
	declare @TBLSA table(id int identity(1,1) PRIMARY KEY, Ukey varchar(20))
	declare @Contract table(id int identity(1,1) PRIMARY KEY, ContractID int)
	declare @ContractSA table(id int identity(1,1) PRIMARY KEY, ContractID int, ServiceAccountID int)

	Set @i=0
	While @i<@ContractCount
	begin
		Insert into @TBLContract
		EXECUTE [LP_Deal_Capture].[dbo].[usp_get_key] '','CREATE CONTRACTS'
		Set @i=@i+1 
	end
	Set @i=0
	While @i<@SACount
	begin
		Insert into @TBLSA
		EXECUTE [LP_Deal_Capture].[dbo].[usp_get_key] '','ACCOUNT ID'
		Set @i=@i+1 
	end


	Insert into @Contract Select distinct ContractID from ST_GenieImport Where DealCaptureStatus=0 
	Insert into @ContractSA Select distinct ContractID, ServiceAccountID from ST_GenieImport Where DealCaptureStatus=0 

	declare @Master TABLE (id int identity(1,1) PRIMARY KEY, ContractID int, CLink int, Contract_NBR varchar(20))
	declare @Child TABLE (ContractID int, ServiceAccountID int, CLink int, Contract_NBR varchar(20), ALink int, Account_ID varchar(20))

	insert into @Child 
	Select a.ContractID, b.ServiceAccountID
	, 1 as Clink
	, c.Ukey as SKey 
	, ROW_NUMBER() over(partition by a.ContractID order by ServiceAccountID) 
	, d.Ukey   from
	@Contract a
	inner join
	@ContractSA b
	on a.ContractID=b.ContractID 
	inner join
	@TBLContract c
	on a.id=c.id 
	inner join
	@TBLSA d
	on b.id=d.id 

	Insert into @Master Select distinct ContractID, CLink, Contract_NBR  from @Child 



	declare @TGenie TABLE (
		[ContractID] [int] NOT NULL,
		[MarketCode] [char](2) NULL,
		[UtilityCode] [varchar](50) NULL,
		[BusinessType] [varchar](50) NULL,
		[PartnerName] [varchar](100) NOT NULL,
		[LoginID] [varchar](50) NOT NULL,
		[AgentName] [varchar](50) NOT NULL,
		[AccountTypeID] [int] NOT NULL,
		[ProductSelection] [varchar](50) NULL,
		[CustomerName] [varchar](100) NULL,
		[DBA] [varchar](100) NULL,
		[DUNS] [varchar](50) NULL,
		[TaxExempt] [bit] NULL,
		[CertificateAtached] [bit] NULL,
		[TaxID] [varchar](50) NULL,
		[ContactFirstName] [varchar](50) NULL,
		[ContactLastName] [varchar](50) NULL,
		[ContactTitle] [varchar](20) NULL,
		[ContactPhone] [varchar](20) NULL,
		[ContactFax] [varchar](20) NULL,
		[ContactEmail] [nvarchar](256) NULL,
		[ContractSignDate] [datetime] NULL,
		[ContractCreatedDate] [datetime] NULL,
		[GPSLat] [float] NULL,
		[GPSLong] [float] NULL,
		[LanguageID] [int] NULL,
		[EmailPreference] [int] NULL,
		[NumberOfAccounts] [int] NULL,
		[ServiceAccountID] [int] NOT NULL,
		[ServiceAccountNumber] [varchar](36) NOT NULL,
		[ServiceAccountName] [varchar](100) NULL,
		[EstimatedUsage] [int] NULL,
		[FlowStartMonth] [datetime] NOT NULL,
		[ContractTerm] [int] NOT NULL,
		[RateID] [int] NOT NULL,
		[TransferRate] [decimal](12, 5) NOT NULL,
		[PartnerMarkup] [decimal](12, 5) NOT NULL,
		[ServiceAddress1] [varchar](50) NOT NULL,
		[ServiceAddress2] [varchar](50) NULL,
		[ServiceCity] [varchar](30) NOT NULL,
		[ServiceState] [char](2) NOT NULL,
		[ServiceZip] [char](10) NOT NULL,
		[BillingSameAsService] [bit] NOT NULL,
		[BillingAccountNumber] [varchar](20) NULL,
		[BillingAddress1] [varchar](50) NULL,
		[BillingAddress2] [varchar](50) NULL,
		[BillingCity] [varchar](30) NULL,
		[BillingState] [char](2) NULL,
		[BillingZip] [char](10) NULL,
		[UtilityNameKey] [char](20) NULL,
		[FlowStartDate] [datetime] NULL,
		[FlowEndDate] [datetime] NULL,
		ZoneCode varchar(20) NULL,
		ContractNBR varchar(20) NULL,
		AccountID varchar(20) NULL,
		DealCaptureStatus int NULL,
		DealCaptureErrorCode varchar(50) NULL,
		Agreementversion varchar(50) NULL,
		AttachmentVersion varchar(50) NULL,
		TermsAndConditionsVersion varchar(50) NULL
	)

	Insert into @TGenie
	Select a.* from ST_GenieImport a
	inner join
	(Select ContractID, MIN(ServiceAccountID) as MinServiceAccountID from ST_GenieImport 
		 where DealCaptureStatus=0 
		group by ContractID ) b
	on a.ContractID=b.ContractID 
	and a.ServiceAccountID=b.MinServiceAccountID 
	Where DealCaptureStatus=0




	declare @deal_address TABLE (
		[contract_nbr] [char](12) NOT NULL,
		[address_link] [int] NOT NULL,
		[address] [char](50) NOT NULL,
		[suite] [char](50) NOT NULL,
		[city] [char](50) NOT NULL,
		[state] [char](2) NOT NULL,
		[zip] [char](10) NOT NULL,
		ContractID int,
		AddressType int
	) 

	declare @deal_account_address TABLE (
		[Account_ID] [char](12) NOT NULL,
		[address_link] [int] NOT NULL,
		[address] [char](50) NOT NULL,
		[suite] [char](50) NOT NULL,
		[city] [char](50) NOT NULL,
		[state] [char](2) NOT NULL,
		[zip] [char](10) NOT NULL,
		ContractID int,
		ServiceAccountID int,
		AddressType int,
		Contract_NBR char(12)
	) 


	
	insert into @deal_address 
	Select b.Contract_Nbr
		, ROW_NUMBER() over(partition by a.ContractID order by AddressType, a.ServiceAccountID) as address_Link
		, [address], Suite, City, [State], zip
		, a.ContractID 
		, AddressType
	from
	(	
		Select a.ContractID, a.ServiceAccountID, 1 as AddressType 
			,BillingAddress1 as [address]
			,BillingAddress2 as Suite
			,BillingCity as City
			,BillingState as [State]
			,BillingZip as Zip
			from @TGenie  a
		--union all
		--Select a.ContractID, a.ServiceAccountID, 2 as AddressType 
		--	,ServiceAddress1 as [address]
		--	,ServiceAddress2 as Suite
		--	,ServiceCity as City
		--	,ServiceState as [State]
		--	,ServiceZip as Zip
		--	from @TGenie  a
	) a
	inner join
	@Master  b
	on a.ContractID=b.ContractID

	-- insert into deal_account_address
	insert into @deal_account_address 
	Select b.Account_ID 
		, ROW_NUMBER() over(partition by a.ContractID order by AddressType, a.ServiceAccountID) as address_Link
		, [address], Suite, City, [State], zip
		,a.contractID
		, a.ServiceAccountID 
		, AddressType
		,b.Contract_NBR
	from
	(	
		Select a.ContractID, a.ServiceAccountID, 1 as AddressType 
			,BillingAddress1 as [address]
			,BillingAddress2 as Suite
			,BillingCity as City
			,BillingState as [State]
			,BillingZip as Zip
			from ST_GenieImport  a
			 where DealCaptureStatus=0 
		union all
		Select a.ContractID, a.ServiceAccountID, 2 as AddressType 
			,ServiceAddress1 as [address]
			,ServiceAddress2 as Suite
			,ServiceCity as City
			,ServiceState as [State]
			,ServiceZip as Zip
			from ST_GenieImport  a
			 where DealCaptureStatus=0 
	) a
	inner join
	@Child b
	on a.ContractID=b.ContractID
	and a.ServiceAccountID=b.ServiceAccountID 


	print 'step 777';

	INSERT INTO [LP_Deal_Capture].[dbo].[deal_name]
			   ([contract_nbr]
			   ,[name_link]
			   ,[full_name]
			   ,[chgstamp])
	Select Contract_NBR, CLink, CustomerName, 0
	from @TGenie a
	inner join
	@Master b
	on a.ContractID=b.ContractID 


	INSERT INTO [lp_deal_capture].[dbo].[deal_name]
			   ([Contract_NBR]
			   ,[name_link]
			   ,[full_name]
			   ,[chgstamp])
	Select b.Contract_NBR, 1+alink, customername, 0 from ST_GenieImport a
	inner join
	@Child b
	on a.ContractID=b.ContractID 
	and a.ServiceAccountID=b.ServiceAccountID 
	and  a.DealCaptureStatus=0 

	INSERT INTO [lp_deal_capture].[dbo].[deal_contact]
			   ([contract_nbr]
			   ,[contact_link]
			   ,[first_name]
			   ,[last_name]
			   ,[title]
			   ,[phone]
			   ,[fax]
			   ,[email]
			   ,[birthday]
			   ,[chgstamp])

	Select Contract_NBR,CLink
		,a.ContactFirstName as first_name
		,a.ContactLastName as last_name
		,a.ContactTitle as title
		,a.ContactPhone as phone
		,a.ContactFax as fax
		,a.ContactEmail as email
		,'01/01' as birthday
		, 0 as chgstamp
	From @TGenie  a
	inner join
	@Master b
	on a.contractID=b.ContractID 

	INSERT INTO [lp_deal_capture].[dbo].[deal_contact]
			   ([Contract_NBR]
			   ,[contact_link]
			   ,[first_name]
			   ,[last_name]
			   ,[title]
			   ,[phone]
			   ,[fax]
			   ,[email]
			   ,[birthday]
			   ,[chgstamp])

	Select b.Contract_NBR ,1+ALink
		,a.ContactFirstName as first_name
		,a.ContactLastName as last_name
		,a.ContactTitle as title
		,a.ContactPhone as phone
		,a.ContactFax as fax
		,a.ContactEmail as email
		,'01/01' as birthday
		, 0 as chgstamp
	From ST_GenieImport  a
	inner join
	@Child b
	on a.contractID=b.ContractID 
	and a.ServiceAccountID=b.ServiceAccountID 
	and  a.DealCaptureStatus=0 


	INSERT INTO [lp_deal_capture].[dbo].[deal_address]
			   ([contract_nbr]
			   ,[address_link]
			   ,[address]
			   ,[suite]
			   ,[city]
			   ,[state]
			   ,[zip]
			   ,[county]
			   ,[state_fips]
			   ,[county_fips]
			   ,[chgstamp])
	Select Contract_Nbr
		, address_Link
		, [address], Suite, City, [State], zip
		,'' as county
		,'' as statefips
		,'' as countyfips
		, 0 as chgstamp
	from @deal_address 


	INSERT INTO [lp_deal_capture].[dbo].[deal_address]
			   ([Contract_NBR]
			   ,[address_link]
			   ,[address]
			   ,[suite]
			   ,[city]
			   ,[state]
			   ,[zip]
			   ,[county]
			   ,[state_fips]
			   ,[county_fips]
			   ,[chgstamp])
	Select Contract_NBR
		, 1+address_Link
		, [address], Suite, City, [State], zip
		,'' as county
		,'' as statefips
		,'' as countyfips
		, 0 as chgstamp
	from @deal_account_address 

	
	declare @Sales table (SalesManager varchar(50), ChannelName varchar(30), ChannelID int)
	
	insert into @Sales
	select top 1 u.FirstName + ' ' + u.LastName as SalesManager, sc.ChannelName, sc.channelID
	from 
	@TGenie a
	inner join
	libertypower..SalesChannel sc
	on a.PartnerName=sc.ChannelName
	join libertypower..[user] u on sc.ChannelDevelopmentManagerID = u.UserID
	


	-- Insert into Deal_Contract

	INSERT INTO [lp_deal_capture].[dbo].[deal_contract]
			   ([contract_nbr]
			   ,[contract_type]
			   ,[status]
			   ,[retail_mkt_id]
			   ,[utility_id]
			   ,[account_type]
			   ,[product_id]
			   ,[rate_id]
			   ,[rate]
			   ,[customer_name_link]
			   ,[customer_address_link]
			   ,[customer_contact_link]
			   ,[billing_address_link]
			   ,[billing_contact_link]
			   ,[owner_name_link]
			   ,[service_address_link]
			   ,[business_type]
			   ,[business_activity]
			   ,[additional_id_nbr_type]
			   ,[additional_id_nbr]
			   ,[contract_eff_start_date]
			   ,[enrollment_type]
			   ,[term_months]
			   ,[date_end]
			   ,[date_deal]
			   ,[date_created]
			   ,[date_submit]
			   ,[sales_channel_role]
			   ,[username]
			   ,[sales_rep]
			   ,[origin]
			   ,[grace_period]
			   ,[chgstamp]
			   ,[contract_rate_type]
			   ,[requested_flow_start_date]
			   ,[deal_type]
			   ,[customer_code]
			   ,[customer_group]
			   ,[SSNClear]
			   ,[SSNEncrypted]
			   ,[TaxStatus]
			   ,[sales_manager])

	Select b.Contract_Nbr
		, 'PAPER' as contract_type
		, 'DRAFT' as status
		, MarketCode as retail_mkt_id
		, UtilityCode as utility_id
		, AccountTypeID as account_type
		, ProductSelection as product_id
		,RateID as rate_id
		,TransferRate+PartnerMarkup as rate
		, 1 as Customer_name_Link
		, 1 as Customer_address_Link
		, 1 as customer_contact_link
		, 1 as billing_address_link
		, 1 as billing_contact_link
		, 1 as owner_name_link
		, 1  as service_address_link
		, BusinessType as business_type
		, 'NONE' as business_activity
		, Case AccountTypeID when 2 then 'SSN' else 'TAX ID' end as additional_id_nbr_type
		, Case AccountTypeID when 2 then 'xxx-xx-xxxx' else TaxID end as additional_id_nbr
		--, 'NONE' as additional_id_nbr_type  -- id type from UI missing
		--, '' as additional_id_nbr     -- ssn number from UI is missing
		,FlowStartMonth as contract_eff_start_date
		, 1 as enrollment_type
		,ContractTerm  AS term_months
		,FlowEndDate as date_end
		, ContractSignDate as date_deal
		, ContractCreatedDate as date_created
		, GETDATE() as date_submit
		, 'Sales Channel/'+PartnerName  AS sales_channel_role
		, LoginID as username
		, AgentName as sales_rep
		, 'GENIE' as origin
		, 365 as graceperiod
		, 0 as chgstamp
		, NULL as Contract_Rate_Type
		,FlowStartDate as requested_flow_start_date
		, NULL as Deal_Type
		, NULL as Customer_Code
		, NULL as Customer_Group
		,NULL as SSNClear
		, Case AccountTypeID when 2 then TaxID else '' end as ssn_encrypted
		, case TaxExempt when 1 then 1 else 2 end as TaxStatus
		, SalesManager
	from 
	@TGenie a
	inner join @Master b
	on a.contractID=b.ContractID 
	inner join @deal_address  bb
	on b.ContractID=bb.contractid
	and bb.addresstype=1
	left join
	@Sales c
	on a.PartnerName=c.ChannelName
	
	print 'step 1';

	-- insert into deal_account_contract
	INSERT INTO [lp_deal_capture].[dbo].[deal_contract_account]
			   ([contract_nbr]
			   ,[contract_type]
			   ,[account_number]
			   ,[status]
			   ,[account_id]
			   ,[retail_mkt_id]
			   ,[utility_id]
			   ,[account_type]
			   ,[product_id]
			   ,[rate_id]
			   ,[rate]
			   ,[account_name_link]
			   ,[customer_name_link]
			   ,[customer_address_link]
			   ,[customer_contact_link]
			   ,[billing_address_link]
			   ,[billing_contact_link]
			   ,[owner_name_link]
			   ,[service_address_link]
			   ,[business_type]
			   ,[business_activity]
			   ,[additional_id_nbr_type]
			   ,[additional_id_nbr]
			   ,[contract_eff_start_date]
			   ,[enrollment_type]
			   ,[term_months]
			   ,[date_end]
			   ,[date_deal]
			   ,[date_created]
			   ,[date_submit]
			   ,[sales_channel_role]
			   ,[username]
			   ,[sales_rep]
			   ,[origin]
			   ,[grace_period]
			   ,[chgstamp]
			   ,[requested_flow_start_date]
			   ,[deal_type]
			   ,[customer_code]
			   ,[customer_group]
			   ,[SSNEncrypted]
			   ,[zone]
			   ,[TaxStatus])

	Select b.Contract_Nbr
		, 'PAPER' as contract_type
		, ServiceAccountNumber as account_number 
		, 'DRAFT' as status
		, b.Account_ID
		, MarketCode as retail_mkt_id
		, UtilityCode as utility_id
		, AccountTypeID as account_type
		, ProductSelection as product_id
		, RateID as rate_id
		, TransferRate+PartnerMarkup as rate
		, 1+ROW_NUMBER() over(partition by b.ContractID order by b.ServiceAccountID) as Account_Name_Link
		, 1 as Customer_Name_Link
		, 1 as Customer_address_Link
		, 1+ROW_NUMBER() over(partition by b.ContractID order by b.ServiceAccountID)  as customer_contact_link
		, bb.address_link as billing_address_link
		, 1 as billing_contact_link
		, 1 as owner_name_link
		, ss.address_link  as service_address_link
		, BusinessType as business_type
		, 'NONE' as business_activity
		, Case AccountTypeID when 2 then 'SSN' else 'TAX ID' end as additional_id_nbr_type
		, Case AccountTypeID when 2 then 'xxx-xx-xxxx' else TaxID end as additional_id_nbr
		--, 'NONE' as additional_id_nbr_type  
		--, '' as additional_id_nbr     
		, FlowStartMonth as contract_eff_start_date
		, 1 as enrollment_type
		, ContractTerm  AS term_months
		, FlowEndDate as date_end
		, ContractSignDate as date_deal
		, ContractCreatedDate as date_created
		, GETDATE() as date_submit
		, 'Sales Channel/'+PartnerName  AS sales_channel_role
		, LoginID as username
		, AgentName as sales_rep
		, 'GENIE' as origin
		, 365 as graceperiod
		, 0 as chgstamp
		, FlowStartDate as requested_flow_start_date
		, NULL as Deal_Type
		, NULL as Customer_Code
		, NULL as Customer_Group
		,Case AccountTypeID when 2 then TaxID else '' end  as SSNEncrypted
		, ZoneCode as Zone
		, case a.TaxExempt when 1 then 1 else 2 end as TaxStatus
	from 
	ST_GenieImport a
	inner join @Child b
	ON a.ServiceAccountID=b.ServiceAccountID 
	and a.DealCaptureStatus=0  
	inner join @deal_account_address bb
	ON b.ServiceAccountID=bb.serviceaccountid
	and bb.addresstype=1
	inner join @deal_account_address ss
	ON b.ServiceAccountID=ss.serviceaccountid
	and ss.addresstype=2
	
	print 'step 2';


	Update a Set ContractNBR=b.Contract_NBR, AccountID=b.Account_ID
	from ST_GenieImport a
	inner join
	@Child b
	on a.ContractID=b.ContractID
	and a.ServiceAccountID=b.ServiceAccountID
	and a.DealCaptureStatus=0  
	
	Update a Set ContractNBR=b.Contract_NBR, DocumentVersion=c.DocVersion
	from ST_GenieImportAttachments a
	inner join
	@Master b
	on a.ContractID=b.ContractID
	left join
	(
		select distinct ContractID, 1 as AttachmentTypeID, TermsAndConditionsVersion as DocVersion from ST_GenieImport Where DealCaptureStatus=0
		--union
		--select distinct ContractID, 16, AttachmentVersion as DocVersion from ST_GenieImport Where DealCaptureStatus=0
		--union
		--select distinct ContractID, 3, TermsAndConditionsVersion as DocVersion from ST_GenieImport Where DealCaptureStatus=0
	) c
	 on a.ContractID=c.ContractID
	 and a.AttachmentTypeID=c.AttachmentTypeID




	if (@@ERROR <>0)
		begin
			--Select 'ERROR'
			rollback TRANSACTION
			return @@ERROR
		end


PRINT 'DONE .... rolling back' ;
	rollback TRANSACTION
-- COMMIT TRANSACTION



/*
	Select *  from dbo.deal_address
	Select *  from dbo.deal_account_address 
	Select *  from dbo.deal_contact
	Select *  from dbo.deal_account_contact
	Select *  from dbo.deal_name
	Select *  from dbo.deal_account_name
	Select *  from dbo.deal_contract where origin='Genie'
	Select *  from dbo.deal_contract_account
*/


END
