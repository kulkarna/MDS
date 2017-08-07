CREATE TABLE [dbo].[VREUCapFactorCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER NOT NULL,
    [ZoneId]          VARCHAR (50)     NULL,
    [Month]           INT              NULL,
    [Year]            INT              NULL,
    [UCapFactor]      DECIMAL (18, 6)  NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEUCapFactorCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UCapFactorCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_PEUCapFactorCurve_85_1564636717__K3_K4_K2_5]
    ON [dbo].[VREUCapFactorCurve]([Month] ASC, [Year] ASC, [ZoneId] ASC)
    INCLUDE([UCapFactor]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREUCapFactorCurve';

