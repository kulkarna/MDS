CREATE TABLE [dbo].[DealScreeningStepType] (
    [DealScreeningStepTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]             VARCHAR (50) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningStepType';

