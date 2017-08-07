CREATE TABLE [dbo].[UtilityServiceClassEnrollLeadTime] (
    [ID]                 NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [ServiceRateClass]   VARCHAR (50)  NOT NULL,
    [UtilityID]          INT           NOT NULL,
    [EnrollmentLeadDays] INT           NOT NULL,
    [DateAdd]            DATETIME      NOT NULL,
    [UserAdd]            VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_UtilityServiceClassEnrollLeadTime] PRIMARY KEY CLUSTERED ([ID] ASC)
);

