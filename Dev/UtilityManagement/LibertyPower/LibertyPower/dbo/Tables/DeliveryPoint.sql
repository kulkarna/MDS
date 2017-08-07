CREATE TABLE [dbo].[DeliveryPoint] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [DeliveryPointTypeID] INT          NOT NULL,
    [ExtRefCode]          VARCHAR (50) NULL,
    [IntRefID]            INT          NULL,
    [IsoID]               INT          NULL,
    [DateCreated]         DATETIME     NOT NULL,
    [CreatedBy]           INT          NOT NULL,
    [DateModified]        DATETIME     NULL,
    [ModifiedBy]          INT          NULL,
    CONSTRAINT [PK_DeliveryPoint] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DeliveryPoint_DeliveryPointType] FOREIGN KEY ([DeliveryPointTypeID]) REFERENCES [dbo].[DeliveryPointType] ([ID]),
    CONSTRAINT [FK_DeliveryPoint_InternalReference] FOREIGN KEY ([IntRefID]) REFERENCES [dbo].[InternalReference] ([ID]),
    CONSTRAINT [FK_DeliveryPoint_WholesaleMarket] FOREIGN KEY ([IsoID]) REFERENCES [dbo].[WholesaleMarket] ([ID])
);

