CREATE TABLE [dbo].[UtilityBillingType] (
    [Id]                          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]            UNIQUEIDENTIFIER NOT NULL,
    [PorDriverId]                 UNIQUEIDENTIFIER NOT NULL,
    [RateClassId]                 UNIQUEIDENTIFIER NULL,
    [LoadProfileId]               UNIQUEIDENTIFIER NULL,
    [TariffCodeId]                UNIQUEIDENTIFIER NULL,
    [UtilityOfferedBillingTypeId] UNIQUEIDENTIFIER NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    CONSTRAINT [PK_UtilityBillingType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UtilityBillingType_BillingType] FOREIGN KEY ([UtilityOfferedBillingTypeId]) REFERENCES [dbo].[BillingType] ([Id]),
    CONSTRAINT [FK_UtilityBillingType_LoadProfile] FOREIGN KEY ([LoadProfileId]) REFERENCES [dbo].[LoadProfile] ([Id]),
    CONSTRAINT [FK_UtilityBillingType_RateClass] FOREIGN KEY ([RateClassId]) REFERENCES [dbo].[RateClass] ([Id]),
    CONSTRAINT [FK_UtilityBillingType_TariffCode] FOREIGN KEY ([TariffCodeId]) REFERENCES [dbo].[TariffCode] ([Id]),
    CONSTRAINT [FK_UtilityBillingType_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO



CREATE TRIGGER [dbo].[zAuditUtilityBillingTypeUpdate]
	ON  [dbo].[UtilityBillingType]
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
		dbo.zAuditUtilityBillingType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],NEWID()) <> isnull(b.[Id],NEWID()) THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],NEWID()) <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDriverId],NEWID()) <> isnull(b.[PorDriverId],NEWID()) THEN 'PorDriverId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],NEWID()) <> isnull(b.[RateClassId],NEWID()) THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],NEWID()) <> isnull(b.[LoadProfileId],NEWID()) THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],NEWID()) <> isnull(b.[TariffCodeId],NEWID()) THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityOfferedBillingTypeId],NEWID()) <> isnull(b.[UtilityOfferedBillingTypeId],NEWID()) THEN 'UtilityOfferedBillingTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUtilityBillingType]
	(
		[Id],
		[UtilityCompanyId],
		[PorDriverId],
		[RateClassId],
		[LoadProfileId],
		[TariffCodeId],
		[UtilityOfferedBillingTypeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[PorDriverIdPrevious],
		[RateClassIdPrevious],
		[LoadProfileIdPrevious],
		[TariffCodeIdPrevious],
		[UtilityOfferedBillingTypeIdPrevious],
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
		a.[Id],
		a.[UtilityCompanyId],
		a.[PorDriverId],
		a.[RateClassId],
		a.[LoadProfileId],
		a.[TariffCodeId],
		a.[UtilityOfferedBillingTypeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[PorDriverId],
		b.[RateClassId],
		b.[LoadProfileId],
		b.[TariffCodeId],
		b.[UtilityOfferedBillingTypeId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
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
GO


---------------------------

CREATE TRIGGER [dbo].[zAuditUtilityBillingTypeInsert]
	ON  [dbo].[UtilityBillingType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUtilityBillingType]
	(	
		[Id],
		[UtilityCompanyId],
		[PorDriverId],
		[RateClassId],
		[LoadProfileId],
		[TariffCodeId],
		[UtilityOfferedBillingTypeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[PorDriverIdPrevious],
		[RateClassIdPrevious],
		[LoadProfileIdPrevious],
		[TariffCodeIdPrevious],
		[UtilityOfferedBillingTypeIdPrevious],
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
			[PorDriverId],
			[RateClassId],
			[LoadProfileId],
			[TariffCodeId],
			[UtilityOfferedBillingTypeId],
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
			'Id,UtilityCompanyId,PorDriverId,RateClassId,LoadProfileId,TariffCodeId,UtilityOfferedBillingTypeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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