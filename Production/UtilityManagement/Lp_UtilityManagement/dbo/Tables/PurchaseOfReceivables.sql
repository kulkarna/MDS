CREATE TABLE [dbo].[PurchaseOfReceivables] (
    [Id]                        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]          UNIQUEIDENTIFIER NOT NULL,
    [PorDriverId]               UNIQUEIDENTIFIER NOT NULL,
    [RateClassId]               UNIQUEIDENTIFIER NULL,
    [LoadProfileId]             UNIQUEIDENTIFIER NULL,
    [TariffCodeId]              UNIQUEIDENTIFIER NULL,
    [IsPorOffered]              BIT              NOT NULL,
    [IsPorParticipated]         BIT              NOT NULL,
    [PorRecourseId]             UNIQUEIDENTIFIER NOT NULL,
    [IsPorAssurance]            BIT              NOT NULL,
    [PorDiscountRate]           DECIMAL (18, 3)  NOT NULL,
    [PorFlatFee]                DECIMAL (18, 3)  NOT NULL,
    [PorDiscountEffectiveDate]  DATETIME         NOT NULL,
    [PorDiscountExpirationDate] DATETIME         NULL,
    [Inactive]                  BIT              NOT NULL,
    [CreatedBy]                 NVARCHAR (100)   NOT NULL,
    [CreatedDate]               DATETIME         NOT NULL,
    [LastModifiedBy]            NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]          DATETIME         NOT NULL,
    CONSTRAINT [PK_PurchaseOfReceivables] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PurchaseOfReceivables_LoadProfile] FOREIGN KEY ([LoadProfileId]) REFERENCES [dbo].[LoadProfile] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_PorDriver] FOREIGN KEY ([PorDriverId]) REFERENCES [dbo].[PorDriver] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_PorRecourse] FOREIGN KEY ([PorRecourseId]) REFERENCES [dbo].[PorRecourse] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_RateClass] FOREIGN KEY ([RateClassId]) REFERENCES [dbo].[RateClass] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_TariffCode] FOREIGN KEY ([TariffCodeId]) REFERENCES [dbo].[TariffCode] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);














GO
ALTER TABLE [dbo].[PurchaseOfReceivables] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);




GO



CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesInsert]
	ON  [dbo].[PurchaseOfReceivables]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 

	INSERT INTO [dbo].[zAuditPurchaseOfReceivables]
	(
		[Id]
       ,[UtilityCompanyId]
       ,[PorDriverId]
       ,[RateClassId]
       ,[LoadProfileId]
       ,[TariffCodeId]
       ,[IsPorOffered]
       ,[IsPorParticipated]
       ,[PorRecourseId]
       ,[IsPorAssurance]
       ,[PorDiscountRate]
       ,[PorFlatFee]
       ,[PorDiscountEffectiveDate]
       ,[PorDiscountExpirationDate]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[UtilityCompanyIdPrevious]
       ,[PorDriverIdPrevious]
       ,[RateClassIdPrevious]
       ,[LoadProfileIdPrevious]
       ,[TariffCodeIdPrevious]
       ,[IsPorOfferedPrevious]
       ,[IsPorParticipatedPrevious]
       ,[PorRecourseIdPrevious]
       ,[IsPorAssurancePrevious]
       ,[PorDiscountRatePrevious]
       ,[PorFlatFeePrevious]
       ,[PorDiscountEffectiveDatePrevious]
       ,[PorDiscountExpirationDatePrevious]
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
       ,[UtilityCompanyId]
       ,[PorDriverId]
       ,[RateClassId]
       ,[LoadProfileId]
       ,[TariffCodeId]
       ,[IsPorOffered]
       ,[IsPorParticipated]
       ,[PorRecourseId]
       ,[IsPorAssurance]
       ,[PorDiscountRate]
       ,[PorFlatFee]
       ,[PorDiscountEffectiveDate]
       ,[PorDiscountExpirationDate]
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
       ,NULL
       ,NULL
       ,NULL
       ,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCompanyId,PorDriverId,RateClassId,LoadProfileId,TariffCodeId,IsPorOffered,IsPorParticipated,PorRecourceId,IsPorAssurance,PorDiscountRate,PorFlatFee,PorDiscountEffectiveDate,PorDiscountExpirationDate,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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



CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesUpdate]
	ON [dbo].[PurchaseOfReceivables]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMHU.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditPurchaseOfReceivables (NOLOCK) ZARMHU 
		INNER JOIN inserted a
			ON ZARMHU.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],NEWID()) <> isnull(b.[Id],NEWID()) THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],NEWID()) <> isnull(b.[UtilityCompanyId],NEWID()) THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDriverId],NEWID()) <> isnull(b.[PorDriverId],NEWID()) THEN 'PorDriverId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],NEWID()) <> isnull(b.[RateClassId],NEWID()) THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],NEWID()) <> isnull(b.[LoadProfileId],NEWID()) THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],NEWID()) <> isnull(b.[TariffCodeId],NEWID()) THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorOffered],'') <> isnull(b.[IsPorOffered],'') THEN 'IsPorOffered' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorParticipated],'') <> isnull(b.[IsPorParticipated],'') THEN 'IsPorParticipated' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorRecourseId],NEWID()) <> isnull(b.[PorRecourseId],NEWID()) THEN 'PorRecourseId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorAssurance],'') <> isnull(b.[IsPorAssurance],'') THEN 'IsPorAssurance' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountRate],'') <> isnull(b.[PorDiscountRate],'') THEN 'PorDiscountRate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorFlatFee],'') <> isnull(b.[PorFlatFee],'') THEN 'PorFlatFee' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountEffectiveDate],'') <> isnull(b.[PorDiscountEffectiveDate],'') THEN 'PorDiscountEffectiveDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountExpirationDate],'') <> isnull(b.[PorDiscountExpirationDate],'') THEN 'PorDiscountExpirationDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditPurchaseOfReceivables]
           ([Id]
           ,[UtilityCompanyId]
           ,[PorDriverId]
           ,[RateClassId]
           ,[LoadProfileId]
           ,[TariffCodeId]
           ,[IsPorOffered]
           ,[IsPorParticipated]
           ,[PorRecourseId]
           ,[IsPorAssurance]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UtilityCompanyIdPrevious]
           ,[PorDriverIdPrevious]
           ,[RateClassIdPrevious]
           ,[LoadProfileIdPrevious]
           ,[TariffCodeIdPrevious]
           ,[IsPorOfferedPrevious]
           ,[IsPorParticipatedPrevious]
           ,[PorRecourseIdPrevious]
           ,[IsPorAssurancePrevious]
           ,[PorDiscountRatePrevious]
           ,[PorFlatFeePrevious]
           ,[PorDiscountEffectiveDatePrevious]
           ,[PorDiscountExpirationDatePrevious]
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
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[PorDriverId]
		,a.[RateClassId]
		,a.[LoadProfileId]
		,a.[TariffCodeId]
		,a.[IsPorOffered]
		,a.[IsPorParticipated]
		,a.[PorRecourseId]
		,a.[IsPorAssurance]
		,a.[PorDiscountRate]
		,a.[PorFlatFee]
		,a.[PorDiscountEffectiveDate]
		,a.[PorDiscountExpirationDate]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[PorDriverId]
		,b.[RateClassId]
		,b.[LoadProfileId]
		,b.[TariffCodeId]
		,b.[IsPorOffered]
		,b.[IsPorParticipated]
		,b.[PorRecourseId]
		,b.[IsPorAssurance]
		,b.[PorDiscountRate]
		,b.[PorFlatFee]
		,b.[PorDiscountEffectiveDate]
		,b.[PorDiscountExpirationDate]
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


