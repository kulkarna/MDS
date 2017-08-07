
CREATE FUNCTION [dbo].[ufn_EtfGetZoneAndClassFromProduct]
(
	@AccountID int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ZoneAndClass varchar(50)

	SET @ZoneAndClass = ( SELECT top 1 
	  replace(reverse(substring(reverse(pricingid),7,charindex('-',substring(reverse(pricingid),7,len(pricingid)))-1)),'/','')
	FROM lp_account.dbo.account a
	JOIN lp_common.dbo.PricingProductMapping pm ON a.product_id = pm.productid AND a.rate_id = pm.rateid
	WHERE AccountID = @AccountID ) 

	-- Return the result of the function
	RETURN @ZoneAndClass

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_EtfGetZoneAndClassFromProduct] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_EtfGetZoneAndClassFromProduct] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

