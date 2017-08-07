CREATE TABLE [dbo].[PricingType] (
    [PricingTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]          VARCHAR (64) NOT NULL,
    [Active]        BIT          CONSTRAINT [DF_PricingType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]   DATETIME     CONSTRAINT [DF_PricingType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_PricingType] PRIMARY KEY CLUSTERED ([PricingTypeID] ASC)
);

