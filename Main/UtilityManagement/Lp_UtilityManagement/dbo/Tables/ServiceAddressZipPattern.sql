CREATE TABLE [dbo].[ServiceAddressZipPattern] (
    [Id]                                     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                       UNIQUEIDENTIFIER NOT NULL,
    [ServiceAddressZipPattern]               NVARCHAR (255)   NULL,
    [ServiceAddressZipPatternDescription]    NVARCHAR (255)   NOT NULL,
    [ServiceAddressZipAddLeadingZero]        INT              NULL,
    [ServiceAddressZipTruncateLast]          INT              NULL,
    [ServiceAddressZipRequiredForEDIRequest] BIT              NOT NULL,
    [Inactive]                               BIT              NOT NULL,
    [CreatedBy]                              NVARCHAR (100)   NOT NULL,
    [CreatedDate]                            DATETIME         NOT NULL,
    [LastModifiedBy]                         NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                       DATETIME         NOT NULL,
    CONSTRAINT [PK_ServiceAddressZipPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ServiceAddressZipPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditServiceAddressZipPatternUpdate]
	ON  [dbo].[ServiceAddressZipPattern]
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
		dbo.zAuditServiceAddressZipPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAddressZipPattern],'') <> isnull(b.[ServiceAddressZipPattern],'') THEN 'ServiceAddressZipPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAddressZipPatternDescription],'') <> isnull(b.[ServiceAddressZipPatternDescription],'') THEN 'ServiceAddressZipPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAddressZipAddLeadingZero],'') <> isnull(b.[ServiceAddressZipAddLeadingZero],'') THEN 'ServiceAddressZipAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAddressZipTruncateLast],'') <> isnull(b.[ServiceAddressZipTruncateLast],'') THEN 'ServiceAddressZipTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceAddressZipRequiredForEDIRequest],'') <> isnull(b.[ServiceAddressZipRequiredForEDIRequest],'') THEN 'ServiceAddressZipRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditServiceAddressZipPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[ServiceAddressZipPattern],
		[ServiceAddressZipPatternDescription],
		[ServiceAddressZipAddLeadingZero],
		[ServiceAddressZipTruncateLast],
		[ServiceAddressZipRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceAddressZipPatternPrevious],
		[ServiceAddressZipPatternDescriptionPrevious],
		[ServiceAddressZipAddLeadingZeroPrevious],
		[ServiceAddressZipTruncateLastPrevious],
		[ServiceAddressZipRequiredForEDIRequestPrevious],
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
		,a.[ServiceAddressZipPattern]
		,a.[ServiceAddressZipPatternDescription]
		,a.[ServiceAddressZipAddLeadingZero]
		,a.[ServiceAddressZipTruncateLast]
		,a.[ServiceAddressZipRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[ServiceAddressZipPattern]
		,b.[ServiceAddressZipPatternDescription]
		,b.[ServiceAddressZipAddLeadingZero]
		,b.[ServiceAddressZipTruncateLast]
		,b.[ServiceAddressZipRequiredForEDIRequest]
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




CREATE TRIGGER [dbo].[zAuditServiceAddressZipPatternInsert]
	ON  [dbo].[ServiceAddressZipPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditServiceAddressZipPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[ServiceAddressZipPattern],
		[ServiceAddressZipPatternDescription],
		[ServiceAddressZipAddLeadingZero],
		[ServiceAddressZipTruncateLast],
		[ServiceAddressZipRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceAddressZipPatternPrevious],
		[ServiceAddressZipPatternDescriptionPrevious],
		[ServiceAddressZipAddLeadingZeroPrevious],
		[ServiceAddressZipTruncateLastPrevious],
		[ServiceAddressZipRequiredForEDIRequestPrevious],
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
			[ServiceAddressZipPattern],
			[ServiceAddressZipPatternDescription],
			[ServiceAddressZipAddLeadingZero],
			[ServiceAddressZipTruncateLast],
			[ServiceAddressZipRequiredForEDIRequest],
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
			'Id,UtilityCompanyId,ServiceAddressZipPattern,ServiceAddressZipPatternDescription,ServiceAddressZipAddLeadingZero,ServiceAddressZipTruncateLast,ServiceAddressZipRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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