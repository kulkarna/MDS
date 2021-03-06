USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMAccountGet]    Script Date: 03/25/2013 14:41:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the list of the accounts from the MtMAccount talbe							*
 *	Modified:								
	EXEC	[usp_MtMAccountGet] 'ETPd', 1,1,1
 ********************************************************************************************** */
ALTER PROCEDURE [dbo].[usp_MtMAccountGet]

	@Status as VARCHAR(10),
	@ProxiedDeliveryPoint AS BIT,
	@ProxiedProfile AS BIT,
	@ProxiedUsage AS BIT
	
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	i.ContractID, i.AccountID
	INTO	#MtMAccount
	FROM	MtMZainetAccountInfo i WITH (NOLOCK)
	WHERE	i.IsDaily = 1
	AND		i.ZainetEndDate >= DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))
	
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

	SELECT	distinct pu.*, dL.Value as Location, pl.Value as LoadProfile, m.ProxiedUsage, m.ProxiedLocation, m.ProxiedProfile
	FROM	MtMAccount m (nolock)
	INNER	JOIN #MtMAccountProxyUsage pu
	ON		m.ID = pu.MtMAccountID
	INNER	Join LibertyPower..PropertyInternalRef  dL  (nolock)
	ON		m.SettlementLocationRefID = dL.ID

	INNER	Join LibertyPower..PropertyInternalRef  pL  (nolock)
	ON		m.LoadProfileRefId = pL.ID

	ORDER	BY pu.ContractID
	
	SET NOCOUNT OFF;
END
