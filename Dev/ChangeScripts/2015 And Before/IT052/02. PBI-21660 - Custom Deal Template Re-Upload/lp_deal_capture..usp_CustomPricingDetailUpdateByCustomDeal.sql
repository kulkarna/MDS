USE [Lp_deal_capture]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomPricingDetailUpdateByCustomDeal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_CustomPricingDetailUpdateByCustomDeal]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================
-- Created By: Gail Mangaroo 
-- IT052 
-- Update deal_pricing record
-- ========================================================================
CREATE PROCEDURE [dbo].[usp_CustomPricingDetailUpdateByCustomDeal]
( 
  @customDealId		 int = 0
  , @DateExpired	datetime 
  , @modifiedBY varchar(25) 
) 
AS 
BEGIN 

	SET NOCOUNT ON;
	
	UPDATE [lp_deal_capture].[dbo].[deal_pricing] 
	SET date_expired = @DateExpired
		, modified_by = @modifiedBY
		, date_modified = GETDATE() 
	WHERE CustomDealID = @customDealId
	
	SELECT @@ROWCOUNT

	SET NOCOUNT OFF;   
END 
