CREATE TABLE [dbo].[TariffCode] (
    [Id]                     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]       UNIQUEIDENTIFIER NOT NULL,
    [LpStandardTariffCodeId] UNIQUEIDENTIFIER NOT NULL,
    [TariffCodeCode]         NVARCHAR (255)   NOT NULL,
    [Description]            NVARCHAR (255)   NOT NULL,
    [AccountTypeId]          UNIQUEIDENTIFIER NOT NULL,
    [Inactive]               BIT              NOT NULL,
    [CreatedBy]              NVARCHAR (100)   NOT NULL,
    [CreatedDate]            DATETIME         NOT NULL,
    [LastModifiedBy]         NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]       DATETIME         NOT NULL,
    [TariffCodeId]           INT              NOT NULL,
    CONSTRAINT [PK_TariffCode] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TariffCode_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([Id]),
    CONSTRAINT [FK_TariffCode_LpStandardTariffCode] FOREIGN KEY ([LpStandardTariffCodeId]) REFERENCES [dbo].[LpStandardTariffCode] ([Id]),
    CONSTRAINT [FK_TariffCode_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO


CREATE TRIGGER [dbo].[zAuditTariffCodeUpdate]
	ON  [dbo].[TariffCode]
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
		dbo.zAuditTariffCode (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeCode],'') <> isnull(b.[TariffCodeCode],'') THEN 'TariffCodeCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN a.[LpStandardTariffCodeId] <> b.[LpStandardTariffCodeId] THEN 'LpStandardTariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],0) <> isnull(b.[TariffCodeId],0) THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditTariffCode]
	(
		[Id],
		[UtilityCompanyId],
		[TariffCodeCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCodeId],
		[TariffCodeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodeIdPrevious],
		[TariffCodeIdPrevious],
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
		a.[TariffCodeCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardTariffCodeId],
		a.[TariffCodeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[TariffCodeCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardTariffCodeId],
		b.[TariffCodeId],
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



CREATE TRIGGER [dbo].[zAuditTariffCodeInsert]
	ON  [dbo].[TariffCode]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditTariffCode]
	(	
		[Id],
		[UtilityCompanyId],
		[TariffCodeCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCodeId],
		[TariffCodeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodeIdPrevious],
		[TariffCodeIdPrevious],
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
			[TariffCodeCode],
			[Description],
			[AccountTypeId],
			[LpStandardTariffCodeId],
			[TariffCodeId],
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
			'Id,UtilityCompanyId,TariffCodeCode,Description,AccountTypeId,LpStandardTariffCodeId,TariffCodeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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