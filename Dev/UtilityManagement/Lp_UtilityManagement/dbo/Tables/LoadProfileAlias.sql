CREATE TABLE [dbo].[LoadProfileAlias] (
    [Id]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [LoadProfileId]        UNIQUEIDENTIFIER NOT NULL,
    [LoadProfileCodeAlias] NVARCHAR (255)   NOT NULL,
    [Inactive]             BIT              NOT NULL,
    [CreatedBy]            NVARCHAR (100)   NOT NULL,
    [CreatedDate]          DATETIME         NOT NULL,
    [LastModifiedBy]       NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]     DATETIME         NOT NULL,
    CONSTRAINT [PK_LoadProfileAlias] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LoadProfileAlias_LoadProfile] FOREIGN KEY ([LoadProfileId]) REFERENCES [dbo].[LoadProfile] ([Id])
);


GO
ALTER TABLE [dbo].[LoadProfileAlias] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO




CREATE TRIGGER [dbo].[zAuditLoadProfileAliasInsert]
	ON  [dbo].[LoadProfileAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLoadProfileAlias]
	(	
		[Id]
		,[LoadProfileId]
		,[LoadProfileCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[LoadProfileIdPrevious]
		,[LoadProfileCodeAliasPrevious]
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
			[LoadProfileId],
			[LoadProfileCodeAlias],
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
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,LoadProfileId,LoadProfileCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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





CREATE TRIGGER [dbo].[zAuditLoadProfileAliasUpdate]
	ON  [dbo].[LoadProfileAlias]
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
		dbo.zAuditLoadProfileAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],'') <> isnull(b.[LoadProfileId],'') THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileCodeAlias],'') <> isnull(b.[LoadProfileCodeAlias],'') THEN 'LoadProfileCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLoadProfileAlias]
	(
		[Id],
		[LoadProfileId],
		[LoadProfileCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[LoadProfileIdPrevious],
		[LoadProfileCodeAliasPrevious],
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
		a.[LoadProfileId],
		a.[LoadProfileCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[LoadProfileId],
		b.[LoadProfileCodeAlias],
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

