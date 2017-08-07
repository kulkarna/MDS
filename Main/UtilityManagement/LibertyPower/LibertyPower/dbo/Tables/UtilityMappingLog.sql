CREATE TABLE [dbo].[UtilityMappingLog] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [AccountNumber]  VARCHAR (50)   NULL,
    [UtilityID]      INT            NULL,
    [Message]        VARCHAR (4000) NULL,
    [SeverityLevel]  TINYINT        NULL,
    [LpcApplication] TINYINT        NULL,
    [DateCreated]    DATETIME       NULL,
    CONSTRAINT [PK_UtilityMappingLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

