CREATE TABLE [dbo].[VRENyisoDayAhead] (
    [ID]                     INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID]        UNIQUEIDENTIFIER NOT NULL,
    [TimeStamp]              DATETIME         NOT NULL,
    [Name]                   VARCHAR (50)     NOT NULL,
    [PTID]                   INT              NOT NULL,
    [LBMP]                   DECIMAL (18, 4)  NOT NULL,
    [MarginalCostLosses]     DECIMAL (18, 4)  NOT NULL,
    [MarginalCostCongestion] DECIMAL (18, 4)  NOT NULL,
    [DateCreated]            DATETIME         CONSTRAINT [DF_VRENyisoDayAhead_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              INT              CONSTRAINT [DF_VRENyisoDayAhead_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]           DATETIME         CONSTRAINT [DF_VRENyisoDayAhead_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]             INT              CONSTRAINT [DF_VRENyisoDayAhead_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VRENyisoDayAhead] PRIMARY KEY CLUSTERED ([ID] ASC, [TimeStamp] ASC)
);

