CREATE TABLE [dbo].[WelcomeCallDisposition] (
    [disposition_id]    INT           IDENTITY (1, 1) NOT NULL,
    [disposition_descp] VARCHAR (100) NOT NULL,
    [call_status]       VARCHAR (1)   NOT NULL
);

