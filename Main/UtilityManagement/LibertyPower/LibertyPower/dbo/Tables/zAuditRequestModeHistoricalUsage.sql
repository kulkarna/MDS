CREATE TABLE [dbo].[zAuditRequestModeHistoricalUsage] (
    [Id]                                                                INT             NOT NULL,
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
    [LastModifiedDate]                                                  DATETIME        NOT NULL
);

