CREATE TABLE [dbo].[Rate] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [RateCodeID]     INT              NOT NULL,
    [Price]          DECIMAL (18, 10) NULL,
    [EffectiveDate]  DATETIME         NOT NULL,
    [ExpirationDate] DATETIME         NULL,
    [DateCreated]    DATETIME         CONSTRAINT [DF_Rate_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      INT              NOT NULL,
    [DateModified]   DATETIME         CONSTRAINT [DF_Rate_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]     INT              NOT NULL,
    CONSTRAINT [PK_Rate] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Rate_RateCode] FOREIGN KEY ([RateCodeID]) REFERENCES [dbo].[RateCode] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Rate';

