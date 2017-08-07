CREATE TABLE [dbo].[AccountInfoFieldRequired] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]   UNIQUEIDENTIFIER NOT NULL,
    [AccountInfoFieldId] UNIQUEIDENTIFIER NOT NULL,
    [IsRequired]         BIT              NOT NULL,
    [Inactive]           BIT              NOT NULL,
    [CreatedBy]          NVARCHAR (100)   NOT NULL,
    [CreatedDate]        DATETIME         NOT NULL,
    [LastModifiedBy]     NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]   DATETIME         NOT NULL,
    CONSTRAINT [PK_AccountInfoFieldRequired] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AccountInfoFieldRequired_AccountInfoField] FOREIGN KEY ([AccountInfoFieldId]) REFERENCES [dbo].[AccountInfoField] ([Id]),
    CONSTRAINT [FK_AccountInfoFieldRequired_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO





CREATE TRIGGER [dbo].[zAuditAccountInfoFieldRequiredInsert]
	ON  [dbo].[AccountInfoFieldRequired]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditAccountInfoFieldRequired]
	(	
		[Id],
		[UtilityCompanyId],
		[AccountInfoFieldId],
		[IsRequired],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[AccountInfoFieldIdPrevious],
		[IsRequiredPrevious],
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
			[AccountInfoFieldId],
			[IsRequired],
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
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,AccountInfoFieldId,IsRequired,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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





CREATE TRIGGER [dbo].[zAuditAccountInfoFieldRequiredUpdate]
	ON  [dbo].[AccountInfoFieldRequired]
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
		dbo.zAuditAccountInfoFieldRequired (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],NEWID()) <> isnull(b.[Id],NEWID()) THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],NEWID()) <> isnull(b.[UtilityCompanyId],NEWID()) THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountInfoFieldId],NEWID()) <> isnull(b.[AccountInfoFieldId],NEWID()) THEN 'AccountInfoFieldId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsRequired],'') <> isnull(b.[IsRequired],'') THEN 'IsRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditAccountInfoFieldRequired]
	(
		[Id],
		[UtilityCompanyId],
		[AccountInfoFieldId],
		[IsRequired],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[AccountInfoFieldIdPrevious],
		[IsRequiredPrevious],
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
		a.[AccountInfoFieldId],
		a.[IsRequired],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[AccountInfoFieldId],
		b.[IsRequired],
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