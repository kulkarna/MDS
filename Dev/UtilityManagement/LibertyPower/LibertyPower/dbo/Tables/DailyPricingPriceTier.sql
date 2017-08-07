CREATE TABLE [dbo].[DailyPricingPriceTier] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        VARCHAR (50)  NULL,
    [Description] VARCHAR (100) NULL,
    [MinMwh]      INT           NULL,
    [MaxMwh]      INT           NULL,
    [SortOrder]   INT           NULL,
    [IsActive]    TINYINT       NULL,
    CONSTRAINT [PK_DailyPricingPriceTier] PRIMARY KEY CLUSTERED ([ID] ASC)
);

