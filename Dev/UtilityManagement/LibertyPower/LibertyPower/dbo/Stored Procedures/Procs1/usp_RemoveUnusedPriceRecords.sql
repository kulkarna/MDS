/*

Purge of Price records based on ProductCrossPriceSetID older than x weeks 
and ONLY records not referenced in table Libertypower.dbo.AccountContractRate

Parameters: 
	@OlderWeekToPurge		int			purge will work from older to newer 
	@MaxRecordsToPurge	int			Will be used to select those ProductCrossPriceSetID which total number of rows is less than this value
	@ReIndex			bit


test:
-- usp_RemoveUnusedPriceRecords @OlderWeekToPurge = 07, @MaxRecordsToPurge = 10000000, @Reindex = 0
*/

CREATE Procedure dbo.usp_RemoveUnusedPriceRecords
(
	@OlderWeekToPurge int = 5			-- 5 weeks or older
,	@MaxRecordsToPurge	int = 20000000	-- 20 mil
,	@Reindex bit = 0					-- no reindex
)
as
Begin

	SET NOCOUNT ON

	Declare @iSETID int
	Declare @i int
	Declare @RunningTotal int
	Declare @RowsToDeleteCnt int
	Declare @DeletedRowsCnt int
	Declare @LastID int
	Declare @ProductCrossPriceSetID int
	Declare @InitialLogID int

	-- ##usp_RemoveUnusedPriceRecords_log is a global temp table accessible from other processes to monitor progress
	
	if NOT exists (SELECT 1 FROM tempdb.sys.objects WHERE OBJECT_ID = OBJECT_ID(N'tempdb..##usp_RemoveUnusedPriceRecords_log'))
	 begin
		Create table ##usp_RemoveUnusedPriceRecords_log (seqid int identity (1,1),EventTime datetime default getdate(), notes varchar(1000))
		Set @InitialLogID = 0
	 end
	else
	 begin
		Select @InitialLogID = max(seqid) from ##usp_RemoveUnusedPriceRecords_log (nolock)
	 end
	 
	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select 'Start of process'

	Declare @SETIDs table (seqid int identity (1,1),ProductCrossPriceSetID int, EffectiveDate datetime, RowCnt int, RunningTotal int)

	Create table #ToDeleteSetID (ProductCrossPriceSetID int, ID int)
	Create unique Clustered index CIDX on #ToDeleteSetID (ProductCrossPriceSetID,ID)

	Declare @ToDelete table (ID int primary key)
	
	--Create table #TEST (ProductCrossPriceSetID int, ID int) -- This table contains records IDs that are candidate for deletion...TEST only

	Create table #Referenced (ID int, ProductCrossPriceSetID int) -- This table contains ALL used prices so far, from table Libertypower.dbo.AccountContractRate

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '@OlderWeekToPurge = ' + convert(varchar,@OlderWeekToPurge)

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '@MaxRecordsToPurge = ' + convert(varchar,@MaxRecordsToPurge)

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '@Reindex = ' + convert(varchar,@Reindex)

--	Fill @SETIDs to purge based on weeks

	Insert INTO	@SETIDs
	SELECT	
			cps.ProductCrossPriceSetID, cps.EffectiveDate, p.cnt, 0
	FROM	
			Libertypower.dbo.ProductCrossPriceSet cps  WITH (NOLOCK)
	join	
			(	select	ProductCrossPriceSetID, cnt=COUNT(1)
				from	Libertypower.dbo.Price WITH (NOLOCK)
				group by ProductCrossPriceSetID
			) p on p.ProductCrossPriceSetID = cps.ProductCrossPriceSetID
	WHERE	
			cps.EffectiveDate < DATEADD(wk, - @OlderWeekToPurge, GETDATE())
	Order by 
			cps.ProductCrossPriceSetID

	
	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '@SETIDs populated, record count: ' + convert(varchar,@@rowcount)


-- Computing running totals to be used for the row processing limit

	Set @i = 1
	Set @RunningTotal = 0
	
	While @i <= (select max(seqid) from @SETIDs)
	 begin

		Select	@RunningTotal = @RunningTotal + RowCnt
		from 	@SETIDs 
		where seqid = @i
	 
		Update @SETIDs 
		Set		RunningTotal = @RunningTotal
		from 	@SETIDs 
		where seqid = @i

		Set @i = @i + 1
	 end
	
-- Showing the results

	Select * 
	from @SETIDs
	Order by seqid

--	Fill #Referenced with price IDs found in Libertypower.dbo.AccountContractRate.

	Insert into #Referenced
	SELECT	
			p.ID
		,	p.ProductCrossPriceSetID
	FROM	
			Libertypower.dbo.AccountContractRate	acr 	WITH (NOLOCK)
	 join	Libertypower.dbo.Price							p   	WITH (NOLOCK) on p.ID = acr.PriceID
	WHERE	
			acr.PriceID IS NOT NULL
	GROUP BY 
			p.ID
		,	p.ProductCrossPriceSetID

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '#Referenced populated, record count: ' + convert(varchar,@@rowcount)

	Create Clustered index CIDX on #Referenced (ID, ProductCrossPriceSetID) with fillfactor = 100

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '#Referenced Indexed'

