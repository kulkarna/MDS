CREATE TABLE [dbo].[VREMarkupCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [Market]          VARCHAR (50)     NULL,
    [UtilityCode]     VARCHAR (50)     NULL,
    [ServiceClass]    VARCHAR (50)     NULL,
    [ZoneID]          VARCHAR (50)     NULL,
    [PricingType]     VARCHAR (50)     NULL,
    [MinSize]         INT              NOT NULL,
    [MaxSize]         INT              NULL,
    [ProductType]     VARCHAR (50)     NULL,
    [EffectiveDate]   DATETIME         NOT NULL,
    [ExpirationDate]  DATETIME         NULL,
    [Markup]          DECIMAL (18, 4)  NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VREMarkupCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_VREMarkupCurve_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_VREMarkupCurve_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_VREMarkupCurve_ModifiedBy] DEFAULT ((1)) NOT NULL,
    [AccountType]     VARCHAR (50)     CONSTRAINT [DF_VREMarkupCurve_AccountType] DEFAULT ('SMB') NOT NULL,
    [MinDuration]     INT              CONSTRAINT [DF_VREMarkupCurve_MinDuration] DEFAULT ((0)) NULL,
    [MaxDuration]     INT              CONSTRAINT [DF_VREMarkupCurve_ManDuration] DEFAULT ((9999)) NULL,
    CONSTRAINT [PK_VREMarkupCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);

