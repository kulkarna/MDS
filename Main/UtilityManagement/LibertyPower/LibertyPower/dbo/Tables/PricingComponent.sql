CREATE TABLE [dbo].[PricingComponent] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [CompCode]        VARCHAR (20)  NOT NULL,
    [CompDescription] VARCHAR (200) NOT NULL,
    [CompCategoryID]  INT           NOT NULL,
    [PricingCurveID]  INT           NOT NULL,
    [DateCreated]     DATETIME      NOT NULL,
    [CreatedBy]       INT           NOT NULL,
    [DateModified]    DATETIME      NULL,
    [ModifiedBy]      INT           NULL,
    CONSTRAINT [PK_PricingComponent] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PricingComponent_ComponentCategory] FOREIGN KEY ([CompCategoryID]) REFERENCES [dbo].[ComponentCategory] ([ID])
);

