USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetMaxAccounts]    Script Date: 10/03/2013 13:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the accounts are ETP'd																				*
 *  To Run:		exec usp_MtMZainetGetMaxAccounts																		*
  *	Modified:	10/3: Replace Zone/profile with SettlementLocationId and LoadProfileRefID								*
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
	--AND 1 = 2
	
	SELECT	m.AccountID, isnull(m.ContractID,0) AS ContractID, ISNULL(CustomDealID,0) as CustomDealID, MAX(ID) AS ID
	INTO	#MAX
	FROM	MtMAccount m	(nolock)
	--AND 1 = 2
	--WHERE	m.Status = 'ETPd'
	--AND (	PATINDEX('%CustomDealUpload%', m.QuoteNumber) = 0
	--	OR	(PATINDEX('%CustomDealUpload%', m.QuoteNumber) >= 1 and m.ContractId is not null)
	--	)
	GROUP	BY m.AccountID, m.ContractID, ISNULL(CustomDealID,0) 

	INSERT	INTO	MtMZainetMaxAccount
			(ID
			,BatchNumber
			,QuoteNumber
			,AccountID
			,ContractID
			,SettlementLocationRefID
			,LoadProfileRefId
			,ProxiedLocation
			,ProxiedProfile
			,ProxiedUsage
			,MeterReadCount
			,Status
			,DateCreated
			,CreatedBy
			,DateModified
		    ,CustomDealID
		    )
	SELECT	Distinct
			m.ID
			,m.BatchNumber
			,m.QuoteNumber
			,m.AccountID
			,m.ContractID
			,m.SettlementLocationRefID
			,m.LoadProfileRefId
			,m.ProxiedLocation
			,m.ProxiedProfile
			,m.ProxiedUsage
			,m.MeterReadCount
			,m.Status
			,m.DateCreated
			,m.CreatedBy
			,m.DateModified
		    ,m.CustomDealID
	FROM	#MAX maxAct
	INNER	JOIN MtMAccount  m (nolock)
	ON		m.ID = maxAct.ID
	WHERE	m.Status = 'ETPd'
	--AND 1 = 2
	
SET NOCOUNT OFF; 
	
END
