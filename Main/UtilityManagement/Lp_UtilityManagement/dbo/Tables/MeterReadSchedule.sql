CREATE TABLE [dbo].[MeterReadSchedule] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId] UNIQUEIDENTIFIER NOT NULL,
    [UtilityTripId]    UNIQUEIDENTIFIER NOT NULL,
    [YearId]           UNIQUEIDENTIFIER NOT NULL,
    [MonthId]          UNIQUEIDENTIFIER NOT NULL,
    [ReadDate]         DATETIME         NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_MeterReadSchedule] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MeterReadSchedule_Month] FOREIGN KEY ([MonthId]) REFERENCES [dbo].[Month] ([Id]),
    CONSTRAINT [FK_MeterReadSchedule_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id]),
    CONSTRAINT [FK_MeterReadSchedule_UtilityTrip] FOREIGN KEY ([UtilityTripId]) REFERENCES [dbo].[UtilityTrip] ([Id]),
    CONSTRAINT [FK_MeterReadSchedule_Year] FOREIGN KEY ([YearId]) REFERENCES [dbo].[Year] ([Id])
);


GO




CREATE TRIGGER [dbo].[zAuditMeterReadScheduleUpdate]
	ON  [dbo].[MeterReadSchedule]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditMeterReadSchedule (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],NEWID()) <> isnull(b.[UtilityCompanyId],NEWID()) THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityTripId],NEWID()) <> isnull(b.[UtilityTripId],NEWID()) THEN 'UtilityTripId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[YearId],NEWID()) <> isnull(b.[YearId],NEWID()) THEN 'YearId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MonthId],NEWID()) <> isnull(b.[MonthId],NEWID()) THEN 'MonthId' + ',' ELSE '' END
		+ CASE WHEN a.[ReadDate] <> b.[ReadDate] THEN 'ReadDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditMeterReadSchedule]
	(
		[Id],
		[UtilityCompanyId],
		[UtilityTripId],
		[YearId],
		[MonthId],
		[ReadDate],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[UtilityTripIdPrevious],
		[YearIdPrevious],
		[MonthIdPrevious],
		[ReadDatePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[UtilityTripId],
		a.[YearId],
		a.[MonthId],
		a.[ReadDate],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[UtilityTripId],
		b.[YearId],
		b.[MonthId],
		b.[ReadDate],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
	SET NOCOUNT OFF;
END
GO





CREATE TRIGGER [dbo].[zAuditMeterReadScheduleInsert]
	ON  [dbo].[MeterReadSchedule]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditMeterReadSchedule]
	(	
		[Id]
		,[UtilityCompanyId]
		,[UtilityTripId]
		,[YearId]
		,[MonthId]
		,[ReadDate]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[UtilityCompanyIdPrevious]
		,[UtilityTripIdPrevious]
		,[YearIdPrevious]
		,[MonthIdPrevious]
		,[ReadDatePrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[UtilityTripId],
			[YearId],
			[MonthId],
			[ReadDate],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,UtilityTripId,YearId,MonthId,ReadDate,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END