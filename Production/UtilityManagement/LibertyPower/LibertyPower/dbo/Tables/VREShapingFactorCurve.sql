CREATE TABLE [dbo].[VREShapingFactorCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [LoadShapeID]     VARCHAR (50)     NOT NULL,
    [ZoneID]          VARCHAR (50)     NOT NULL,
    [Month]           INT              NOT NULL,
    [Year]            INT              NOT NULL,
    [Date]            DATETIME         NOT NULL,
    [PeakFactor]      DECIMAL (6, 5)   NOT NULL,
    [OffPeakFactor]   DECIMAL (6, 5)   NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VREShapingFactorCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              NOT NULL,
    CONSTRAINT [PK_VREShapingFactorCurve] PRIMARY KEY CLUSTERED ([ID] ASC, [LoadShapeID] ASC, [ZoneID] ASC, [Month] ASC, [Year] ASC, [DateCreated] ASC)
);

