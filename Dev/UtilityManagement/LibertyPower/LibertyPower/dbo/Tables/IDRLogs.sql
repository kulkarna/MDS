CREATE TABLE [dbo].[IDRLogs] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [UtilityID]  VARCHAR (15)  NOT NULL,
    [LogMessage] VARCHAR (350) NULL,
    [CreateDate] DATETIME      NOT NULL,
    CONSTRAINT [PK_IDRLogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);

