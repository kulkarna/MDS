CREATE TABLE [dbo].[ImpRequestModeIdr] (
    [UtilityCode]                               NVARCHAR (255) NULL,
    [EnrollmentType]                            NVARCHAR (255) NULL,
    [Mode]                                      NVARCHAR (255) NULL,
    [AddressForPreEnrollment]                   NVARCHAR (255) NULL,
    [EmailTemplate]                             NVARCHAR (255) NULL,
    [Instructions]                              NVARCHAR (MAX) NULL,
    [UtilitysSlaIdrResponseInDays]              NVARCHAR (255) NULL,
    [LibertyPowersSlaFollowUpIdrResponseInDays] NVARCHAR (255) NULL,
    [IsLoaRequired]                             NVARCHAR (255) NULL,
    [RequestCostAccount]                        NVARCHAR (255) NULL,
    [RequestCostAccount Amount]                 NVARCHAR (255) NULL
);



