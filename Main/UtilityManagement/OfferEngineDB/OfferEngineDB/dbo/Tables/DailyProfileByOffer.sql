CREATE TABLE [dbo].[DailyProfileByOffer] (
    [ID]             INT          IDENTITY (100, 1) NOT NULL,
    [OfferId]        VARCHAR (50) NOT NULL,
    [AccountNumber]  VARCHAR (50) NOT NULL,
    [DailyProfileId] INT          NOT NULL,
    [BeginDate]      DATETIME     NOT NULL,
    [EndDate]        DATETIME     NOT NULL,
    [Created]        DATETIME     CONSTRAINT [DF_DailyProfileByOffer_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]      VARCHAR (50) NULL,
    CONSTRAINT [PK_DailyProfileByOffer] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_DailyProfileByOffer]
    ON [dbo].[DailyProfileByOffer]([AccountNumber] ASC, [OfferId] ASC, [DailyProfileId] ASC) WITH (FILLFACTOR = 90);

