CREATE TABLE [dbo].[GeniePriceMapping] (
    [ID]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [PriceID]         BIGINT        NOT NULL,
    [ProductID]       VARCHAR (20)  NOT NULL,
    [RateID]          INT           NOT NULL,
    [RateDescription] VARCHAR (250) NOT NULL,
    [PriceTierID]     INT           NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [GeniePriceMapping__ProductID_RateID_I]
    ON [dbo].[GeniePriceMapping]([ProductID] ASC, [RateID] ASC)
    INCLUDE([PriceID], [PriceTierID]);

