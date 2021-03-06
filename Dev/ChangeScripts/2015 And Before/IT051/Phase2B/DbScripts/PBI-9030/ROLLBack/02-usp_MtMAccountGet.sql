USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountGet]    Script Date: 12/09/2013 15:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the list of the accounts from the MtMAccount talbe							*
 *	Modified:								
	EXEC	usp_MtMAccountGet 'ETPd', 1,1,1
 ********************************************************************************************** */
ALTER PROCEDURE [dbo].[usp_MtMAccountGet]

	@Status as VARCHAR(10),
	@ProxiedZone AS BIT,
	@ProxiedProfile AS BIT,
	@ProxiedUsage AS BIT
	
AS

BEGIN
	SET NOCOUNT ON;
	--exec usp_MtMZainetGetAccountInfo
	
	-- First get all the accounts with the proper Zainet status
	SELECT	i.ContractID, i.AccountID
	INTO	#MtMAccount
	FROM	MtMZainetAccountInfo i
	--INNER	JOIN MtMReportStatus rs (nolock)
	--ON		i.Status = rs.Status
	--AND		i.SubStatus = rs.SubStatus
	--AND		rs.Inactive = 0
	WHERE	i.IsDaily = 1
	AND		i.ZainetEndDate >= DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))


	-- Get the MtMAccountID for those accounts
	SELECT	a.AccountID, a.ContractID, MAX(ID) as MtMAccountID
	INTO	#MtMAccountProxy
	FROM	/*MtMAccount*/MtMZainetMaxAccount a (nolock)
	INNER	jOIN #MtMAccount i
	ON		i.AccountID = a.AccountID
	AND		i.ContractID = a.ContractID				
	WHERE	ProxiedUsage = 1
	-- TODO: commented for now as we still have issues with profile and zones. only look at the proxied usage for now.WHERE	(ProxiedZone = @ProxiedZone OR ProxiedProfile = @ProxiedProfile OR ProxiedUsage = @ProxiedUsage)
	--and		a.DateCreated >= DATEADD(D, -1, DATEDIFF(D, 0, GETDATE()))
	AND		a.[Status] LIKE '%' +  @Status + '%'
	GROUP	BY a.ContractID, a.AccountID
	
	CREATE NONCLUSTERED INDEX idx_AccountP_I ON #MtMAccountProxy (MtMAccountID)
	
	-- Get the UsageSource for those accounts
	SELECT	DISTINCT ap.*, u.UsageSource
	INTO	#MtMAccountProxyUsage
	FROM	#MtMAccountProxy ap
	INNER	JOIN MtMUsage u (nolock)
	ON		ap.MtMAccountID = u.MtMAccountID
	
	CREATE NONCLUSTERED INDEX idx_AccountPU_I ON #MtMAccountProxyUsage (MtMAccountID)
	
	-- Combine all the Data
	SELECT	distinct pu.*, m.Zone, m.LoadProfile, m.ProxiedUsage, m.ProxiedZone, m.ProxiedProfile
	FROM	MtMAccount m (nolock)
	INNER	JOIN #MtMAccountProxyUsage pu
	ON		m.ID = pu.MtMAccountID
	--where 1=2
	ORDER	BY pu.ContractID
	
	SET NOCOUNT OFF;
END


