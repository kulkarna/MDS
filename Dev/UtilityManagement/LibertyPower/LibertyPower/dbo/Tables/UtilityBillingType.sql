CREATE TABLE [dbo].[UtilityBillingType] (
    [UtilityID]     INT      NOT NULL,
    [BillingTypeID] INT      NOT NULL,
    [DateCreated]   DATETIME CONSTRAINT [DF_Utility_BillingType_DateCreated] DEFAULT (getdate()) NULL,
    [DateModified]  DATETIME NULL,
    CONSTRAINT [PK_Utility_BillingType] PRIMARY KEY CLUSTERED ([UtilityID] ASC, [BillingTypeID] ASC)
);

