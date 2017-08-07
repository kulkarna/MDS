USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_IsNewerUsageAvailable]    Script Date: 01/07/2014 16:56:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_IsNewerUsageAvailable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_IsNewerUsageAvailable]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_IsNewerUsageAvailable]    Script Date: 01/07/2014 16:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 1/7/2014 4:17 pm
-- Description:	Check if usage is available for offer
-- =============================================
CREATE PROCEDURE [dbo].[usp_IsNewerUsageAvailable]
	-- Add the parameters for the stored procedure here
	@OfferID nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	if exists(
		select 1 from offerenginedb..OE_OFFER_ACCOUNTS ooa (nolock)
		join OfferEngineDB..OE_ACCOUNT oa (nolock) on ooa.OE_ACCOUNT_ID=oa.ID
		cross  apply (
		select dbo.udf_GetMostRecentUsageDate(oa.UTILITY,oa.ACCOUNT_NUMBER) as MostRecentUsageDate
		) mrud
		where mrud.MostRecentUsageDate > oa.USAGE_DATE
		and ooa.Offer_ID=@OfferID
		)
		SELECT 1
	ELSE
		SELECT 0
		
	SET NOCOUNT OFF
END

GO


