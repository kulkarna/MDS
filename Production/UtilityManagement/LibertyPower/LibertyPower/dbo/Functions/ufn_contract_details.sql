

-- =============================================
-- Author:		Eric Hernandez
-- Create date: 4/20/2012
-- Description:	Get current price details of contract along with what it should be.
-- Modified: 11/1/2012 by Cathy Gh.: use vw_AccountContractRate
-- Modified: 11/8/2012 By Cathy GH: In case of a multi term product, get the price from the table ProductCrossPriceMulti. ActualTransferRate is the price of the current sub term  
-- =============================================
-- select * from libertypower.dbo.ufn_contract_details('ct3')
CREATE FUNCTION [dbo].[ufn_contract_details] (@contract_nbr VARCHAR(25))
RETURNS @ContractDetails Table
(
	AccountID INT
	, PriceID INT
	, ContractTierID INT
	, ContractTransferRate DECIMAL(18,10)
	, ContractRate DECIMAL(18,10)
	, [Description] VARCHAR(100)
	, MinKwh INT
	, MaxKwh INT
	, ChannelGroupID INT
	, ChannelTypeID INT
	, ProductTypeID INT
	, MarketID INT
	, UtilityID INT
	, SegmentID INT
	, ZoneID INT
	, ServiceClassID INT
	, Term INT
	, IsTermRange INT
	, ProductBrandID INT
	, ActualTierID INT
	, ActualTransferRate DECIMAL(18,10)
	, ActualPriceID INT
	, AccountNumber varchar(30)
	, UtilityCode varchar(50)
)
AS
BEGIN
	DECLARE @ContractID INT
	DECLARE @SalesChannelID INT
	DECLARE @ContractStartDate DATETIME
	DECLARE @SignedDate DATETIME
	
	SELECT @ContractID = ContractID, @ContractStartDate = c.StartDate, @SignedDate = SignedDate, @SalesChannelID = SalesChannelID
	FROM LibertyPower..Contract c (NOLOCK)
	WHERE c.Number = @contract_nbr

	--SELECT top 10 * from libertypower..Price
	
	DECLARE @Price AS TABLE 
	(
		ID				bigint NOT NULL,
		ChannelID		int NOT NULL,
		ChannelGroupID	int NOT NULL,
		ChannelTypeID	int NOT NULL,
		ProductTypeID	int NOT NULL,
		MarketID		int NOT NULL,
		UtilityID		int NOT NULL,
		SegmentID		int NOT NULL,
		ZoneID			int NOT NULL,
		ServiceClassID	int NOT NULL,
		StartDate		datetime NOT NULL,
		Term			int NOT NULL,
		Price			decimal(18, 10) NOT NULL,
		IsTermRange		tinyint NOT NULL,
		PriceTier		tinyint NULL,
		ProductBrandID	int ,
		ProductCrossPriceID int
	)
	
		
	INSERT INTO @Price
	SELECT ID,ChannelID,ChannelGroupID,ChannelTypeID,ProductTypeID,MarketID,UtilityID,SegmentID,ZoneID,ServiceClassID,StartDate,Term,Price,IsTermRange,PriceTier,ProductBrandID, ProductCrossPriceID
	FROM LibertyPower..Price (NOLOCK)
	WHERE 1=1
	AND StartDate = @ContractStartDate
	AND @SignedDate BETWEEN CostRateEffectiveDate AND CostRateExpirationDate
	AND ChannelID = @SalesChannelID

	DECLARE @total_contract_usage INT
	SELECT @total_contract_usage = SUM(au.AnnualUsage)
	FROM LibertyPower..Account a (NOLOCK)
	JOIN LibertyPower..AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID
	WHERE a.CurrentContractID = @ContractID AND au.EffectiveDate = @ContractStartDate


	INSERT INTO @ContractDetails(	ac.AccountID, PriceID, ContractTierID, ContractTransferRate, ContractRate, [Description], 
									MinKwh, MaxKwh, ChannelGroupID, ChannelTypeID, ProductTypeID, MarketID, UtilityID, SegmentID, 
									ZoneID, ServiceClassID, Term, IsTermRange, ProductBrandID, AccountNumber, UtilityCode
								)
	SELECT	ac.AccountID, acr.PriceID, t.ID,
			CASE WHEN pb.IsMultiTerm = 0 THEN p.Price
				ELSE m.Price
				END AS Price,
			acr.Rate, t.Description, t.MinMwh * 1000, t.MaxMwh * 1000, 
			ChannelGroupID, ChannelTypeID, p.ProductTypeID, p.MarketID, p.UtilityID, SegmentID, ZoneID, ServiceClassID, 
			p.Term, IsTermRange, p.ProductBrandID, a.AccountNumber, u.UtilityCode
	FROM LibertyPower..AccountContract ac (NOLOCK)
	JOIN LibertyPower..vw_AccountContractRate acr (NOLOCK) ON ac.AccountContractID = acr.AccountContractID
	JOIN Libertypower..Account a (NOLOCK) ON ac.AccountID = a.AccountID
	JOIN Libertypower..Utility u (NOLOCK) ON a.UtilityID = u.ID
	JOIN @Price p ON acr.PriceID = p.ID
	JOIN ProductBrand pb (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
	LEFT JOIN ProductCrossPriceMulti m (NOLOCK)
	ON	acr.ProductCrossPriceMultiID = m.ProductCrossPriceMultiID
	AND	pb.IsMultiTerm = 1
	JOIN LibertyPower..DailyPricingPriceTier t (NOLOCK) ON p.PriceTier = t.ID
	WHERE ac.ContractID = @ContractID


	UPDATE t
	SET ActualTierID = ActualTier.ID
		, ActualTransferRate = CASE WHEN pb.IsMultiTerm = 0 THEN p.Price ELSE m.Price END 
		, ActualPriceID = p.ID
	FROM @ContractDetails t
	JOIN LibertyPower..DailyPricingPriceTier ActualTier (NOLOCK) ON @total_contract_usage BETWEEN (MinMwh * 1000) AND (MaxMwh * 1000) OR ActualTier.ID = 0
	JOIN @Price p 
		ON  p.PriceTier = ActualTier.ID
		AND t.ChannelGroupID = p.ChannelGroupID
		AND t.ChannelTypeID = p.ChannelTypeID
		AND t.ProductTypeID = p.ProductTypeID
		AND t.MarketID = p.MarketID
		AND t.UtilityID = p.UtilityID
		AND t.SegmentID = p.SegmentID
		AND t.ZoneID = p.ZoneID
		AND t.ServiceClassID = p.ServiceClassID
		AND t.Term = p.Term
		--AND t.IsTermRange = p.IsTermRange
		AND t.ProductBrandID = p.ProductBrandID
	JOIN ProductBrand pb (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
	LEFT JOIN vw_ProductCrossPriceMulti m 
	ON	p.ProductCrossPriceID = m.ProductCrossPriceID
	AND	pb.IsMultiTerm = 1
	
	
	
	RETURN
END


