
-- exec usp_MtMContractsGet '5/5/2013'
CREATE PROCEDURE [dbo].[usp_MtMContractsGet]
(
	@DateSubmitted	  datetime
)

AS 

BEGIN
	SET NOCOUNT ON;
--drop table MtMError

	SElECT	DISTINCT
			c.Number
	--From	MtMError c

	FROM	LibertyPower..Account a (nolock)
	
	INNER	JOIN LibertyPower..Contract c (nolock)
	ON		a.CurrentContractID = c.ContractID

	INNER	JOIN LibertyPower..AccountContract ac (nolock)
	ON		a.AccountID = ac.AccountID
	AND		a.CurrentContractID = ac.ContractID

	INNER	JOIN LibertyPower..AccountContractRate acr (nolock)
	ON		ac.AccountContractID = acr.AccountContractID
	AND		acr.IsContractedRate = 1

	INNER	JOIN [LibertyPower].[dbo].[Price] p(NOLOCK)
	ON		acr.PriceID = p.ID 
	
	--INNER	JOIN Lp_common..common_product p (nolock)
	--ON		acr.LegacyProductID = p.product_id
		
	WHERE	a.Origin NOT IN ('INIT LOAD', 'ONLINE', 'EXCEL')
	--AND		p.product_category = 'FIXED' 
	AND		p.ProductTypeID IN ('1','7')
	AND		c.DateCreated BETWEEN	DATEADD(D, 0, DATEDIFF(D, 0, @DateSubmitted)) 
							AND		DATEADD(D, 0, DATEDIFF(D, 0, GETDATE())) 
--	AND		a.DateCreated between '12/10/2012' AND '12/12/2012'

	SET NOCOUNT OFF;

END


