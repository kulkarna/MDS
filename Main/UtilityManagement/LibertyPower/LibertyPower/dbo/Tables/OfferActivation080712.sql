CREATE TABLE [dbo].[OfferActivation080712] (
    [OfferActivationID]      INT     IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT     NULL,
    [Term]                   INT     NULL,
    [IsActive]               TINYINT NULL,
    [LowerTerm]              INT     NULL,
    [UpperTerm]              INT     NULL
);

