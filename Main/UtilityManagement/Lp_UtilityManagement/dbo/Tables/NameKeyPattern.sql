CREATE TABLE [dbo].[NameKeyPattern] (
    [Id]                           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]             UNIQUEIDENTIFIER NOT NULL,
    [NameKeyPattern]               NVARCHAR (255)   NULL,
    [NameKeyPatternDescription]    NVARCHAR (255)   NOT NULL,
    [NameKeyAddLeadingZero]        INT              NULL,
    [NameKeyTruncateLast]          INT              NULL,
    [NameKeyRequiredForEDIRequest] BIT              NOT NULL,
    [Inactive]                     BIT              NOT NULL,
    [CreatedBy]                    NVARCHAR (100)   NOT NULL,
    [CreatedDate]                  DATETIME         NOT NULL,
    [LastModifiedBy]               NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]             DATETIME         NOT NULL,
    CONSTRAINT [PK_NameKeyPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_NameKeyPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditNameKeyPatternUpdate]
	ON  [dbo].[NameKeyPattern]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(AZUC.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditNameKeyPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[NameKeyPattern],'') <> isnull(b.[NameKeyPattern],'') THEN 'NameKeyPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[NameKeyPatternDescription],'') <> isnull(b.[NameKeyPatternDescription],'') THEN 'NameKeyPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[NameKeyAddLeadingZero],'') <> isnull(b.[NameKeyAddLeadingZero],'') THEN 'NameKeyAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[NameKeyTruncateLast],'') <> isnull(b.[NameKeyTruncateLast],'') THEN 'NameKeyTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[NameKeyRequiredForEDIRequest],'') <> isnull(b.[NameKeyRequiredForEDIRequest],'') THEN 'NameKeyRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditNameKeyPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[NameKeyPattern],
		[NameKeyPatternDescription],
		[NameKeyAddLeadingZero],
		[NameKeyTruncateLast],
		[NameKeyRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[NameKeyPatternPrevious],
		[NameKeyPatternDescriptionPrevious],
		[NameKeyAddLeadingZeroPrevious],
		[NameKeyTruncateLastPrevious],
		[NameKeyRequiredForEDIRequestPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[NameKeyPattern]
		,a.[NameKeyPatternDescription]
		,a.[NameKeyAddLeadingZero]
		,a.[NameKeyTruncateLast]
		,a.[NameKeyRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[NameKeyPattern]
		,b.[NameKeyPatternDescription]
		,b.[NameKeyAddLeadingZero]
		,b.[NameKeyTruncateLast]
		,b.[NameKeyRequiredForEDIRequest]
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
			
	SET NOCOUNT OFF;

END
GO




CREATE TRIGGER [dbo].[zAuditNameKeyPatternInsert]
	ON  [dbo].[NameKeyPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditNameKeyPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[NameKeyPattern],
		[NameKeyPatternDescription],
		[NameKeyAddLeadingZero],
		[NameKeyTruncateLast],
		[NameKeyRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[NameKeyPatternPrevious],
		[NameKeyPatternDescriptionPrevious],
		[NameKeyAddLeadingZeroPrevious],
		[NameKeyTruncateLastPrevious],
		[NameKeyRequiredForEDIRequestPrevious],
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
			[NameKeyPattern],
			[NameKeyPatternDescription],
			[NameKeyAddLeadingZero],
			[NameKeyTruncateLast],
			[NameKeyRequiredForEDIRequest],
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
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,NameKeyPattern,NameKeyPatternDescription,NameKeyAddLeadingZero,NameKeyTruncateLast,NameKeyRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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