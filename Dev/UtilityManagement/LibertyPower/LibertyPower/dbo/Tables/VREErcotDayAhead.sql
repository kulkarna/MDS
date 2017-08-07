CREATE TABLE [dbo].[VREErcotDayAhead] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [Date]            DATETIME         NOT NULL,
    [IntervalEnding]  INT              NOT NULL,
    [Houston]         DECIMAL (18, 4)  NOT NULL,
    [North]           DECIMAL (18, 4)  NOT NULL,
    [South]           DECIMAL (18, 4)  NOT NULL,
    [West]            DECIMAL (18, 4)  NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VREErcotDayAhead_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_VREErcotDayAhead_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_VREErcotDayAhead_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_VREErcotDayAhead_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VREErcotDayAhead] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREErcotDayAhead';