-- Collecting IDs in Price constrained by the SetIDs collected earlier and max Record processing, and then purge them of ones found referenced

	Insert into #ToDeleteSetID
	Select 
			p.ProductCrossPriceSetID
		,	p.ID
	from Libertypower.dbo.Price p with (nolock)
	join @SETIDs				s on s.ProductCrossPriceSetID = p.ProductCrossPriceSetID
	Where s.RunningTotal < @MaxRecordsToPurge
	Order by 	
			p.ProductCrossPriceSetID
		,	p.ID

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '#ToDeleteSetID Populated, record count: ' + convert(varchar,@@rowcount)

	Create unique index IDX_ID on #ToDeleteSetID (ID)
	with fillfactor = 100
	
	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '#ToDeleteSetID Index IDX_ID created'

	Delete  td
	from	#ToDeleteSetID	td
	join	#Referenced		tr with (nolock) on tr.ID = td.ID and tr.ProductCrossPriceSetID = td.ProductCrossPriceSetID

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select '#ToDeleteSetID Purged of referenced Prices, purged record count: ' + convert(varchar,@@rowcount)

-- Showing SETIDs and records that will actually be purged

	Select ProductCrossPriceSetID, cnt = COUNT(1)
	from	#ToDeleteSetID
	group by ProductCrossPriceSetID
	order by ProductCrossPriceSetID

--RETURN
--- This spot if required to disable existing non-clustered indexes on Price to improve deletion speed

/* Adding FK as protection from wrong deletions
 	NOTE!! suspended due to bad value in table (0)

	ALTER TABLE Libertypower.dbo.AccountContractRate
	ADD CONSTRAINT FK_PRICEID FOREIGN KEY (PRICEID)
    REFERENCES Libertypower.dbo.Price (ID) ;

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select 'FK created'


	Create Index PRICEID_FK on Libertypower.dbo.AccountContractRate (PriceID)
	with fillfactor=95

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select 'Index for FK created'

*/

/*  Loop logic

	For each SETID eligible to be purged:
		Until all rows for PriceSetID havebeen deleted:
			Collect into @ToDelete the first/next 5000 rows in #ToDeleteSetID for the SETID (in order of ID)  
			Delete from PRICE 
		
*/

	Set @DeletedRowsCnt = 0
	Set @iSETID = 1

	While @iSETID <= (select MAX(seqid) from @SETIDs)
	  and @DeletedRowsCnt < @MaxRecordsToPurge	
	 begin

		Select @ProductCrossPriceSetID = ProductCrossPriceSetID
		From	@SETIDs 
		where seqid = @iSETID

		Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
		Select 'Start processing ProductCrossPriceSetID ' + convert(varchar,@ProductCrossPriceSetID) + ' , Current @DeletedRowsCnt = ' + convert(varchar,@DeletedRowsCnt)

		-- Load with first 5000 rows
		Delete from @ToDelete
	 
		Insert into @ToDelete
		Select top 5000
				ID
		from #ToDeleteSetID
		where ProductCrossPriceSetID = @ProductCrossPriceSetID
		Order by ID
			
		Set @RowsToDeleteCnt = @@rowcount

		-- Loop thru all the records of the PriceSetID
		
		While @RowsToDeleteCnt > 0
		 Begin		

			-- @LastID is used to avoid deleting records from #ToDeleteSetID (the table is ordered by ProductCrossPriceSetID,ID).
			
			Select @LastID = max(ID)
			from @ToDelete

			/* TEST only 
			Insert into #TEST
			Select	@ProductCrossPriceSetID, p.ID
			from	libertypower.dbo.Price	p with (rowlock)
			join	@ToDelete				td on td.ID = p.ID
			Order by ID
			*/

			/* The Real stuff */
			Delete p
			from	libertypower.dbo.Price	p with (rowlock)
			join	@ToDelete				td on td.ID = p.ID
			


			Set @DeletedRowsCnt = @DeletedRowsCnt + @@rowcount

			Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
			Select 'Deleting ProductCrossPriceSetID ' + convert(varchar,@ProductCrossPriceSetID) 
				 + ' , @DeletedRowsCnt = ' + convert(varchar,@DeletedRowsCnt)
				 + ' , @LastID = ' + convert(varchar,@LastID)


			-- Reload with next 5000 rows
			Delete from @ToDelete
		 
			Insert into @ToDelete
			Select top 5000
					ID
			from #ToDeleteSetID
			where ProductCrossPriceSetID = @ProductCrossPriceSetID
			  and ID > @LastID
			Order by ID

			Set @RowsToDeleteCnt = @@rowcount

		 End
		
		Set @iSETID = @iSETID + 1

	 end

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select 'Loop for ProductCrossPriceSetIDs completed, Current @DeletedRowsCnt = ' + convert(varchar,@DeletedRowsCnt)

-- 

	if @Reindex = 1
	 begin
		Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
		Select 'Reindexing Price table' 

		Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
		Select 'Reindexing Price table not enabled at this time' 

		-- Alter Table Price REBUILD
		-- execute dbawork.dbo.dba_Reindex_DB_LCKTO_1 @DBName = 'LibertyPower', @Debug=1

		Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
		Select 'Reindexing Price table completed' 

	 end

--- This spot for re-enabling existing non-clustered indexes on Price to improve deletion speed (if needed)
	 
	 
/* Drop FK
 	NOTE : suspended due to bad value in table	(0)

	ALTER TABLE Libertypower.dbo.AccountContractRate
	DROP CONSTRAINT FK_PRICEID
	
*/

	--Select * from #TEST

	Insert into ##usp_RemoveUnusedPriceRecords_log (Notes) 
	Select 'End of process' 

	-- Showing content of the log for this execution only
	
	Select  *
	from ##usp_RemoveUnusedPriceRecords_log 
	where seqid > @InitialLogID
	Order by seqid
	
end