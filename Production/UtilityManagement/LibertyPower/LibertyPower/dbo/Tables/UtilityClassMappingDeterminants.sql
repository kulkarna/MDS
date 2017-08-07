CREATE TABLE [dbo].[UtilityClassMappingDeterminants] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [UtilityID] INT          NOT NULL,
    [Driver]    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_UtilityClassMappingDeterminants] PRIMARY KEY CLUSTERED ([ID] ASC)
);

