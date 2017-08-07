CREATE TABLE [dbo].[VREUCapPriceCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER NOT NULL,
    [ZoneId]          VARCHAR (50)     NULL,
    [Month]           INT              NULL,
    [Year]            INT              NULL,
    [UCapPrice]       DECIMAL (10, 5)  NULL,
    [Createdby]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEUCapPriceCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UCapPriceCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREUCapPriceCurve';

