CREATE TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] (
    [Id]                          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RequestModeTypeId]           UNIQUEIDENTIFIER NOT NULL,
    [RequestModeEnrollmentTypeId] UNIQUEIDENTIFIER NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    [RequestModeTypeGenreId]      UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RequestModeTypeToRequestModeEnrollmentType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeEnrollmentType] FOREIGN KEY ([RequestModeEnrollmentTypeId]) REFERENCES [dbo].[RequestModeEnrollmentType] ([Id]),
    CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeType] FOREIGN KEY ([RequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeTypeGenre] FOREIGN KEY ([RequestModeTypeGenreId]) REFERENCES [dbo].[RequestModeTypeGenre] ([Id])
);


GO





CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeInsert]
	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeEnrollmentTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
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
		[RequestModeEnrollmentTypeId],
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
		,'Id,RequestModeTypeId,RequestModeEnrollmentTypeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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



CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeUpdate]
	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
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
		dbo.zAuditRequestModeTypeToRequestModeEnrollmentType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeEnrollmentTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
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
		a.[RequestModeEnrollmentTypeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RequestModeTypeId],
		b.[RequestModeEnrollmentTypeId],
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

