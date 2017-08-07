	----------------	SCRIPT TO PORT OLD ACCOUNT EVENTS TO NEW EVENT LOGGING SYSTEM	----------------


	----------------	INSERT NEW CONTRACT EVENTS	----------------
IF NOT EXISTS(SELECT 1 FROM [LibertyPower]..[ContractEventType] WHERE [ContractEventTypeId] > 23)
BEGIN
	INSERT INTO [LibertyPower]..[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (24, 'ContractMerged', 'Contract was merged', 1, '20120821 15:56:04')
	INSERT INTO [LibertyPower]..[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (25, 'DealDateChangedManual', 'Deal date was manual changed', 1, '20120821 15:57:28')
END


IF NOT EXISTS(SELECT 1 FROM [LibertyPower]..[AccountEventType] WHERE [AccountEventTypeId] > 15)
BEGIN
	INSERT INTO [LibertyPower]..[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (16, 'ProductChangedManual', 'Product was manual changed', 1, 1, '20120821 15:56:33')
	INSERT INTO [LibertyPower]..[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (17, 'RateStartChangedManual', 'Rate Start was manual changed', 1, 1, '20120821 15:57:04')
END

	----------------	SCRIPT TO PORT OLD ACCOUNT EVENTS TO NEW EVENT LOGGING SYSTEM	----------------

--Fields from old AccountEventHistory table
DECLARE @EventId				int
DECLARE @AccountId				int
DECLARE @ContractId				int
DECLARE @EventDate				DateTime
DECLARE @EventEffectiveDate		DateTime

--Store for NEW AccountEventType, converted from OLD EventStatus
DECLARE @EventTypeId		int


DECLARE IHateCursors CURSOR FOR
	--Get list of Account Events not ported to the new tables
	SELECT DISTINCT
--TOP 1000					--UNCOMMENT to migrate old events in smaller batches
		aeh.[ID]
		,a.[AccountId]
		,ac.[ContractID]
		,aeh.[EventID]			--OLD EventId
		,aeh.[EventDate]
		,aeh.[EventEffectiveDate]
	FROM [LibertyPower]..[AccountEventHistory]		aeh WITH (NOLOCK)
	JOIN [LibertyPower]..[Account]					a WITH (NOLOCK)
		ON a.AccountIdLegacy = aeh.AccountId
	JOIN [LibertyPower]..[AccountContract]			ac WITH (NOLOCK)
		ON ac.AccountID = a.AccountID
	LEFT JOIN [LibertyPower]..[EventInstance]		ei WITH (NOLOCK)
		ON ei.Notes = CAST(aeh.ID AS varchar(20))	--Items with a matching OLD EventId in the Notes field have already been processed.
		AND ei.CreatedBy = 'System/DataMigration'
	WHERE ei.Notes IS NULL		--Get only the AccountEventHistory items NOT already added to NEW EventInstance table


	OPEN IHateCursors;

	FETCH NEXT FROM IHateCursors
	INTO @EventId, @AccountID, @ContractId, @EventTypeId, @EventDate, @EventEffectiveDate
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [LibertyPower]..[EventInstance] (
			[ParentEventId]
			,[EventDomainId]
			,[EventStatusId]
			,[ScheduledTime]
			,[LastUpdated]
			,[IsStarted]
			,[IsSuspended]
			,[IsCompleted]
			,[Notes]
			,[CreatedBy]
			,[DateCreated]
		) VALUES (
			NULL							--AS ParentEventId
			,1								--AS EventDomainId
			,4								--AS EventStatusId
			,@EventEffectiveDate			--AS ScheduledTime
			,GETDATE()						--AS LastUpdated
			,1								--AS IsStarted
			,0								--AS IsSuspended
			,1								--AS IsCompleted
			,@EventId						--AS Notes			--PUT ID of old event into notes for verification/correlation
			,'System/DataMigration'			--AS CreatedBy
			,GETDATE()						--AS DateCreated
		)

		--Add a Contract Event
		IF(@EventTypeId = 1 OR @EventTypeId = 2 OR @EventTypeId = 7 OR @EventTypeId = 9 OR @EventTypeId = 13 OR @EventTypeId = 17 OR @EventTypeId = 18)
			INSERT INTO [LibertyPower]..[ContractEvent] (
				[EventInstanceId]
				,[ContractEventTypeId]
				,[ContractId]
			) VALUES (
				@@IDENTITY						--AS EventInstanceId	--The items in AccountEvent are children of EventInstance
				,CASE @EventTypeId
					WHEN 1 THEN 1				--DealSubmission				to	Created
					WHEN 2 THEN 1				--RenewalSubmission				to	Created
					WHEN 7 THEN 19				--CheckAccountEvent				to	DealScreeningComplete
					WHEN 9 THEN 1				--ContractConversion			to	Created
					WHEN 13 THEN 24				--ContractMerge					to	ContractMerged
					WHEN 17 THEN 25				--DealDateChangeManual			to	DealDateChangedManual
					WHEN 18 THEN 22				--SalesChannelChangeManual		to	SalesChannelChanged
					ELSE 0
				END
				,@ContractId					--AS ContractId
			)

		ELSE	--Add an AccountEvent

		IF(@EventTypeId = 3 OR @EventTypeId = 4 OR @EventTypeId = 6 OR @EventTypeId = 8 OR @EventTypeId = 10 OR @EventTypeId = 11 OR @EventTypeId = 12 OR @EventTypeId = 14 OR @EventTypeId = 15 OR @EventTypeId = 16)
			INSERT INTO [LibertyPower]..[AccountEvent] (
				[EventInstanceId]
				,[AccountEventTypeId]
				,[AccountId]
			) VALUES (
				@@IDENTITY						--AS EventInstanceId	--The items in AccountEvent are children of EventInstance
	--			,@EventTypeId			--AS AccountEventTypeId
				,CASE @EventTypeId
					--WHEN 2 THEN 12				--RenewalSubmission				to	Existing Account Renewed
					WHEN 3 THEN 14				--UsageUpdate					to	Account Usage Updated Automatically
					WHEN 4 THEN 8				--Enrollment					to	Account Enrolled/Created
					WHEN 5 THEN 13				--Rollover						to	Account Rollover Occured
					WHEN 6 THEN 9				--RateChange					to	Account Rate Changed Automatically
					--WHEN 7 THEN 1				--CheckAccountEvent				to	Account Information Verified (aka CheckAccount)
					WHEN 8 THEN 3				--DeEnrollment					to	Account De-enrolled
					WHEN 10 THEN 2				--Commission					to	Account Commission Calculated
					WHEN 11 THEN 10				--RateChangeManual				to	Account Rate Changed Manually
					WHEN 12 THEN 15				--UsageUpdateManual				to	Account Usage Updated Manually
					WHEN 14 THEN 16				--ProductChangeManual			to	ProductChangedManual
					WHEN 15 THEN 10				--ProductRateChangeManual		to	Account Rate Changed Manually
					WHEN 16 THEN 17				--ContractEffChangeManual		to	RateStartChangedManual
					ELSE 0
				END
				,@AccountID						--AS AccountId
			)

		FETCH NEXT FROM IHateCursors
		INTO @EventId, @AccountID, @ContractId, @EventTypeId, @EventDate, @EventEffectiveDate
	END

	CLOSE IHateCursors
	DEALLOCATE IHateCursors


/*
	--USE TO CLEAR ANY DUMMY DATA FROM NEW EVENT TABLES--

truncate table [LibertyPower]..[ContractEvent] 
truncate table [LibertyPower]..[AccountEvent]
truncate table [LibertyPower]..[CustomerEvent] 
truncate table [LibertyPower]..[EventError]
delete from [LibertyPower]..[EventInstance]

*/



