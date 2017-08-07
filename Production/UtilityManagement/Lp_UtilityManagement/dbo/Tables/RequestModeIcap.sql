CREATE TABLE [dbo].[RequestModeIcap] (
    [Id]                                         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                           UNIQUEIDENTIFIER NOT NULL,
    [RequestModeEnrollmentTypeId]                UNIQUEIDENTIFIER NOT NULL,
    [RequestModeTypeId]                          UNIQUEIDENTIFIER NOT NULL,
    [AddressForPreEnrollment]                    NVARCHAR (200)   NOT NULL,
    [EmailTemplate]                              NVARCHAR (2000)  NULL,
    [Instructions]                               NVARCHAR (500)   NOT NULL,
    [UtilitysSlaIcapResponseInDays]              INT              NOT NULL,
    [LibertyPowersSlaFollowUpIcapResponseInDays] INT              NOT NULL,
    [IsLoaRequired]                              BIT              NOT NULL,
    [Inactive]                                   BIT              NOT NULL,
    [CreatedBy]                                  NVARCHAR (100)   NOT NULL,
    [CreatedDate]                                DATETIME         NOT NULL,
    [LastModifiedBy]                             NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                           DATETIME         NOT NULL,
    CONSTRAINT [PK_RequestModeIcap] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RequestModeIcap_RequestModeEnrollmentType] FOREIGN KEY ([RequestModeEnrollmentTypeId]) REFERENCES [dbo].[RequestModeEnrollmentType] ([Id]),
    CONSTRAINT [FK_RequestModeIcap_RequestModeType] FOREIGN KEY ([RequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeIcap_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO



CREATE TRIGGER [dbo].[zAuditRequestModeIcapInsert]
	ON  [dbo].[RequestModeIcap]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 

	INSERT INTO [dbo].[zAuditRequestModeIcap]
	(
		[Id]
       ,[UtilityCompanyId]
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaIcapResponseInDays]
       ,[LibertyPowersSlaFollowUpIcapResponseInDays]
       ,[IsLoaRequired]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[UtilityCompanyIdPrevious]
       ,[RequestModeEnrollmentTypeIdPrevious]
       ,[RequestModeTypeIdPrevious]
       ,[AddressForPreEnrollmentPrevious]
       ,[EmailTemplatePrevious]
       ,[InstructionsPrevious]
       ,[UtilitysSlaIcapResponseInDaysPrevious]
       ,[LibertyPowersSlaFollowUpIcapResponseInDaysPrevious]
       ,[IsLoaRequiredPrevious]
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
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaIcapResponseInDays]
       ,[LibertyPowersSlaFollowUpIcapResponseInDays]
       ,[IsLoaRequired]
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
		,'Id,UtilityCompanyId,RequestModeEnrollmentTypeId,RequestModeTypeId,AddressForPreEnrollment,EmailTemplate,Instructions,UtilitysSlaIcapResponseInDays,LibertyPowersSlaFollowUpIcapResponseInDays,IsLoaRequired,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
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

CREATE TRIGGER [dbo].[zAuditRequestModeIcapUpdate]
	ON [dbo].[RequestModeIcap]
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
		dbo.zAuditRequestModeIcap (NOLOCK) ZARMHU 
		INNER JOIN inserted a
			ON ZARMHU.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AddressForPreEnrollment],'') <> isnull(b.[AddressForPreEnrollment],'') THEN 'AddressForPreEnrollment' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EmailTemplate],'') <> isnull(b.[EmailTemplate],'') THEN 'EmailTemplate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instructions],'') <> isnull(b.[Instructions],'') THEN 'Instructions' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilitysSlaIcapResponseInDays],'') <> isnull(b.[UtilitysSlaIcapResponseInDays],'') THEN 'UtilitysSlaIcapResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LibertyPowersSlaFollowUpIcapResponseInDays],'') <> isnull(b.[LibertyPowersSlaFollowUpIcapResponseInDays],'') THEN 'LibertyPowersSlaFollowUpIcapResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsLoaRequired],'') <> isnull(b.[IsLoaRequired],'') THEN 'IsLoaRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeIcap]
           ([Id]
           ,[UtilityCompanyId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaIcapResponseInDays]
           ,[LibertyPowersSlaFollowUpIcapResponseInDays]
           ,[IsLoaRequired]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UtilityCompanyIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[AddressForPreEnrollmentPrevious]
           ,[EmailTemplatePrevious]
           ,[InstructionsPrevious]
           ,[UtilitysSlaIcapResponseInDaysPrevious]
           ,[LibertyPowersSlaFollowUpIcapResponseInDaysPrevious]
           ,[IsLoaRequiredPrevious]
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
		,a.[RequestModeEnrollmentTypeId]
		,a.[RequestModeTypeId]
		,a.[AddressForPreEnrollment]
		,a.[EmailTemplate]
		,a.[Instructions]
		,a.[UtilitysSlaIcapResponseInDays]
		,a.[LibertyPowersSlaFollowUpIcapResponseInDays]
		,a.[IsLoaRequired]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[RequestModeEnrollmentTypeId]
		,b.[RequestModeTypeId]
		,b.[AddressForPreEnrollment]
		,b.[EmailTemplate]
		,b.[Instructions]
		,b.[UtilitysSlaIcapResponseInDays]
		,b.[LibertyPowersSlaFollowUpIcapResponseInDays]
		,b.[IsLoaRequired]
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

