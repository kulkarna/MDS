CREATE TABLE [dbo].[UserInterfaceControlVisibility] (
    [Id]                                                       UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceFormId]                                      UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceFormControlId]                               UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceControlAndValueGoverningControlVisibilityId] UNIQUEIDENTIFIER NOT NULL,
    [Inactive]                                                 BIT              NOT NULL,
    [CreatedBy]                                                NVARCHAR (100)   NOT NULL,
    [CreatedDate]                                              DATETIME         NOT NULL,
    [LastModifiedBy]                                           NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                                         DATETIME         NOT NULL,
    CONSTRAINT [PK_UserInterfaceControlVisibility] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceControlAndValueGoverningControlVisibility] FOREIGN KEY ([UserInterfaceControlAndValueGoverningControlVisibilityId]) REFERENCES [dbo].[UserInterfaceControlAndValueGoverningControlVisibility] ([Id]),
    CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceForm] FOREIGN KEY ([UserInterfaceFormId]) REFERENCES [dbo].[UserInterfaceForm] ([Id]),
    CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceFormControl] FOREIGN KEY ([UserInterfaceFormControlId]) REFERENCES [dbo].[UserInterfaceFormControl] ([Id])
);


GO
ALTER TABLE [dbo].[UserInterfaceControlVisibility] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


GO
CREATE TRIGGER [dbo].[zAuditUserInterfaceControlVisibilityInsert]
	ON  [dbo].[UserInterfaceControlVisibility]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlId]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlIdPrevious]
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
		[UserInterfaceFormControlId],
		[UserInterfaceControlAndValueGoverningControlVisibilityId],
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
		,'Id,UserInterfaceFormId,UserInterfaceFormControlId,UserInterfaceControlAndValueGoverningControlVisibilityId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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


CREATE TRIGGER [dbo].[zAuditUserInterfaceControlVisibilityUpdate]
	ON  [dbo].[UserInterfaceControlVisibility]
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
		dbo.zAuditUserInterfaceControlVisibility (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormId],'') <> isnull(b.[UserInterfaceFormId],'') THEN 'UserInterfaceFormId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormControlId],'') <> isnull(b.[UserInterfaceFormControlId],'') THEN 'UserInterfaceFormControlId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceControlAndValueGoverningControlVisibilityId],'') <> isnull(b.[UserInterfaceControlAndValueGoverningControlVisibilityId],'') THEN 'UserInterfaceControlAndValueGoverningControlVisibilityId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlId]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlIdPrevious]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityIdPrevious]
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
		a.[UserInterfaceFormControlId],
		a.[UserInterfaceControlAndValueGoverningControlVisibilityId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormId],
		b.[UserInterfaceFormControlId],
		b.[UserInterfaceControlAndValueGoverningControlVisibilityId],
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



