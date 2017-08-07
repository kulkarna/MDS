CREATE TABLE [dbo].[VREPorDataCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [Utility]         VARCHAR (50)     NULL,
    [ServiceClassID]  VARCHAR (50)     NULL,
    [PorType]         VARCHAR (50)     NULL,
    [PorRate]         DECIMAL (18, 6)  NULL,
    [FileContextGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_PEPorDataCurve_FileContextGuid] DEFAULT (newid()) NOT NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEPorDataCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_PorCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREPorDataCurve';

