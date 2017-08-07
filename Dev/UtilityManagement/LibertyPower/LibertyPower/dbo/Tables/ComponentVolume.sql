CREATE TABLE [dbo].[ComponentVolume] (
    [ID]              INT      IDENTITY (1, 1) NOT NULL,
    [PricingCompID]   INT      NOT NULL,
    [IsoID]           INT      NULL,
    [MarketID]        INT      NULL,
    [DeliveryPointID] INT      NULL,
    [VolumeID]        INT      NULL,
    [DateCreated]     DATETIME NOT NULL,
    [CreatedBy]       INT      NOT NULL,
    [DateModified]    DATETIME NULL,
    [ModifiedBy]      INT      NULL,
    CONSTRAINT [PK_ComponentVolume] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ComponentVolume_PricingComponent] FOREIGN KEY ([PricingCompID]) REFERENCES [dbo].[PricingComponent] ([ID])
);

