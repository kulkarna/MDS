/*******************************************************************************
 * <usp_HeatGasPriceSelect>
 * <Get the list of the gas prices for a specific rate>
 *
 * History
 *******************************************************************************
 * <11/20/2011> - <CGHAZAL>
 * Created.
 *******************************************************************************
 */

CREATE	PROCEDURE	[dbo].[usp_HeatGasPriceSelect] 
		(@DealPricingDetailID AS INT)

AS

BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DealPricingDetailID, Month, GasPrice, Inactive, DatePriceLocked
	FROM	HeatGasPrice
	WHERE	DealPricingDetailID = @DealPricingDetailID
	ORDER	BY Month
	
	SET NOCOUNT OFF;
	
END
