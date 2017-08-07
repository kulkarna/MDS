CREATE TABLE [dbo].[DeliveryPointInternalReference] (
    [ID]                       INT          IDENTITY (1, 1) NOT NULL,
    [DeliveryPointTypeID]      INT          NOT NULL,
    [IsoID]                    INT          NOT NULL,
    [DeliveryPointInternalRef] VARCHAR (20) NOT NULL,
    [DateCreated]              DATETIME     NOT NULL,
    [CreatedBy]                INT          NOT NULL,
    [DateModified]             DATETIME     NULL,
    [ModifiedBy]               INT          NULL,
    CONSTRAINT [PK_DeliveryPointInternalReference] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DeliveryPointInternalReference_DeliveryPointType] FOREIGN KEY ([DeliveryPointTypeID]) REFERENCES [dbo].[DeliveryPointType] ([ID]),
    CONSTRAINT [FK_DeliveryPointInternalReference_WholesaleMarket] FOREIGN KEY ([IsoID]) REFERENCES [dbo].[WholesaleMarket] ([ID])
);

