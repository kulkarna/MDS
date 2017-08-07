CREATE TABLE [dbo].[IdrRule] (
    [Id]                           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]             UNIQUEIDENTIFIER NOT NULL,
    [RateClassId]                  UNIQUEIDENTIFIER NULL,
    [LoadProfileId]                UNIQUEIDENTIFIER NULL,
    [MinUsageMWh]                  INT              NULL,
    [MaxUsageMWh]                  INT              NULL,
    [IsOnEligibleCustomerList]     BIT              NOT NULL,
    [IsHistoricalArchiveAvailable] BIT              NOT NULL,
    [Inactive]                     BIT              NOT NULL,
    [CreatedBy]                    NVARCHAR (100)   NOT NULL,
    [CreatedDate]                  DATETIME         NOT NULL,
    [LastModifiedBy]               NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]             DATETIME         NOT NULL,
    [RequestModeIdrId]             UNIQUEIDENTIFIER NULL,
    [RequestModeTypeId]            UNIQUEIDENTIFIER NULL,
    [TariffCodeId]                 UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_IdrRule] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_IdrRule_LoadProfile] FOREIGN KEY ([LoadProfileId]) REFERENCES [dbo].[LoadProfile] ([Id]),
    CONSTRAINT [FK_IdrRule_RateClass] FOREIGN KEY ([RateClassId]) REFERENCES [dbo].[RateClass] ([Id]),
    CONSTRAINT [FK_IdrRule_RequestModeIdr] FOREIGN KEY ([RequestModeIdrId]) REFERENCES [dbo].[RequestModeIdr] ([Id]),
    CONSTRAINT [FK_IdrRule_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id]),
    CONSTRAINT [FK_IdrRules_LoadProfile] FOREIGN KEY ([LoadProfileId]) REFERENCES [dbo].[LoadProfile] ([Id]),
    CONSTRAINT [FK_IdrRules_TariffCode] FOREIGN KEY ([TariffCodeId]) REFERENCES [dbo].[TariffCode] ([Id])
);














GO
ALTER TABLE [dbo].[IdrRule] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);




GO
CREATE TRIGGER [dbo].[zAuditIdrRuleUpdate]
	ON  [dbo].[IdrRule]
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
		dbo.zAuditIdrRule (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],NEWID()) <> isnull(b.[Id],NEWID()) THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],NEWID()) <> isnull(b.[UtilityCompanyId],NEWID()) THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],NEWID()) <> isnull(b.[RequestModeTypeId],NEWID()) THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeIdrId],NEWID()) <> isnull(b.[RequestModeIdrId],NEWID()) THEN 'RequestModeIdrId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],NEWID()) <> isnull(b.[RateClassId],NEWID()) THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],NEWID()) <> isnull(b.[LoadProfileId],NEWID()) THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],NEWID()) <> isnull(b.[TariffCodeId],NEWID()) THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MinUsageMWh],'') <> isnull(b.[MinUsageMWh],'') THEN 'MinUsageMWh' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MaxUsageMWh],'') <> isnull(b.[MaxUsageMWh],'') THEN 'MaxUsageMWh' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsOnEligibleCustomerList],'') <> isnull(b.[IsOnEligibleCustomerList],'') THEN 'IsOnEligibleCustomerList' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsHistoricalArchiveAvailable],'') <> isnull(b.[IsHistoricalArchiveAvailable],'') THEN 'IsHistoricalArchiveAvailable' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].zAuditIdrRule 
	(
	[Id],
	[UtilityCompanyId],
	[RequestModeTypeId],
	[RequestModeIdrId],
	[RateClassId],
	[LoadProfileId],
	[TariffCodeId],
	[MinUsageMWh],
	[MaxUsageMWh],
	[IsOnEligibleCustomerList],
	[IsHistoricalArchiveAvailable],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate],
	[IdPrevious],
	[UtilityCompanyIdPrevious],
	[RequestModeTypeIdPrevious],
	[RequestModeIdrIdPrevious],
	[RateClassIdPrevious],
	[LoadProfileIdPrevious] ,
	[TariffCodeIdPrevious] ,
	[MinUsageMWhPrevious],
	[MaxUsageMWhPrevious],
	[IsOnEligibleCustomerListPrevious],
	[IsHistoricalArchiveAvailablePrevious],
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
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[RequestModeTypeId]
		,a.[RequestModeIdrId]
		,a.[RateClassId]
		,a.[LoadProfileId]
		,a.[TariffCodeId]
		,a.[MinUsageMWh]
		,a.[MaxUsageMWh]
		,a.[IsOnEligibleCustomerList]
		,a.[IsHistoricalArchiveAvailable]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[RequestModeTypeId]
		,a.[RequestModeIdrId]
		,b.[RateClassId]
		,b.[LoadProfileId]
		,b.[TariffCodeId]
		,b.[MinUsageMWh]
		,b.[MaxUsageMWh]
		,b.[IsOnEligibleCustomerList]
		,b.[IsHistoricalArchiveAvailable]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,
		@ChangeTrackingCurrentVersion
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
CREATE TRIGGER [dbo].[zAuditIdrRuleInsert]
	ON  [dbo].[IdrRule]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 


	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditIdrRule]
	(
	[Id],
	[UtilityCompanyId],
	[RequestModeTypeId],
	[RequestModeIdrId],
	[RateClassId],
	[LoadProfileId],
	[TariffCodeId],
	[MinUsageMWh],
	[MaxUsageMWh],
	[IsOnEligibleCustomerList],
	[IsHistoricalArchiveAvailable],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate],
	[IdPrevious],
	[UtilityCompanyIdPrevious],
	[RequestModeTypeIdPrevious],
	[RequestModeIdrIdPrevious],
	[RateClassIdPrevious],
	[LoadProfileIdPrevious],
	[TariffCodeIdPrevious],
	[MinUsageMWhPrevious],
	[MaxUsageMWhPrevious],
	[IsOnEligibleCustomerListPrevious],
	[IsHistoricalArchiveAvailablePrevious],
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
	[RequestModeTypeId],
	[RequestModeIdrId],
	[RateClassId],
	[LoadProfileId],
	[TariffCodeId],
	[MinUsageMWh],
	[MaxUsageMWh],
	[IsOnEligibleCustomerList],
	[IsHistoricalArchiveAvailable],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate]
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
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCompanyId,RequestModeTypeId,RequestModeIdrId,RateClassId,LoadProfileId,TariffCodeId,MinUsageMWh,MaxUsageMWh,IsOnEligibleCustomerList,IsHistoricalArchiveAvailable,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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