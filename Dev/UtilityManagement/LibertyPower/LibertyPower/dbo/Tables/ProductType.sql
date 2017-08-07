CREATE TABLE [dbo].[ProductType] (
    [ProductTypeID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (200) NOT NULL,
    [Active]        TINYINT       CONSTRAINT [DF_Product_Active] DEFAULT ((0)) NOT NULL,
    [Username]      VARCHAR (200) NULL,
    [DateCreated]   DATETIME      CONSTRAINT [DF_Product_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductTypeID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductType';

