CREATE TABLE [dbo].[UtilityClassMappingResultants] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [DeterminantsID] INT          NOT NULL,
    [Result]         VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_UtilityClassMappingResultants] PRIMARY KEY CLUSTERED ([ID] ASC)
);

