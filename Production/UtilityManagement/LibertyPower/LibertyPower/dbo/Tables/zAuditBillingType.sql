CREATE TABLE [dbo].[zAuditBillingType] (
    [BillingTypeID] INT          NOT NULL,
    [Type]          VARCHAR (50) NOT NULL,
    [Sequence]      INT          NOT NULL,
    [Active]        BIT          NOT NULL,
    [DateCreated]   DATETIME     NOT NULL,
    [Description]   VARCHAR (50) NULL
);

