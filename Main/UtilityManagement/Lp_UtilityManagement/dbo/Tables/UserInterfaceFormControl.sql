CREATE TABLE [dbo].[UserInterfaceFormControl] (
    [Id]                  UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceFormId] UNIQUEIDENTIFIER NOT NULL,
    [ControlName]         VARCHAR (50)     NOT NULL,
    [Inactive]            BIT              NOT NULL,
    [CreatedBy]           NVARCHAR (100)   NOT NULL,
    [CreatedDate]         DATETIME         NOT NULL,
    [LastModifiedBy]      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]    DATETIME         NOT NULL,
    CONSTRAINT [PK_UserInterfaceFormControls] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UserInterfaceFormControl_UserInterfaceForm] FOREIGN KEY ([UserInterfaceFormId]) REFERENCES [dbo].[UserInterfaceForm] ([Id])
);


GO
ALTER TABLE [dbo].[UserInterfaceFormControl] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


GO
CREATE TRIGGER [dbo].[zAuditUserInterfaceFormControlInsert]
	ON  [dbo].[UserInterfaceFormControl]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceFormControl]
           ([Id]
           ,[UserInterfaceFormId]
           ,[ControlName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[ControlNamePrevious]
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
		[UserInterfaceFormId],
		[ControlName],
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
		,'Id,UserInterfaceFormId,ControlName,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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


CREATE TRIGGER [dbo].[zAuditUserInterfaceFormControlUpdate]
	ON  [dbo].[UserInterfaceFormControl]
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
		dbo.zAuditUserInterfaceFormControl (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormId],'') <> isnull(b.[UserInterfaceFormId],'') THEN 'UserInterfaceFormId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ControlName],'') <> isnull(b.[ControlName],'') THEN 'ControlName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceFormControl]
           ([Id]
           ,[UserInterfaceFormId]
           ,[ControlName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[ControlNamePrevious]
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
		a.[UserInterfaceFormId],
		a.[ControlName],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormId],
		b.[ControlName],
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



