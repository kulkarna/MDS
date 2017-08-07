CREATE TABLE [dbo].[IcapFactors] (
    [ID]          INT            NOT NULL,
    [UtilityCode] VARCHAR (50)   NOT NULL,
    [LoadShapeId] VARCHAR (50)   NOT NULL,
    [IcapDate]    DATETIME       NOT NULL,
    [IcapFactor]  DECIMAL (8, 5) NOT NULL,
    CONSTRAINT [PK_IcapFactors] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

