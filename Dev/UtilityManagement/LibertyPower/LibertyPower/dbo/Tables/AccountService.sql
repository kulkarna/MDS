CREATE TABLE [dbo].[AccountService] (
    [AccountServiceID] INT       IDENTITY (1, 1) NOT NULL,
    [account_id]       CHAR (12) NOT NULL,
    [StartDate]        DATETIME  NULL,
    [EndDate]          DATETIME  NULL,
    [DateCreated]      DATETIME  CONSTRAINT [DF_AccountService_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountService] PRIMARY KEY CLUSTERED ([AccountServiceID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_AccountService_account_id]
    ON [dbo].[AccountService]([account_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_AcountService_account_id_Dates]
    ON [dbo].[AccountService]([account_id] ASC, [StartDate] DESC, [EndDate] DESC);


GO

CREATE TRIGGER [dbo].[TR_AccountServiceInsert]
	ON  [dbo].[AccountService]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	Declare @upds table (Account_id char(12))

	-- Collect by Account_ID when records are inserted
	insert into @upds (Account_id)
	Select Account_id
	from	inserted ins 
	group by Account_id
	
	Declare @ALS table (Account_ID char(12),AccountID int, StartDate datetime NULL, EndDate datetime NULL)

	--Collect latest dates of those Account_ID being modified
	Insert into @ALS (Account_ID, accountid, StartDate, EndDate)
	Select aLatestService.Account_id, aLatestService.accountid, aLatestService.StartDate, aLatestService.EndDate
	from
	(
		select   
				ASERVICE.account_id, A.accountid, ASERVICE.StartDate, ASERVICE.EndDate, ROW_NUMBER() OVER (PARTITION BY ASERVICE.account_id ORDER BY ASERVICE.StartDate DESC, ASERVICE.DateCreated DESC) AS rownum  
		from @upds ins 
		join libertypower.dbo.AccountService (NOLOCK) ASERVICE on ASERVICE.Account_id = ins.Account_id
		join libertypower.dbo.Account (nolock)	A ON A.AccountIdLegacy = ASERVICE.account_id
	
	) aLatestService
	where aLatestService.rownum = 1  

	Update ALS
	Set		ALS.StartDate = t.StartDate
		,	ALS.EndDate = t.EndDate
		,	ALS.DateModified = getdate()
	from @ALS t
	join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID

	Insert into libertypower.dbo.AccountLatestService (accountid, StartDate, EndDate)
	Select t.AccountID, t.StartDate, t.EndDate
	from @ALS t
	left join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID
	Where
		ALS.AccountID is null
		
	
	SET NOCOUNT OFF;
END


GO

CREATE TRIGGER [dbo].[TR_AccountServiceUpdate]
	ON  [dbo].[AccountService]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	Declare @upds table (Account_id char(12))

	-- Collect by Account_ID when dates have been modified
	insert into @upds (Account_id)
	Select  Account_id
	from	inserted ins 
	group by Account_id
	
	Declare @ALS table (Account_ID char(12),AccountID int, StartDate datetime NULL, EndDate datetime NULL)

	--Collect latest dates of those Account_ID being modified
	Insert into @ALS (Account_ID, accountid, StartDate, EndDate)
	Select aLatestService.Account_id, aLatestService.accountid, aLatestService.StartDate, aLatestService.EndDate
	from
	(
		select   
				ASERVICE.account_id, A.accountid, ASERVICE.StartDate, ASERVICE.EndDate, ROW_NUMBER() OVER (PARTITION BY ASERVICE.account_id ORDER BY ASERVICE.StartDate DESC, ASERVICE.EndDate DESC) AS rownum  
		from @upds ins 
		join libertypower.dbo.AccountService (NOLOCK) ASERVICE on ASERVICE.Account_id = ins.Account_id
		join libertypower.dbo.Account (nolock)	A ON A.AccountIdLegacy = ASERVICE.account_id
	
	) aLatestService
	where aLatestService.rownum = 1  

	Update ALS
	Set		ALS.StartDate = t.StartDate
		,	ALS.EndDate = t.EndDate
		,	ALS.DateModified = getdate()
	from @ALS t
	join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID

	Insert into libertypower.dbo.AccountLatestService (accountid, StartDate, EndDate)
	Select t.AccountID, 1.StartDate, t.EndDate
	from @ALS t
	left join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID
	Where
		ALS.AccountID is null
		
	
	SET NOCOUNT OFF;
END


GO

CREATE TRIGGER [dbo].[TR_AccountServiceDelete]
	ON  [dbo].[AccountService]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	Declare @upds table (Account_id char(12), cnt int null)
	Declare @dels table (Account_id char(12))

	-- Collect Account_IDs of records being deleted but at least 1 record per Account_ID still exists
	insert into @upds (Account_id, cnt)
	Select  del.account_id, cnt=count(1)
	from	(select distinct account_id from deleted) del 
	join	libertypower.dbo.AccountService (NOLOCK) ASERVICE on ASERVICE.account_id = del.account_id
	group by del.account_id
	having count(1) > 0
	
	-- Collect Account_IDs of records being deleted and related Account_ID COMPLETELY removed from the table
	insert into @dels (account_id) 
	Select  del.account_id
	from	deleted del
	where	Account_id not in (select Account_id from @upds)
	group by del.account_id
	
	Declare @ALS table (Account_ID char(12),AccountID int, StartDate datetime NULL, EndDate datetime NULL)

	--Collect latest dates of those Account_ID still existing
	Insert into @ALS (Account_ID, accountid, StartDate, EndDate)
	Select aLatestService.Account_id, aLatestService.accountid, aLatestService.StartDate, aLatestService.EndDate
	from
	(
		select   
				ASERVICE.account_id, A.accountid, ASERVICE.StartDate, ASERVICE.EndDate, ROW_NUMBER() OVER (PARTITION BY ASERVICE.account_id ORDER BY ASERVICE.StartDate DESC, ASERVICE.EndDate DESC) AS rownum  
		from @upds ins 
		join libertypower.dbo.AccountService (NOLOCK) ASERVICE on ASERVICE.Account_id = ins.Account_id
		join libertypower.dbo.Account (nolock)	A ON A.AccountIdLegacy = ASERVICE.account_id
	
	) aLatestService
	where aLatestService.rownum = 1  

	-- Update AccountLatestService if record exists
	Update ALS
	Set		ALS.StartDate = t.StartDate
		,	ALS.EndDate = t.EndDate
		,	ALS.DateModified = getdate()
	from @ALS t
	join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID

	-- Insert AccountLatestService if record not exists
	Insert into libertypower.dbo.AccountLatestService (accountid, StartDate, EndDate)
	Select t.AccountID, 1.StartDate, t.EndDate
	from @ALS t
	left join libertypower.dbo.AccountLatestService  ALS on ALS.AccountID = t.AccountID
	Where
		ALS.AccountID is null
		
	-- Delete AccountLatestService if no more records exists in AccountService
	Delete  ALS
	from	@dels dels
	join	libertypower.dbo.Account (nolock) A ON A.AccountIdLegacy = dels.account_id
	join	libertypower.dbo.AccountLatestService (nolock) ALS on ALS.AccountID = A.AccountID
	
	SET NOCOUNT OFF;
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountService';

