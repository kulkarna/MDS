CREATE TABLE [dbo].[MeterType] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]    UNIQUEIDENTIFIER NULL,
    [MeterTypeCode]       NVARCHAR (255)   NOT NULL,
    [Description]         NVARCHAR (255)   NOT NULL,
    [AccountTypeId]       UNIQUEIDENTIFIER NOT NULL,
    [LpStandardMeterType] NVARCHAR (255)   NOT NULL,
    [Sequence]            INT              NOT NULL,
    [Inactive]            BIT              NOT NULL,
    [CreatedBy]           NVARCHAR (100)   NOT NULL,
    [CreatedDate]         DATETIME         NOT NULL,
    [LastModifiedBy]      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]    DATETIME         NOT NULL,
    CONSTRAINT [PK_MeterType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MeterType_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([Id]),
    CONSTRAINT [FK_MeterType_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO
ALTER TABLE [dbo].[MeterType] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO



CREATE TRIGGER [dbo].[zAuditMeterTypeInsert]
	ON  [dbo].[MeterType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditMeterType]
	(	
		[Id],
		[UtilityCompanyId],
		[MeterTypeCode],
		[Description],
		[AccountTypeId],
		[LpStandardMeterType],
		[Sequence],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterTypeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardMeterTypePrevious],
		[SequencePrevious],
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
			[MeterTypeCode],
			[Description],
			[AccountTypeId],
			[LpStandardMeterType],
			[Sequence],
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
			'Id,UtilityCompanyId,MeterTypeCode,Description,AccountTypeId,LpStandardMeterType,Sequence,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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




CREATE TRIGGER [dbo].[zAuditMeterTypeUpdate]
	ON  [dbo].[MeterType]
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
		dbo.zAuditMeterType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterTypeCode],'') <> isnull(b.[MeterTypeCode],'') THEN 'MeterTypeCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardMeterType],'') <> isnull(b.[LpStandardMeterType],'') THEN 'LpStandardMeterType' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Sequence],'') <> isnull(b.[Sequence],'') THEN 'Sequence' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditMeterType]
	(
		[Id],
		[UtilityCompanyId],
		[MeterTypeCode],
		[Description],
		[AccountTypeId],
		[LpStandardMeterType],
		[Sequence],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterTypeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardMeterTypePrevious],
		[SequencePrevious],
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
		a.[MeterTypeCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardMeterType],
		a.[Sequence],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[MeterTypeCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardMeterType],
		b.[Sequence],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
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
