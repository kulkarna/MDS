CREATE TABLE [dbo].[DealScreeningTransition] (
    [DealScreeningTransitionID] INT          IDENTITY (1, 1) NOT NULL,
    [DealScreeningStepID]       INT          NOT NULL,
    [Disposition]               VARCHAR (20) NULL,
    [CurrentAccountStatus]      VARCHAR (50) NULL,
    [CurrentAccountSubStatus]   VARCHAR (50) NULL,
    [NextStepNumber]            INT          NULL,
    [NextAccountStatus]         VARCHAR (50) NULL,
    [NextAccountSubStatus]      VARCHAR (50) NULL,
    [DateCreated]               DATETIME     NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningTransition';

