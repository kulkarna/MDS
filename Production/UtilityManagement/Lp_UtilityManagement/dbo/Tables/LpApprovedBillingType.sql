CREATE TABLE [dbo].[LpApprovedBillingType] (
    [Id]                    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [LpBillingTypeId]       UNIQUEIDENTIFIER NOT NULL,
    [ApprovedBillingTypeId] UNIQUEIDENTIFIER NOT NULL,
    [Inactive]              BIT              NOT NULL,
    [CreatedBy]             NVARCHAR (100)   NOT NULL,
    [CreatedDate]           DATETIME         NOT NULL,
    [LastModifiedBy]        NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]      DATETIME         NOT NULL,
    CONSTRAINT [PK_LpApprovedBillingType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LpApprovedBillingType_ApprovedBillingType] FOREIGN KEY ([ApprovedBillingTypeId]) REFERENCES [dbo].[BillingType] ([Id]),
    CONSTRAINT [FK_LpApprovedBillingType_LpBillingType] FOREIGN KEY ([LpBillingTypeId]) REFERENCES [dbo].[LpBillingType] ([Id])
);






GO







CREATE TRIGGER [dbo].[zAuditLpApprovedBillingTypeUpdate]
	ON  [dbo].[LpApprovedBillingType]
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
		dbo.zAuditLpApprovedBillingType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],NEWID()) <> isnull(b.[Id],NEWID()) THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpBillingTypeId],NEWID()) <> isnull(b.[LpBillingTypeId],NEWID()) THEN 'LpBillingTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ApprovedBillingTypeId],NEWID()) <> isnull(b.[ApprovedBillingTypeId],NEWID()) THEN 'ApprovedBillingTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLpApprovedBillingType]
	(
		[Id],
		[LpBillingTypeId],
		[ApprovedBillingTypeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[LpBillingTypeIdPrevious],
		[ApprovedBillingTypeIdPrevious],
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
		a.[LpBillingTypeId],
		a.[ApprovedBillingTypeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[LpBillingTypeId],
		b.[ApprovedBillingTypeId],
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

CREATE TRIGGER [dbo].[zAuditLpApprovedBillingTypeInsert]
	ON  [dbo].[LpApprovedBillingType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLpApprovedBillingType]
	(	
		[Id],
		[LpBillingTypeId],
		[ApprovedBillingTypeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[LpBillingTypeIdPrevious],
		[ApprovedBillingTypeIdPrevious],
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
			[LpBillingTypeId],
			[ApprovedBillingTypeId],
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
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,LpBillingTypeId,ApprovedBillingTypeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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