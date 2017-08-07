-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 02/18/2013
-- Description:	Get Price Details By PriceId
-- =============================================
CREATE PROCEDURE dbo.GetPriceDetailsByPriceId
	@PriceId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT dpd.[deal_pricing_detail_id]
		  ,dpd.[deal_pricing_id]
		  ,dpd.[product_id]
		  ,dpd.[rate_id]
		  ,dpd.[date_created]
		  ,dpd.[username]
		  ,dpd.[date_modified]
		  ,dpd.[modified_by]
		  ,dpd.[rate_submit_ind]
		  ,dpd.[ContractRate]
		  ,dpd.[Commission]
		  ,dpd.[Cost]
		  ,dpd.[MTM]
		  ,dpd.[HasPassThrough]
		  ,dpd.[BackToBack]
		  ,dpd.[HeatIndexSourceID]
		  ,dpd.[HeatRate]
		  ,dpd.[ExpectedTermUsage]
		  ,dpd.[ExpectedAccountsAmount]
		  ,dpd.[ETP]
		  ,dpd.[PriceID]
		  ,dpd.[SelfGenerationID]
		  , dp.account_name
		  , dp.sales_channel_role
		  , dp.commission_rate
		  , dp.date_expired
		  , dp.date_created
		  , dp.pricing_request_id
		  
	  FROM [Lp_deal_capture].[dbo].[deal_pricing_detail] dpd with (nolock)
		INNER JOIN [Lp_deal_capture].dbo.deal_pricing dp with (nolock) ON dp.deal_pricing_id=dpd.deal_pricing_id
	  WHERE PriceID=@PriceId
END
