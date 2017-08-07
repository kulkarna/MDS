CREATE TABLE [dbo].[UtilityCompany] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCode]         VARCHAR (50)     NOT NULL,
    [Inactive]            BIT              NOT NULL,
    [CreatedBy]           NVARCHAR (100)   NOT NULL,
    [CreatedDate]         DATETIME         NOT NULL,
    [LastModifiedBy]      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]    DATETIME         NOT NULL,
    [UtilityIdInt]        INT              NOT NULL,
    [FullName]            NVARCHAR (255)   NULL,
    [IsoId]               UNIQUEIDENTIFIER NOT NULL,
    [MarketId]            UNIQUEIDENTIFIER NOT NULL,
    [PrimaryDunsNumber]   NVARCHAR (255)   NULL,
    [LpEntityId]          NVARCHAR (255)   NULL,
    [SalesForceId]        NVARCHAR (255)   NULL,
    [ParentCompany]       NVARCHAR (255)   NULL,
    [UtilityStatusId]     UNIQUEIDENTIFIER NOT NULL,
    [EnrollmentLeadDays]  INT              NULL,
    [AccountLength]       INT              NULL,
    [AccountNumberPrefix] NVARCHAR (10)    NULL,
    [PorOption]           BIT              NOT NULL,
    [MeterNumberRequired] BIT              NOT NULL,
    [MeterNumberLength]   SMALLINT         NULL,
    [EdiCapabale]         BIT              NOT NULL,
    [UtilityPhoneNumber]  NVARCHAR (30)    NULL,
    [BillingTypeId]       UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_UtilityCompany] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityCompany_BillingType] FOREIGN KEY ([BillingTypeId]) REFERENCES [dbo].[BillingType] ([Id]),
    CONSTRAINT [FK_UtilityCompany_ISO] FOREIGN KEY ([IsoId]) REFERENCES [dbo].[ISO] ([Id]),
    CONSTRAINT [FK_UtilityCompany_Market] FOREIGN KEY ([MarketId]) REFERENCES [dbo].[Market] ([Id]),
    CONSTRAINT [FK_UtilityCompany_TriStateValuePendingActiveInactive] FOREIGN KEY ([UtilityStatusId]) REFERENCES [dbo].[TriStateValuePendingActiveInactive] ([Id])
);




















GO
ALTER TABLE [dbo].[UtilityCompany] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


GO

CREATE TRIGGER [dbo].[zAuditUtilityCompanyInsert]
	ON  [dbo].[UtilityCompany]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 


	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditUtilityCompany]
	(
		[Id]
		,[UtilityCode]
		,[FullName]
		,[IsoId]
		,[MarketId]
		,[PrimaryDunsNumber]
		,[LpEntityId]
		,[UtilityStatusId]
		,[ParentCompany]
		,[SalesForceId]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[UtilityCodePrevious]
		,[FullNamePrevious]
		,[IsoIdPrevious]
		,[MarketIdPrevious]
		,[PrimaryDunsNumberPrevious]
		,[LpEntityIdPrevious]
		,[UtilityStatusIdPrevious]
		,[ParentCompanyPrevious]
		,[SalesForceIdPrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		[Id]
		,[UtilityCode]
		,[FullName]
		,[IsoId]
		,[MarketId]
		,[PrimaryDunsNumber]
		,[LpEntityId]
		,[UtilityStatusId]
		,[ParentCompany]
		,[SalesForceId]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
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
		,'Id,UtilityCode,FullName,IsoId,MarketId,PrimaryDunsNumber,LpEntityId,UtilityStatusId,ParentCompany,SalesForceIdInactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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


CREATE TRIGGER [dbo].[zAuditUtilityCompanyUpdate]
	ON  [dbo].[UtilityCompany]
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
		dbo.zAuditUtilityCompany (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCode],'') <> isnull(b.[UtilityCode],'') THEN 'UtilityCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[FullName],'') <> isnull(b.[FullName],'') THEN 'FullName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsoId],NEWID()) <> isnull(b.[IsoId],NEWID()) THEN 'IsoId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MarketId],NEWID()) <> isnull(b.[MarketId],NEWID()) THEN 'MarketId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PrimaryDunsNumber],'') <> isnull(b.[PrimaryDunsNumber],'') THEN 'PrimaryDunsNumber' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpEntityId],'') <> isnull(b.[LpEntityId],'') THEN 'LpEntityId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityStatusId],NEWID()) <> isnull(b.[UtilityStatusId],NEWID()) THEN 'UtilityStatusId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ParentCompany],'') <> isnull(b.[ParentCompany],'') THEN 'ParentCompany' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[SalesForceId],'') <> isnull(b.[SalesForceId],'') THEN 'SalesForceId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditUtilityCompany] 
	(
		[Id]
		,[UtilityCode]
		,[FullName]
		,[IsoId]
		,[MarketId]
		,[PrimaryDunsNumber]
		,[LpEntityId]
		,[UtilityStatusId]
		,[ParentCompany]
		,[SalesForceId]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[UtilityCodePrevious]
		,[FullNamePrevious]
		,[IsoIdPrevious]
		,[MarketIdPrevious]
		,[PrimaryDunsNumberPrevious]
		,[LpEntityIdPrevious]
		,[UtilityStatusIdPrevious]
		,[ParentCompanyPrevious]
		,[SalesForceIdPrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id]
		,a.[UtilityCode]
		,a.[FullName]
		,a.[IsoId]
		,a.[MarketId]
		,a.[PrimaryDunsNumber]
		,a.[LpEntityId]
		,a.[UtilityStatusId]
		,a.[ParentCompany]
		,a.[SalesForceId]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCode]
		,b.[FullName]
		,b.[IsoId]
		,b.[MarketId]
		,b.[PrimaryDunsNumber]
		,b.[LpEntityId]
		,b.[UtilityStatusId]
		,b.[ParentCompany]
		,b.[SalesForceId]
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
