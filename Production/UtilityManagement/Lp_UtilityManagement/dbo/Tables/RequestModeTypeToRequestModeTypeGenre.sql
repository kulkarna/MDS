CREATE TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre] (
    [Id]                     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RequestModeTypeId]      UNIQUEIDENTIFIER NOT NULL,
    [RequestModeTypeGenreId] UNIQUEIDENTIFIER NOT NULL,
    [Inactive]               BIT              NOT NULL,
    [CreatedBy]              NVARCHAR (100)   NOT NULL,
    [CreatedDate]            DATETIME         NOT NULL,
    [LastModifiedBy]         NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]       DATETIME         NOT NULL,
    CONSTRAINT [PK_RequestModeTypeToRequestModeTypeGenre] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeType] FOREIGN KEY ([RequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeTypeGenre] FOREIGN KEY ([RequestModeTypeGenreId]) REFERENCES [dbo].[RequestModeTypeGenre] ([Id])
);


GO
ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


GO




CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeTypeGenreInsert]
	ON  [dbo].[RequestModeTypeToRequestModeTypeGenre]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeTypeGenreId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeTypeGenreIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[RequestModeTypeId],
		[RequestModeTypeGenreId],
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
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,RequestModeTypeId,RequestModeTypeGenreId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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



CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeTypeGenreUpdate]
	ON  [dbo].[RequestModeTypeToRequestModeTypeGenre]
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
		dbo.zAuditRequestModeTypeToRequestModeTypeGenre (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeGenreId],'') <> isnull(b.[RequestModeTypeGenreId],'') THEN 'RequestModeTypeGenreId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeTypeGenreId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeTypeGenreIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[RequestModeTypeId],
		a.[RequestModeTypeGenreId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RequestModeTypeId],
		b.[RequestModeTypeGenreId],
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

