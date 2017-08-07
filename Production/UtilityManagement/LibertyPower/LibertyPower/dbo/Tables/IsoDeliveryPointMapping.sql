CREATE TABLE [dbo].[IsoDeliveryPointMapping] (
    [ID]                    INT          IDENTITY (1, 1) NOT NULL,
    [IsoID]                 INT          NULL,
    [DeliveryPointIntRefID] INT          NULL,
    [IsoValue]              VARCHAR (50) NULL,
    [DateCreated]           DATETIME     NOT NULL,
    [CreatedBy]             INT          NOT NULL,
    [DateModified]          DATETIME     NULL,
    [ModifiedBy]            INT          NULL,
    CONSTRAINT [PK_IsoDeliveryPointMapping] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_IsoDeliveryPointMapping_DeliveryPointInternalReference] FOREIGN KEY ([DeliveryPointIntRefID]) REFERENCES [dbo].[DeliveryPointInternalReference] ([ID]),
    CONSTRAINT [FK_IsoDeliveryPointMapping_WholesaleMarket] FOREIGN KEY ([IsoID]) REFERENCES [dbo].[WholesaleMarket] ([ID])
);

