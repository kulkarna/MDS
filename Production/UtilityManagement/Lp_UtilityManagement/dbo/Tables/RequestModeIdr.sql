CREATE TABLE [dbo].[RequestModeIdr] (
    [Id]                                        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                          UNIQUEIDENTIFIER NOT NULL,
    [RequestModeEnrollmentTypeId]               UNIQUEIDENTIFIER NOT NULL,
    [RequestModeTypeId]                         UNIQUEIDENTIFIER NOT NULL,
    [AddressForPreEnrollment]                   NVARCHAR (255)   NOT NULL,
    [EmailTemplate]                             NVARCHAR (2000)  NOT NULL,
    [Instructions]                              NVARCHAR (500)   NOT NULL,
    [UtilitysSlaIdrResponseInDays]              INT              NOT NULL,
    [LibertyPowersSlaFollowUpIdrResponseInDays] INT              NOT NULL,
    [IsLoaRequired]                             BIT              NOT NULL,
    [RequestCostAccount]                        MONEY            NOT NULL,
    [Inactive]                                  BIT              NOT NULL,
    [CreatedBy]                                 NVARCHAR (100)   NOT NULL,
    [CreatedDate]                               DATETIME         NOT NULL,
    [LastModifiedBy]                            NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                          DATETIME         NOT NULL,
    [AlwaysRequest]                             BIT              NULL,
    CONSTRAINT [PK_RequestModeIdr] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RequestModeIdr_RequestModeEnrollmentType] FOREIGN KEY ([RequestModeEnrollmentTypeId]) REFERENCES [dbo].[RequestModeEnrollmentType] ([Id]),
    CONSTRAINT [FK_RequestModeIdr_RequestModeType] FOREIGN KEY ([RequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeIdr_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);








GO
ALTER TABLE [dbo].[RequestModeIdr] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);


GO







CREATE TRIGGER [dbo].[zAuditRequestModeIdrInsert]
	ON  [dbo].[RequestModeIdr]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeIdr]
	(	
		[Id],
		[UtilityCompanyId],
		[RequestModeEnrollmentTypeId],
		[RequestModeTypeId],
		[AddressForPreEnrollment],
		[EmailTemplate],
		[Instructions],
		[UtilitysSlaIdrResponseInDays],
		[LibertyPowersSlaFollowUpIdrResponseInDays],
		[IsLoaRequired],
		[RequestCostAccount],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[AlwaysRequest],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeEnrollmentTypeIdPrevious],
		[RequestModeTypeIdPrevious],
		[AddressForPreEnrollmentPrevious],
		[EmailTemplatePrevious],
		[InstructionsPrevious],
		[UtilitysSlaIdrResponseInDaysPrevious],
		[LibertyPowersSlaFollowUpIdrResponseInDaysPrevious],
		[IsLoaRequiredPrevious],
		[RequestCostAccountPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[AlwaysRequestPrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[RequestModeEnrollmentTypeId],
			[RequestModeTypeId],
			[AddressForPreEnrollment],
			[EmailTemplate],
			[Instructions],
			[UtilitysSlaIdrResponseInDays],
			[LibertyPowersSlaFollowUpIdrResponseInDays],
			[IsLoaRequired],
			[RequestCostAccount],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			[AlwaysRequest],
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
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,RequestModeEnrollmentTypeId,RequestModeTypeId,AddressForPreEnrollment,EmailTemplate,Instructions,UtilitysSlaIdrResponseInDays,LibertyPowersSlaFollowUpIdrResponseInDays,IsLoaRequired,RequestCostAccount,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate,AlwaysRequest'
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




CREATE TRIGGER [dbo].[zAuditRequestModeIdrUpdate]
	ON  [dbo].[RequestModeIdr]
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
		dbo.zAuditRequestModeIdr (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AddressForPreEnrollment],'') <> isnull(b.[AddressForPreEnrollment],'') THEN 'AddressForPreEnrollment' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EmailTemplate],'') <> isnull(b.[EmailTemplate],'') THEN 'EmailTemplate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instructions],'') <> isnull(b.[Instructions],'') THEN 'Instructions' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilitysSlaIdrResponseInDays],'') <> isnull(b.[UtilitysSlaIdrResponseInDays],'') THEN 'UtilitysSlaIdrResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LibertyPowersSlaFollowUpIdrResponseInDays],'') <> isnull(b.[LibertyPowersSlaFollowUpIdrResponseInDays],'') THEN 'LibertyPowersSlaFollowUpIdrResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsLoaRequired],'') <> isnull(b.[IsLoaRequired],'') THEN 'IsLoaRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestCostAccount],'') <> isnull(b.[RequestCostAccount],'') THEN 'RequestCostAccount' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AlwaysRequest],0) <> isnull(b.[AlwaysRequest],0) THEN 'AlwaysRequest' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeIdr]
	(
		[Id],
		[UtilityCompanyId],
		[RequestModeEnrollmentTypeId],
		[RequestModeTypeId],
		[AddressForPreEnrollment],
		[EmailTemplate],
		[Instructions],
		[UtilitysSlaIdrResponseInDays],
		[LibertyPowersSlaFollowUpIdrResponseInDays],
		[IsLoaRequired],
		[RequestCostAccount],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[AlwaysRequest],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeEnrollmentTypeIdPrevious],
		[RequestModeTypeIdPrevious],
		[AddressForPreEnrollmentPrevious],
		[EmailTemplatePrevious],
		[InstructionsPrevious],
		[UtilitysSlaIdrResponseInDaysPrevious],
		[LibertyPowersSlaFollowUpIdrResponseInDaysPrevious],
		[IsLoaRequiredPrevious],
		[RequestCostAccountPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[AlwaysRequestPrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[RequestModeEnrollmentTypeId],
		a.[RequestModeTypeId],
		a.[AddressForPreEnrollment],
		a.[EmailTemplate],
		a.[Instructions],
		a.[UtilitysSlaIdrResponseInDays],
		a.[LibertyPowersSlaFollowUpIdrResponseInDays],
		a.[IsLoaRequired],
		a.[RequestCostAccount],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		a.[AlwaysRequest],
		b.[Id],
		b.[UtilityCompanyId],
		b.[RequestModeEnrollmentTypeId],
		b.[RequestModeTypeId],
		b.[AddressForPreEnrollment],
		b.[EmailTemplate],
		b.[Instructions],
		b.[UtilitysSlaIdrResponseInDays],
		b.[LibertyPowersSlaFollowUpIdrResponseInDays],
		b.[IsLoaRequired],
		b.[RequestCostAccount],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		b.[AlwaysRequest],
		@ChangeTrackingCurrentVersion,
		@ChangeTrackingCreationVersion,
		'U',
		@SysChangeColumns	
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
