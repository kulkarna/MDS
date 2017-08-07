CREATE TABLE [dbo].[VREDailyProfileCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [ISO]             VARCHAR (50)     NULL,
    [Utility]         VARCHAR (50)     NULL,
    [LoadShapeID]     VARCHAR (50)     NULL,
    [Zone]            VARCHAR (50)     NULL,
    [Date]            DATETIME         NULL,
    [DPV]             DECIMAL (18, 7)  NULL,
    [PeakPercent]     DECIMAL (18, 15) NULL,
    [PDF]             DECIMAL (18, 7)  NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VREDailyProfileCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              NOT NULL,
    CONSTRAINT [PK_VREDailyProfileCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);

