CREATE TABLE [dbo].[UtilityDunsMapping] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [UtilityCode] VARCHAR (50) NULL,
    [UtilityDuns] VARCHAR (50) NULL,
    CONSTRAINT [PK_UtilityDunsMapping] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

