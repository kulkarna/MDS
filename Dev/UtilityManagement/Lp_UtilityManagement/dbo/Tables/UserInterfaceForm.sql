CREATE TABLE [dbo].[UserInterfaceForm] (
    [Id]                    UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceFormName] VARCHAR (50)     NOT NULL,
    [Inactive]              BIT              NOT NULL,
    [CreatedBy]             NVARCHAR (100)   NOT NULL,
    [CreatedDate]           DATETIME         NOT NULL,
    [LastModifiedBy]        NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]      DATETIME         NOT NULL,
    CONSTRAINT [PK_UserInterfaceForm] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
ALTER TABLE [dbo].[UserInterfaceForm] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


GO


CREATE TRIGGER [dbo].[zAuditUserInterfaceFormUpdate]
	ON  [dbo].[UserInterfaceForm]
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
		dbo.zAuditUserInterfaceForm (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormName],'') <> isnull(b.[UserInterfaceFormName],'') THEN 'UserInterfaceFormName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceForm]
           ([Id]
           ,[UserInterfaceFormName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormNamePrevious]
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
		a.[UserInterfaceFormName],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormName],
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




GO
CREATE TRIGGER [dbo].[zAuditUserInterfaceFormInsert]
	ON  [dbo].[UserInterfaceForm]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceForm]
           ([Id]
           ,[UserInterfaceFormName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormNamePrevious]
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
		[UserInterfaceFormName],
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
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UserInterfaceFormName,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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
