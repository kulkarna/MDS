CREATE TABLE [dbo].[BillingAccountPattern] (
    [Id]                                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                    UNIQUEIDENTIFIER NOT NULL,
    [BillingAccountPattern]               NVARCHAR (255)   NULL,
    [BillingAccountPatternDescription]    NVARCHAR (255)   NOT NULL,
    [BillingAccountAddLeadingZero]        INT              NULL,
    [BillingAccountTruncateLast]          INT              NULL,
    [BillingAccountRequiredForEDIRequest] BIT              NOT NULL,
    [Inactive]                            BIT              NOT NULL,
    [CreatedBy]                           NVARCHAR (100)   NOT NULL,
    [CreatedDate]                         DATETIME         NOT NULL,
    [LastModifiedBy]                      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                    DATETIME         NOT NULL,
    CONSTRAINT [PK_BillingAccountPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BillingAccountPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO


CREATE TRIGGER [dbo].[zAuditBillingAccountPatternUpdate]
	ON  [dbo].[BillingAccountPattern]
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
		dbo.zAuditBillingAccountPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingAccountPattern],'') <> isnull(b.[BillingAccountPattern],'') THEN 'BillingAccountPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingAccountPatternDescription],'') <> isnull(b.[BillingAccountPatternDescription],'') THEN 'BillingAccountPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingAccountAddLeadingZero],'') <> isnull(b.[BillingAccountAddLeadingZero],'') THEN 'BillingAccountAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingAccountTruncateLast],'') <> isnull(b.[BillingAccountTruncateLast],'') THEN 'BillingAccountTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[BillingAccountRequiredForEDIRequest],'') <> isnull(b.[BillingAccountRequiredForEDIRequest],'') THEN 'BillingAccountRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditBillingAccountPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[BillingAccountPattern],
		[BillingAccountPatternDescription],
		[BillingAccountAddLeadingZero],
		[BillingAccountTruncateLast],
		[BillingAccountRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[BillingAccountPatternPrevious],
		[BillingAccountPatternDescriptionPrevious],
		[BillingAccountAddLeadingZeroPrevious],
		[BillingAccountTruncateLastPrevious],
		[BillingAccountRequiredForEDIRequestPrevious],
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
		,a.[BillingAccountPattern]
		,a.[BillingAccountPatternDescription]
		,a.[BillingAccountAddLeadingZero]
		,a.[BillingAccountTruncateLast]
		,a.[BillingAccountRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[BillingAccountPattern]
		,b.[BillingAccountPatternDescription]
		,b.[BillingAccountAddLeadingZero]
		,b.[BillingAccountTruncateLast]
		,b.[BillingAccountRequiredForEDIRequest]
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



CREATE TRIGGER [dbo].[zAuditBillingAccountPatternInsert]
	ON  [dbo].[BillingAccountPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditBillingAccountPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[BillingAccountPattern],
		[BillingAccountPatternDescription],
		[BillingAccountAddLeadingZero],
		[BillingAccountTruncateLast],
		[BillingAccountRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[BillingAccountPatternPrevious],
		[BillingAccountPatternDescriptionPrevious],
		[BillingAccountAddLeadingZeroPrevious],
		[BillingAccountTruncateLastPrevious],
		[BillingAccountRequiredForEDIRequestPrevious],
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
			[BillingAccountPattern],
			[BillingAccountPatternDescription],
			[BillingAccountAddLeadingZero],
			[BillingAccountTruncateLast],
			[BillingAccountRequiredForEDIRequest],
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
			'Id,UtilityCompanyId,BillingAccountPattern,BillingAccountPatternDescription,BillingAccountAddLeadingZero,BillingAccountTruncateLast,BillingAccountRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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