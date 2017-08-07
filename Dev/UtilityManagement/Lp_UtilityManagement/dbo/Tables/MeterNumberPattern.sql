CREATE TABLE [dbo].[MeterNumberPattern] (
    [Id]                               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                 UNIQUEIDENTIFIER NOT NULL,
    [MeterNumberPattern]               NVARCHAR (255)   NULL,
    [MeterNumberPatternDescription]    NVARCHAR (255)   NULL,
    [MeterNumberAddLeadingZero]        INT              NULL,
    [MeterNumberTruncateLast]          INT              NULL,
    [MeterNumberRequiredForEdiRequest] BIT              NOT NULL,
    [Inactive]                         BIT              NOT NULL,
    [CreatedBy]                        NVARCHAR (100)   NOT NULL,
    [CreatedDate]                      DATETIME         NOT NULL,
    [LastModifiedBy]                   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                 DATETIME         NOT NULL,
    CONSTRAINT [PK_MeterNumberPattern] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MeterNumberPattern_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditMeterNumberPatternUpdate]
	ON  [dbo].[MeterNumberPattern]
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
		dbo.zAuditMeterNumberPattern (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberPattern],'') <> isnull(b.[MeterNumberPattern],'') THEN 'MeterNumberPattern' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberPatternDescription],'') <> isnull(b.[MeterNumberPatternDescription],'') THEN 'MeterNumberPatternDescription' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberAddLeadingZero],'') <> isnull(b.[MeterNumberAddLeadingZero],'') THEN 'MeterNumberAddLeadingZero' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberTruncateLast],'') <> isnull(b.[MeterNumberTruncateLast],'') THEN 'MeterNumberTruncateLast' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterNumberRequiredForEDIRequest],'') <> isnull(b.[MeterNumberRequiredForEDIRequest],'') THEN 'MeterNumberRequiredForEDIRequest' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditMeterNumberPattern] 
	(
		[Id],
		[UtilityCompanyId],
		[MeterNumberPattern],
		[MeterNumberPatternDescription],
		[MeterNumberAddLeadingZero],
		[MeterNumberTruncateLast],
		[MeterNumberRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterNumberPatternPrevious],
		[MeterNumberPatternDescriptionPrevious],
		[MeterNumberAddLeadingZeroPrevious],
		[MeterNumberTruncateLastPrevious],
		[MeterNumberRequiredForEDIRequestPrevious],
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
		,a.[MeterNumberPattern]
		,a.[MeterNumberPatternDescription]
		,a.[MeterNumberAddLeadingZero]
		,a.[MeterNumberTruncateLast]
		,a.[MeterNumberRequiredForEDIRequest]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[MeterNumberPattern]
		,b.[MeterNumberPatternDescription]
		,b.[MeterNumberAddLeadingZero]
		,b.[MeterNumberTruncateLast]
		,b.[MeterNumberRequiredForEDIRequest]
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




CREATE TRIGGER [dbo].[zAuditMeterNumberPatternInsert]
	ON  [dbo].[MeterNumberPattern]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditMeterNumberPattern]
	(	
		[Id],
		[UtilityCompanyId],
		[MeterNumberPattern],
		[MeterNumberPatternDescription],
		[MeterNumberAddLeadingZero],
		[MeterNumberTruncateLast],
		[MeterNumberRequiredForEDIRequest],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterNumberPatternPrevious],
		[MeterNumberPatternDescriptionPrevious],
		[MeterNumberAddLeadingZeroPrevious],
		[MeterNumberTruncateLastPrevious],
		[MeterNumberRequiredForEDIRequestPrevious],
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
			[MeterNumberPattern],
			[MeterNumberPatternDescription],
			[MeterNumberAddLeadingZero],
			[MeterNumberTruncateLast],
			[MeterNumberRequiredForEDIRequest],
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
			'Id,UtilityCompanyId,MeterNumberPattern,MeterNumberPatternDescription,MeterNumberAddLeadingZero,MeterNumberTruncateLast,MeterNumberRequiredForEDIRequest,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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