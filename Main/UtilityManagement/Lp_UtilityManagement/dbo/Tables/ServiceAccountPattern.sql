CREATE TABLE [dbo].[ServiceAccountPattern] (
    [Id]                                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                    UNIQUEIDENTIFIER NOT NULL,
    [ServiceAccountPattern]               NVARCHAR (255)   NULL,
    [ServiceAccountPatternDescription]    NVARCHAR (255)   NOT NULL,
    [ServiceAccountAddLeadingZero]        INT              NULL,
    [ServiceAccountTruncateLast]          INT              NULL,
    [ServiceAccountRequiredForEDIRequest] BIT              NOT NULL,
    [Inactive]                            BIT              NOT NULL,
    [CreatedBy]                           NVARCHAR (100)   NOT NULL,
    [CreatedDate]                         DATETIME         NOT NULL,
    [LastModifiedBy]                      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                    DATETIME         NOT NULL,
    CONSTRAINT [PK_ServiceAccountPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ServiceAccountPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditServiceAccountPatternUpdate]
	ON  [dbo].[ServiceAccountPattern]
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
		dbo.zAuditServiceAccountPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAccountPattern],'') <> isnull(b.[ServiceAccountPattern],'') THEN 'ServiceAccountPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAccountPatternDescription],'') <> isnull(b.[ServiceAccountPatternDescription],'') THEN 'ServiceAccountPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAccountAddLeadingZero],'') <> isnull(b.[ServiceAccountAddLeadingZero],'') THEN 'ServiceAccountAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAccountTruncateLast],'') <> isnull(b.[ServiceAccountTruncateLast],'') THEN 'ServiceAccountTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAccountRequiredForEDIRequest],'') <> isnull(b.[ServiceAccountRequiredForEDIRequest],'') THEN 'ServiceAccountRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditServiceAccountPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[ServiceAccountPattern],
		[ServiceAccountPatternDescription],
		[ServiceAccountAddLeadingZero],
		[ServiceAccountTruncateLast],
		[ServiceAccountRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceAccountPatternPrevious],
		[ServiceAccountPatternDescriptionPrevious],
		[ServiceAccountAddLeadingZeroPrevious],
		[ServiceAccountTruncateLastPrevious],
		[ServiceAccountRequiredForEDIRequestPrevious],
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
		,a.[ServiceAccountPattern]
		,a.[ServiceAccountPatternDescription]
		,a.[ServiceAccountAddLeadingZero]
		,a.[ServiceAccountTruncateLast]
		,a.[ServiceAccountRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[ServiceAccountPattern]
		,b.[ServiceAccountPatternDescription]
		,b.[ServiceAccountAddLeadingZero]
		,b.[ServiceAccountTruncateLast]
		,b.[ServiceAccountRequiredForEDIRequest]
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




CREATE TRIGGER [dbo].[zAuditServiceAccountPatternInsert]
	ON  [dbo].[ServiceAccountPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditServiceAccountPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[ServiceAccountPattern],
		[ServiceAccountPatternDescription],
		[ServiceAccountAddLeadingZero],
		[ServiceAccountTruncateLast],
		[ServiceAccountRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceAccountPatternPrevious],
		[ServiceAccountPatternDescriptionPrevious],
		[ServiceAccountAddLeadingZeroPrevious],
		[ServiceAccountTruncateLastPrevious],
		[ServiceAccountRequiredForEDIRequestPrevious],
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
			[ServiceAccountPattern],
			[ServiceAccountPatternDescription],
			[ServiceAccountAddLeadingZero],
			[ServiceAccountTruncateLast],
			[ServiceAccountRequiredForEDIRequest],
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
			'Id,UtilityCompanyId,ServiceAccountPattern,ServiceAccountPatternDescription,ServiceAccountAddLeadingZero,ServiceAccountTruncateLast,ServiceAccountRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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