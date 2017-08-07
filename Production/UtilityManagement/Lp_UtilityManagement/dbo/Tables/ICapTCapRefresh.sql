CREATE TABLE [dbo].[ICapTCapRefresh] (
    [Id]                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]  UNIQUEIDENTIFIER NOT NULL,
    [ICapNextRefresh]   NVARCHAR (4)     NULL,
    [ICapEffectiveDate] NVARCHAR (4)     NULL,
    [TCapNextRefresh]   NVARCHAR (4)     NULL,
    [TCapEffectiveDate] NVARCHAR (4)     NULL,
    [Inactive]          BIT              NOT NULL,
    [CreatedBy]         NVARCHAR (100)   NOT NULL,
    [CreatedDate]       DATETIME         NOT NULL,
    [LastModifiedBy]    NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]  DATETIME         NOT NULL,
    CONSTRAINT [PK_ICapTCapRefresh] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ICapTCapRefresh_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);




GO



CREATE TRIGGER [dbo].[zAuditICapTCapRefreshUpdate]
	ON  [dbo].[ICapTCapRefresh]
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
		dbo.zAuditICapTCapRefresh (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN a.[ICapNextRefresh] <> b.[ICapNextRefresh] THEN 'ICapNextRefresh' + ',' ELSE '' END
		+ CASE WHEN a.[ICapEffectiveDate] <> b.[ICapEffectiveDate] THEN 'ICapEffectiveDate' + ',' ELSE '' END
		+ CASE WHEN a.[TCapNextRefresh] <> b.[TCapNextRefresh] THEN 'TCapNextRefresh' + ',' ELSE '' END
		+ CASE WHEN a.[TCapEffectiveDate] <> b.[TCapEffectiveDate] THEN 'TCapEffectiveDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditICapTCapRefresh] 
	(
		[Id],
		[UtilityCompanyId],
		[ICapNextRefresh],
		[ICapEffectiveDate],
		[TCapNextRefresh],
		[TCapEffectiveDate],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ICapNextRefreshPrevious],
		[ICapEffectiveDatePrevious],
		[TCapNextRefreshPrevious],
		[TCapEffectiveDatePrevious],
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
		,a.[ICapNextRefresh]
		,a.[ICapEffectiveDate]
		,a.[TCapNextRefresh]
		,a.[TCapEffectiveDate]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[ICapNextRefresh]
		,b.[ICapEffectiveDate]
		,b.[TCapNextRefresh]
		,b.[TCapEffectiveDate]
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




CREATE TRIGGER [dbo].[zAuditICapTCapRefreshInsert]
	ON  [dbo].[ICapTCapRefresh]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditICapTCapRefresh]
	(	
		[Id],
		[UtilityCompanyId],
		[ICapNextRefresh],
		[ICapEffectiveDate],
		[TCapNextRefresh],
		[TCapEffectiveDate],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ICapNextRefreshPrevious],
		[ICapEffectiveDatePrevious],
		[TCapNextRefreshPrevious],
		[TCapEffectiveDatePrevious],
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
			[ICapNextRefresh],
			[ICapEffectiveDate],
			[TCapNextRefresh],
			[TCapEffectiveDate],
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
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,ICapNextRefresh,ICapEffectiveDate,TCapNextRefresh,TCapEffectiveDate,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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