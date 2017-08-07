CREATE TABLE [dbo].[FactorInputs] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [InputID]         INT             NOT NULL,
    [IsoID]           INT             NULL,
    [MarketID]        INT             NULL,
    [UtilityID]       INT             NULL,
    [DeliveryPointID] INT             NULL,
    [StartDate]       DATETIME        NOT NULL,
    [EndDate]         DATETIME        NOT NULL,
    [Value]           DECIMAL (10, 2) NOT NULL,
    [DateCreated]     DATETIME        NOT NULL,
    [CreatedBy]       INT             NOT NULL,
    [DateModified]    DATETIME        NULL,
    [ModifiedBy]      INT             NULL,
    CONSTRAINT [PK_FactorInputs] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_FactorInputs_Inputs] FOREIGN KEY ([InputID]) REFERENCES [dbo].[Inputs] ([ID])
);

