CREATE FUNCTION [dbo].[GrossMarginValueForAProduct] (
@prmProductID varchar(100)
,@prmRateID int
,@prmDealDate datetime
,@prmEffStartDate datetime
)
RETURNS Decimal(18,6)
AS
BEGIN
--TEST
--DECLARE @prmProductID varchar(100)
--DECLARE @prmRateID int
--DECLARE @prmDealDate datetime
--DECLARE @prmEffStartDate datetime

DECLARE @GrossMargin decimal(18,6)
DECLARE @Custom char(1)

-- TEST
--SET @prmProductID = 'CTPEN_IP            '
--SET @prmRateID = 2401
--SET @prmDealDate = '3/9/2009'
--SET @prmEffStartDate = '6/14/2010'

SET @GrossMargin = 0
SET @Custom = 'N'
SET @prmDealDate = DateAdd(dd, DateDiff(dd, 0, @prmDealDate) , 0 )

SELECT
	@Custom = CASE
			WHEN CP.IsCustom = 1 THEN 'Y'
			ELSE 'N'
		END 
FROM
	Lp_Common.dbo.Common_Product CP (NOLOCK)
WHERE
	CP.Product_ID = @prmProductID


IF @Custom = 'Y'
	BEGIN
		SELECT 
			@GrossMargin = COALESCE(GrossMargin,0)
		FROM
			lp_common.dbo.common_product_rate CPR (NOLOCK)
		WHERE
			CPR.product_id=@prmProductID
			AND CPR.rate_id=@prmRateID
	END
ELSE
	SELECT
		@GrossMargin = COALESCE(GrossMargin,0) 
	FROM
		Lp_Common.dbo.Product_Rate_History PRH (NOLOCK)
	WHERE
		PRH.Product_Rate_History_ID = (
			SELECT
				MAX(PRH2.Product_Rate_History_ID) MAX_ID
			FROM
				Lp_Common.dbo.Product_Rate_History PRH2 (NOLOCK)
			WHERE
				PRH2.Product_ID = @prmProductID
				AND PRH2.Rate_ID = @prmRateID
				AND PRH2.Eff_Date = @prmDealDate
				--AND MONTH(PRH2.Contract_Eff_Start_Date) = MONTH(@prmEffStartDate)
				--AND YEAR(PRH2.Contract_Eff_Start_Date) = YEAR(@prmEffStartDate)
				
			)	

	RETURN @GrossMargin
END