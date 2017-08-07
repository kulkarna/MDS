CREATE TABLE [dbo].[VREBillingTransactionCostCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER NOT NULL,
    [BillingType]     VARCHAR (50)     NULL,
    [Cost]            DECIMAL (18, 6)  NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PEBillingTransactionCostCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_BillingTransactionCostCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREBillingTransactionCostCurve';

