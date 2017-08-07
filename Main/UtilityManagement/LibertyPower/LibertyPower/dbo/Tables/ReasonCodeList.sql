CREATE TABLE [dbo].[ReasonCodeList] (
    [ReasonCodeID] INT         IDENTITY (1, 1) NOT NULL,
    [Step]         INT         NOT NULL,
    [Code]         NCHAR (50)  NOT NULL,
    [Description]  NCHAR (100) NOT NULL,
    [Order]        INT         NOT NULL,
    [DateCreated]  DATETIME    NULL
);

