----------------------------------------------------------------------------------
--Scripts to get the Description for all the respective Id's provided
--SalesChannel, Market, Utility, AccountType,Product Brand and Price Tier
-------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetSalesChannelName]    Script Date: 12/26/2013 16:29:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetSalesChannelName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetSalesChannelName]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetSalesChannelName]    Script Date: 12/26/2013 16:29:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

		 
	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the salesChannel NAME for the given sales channelID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetSalesChannelName]
	@p_salesChannelId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		ChannelName
	From 
		LibertyPower.dbo.SalesChannel with (nolock)		
	Where 
		ChannelID=@p_salesChannelId
		
	SET NOCOUNT OFF;
END

GO


-----------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMarketCode]    Script Date: 12/26/2013 16:30:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMarketCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMarketCode]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMarketCode]    Script Date: 12/26/2013 16:30:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the market CODE for the given marketID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetMarketCode]
	@p_marketId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		MarketCode
	From 
		LibertyPower.dbo.Market with (nolock)		
	Where 
		ID=@p_marketId
		
	SET NOCOUNT OFF;
END

GO


--------------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUtilityCode]    Script Date: 12/26/2013 16:30:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUtilityCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUtilityCode]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUtilityCode]    Script Date: 12/26/2013 16:30:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the Utility CODE for the given utility
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetUtilityCode]
	@p_utlityId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		UtilityCode
	From 
		LibertyPower.dbo.Utility with (nolock)		
	Where 
		ID=@p_utlityId
		
	SET NOCOUNT OFF;
END

GO


-----------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 12/26/2013 16:33:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAccountTypeDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAccountTypeDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 12/26/2013 16:33:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the AccoumntType CODE for the given AccountTypeID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetAccountTypeDescription]
	@p_AccountTypeId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		AccountType
	From 
		LibertyPower.dbo.AccountType with (nolock)		
	Where 
		ID=@p_AccountTypeId
		
	SET NOCOUNT OFF;
END

GO


----------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetproductBrandDescription]    Script Date: 12/26/2013 16:34:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetproductBrandDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetproductBrandDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetproductBrandDescription]    Script Date: 12/26/2013 16:34:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the Product Brand name for the given ProductBrandID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetproductBrandDescription]
	@p_ProductBrandId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		Name
	From 
		LibertyPower.dbo.ProductBrand with (nolock)		
	Where 
		ProductBrandId=@p_ProductBrandId
		
	SET NOCOUNT OFF;
END

GO


----------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetPriceTierDescription]    Script Date: 12/26/2013 16:34:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetPriceTierDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetPriceTierDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetPriceTierDescription]    Script Date: 12/26/2013 16:34:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the PriceTier Desc for the given PriceTierID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetPriceTierDescription]
	@p_PriceTierId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		Description
	From 
		LibertyPower.dbo.DailyPricingPriceTier with (nolock)		
	Where 
		ID=@p_PriceTierId
		
	SET NOCOUNT OFF;
END

GO


----------------------------------------------------------

