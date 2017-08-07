CREATE TABLE [dbo].[TariffCodeAlias] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [TariffCodeId]        UNIQUEIDENTIFIER NOT NULL,
    [TariffCodeCodeAlias] NVARCHAR (255)   NOT NULL,
    [Inactive]            BIT              NOT NULL,
    [CreatedBy]           NVARCHAR (100)   NOT NULL,
    [CreatedDate]         DATETIME         NOT NULL,
    [LastModifiedBy]      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]    DATETIME         NOT NULL,
    CONSTRAINT [PK_TariffCodeAlias] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TariffCodeAlias_TariffCode] FOREIGN KEY ([TariffCodeId]) REFERENCES [dbo].[TariffCode] ([Id])
);


GO
ALTER TABLE [dbo].[TariffCodeAlias] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO







CREATE TRIGGER [dbo].[zAuditTariffCodeAliasInsert]
	ON  [dbo].[TariffCodeAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditTariffCodeAlias]
	(	
		[Id]
		,[TariffCodeId]
		,[TariffCodeCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[TariffCodeIdPrevious]
		,[TariffCodeCodeAliasPrevious]
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
			[TariffCodeId],
			[TariffCodeCodeAlias],
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
			'Id,TariffCodeId,TariffCodeCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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





CREATE TRIGGER [dbo].[zAuditTariffCodeAliasUpdate]
	ON  [dbo].[TariffCodeAlias]
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
		dbo.zAuditTariffCodeAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],'') <> isnull(b.[TariffCodeId],'') THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeCodeAlias],'') <> isnull(b.[TariffCodeCodeAlias],'') THEN 'TariffCodeCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditTariffCodeAlias]
	(
		[Id],
		[TariffCodeId],
		[TariffCodeCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[TariffCodeIdPrevious],
		[TariffCodeCodeAliasPrevious],
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
		a.[TariffCodeId],
		a.[TariffCodeCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[TariffCodeId],
		b.[TariffCodeCodeAlias],
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

