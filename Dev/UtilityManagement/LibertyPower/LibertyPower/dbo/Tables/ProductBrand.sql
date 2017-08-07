CREATE TABLE [dbo].[ProductBrand] (
    [ProductBrandID]    INT           IDENTITY (1, 1) NOT NULL,
    [ProductTypeID]     INT           NOT NULL,
    [Name]              VARCHAR (500) NOT NULL,
    [IsCustom]          TINYINT       CONSTRAINT [DF_Brand_IsCustom] DEFAULT ((0)) NOT NULL,
    [IsDefaultRollover] TINYINT       CONSTRAINT [DF_Brand_IsDefaultRollover] DEFAULT ((0)) NOT NULL,
    [RolloverBrandID]   INT           NULL,
    [Active]            TINYINT       CONSTRAINT [DF_Brand_Active] DEFAULT ((0)) NOT NULL,
    [Username]          VARCHAR (200) NULL,
    [DateCreated]       DATETIME      CONSTRAINT [DF_Brand_DateCreated] DEFAULT (getdate()) NOT NULL,
    [IsMultiTerm]       BIT           CONSTRAINT [DF__ProductBr__IsMul__54C23EC5] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductBrand] PRIMARY KEY CLUSTERED ([ProductBrandID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductBrand';

