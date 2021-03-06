USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetMaxAccounts]    Script Date: 08/12/2013 11:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the accounts are ETP'd																				*
 *  To Run:		exec usp_MtMZainetGetMaxAccounts																		*
  *	Modified:																											*
 ************************************************************************************************************************/
ALTER	PROCEDURE [dbo].[usp_MtMZainetGetMaxAccounts]

AS

BEGIN

SET NOCOUNT ON; 

	TRUNCATE	TABLE MtMZainetMaxAccount
	
	-- First, reset all the accounts that failed for date issues the day before
	UPDATE	MtMAccount
	SET		Status = 'ETPd'
	WHERE	Status = 'ETPd - Failed(Zainet)'
	
	SELECT	m.AccountID, isnull(m.ContractID,0) AS ContractID, ISNULL(DealPricingID,0) as DealPricingID, MAX(ID) AS ID
	INTO	#MAX
	FROM	MtMAccount m	(nolock)
	--WHERE	m.Status = 'ETPd'
	--AND (	PATINDEX('%CustomDealUpload%', m.QuoteNumber) = 0
	--	OR	(PATINDEX('%CustomDealUpload%', m.QuoteNumber) >= 1 and m.ContractId is not null)
	--	)
	GROUP	BY m.AccountID, m.ContractID, ISNULL(DealPricingID,0) 

	INSERT	INTO	MtMZainetMaxAccount
	SELECT	Distinct m.*
	FROM	#MAX maxAct
	INNER	JOIN MtMAccount  m (nolock)
	ON		m.ID = maxAct.ID
	WHERE	m.Status = 'ETPd'
	--where 1=2
	
SET NOCOUNT OFF; 
	
END
