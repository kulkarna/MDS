CREATE TABLE [dbo].[OfferActivationHistory] (
    [OfferActivationHistoryID] INT      IDENTITY (1, 1) NOT NULL,
    [OfferActivationID]        INT      NULL,
    [UserID]                   INT      NULL,
    [IsActive]                 TINYINT  NULL,
    [DateUpdated]              DATETIME NOT NULL,
    CONSTRAINT [PK_OfferActivationHistory] PRIMARY KEY CLUSTERED ([OfferActivationHistoryID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [<ndx_OfferActivationID, sysname,>]
    ON [dbo].[OfferActivationHistory]([OfferActivationID] ASC);


GO
CREATE NONCLUSTERED INDEX [<ndx_IsActive_DateUpdated, sysname,>]
    ON [dbo].[OfferActivationHistory]([IsActive] ASC, [DateUpdated] ASC);


GO
CREATE NONCLUSTERED INDEX [OfferActivationHistory__Cover1]
    ON [dbo].[OfferActivationHistory]([OfferActivationID] ASC)
    INCLUDE([IsActive], [DateUpdated]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'OfferActivationHistory';

