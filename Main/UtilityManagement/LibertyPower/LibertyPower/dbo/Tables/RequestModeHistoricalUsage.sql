CREATE TABLE [dbo].[RequestModeHistoricalUsage] (
    [Id]                                                                INT             IDENTITY (1, 1) NOT NULL,
    [UtilityId]                                                         INT             NOT NULL,
    [RequestModeEnrollmentTypeId]                                       INT             NOT NULL,
    [RequestModeTypeId]                                                 INT             NOT NULL,
    [AddressForPreEnrollment]                                           NVARCHAR (200)  NOT NULL,
    [EmailTemplate]                                                     NVARCHAR (2000) NULL,
    [Instructions]                                                      NVARCHAR (500)  NOT NULL,
    [UtilitysSlaHistoricalUsageResponseInDays]                          INT             NOT NULL,
    [LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]             INT             NOT NULL,
    [IsLoaRequired]                                                     BIT             NOT NULL,
    [IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] BIT             NOT NULL,
    [Inactive]                                                          BIT             NOT NULL,
    [CreatedBy]                                                         NVARCHAR (100)  NOT NULL,
    [CreatedDate]                                                       DATETIME        NOT NULL,
    [LastModifiedBy]                                                    NVARCHAR (100)  NOT NULL,
    [LastModifiedDate]                                                  DATETIME        NOT NULL,
    CONSTRAINT [PK_RequestModeHistoricalUsage] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeEnrollmentType] FOREIGN KEY ([RequestModeEnrollmentTypeId]) REFERENCES [dbo].[RequestModeEnrollmentType] ([Id]),
    CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeType] FOREIGN KEY ([RequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeHistoricalUsage_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO



CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageInsert]
	ON  [dbo].[RequestModeHistoricalUsage]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeHistoricalUsage]
           ([Id]
           ,[UtilityId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaHistoricalUsageResponseInDays]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
           ,[IsLoaRequired]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaHistoricalUsageResponseInDays]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
           ,[IsLoaRequired]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageUpdate]
	ON  [dbo].[RequestModeHistoricalUsage]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeHistoricalUsage]
           ([Id]
           ,[UtilityId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaHistoricalUsageResponseInDays]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
           ,[IsLoaRequired]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaHistoricalUsageResponseInDays]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
           ,[IsLoaRequired]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
