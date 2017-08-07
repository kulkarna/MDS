USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MarketProducts]    Script Date: 07/15/2014 17:05:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
BEGIN TRANSACTION;

BEGIN TRY


    IF EXISTS (SELECT 1 FROM SYS.TABLES WHERE Name='MarketProducts')
    BEGIN
	   DROP TABLE [dbo].[MarketProducts];
    END;
    --Table with static data, delete and recreate.

 CREATE TABLE [dbo].[MarketProducts](
	[MarketProductID] [int] IDENTITY(1,1) NOT NULL,
	[MarketID] [int] NULL,
	[ProductBrandID] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_MarketProducts] PRIMARY KEY CLUSTERED 
(
	[MarketProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]


    ALTER TABLE [dbo].[MarketProducts]  WITH CHECK ADD  CONSTRAINT [FK_MarketProducts_Market] FOREIGN KEY([MarketID])
    REFERENCES [dbo].[Market] ([ID])

    ALTER TABLE [dbo].[MarketProducts] CHECK CONSTRAINT [FK_MarketProducts_Market]

    ALTER TABLE [dbo].[MarketProducts]  WITH CHECK ADD  CONSTRAINT [FK_MarketProducts_ProductBrand] FOREIGN KEY([ProductBrandID])
    REFERENCES [dbo].[ProductBrand] ([ProductBrandID])

    ALTER TABLE [dbo].[MarketProducts] CHECK CONSTRAINT [FK_MarketProducts_ProductBrand]

    ALTER TABLE [dbo].[MarketProducts]  WITH CHECK ADD  CONSTRAINT [FK_MarketProducts_User] FOREIGN KEY([CreatedBy])
    REFERENCES [dbo].[User] ([UserID])

    ALTER TABLE [dbo].[MarketProducts] CHECK CONSTRAINT [FK_MarketProducts_User]

    ALTER TABLE [dbo].[MarketProducts] ADD  CONSTRAINT [DF_MarketProducts_IsActive]  DEFAULT ((1)) FOR [IsActive]

    --Insert Static Data with USERID-1949
    IF EXISTS (Select * from MarketProducts)
    BEGIN
	   DELETE FROM MarketProducts;
    END

    INSERT INTO MarketProducts(MarketID,ProductBrandID,CreatedBy,CreatedDate)
    select m.id as MarketID,
    --m.MarketCode,
    b.ProductBrandID,
    1949 as CreatedBy,
    GETDATE() as CreatedDate
	from Market m with(nolock) CROSS JOIN ProductBrand b with(nolock) where 
    (m.MarketCode in('CT','NY','NJ','PA','IL','MD') and b.ProductBrandID in(1,2,4,19,13) and  m.InactiveInd=0)
    or
    (
	   (ProductBrandID=18 and MarketCode ='IL' and m.InactiveInd=0)
	   or
	   (ProductBrandID=21 and MarketCode ='CT' and m.InactiveInd=0)
	   or
	   (ProductBrandID=22 and MarketCode ='MD' and m.InactiveInd=0)
	   or
	   (ProductBrandID=23 and MarketCode ='PA' and m.InactiveInd=0)
    )
    order by MarketID,ProductBrandID;

END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;
--Select * from MarketProducts;