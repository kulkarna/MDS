CREATE TABLE [dbo].[VRENeisoDayAhead] (
    [ID]                      INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID]         UNIQUEIDENTIFIER NOT NULL,
    [Date]                    DATETIME         NOT NULL,
    [HourEnd]                 INT              NOT NULL,
    [LocationID]              VARCHAR (50)     NULL,
    [LocationName]            VARCHAR (50)     NULL,
    [LocationType]            VARCHAR (50)     NULL,
    [LocationalMarginalPrice] DECIMAL (18, 4)  NOT NULL,
    [DateCreated]             DATETIME         CONSTRAINT [DF_VRENeisoDayAhead_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               INT              CONSTRAINT [DF_VRENeisoDayAhead_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]            DATETIME         CONSTRAINT [DF_VRENeisoDayAhead_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]              INT              CONSTRAINT [DF_VRENeisoDayAhead_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VRENeisoDayAhead] PRIMARY KEY CLUSTERED ([ID] ASC, [Date] ASC)
);

