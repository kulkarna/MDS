USE [lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_PricingRequestSelect]    Script Date: 01/24/2014 12:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/********************************************  usp_PricingRequestSelect ********************************************/

/*******************************************************************************
 * <usp_PricingRequestSelect>
 * <Get the list of pricing requests>
 *
 * History
 *******************************************************************************
 * <11/24/2011> - <CGHAZAL>
 * Created.
 *******************************************************************************
 * 1/25/2014 - Gail Mangaroo 
 * Modified 
 * 
 * Added @DueDate and @PricingRequest parameters
 */

ALTER	PROCEDURE	[dbo].[usp_PricingRequestSelect] 
(@PricingRequest varchar(50) = null 
, @DueDate datetime = null 
 )
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	REQUEST_ID
	FROM	OfferEngineDB..OE_PRICING_REQUEST (NOLOCK)
	WHERE ( DUE_DATE >= @DueDate OR @DueDate is null ) 
		AND ( REQUEST_ID = @PricingRequest OR @PricingRequest is null ) 
			
	ORDER	BY REQUEST_ID
	
	SET NOCOUNT OFF;
	
END
GO

