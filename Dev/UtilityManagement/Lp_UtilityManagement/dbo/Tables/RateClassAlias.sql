CREATE TABLE [dbo].[RateClassAlias] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RateClassId]        UNIQUEIDENTIFIER NOT NULL,
    [RateClassCodeAlias] NVARCHAR (255)   NOT NULL,
    [Inactive]           BIT              NOT NULL,
    [CreatedBy]          NVARCHAR (100)   NOT NULL,
    [CreatedDate]        DATETIME         NOT NULL,
    [LastModifiedBy]     NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]   DATETIME         NOT NULL,
    CONSTRAINT [PK_RateClassAlias] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RateClassAlias_RateClass] FOREIGN KEY ([RateClassId]) REFERENCES [dbo].[RateClass] ([Id])
);


GO
ALTER TABLE [dbo].[RateClassAlias] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO

CREATE TRIGGER [dbo].[zAuditRateClassAliasInsert]
	ON  [dbo].[RateClassAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRateClassAlias]
	(	
		[Id]
		,[RateClassId]
		,[RateClassCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[RateClassIdPrevious]
		,[RateClassCodeAliasPrevious]
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
			[RateClassId],
			[RateClassCodeAlias],
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
			'Id,RateClassId,RateClassCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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


CREATE TRIGGER [dbo].[zAuditRateClassAliasUpdate]
	ON  [dbo].[RateClassAlias]
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
		dbo.zAuditRateClassAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],'') <> isnull(b.[RateClassId],'') THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassCodeAlias],'') <> isnull(b.[RateClassCodeAlias],'') THEN 'RateClassCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRateClassAlias]
	(
		[Id],
		[RateClassId],
		[RateClassCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[RateClassIdPrevious],
		[RateClassCodeAliasPrevious],
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
		a.[RateClassId],
		a.[RateClassCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RateClassId],
		b.[RateClassCodeAlias],
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
