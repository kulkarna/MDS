CREATE TABLE [dbo].[VREARCreditReservePercent] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [UtilityCode]     VARCHAR (50)     NOT NULL,
    [Month]           INT              NOT NULL,
    [Year]            INT              NOT NULL,
    [ARPercent]       DECIMAL (5, 4)   NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_ARCreditReservePercentCurveFile_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_ARCreditReservePercentCurveFile_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_ARCreditReservePercentCurveFile_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_ARCreditReservePercentCurveFile_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VRECreditReservetCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREARCreditReservePercent';

