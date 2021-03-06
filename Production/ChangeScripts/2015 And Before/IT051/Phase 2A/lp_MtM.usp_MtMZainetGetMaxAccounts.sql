USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetMaxAccounts]    Script Date: 03/13/2013 13:52:59 ******/
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
	
	INSERT	INTO	MtMZainetMaxAccount
	
	SELECT	m.AccountID, m.ContractID, MAX(ID) AS ID
	FROM	MtMAccount m	(nolock)
	WHERE	m.Status = 'ETPd'
	AND (
		(PATINDEX('CustomDealUpload-%', m.QuoteNumber) = 0)
		or
		(
		(PATINDEX('CustomDealUpload-%', m.QuoteNumber) >= 1) and (m.ContractId is not null)
		)
		)
	
	GROUP	BY m.AccountID, m.ContractID

SET NOCOUNT OFF; 
	
END