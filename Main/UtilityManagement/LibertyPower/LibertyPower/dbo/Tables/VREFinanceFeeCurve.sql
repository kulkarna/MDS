CREATE TABLE [dbo].[VREFinanceFeeCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_PEFinanceFeeCurve_FileContextGuid] DEFAULT (newid()) NOT NULL,
    [Market]          VARCHAR (50)     NULL,
    [Fee]             DECIMAL (18, 6)  NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEFinanceFeeCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_FinanceFeeCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREFinanceFeeCurve';

