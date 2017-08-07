CREATE TABLE [dbo].[OfferActivation] (
    [OfferActivationID]      INT     IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT     NULL,
    [Term]                   INT     NULL,
    [IsActive]               TINYINT NULL,
    [LowerTerm]              INT     NULL,
    [UpperTerm]              INT     NULL,
    CONSTRAINT [PK_OfferActivation] PRIMARY KEY CLUSTERED ([OfferActivationID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OfferActivation_ProductConfiguration] FOREIGN KEY ([ProductConfigurationID]) REFERENCES [dbo].[ProductConfiguration] ([ProductConfigurationID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'OfferActivation';

