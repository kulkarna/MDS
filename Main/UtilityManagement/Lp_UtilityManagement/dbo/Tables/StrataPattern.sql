CREATE TABLE [dbo].[StrataPattern] (
    [Id]                          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]            UNIQUEIDENTIFIER NOT NULL,
    [StrataPattern]               NVARCHAR (255)   NULL,
    [StrataPatternDescription]    NVARCHAR (255)   NULL,
    [StrataAddLeadingZero]        INT              NULL,
    [StrataTruncateLast]          INT              NULL,
    [StrataRequiredForEdiRequest] BIT              NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    CONSTRAINT [PK_StrataPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_StrataPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditStrataPatternUpdate]
	ON  [dbo].[StrataPattern]
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
		dbo.zAuditStrataPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[StrataPattern],'') <> isnull(b.[StrataPattern],'') THEN 'StrataPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[StrataPatternDescription],'') <> isnull(b.[StrataPatternDescription],'') THEN 'StrataPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[StrataAddLeadingZero],'') <> isnull(b.[StrataAddLeadingZero],'') THEN 'StrataAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[StrataTruncateLast],'') <> isnull(b.[StrataTruncateLast],'') THEN 'StrataTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[StrataRequiredForEDIRequest],'') <> isnull(b.[StrataRequiredForEDIRequest],'') THEN 'StrataRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditStrataPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[StrataPattern],
		[StrataPatternDescription],
		[StrataAddLeadingZero],
		[StrataTruncateLast],
		[StrataRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[StrataPatternPrevious],
		[StrataPatternDescriptionPrevious],
		[StrataAddLeadingZeroPrevious],
		[StrataTruncateLastPrevious],
		[StrataRequiredForEDIRequestPrevious],
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
		,a.[StrataPattern]
		,a.[StrataPatternDescription]
		,a.[StrataAddLeadingZero]
		,a.[StrataTruncateLast]
		,a.[StrataRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[StrataPattern]
		,b.[StrataPatternDescription]
		,b.[StrataAddLeadingZero]
		,b.[StrataTruncateLast]
		,b.[StrataRequiredForEDIRequest]
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




CREATE TRIGGER [dbo].[zAuditStrataPatternInsert]
	ON  [dbo].[StrataPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditStrataPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[StrataPattern],
		[StrataPatternDescription],
		[StrataAddLeadingZero],
		[StrataTruncateLast],
		[StrataRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[StrataPatternPrevious],
		[StrataPatternDescriptionPrevious],
		[StrataAddLeadingZeroPrevious],
		[StrataTruncateLastPrevious],
		[StrataRequiredForEDIRequestPrevious],
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
			[StrataPattern],
			[StrataPatternDescription],
			[StrataAddLeadingZero],
			[StrataTruncateLast],
			[StrataRequiredForEDIRequest],
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
			'Id,UtilityCompanyId,StrataPattern,StrataPatternDescription,StrataAddLeadingZero,StrataTruncateLast,StrataRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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