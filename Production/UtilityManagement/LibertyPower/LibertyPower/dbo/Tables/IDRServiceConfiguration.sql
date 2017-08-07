CREATE TABLE [dbo].[IDRServiceConfiguration] (
    [UtilityID]         VARCHAR (15)  NOT NULL,
    [StartDate]         DATETIME      NULL,
    [Frequency]         INT           NULL,
    [Status]            VARCHAR (3)   NULL,
    [EmailNotification] VARCHAR (150) NULL,
    [StartTime]         VARCHAR (10)  NULL,
    CONSTRAINT [PK_IDRServiceConfiguration] PRIMARY KEY CLUSTERED ([UtilityID] ASC)
);

