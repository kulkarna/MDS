CREATE TABLE [dbo].[DealScreeningCommission] (
    [DealScreeningCommissionID] INT      IDENTITY (1000, 1) NOT NULL,
    [DealScreeningStepID]       INT      NOT NULL,
    [PayCommission]             TINYINT  CONSTRAINT [DF_DealScreeningCommission_PayCommission] DEFAULT ((0)) NOT NULL,
    [DateCreated]               DATETIME CONSTRAINT [DF_DealScreeningCommission_DateCreated] DEFAULT (getdate()) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningCommission';

