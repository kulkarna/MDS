USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMContractsGet]    Script Date: 11/02/2012 09:24:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec usp_MtMContractsGet '9/28/2012'
ALTER PROCEDURE [dbo].[usp_MtMContractsGet]
(
	@DateSubmitted	  datetime
)

AS

BEGIN
	SET NOCOUNT ON;
	
	SElECT	DISTINCT
			c.Number
	FROM	LibertyPower..Account a (nolock)

	INNER	JOIN LibertyPower..Contract c (nolock)
	ON		a.CurrentContractID = c.ContractID

	INNER	JOIN LibertyPower..AccountContract ac (nolock)
	ON		a.AccountID = ac.AccountID
	AND		a.CurrentContractID = ac.ContractID

	INNER	JOIN LibertyPower..vw_AccountContractRate acr (nolock)
	ON		ac.AccountContractID = acr.AccountContractID
	--AND		acr.IsContractedRate = 1

	INNER	JOIN Lp_common..common_product p (nolock)
	ON		acr.LegacyProductID = p.product_id
		
	WHERE	a.Origin NOT IN ('INIT LOAD', 'ONLINE', 'EXCEL', 'WEB')
	--AND		a.DateCreated > '10/11/2012'
	AND		a.DateCreated > CAST(Month(@DateSubmitted) AS VARCHAR(2)) + '/' + CAST(Day(@DateSubmitted)as VARCHAR(2)) + '/' + CAST(Year(@DateSubmitted) as VARCHAR(4))
	--AND		a.DateCreated BETWEEN '8/14/2012' AND '8/15/2012'	--567 rows
	--AND		a.DateCreated BETWEEN '8/15/2012' AND '8/16/2012'	--463 rows
	--AND		a.DateCreated BETWEEN '8/17/2012' AND '8/18/2012'	--767 rows
	--AND		a.DateCreated BETWEEN '8/20/2012' AND '8/21/2012'	--1097 rows
	--AND		a.DateCreated BETWEEN '8/21/2012' AND '8/22/2012'	--622 rows
	--AND		a.DateCreated BETWEEN '8/23/2012' AND '8/24/2012'	--597 rows
	--AND		a.DateCreated BETWEEN '8/27/2012' AND '8/28/2012'	--1200 rows
	AND		p.product_category = 'FIXED'

	SET NOCOUNT OFF;
	
END

