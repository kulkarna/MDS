USE [lp_deal_capture]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/********************************************  usp_HeatGasPriceUpdate ********************************************/

/*******************************************************************************
 * <usp_HeatGasPriceUpdate>
 * <Update the list of the gas prices for a specific rate>
 *
 * History
 *******************************************************************************
 * <11/20/2011> - <CGHAZAL>
 * Created.
 *******************************************************************************
 * Modified: 11/20/2013 Gail M.
 * added parameter defaults
 */

ALTER	PROCEDURE	[dbo].[usp_HeatGasPriceUpdate] 
		(@DealPricingDetailID AS INT,
		 @Month AS INT,
		 @GasPrice AS DECIMAL(9,6) = null,
		 @Inactive AS BIT,
		 @DatePriceLocked AS DATETIME = null
		 )

AS

BEGIN
	
	SET NOCOUNT ON;
	
	IF (EXISTS (SELECT	* 
				FROM	HeatGasPrice (NOLOCK)
				WHERE	DealPricingDetailID = @DealPricingDetailID
				AND		Month = @Month)
		)
	
		UPDATE	HeatGasPrice
		SET		GasPrice = @GasPrice,
				Inactive = @Inactive,
				DatePriceLocked = @DatePriceLocked,
				DateModified = GETDATE()
		WHERE	DealPricingDetailID = @DealPricingDetailID
		AND		Month = @Month
	
	ELSE
	
		INSERT	INTO HeatGasPrice
				(	DealPricingDetailID,
					Month,
					GasPrice,
					Inactive,
					DatePriceLocked
				)
				
		VALUES	(	@DealPricingDetailID,
					@Month,
					@GasPrice,
					@Inactive,
					@DatePriceLocked
				)
	
	SET NOCOUNT OFF;
	
END

