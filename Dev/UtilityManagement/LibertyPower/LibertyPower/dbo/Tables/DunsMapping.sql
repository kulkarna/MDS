CREATE TABLE [dbo].[DunsMapping] (
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    [UtilityID]  INT          NULL,
    [DunsNumber] VARCHAR (50) NULL,
    CONSTRAINT [PK_DunsMapping] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

