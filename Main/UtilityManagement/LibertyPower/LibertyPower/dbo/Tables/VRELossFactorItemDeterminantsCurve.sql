CREATE TABLE [dbo].[VRELossFactorItemDeterminantsCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGuid] UNIQUEIDENTIFIER NOT NULL,
    [UtilityCode]     VARCHAR (50)     NULL,
    [ServiceClass]    VARCHAR (50)     NULL,
    [ZoneID]          VARCHAR (50)     NULL,
    [Voltage]         VARCHAR (50)     NULL,
    [LossFactorId]    VARCHAR (50)     NULL,
    [CreatedBy]       INT              NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_PELossFactorItemDeterminantsCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_LossFactorCurveDeterminants] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRELossFactorItemDeterminantsCurve';

