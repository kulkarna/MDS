USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ProductBrand]    Script Date: 10/17/2012 08:15:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

ALTER TABLE dbo.ProductBrand ADD IsMultiTerm bit DEFAULT 0 NOT NULL ;
GO


UPDATE dbo.ProductBrand
SET IsMultiTerm=1
WHERE ProductBrandID=17
GO




