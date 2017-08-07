CREATE TABLE [dbo].[EflModifiers] (
    [ID]         INT             IDENTITY (1, 1) NOT NULL,
    [UtilityID]  INT             NOT NULL,
    [RateUsage1] DECIMAL (12, 7) CONSTRAINT [DF_EflModifiers_RateUsage1] DEFAULT ((0)) NOT NULL,
    [RateUsage2] DECIMAL (12, 7) CONSTRAINT [DF_EflModifiers_RateUsage2] DEFAULT ((0)) NOT NULL,
    [RateUsage3] DECIMAL (12, 7) CONSTRAINT [DF_EflModifiers_RateUsage3] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EflModifiers] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EflModifiers_Utility] FOREIGN KEY ([UtilityID]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflModifiers';

