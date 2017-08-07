CREATE TABLE [dbo].[RateClass] (
    [Id]                    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]      UNIQUEIDENTIFIER NOT NULL,
    [RateClassCode]         NVARCHAR (255)   NOT NULL,
    [Description]           NVARCHAR (255)   NOT NULL,
    [AccountTypeId]         UNIQUEIDENTIFIER NOT NULL,
    [Inactive]              BIT              NOT NULL,
    [CreatedBy]             NVARCHAR (100)   NOT NULL,
    [CreatedDate]           DATETIME         NOT NULL,
    [LastModifiedBy]        NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]      DATETIME         NOT NULL,
    [RateClassId]           INT              NOT NULL,
    [LpStandardRateClassId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RateClass] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RateClass_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([Id]),
    CONSTRAINT [FK_RateClass_LpStandardRateClass] FOREIGN KEY ([LpStandardRateClassId]) REFERENCES [dbo].[LpStandardRateClass] ([Id]),
    CONSTRAINT [FK_RateClass_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO
ALTER TABLE [dbo].[RateClass] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO


CREATE TRIGGER [dbo].[zAuditRateClassInsert]
	ON  [dbo].[RateClass]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRateClass]
	(	
		[Id],
		[UtilityCompanyId],
		[RateClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardRateClassId],
		[RateClassId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RateClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardRateClassIdPrevious],
		[RateClassIdPrevious],
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
			[Id],
			[UtilityCompanyId],
			[RateClassCode],
			[Description],
			[AccountTypeId],
			[LpStandardRateClassId],
			[RateClassId],
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
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,RateClassCode,Description,AccountTypeId,LpStandardRateClassId,RateClassId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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



GO

CREATE TRIGGER [dbo].[zAuditRateClassUpdate]
	ON  [dbo].[RateClass]
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
		dbo.zAuditRateClass (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassCode],'') <> isnull(b.[RateClassCode],'') THEN 'RateClassCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN a.[LpStandardRateClassId] <> b.[LpStandardRateClassId] THEN 'LpStandardRateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],0) <> isnull(b.[RateClassId],0) THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRateClass]
	(
		[Id],
		[UtilityCompanyId],
		[RateClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardRateClassId],
		[RateClassId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RateClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardRateClassIdPrevious],
		[RateClassIdPrevious],
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
		a.[RateClassCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardRateClassId],
		a.[RateClassId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[RateClassCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardRateClassId],
		b.[RateClassId],
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
