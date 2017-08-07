CREATE TABLE [dbo].[Market] (
    [ID]                       INT          IDENTITY (1, 1) NOT NULL,
    [MarketCode]               VARCHAR (50) NOT NULL,
    [RetailMktDescp]           VARCHAR (50) NULL,
    [WholesaleMktId]           INT          NULL,
    [PucCertification_number]  VARCHAR (50) NULL,
    [DateCreated]              DATETIME     NULL,
    [Username]                 NCHAR (200)  NULL,
    [InactiveInd]              CHAR (1)     NULL,
    [ActiveDate]               DATETIME     NULL,
    [Chgstamp]                 SMALLINT     NULL,
    [TransferOwnershipEnabled] SMALLINT     NULL,
    [EnableTieredPricing]      TINYINT      CONSTRAINT [DF_Market_EnableTieredPricing] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Market] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Market_WholesaleMarket] FOREIGN KEY ([WholesaleMktId]) REFERENCES [dbo].[WholesaleMarket] ([ID])
);

