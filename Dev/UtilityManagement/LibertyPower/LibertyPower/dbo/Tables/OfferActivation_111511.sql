CREATE TABLE [dbo].[OfferActivation_111511] (
    [OfferActivationID]      INT     IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT     NULL,
    [Term]                   INT     NULL,
    [IsActive]               TINYINT NULL,
    [LowerTerm]              INT     NULL,
    [UpperTerm]              INT     NULL
);

