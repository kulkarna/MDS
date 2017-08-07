CREATE TABLE [dbo].[UtilityStratumRange] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [UtilityId]        INT          NOT NULL,
    [ServiceRateClass] VARCHAR (50) NULL,
    [StratumVariable]  VARCHAR (50) NULL,
    [StratumStart]     FLOAT (53)   NOT NULL,
    [StratumEnd]       FLOAT (53)   NOT NULL,
    CONSTRAINT [PK_UtilityStratumRange] PRIMARY KEY CLUSTERED ([ID] ASC)
);

