CREATE TABLE [dbo].[RequestModeTypeGenre] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]             NVARCHAR (50)    NOT NULL,
    [Description]      NVARCHAR (255)   NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_RequestModeTypeGenre] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO





CREATE TRIGGER [dbo].[zAuditRequestModeTypeGenreInsert]
	ON  [dbo].[RequestModeTypeGenre]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	INSERT INTO [dbo].[zAuditRequestModeTypeGenre]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
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
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,Name,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted a

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




CREATE TRIGGER [dbo].[zAuditRequestModeTypeGenreUpdate]
	ON  [dbo].[RequestModeTypeGenre]
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
		dbo.zAuditRequestModeType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Name],'') <> isnull(b.[Name],'') THEN 'Name' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditRequestModeTypeGenre]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
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
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[Name]
		,b.[Description]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
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

