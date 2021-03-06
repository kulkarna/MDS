USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMZainetGetMaxAccounts]    Script Date: 03/14/2013 17:30:27 ******/
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

	TRUNCATE	TABLE MtMZainetMaxAccount
	
	INSERT	INTO	MtMZainetMaxAccount
	
	SELECT	m.AccountID, m.ContractID, MAX(ID) AS ID
	FROM	MtMAccount m	(nolock)
	WHERE	m.Status = 'ETPd'
	--AND 	1 = 2
	GROUP	BY m.AccountID, m.ContractID

END