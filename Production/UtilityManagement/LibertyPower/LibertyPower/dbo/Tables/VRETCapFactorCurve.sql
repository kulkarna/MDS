CREATE TABLE [dbo].[VRETCapFactorCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [ZoneId]          VARCHAR (50)     NULL,
    [Month]           INT              NULL,
    [Year]            INT              NULL,
    [TCapFactor]      DECIMAL (18, 6)  NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PETCapFactorCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_TCapFactorCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRETCapFactorCurve';

