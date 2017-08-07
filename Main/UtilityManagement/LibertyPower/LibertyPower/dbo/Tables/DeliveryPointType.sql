CREATE TABLE [dbo].[DeliveryPointType] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (100) NOT NULL,
    [DateCreated]  DATETIME      NOT NULL,
    [CreatedBy]    INT           NOT NULL,
    [DateModified] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    CONSTRAINT [PK_DeliveryPointType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

