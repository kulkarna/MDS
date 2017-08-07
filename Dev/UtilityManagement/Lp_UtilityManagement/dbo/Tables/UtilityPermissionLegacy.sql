CREATE TABLE [dbo].[UtilityPermissionLegacy] (
    [ID]                INT       IDENTITY (1, 1) NOT NULL,
    [UtilityCode]       CHAR (15) NOT NULL,
    [RetailMktID]       CHAR (2)  NOT NULL,
    [PaperContractOnly] SMALLINT  NOT NULL,
    CONSTRAINT [PK_[UtilityPermissionLegacy] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

