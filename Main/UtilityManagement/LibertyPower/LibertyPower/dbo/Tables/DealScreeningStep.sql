CREATE TABLE [dbo].[DealScreeningStep] (
    [DealScreeningStepID] INT          IDENTITY (1, 1) NOT NULL,
    [DealScreeningPathID] INT          NOT NULL,
    [StepNumber]          INT          NULL,
    [StepType]            VARCHAR (80) NULL,
    [DateCreated]         DATETIME     CONSTRAINT [DF_DealScreeningStep_DateCreated] DEFAULT (getdate()) NULL,
    [StepTypeID]          INT          NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningStep';

