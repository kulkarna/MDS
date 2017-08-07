USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAccountInfoByContractId]    Script Date: 10/01/2013 14:31:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	9/17/2013																		*
 *	Descp:		Get the list of the accounts for the contract number passed						*
 *	Modified:																					*
	EXEC	usp_GetAccountInfoByContractId 30732, 	95199									*
 ********************************************************************************************** */
 
ALTER PROCEDURE [dbo].[usp_GetAccountInfoByContractId]
@ContractID AS INT, @AccountID as INT

AS

BEGIN
	SET NOCOUNT ON;

	-- Save the data needed into a temp table so the query runs faster
	--Get the Account Contract info
	SELECT	C.ContractID, C.Number as ContractNumber, C.SignedDate, C.StartDate, 
			A.AccountID, A.AccountNumber, A.Zone, A.LoadProfile, A.ServiceRateClass, A.StratumVariable, A.UtilityID, A.BillingGroup, A.DeliveryLocationRefID, A.LoadProfileRefID, A.ServiceClassRefID,
			AC.AccountContractID, AccountNameID
	INTO	#Account
	FROM	LibertyPower..AccountContract AC WITH (NOLOCK) 	
	
	INNER	JOIN LibertyPower..Contract C (NOLOCK)
	ON		AC.ContractID = C.ContractID
	
	INNER	Join LibertyPower..Account A WITH (NOLOCK)
	ON		AC.AccountID = A.AccountID
	
	WHERE	AC.ContractID = @ContractID
	AND		AC.AccountID = @AccountID

	--Select all the data together
	SELECT	DISTINCT
			A.ContractID, 
			A.ContractNumber, 
			A.SignedDate,
			A.AccountID,
			A.AccountNumber,
			U.UtilityCode, 
			A.BillingGroup,
			LTRIM(RTRIM(A.Zone)) AS Zone,
			LTRIM(RTRIM(A.LoadProfile)) AS LoadProfile, 
			AName.Name As BusinessName,
			A.ServiceRateClass AS RateClass, 
			A.StratumVariable,
			A.DeliveryLocationRefID, 
			A.LoadProfileRefID, 
			A.ServiceClassRefID,
			ACR.LegacyProductID AS ProductId,
			dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate ) FlowStartDate,
			ACR.RateStart AS ContractStartDate,
			ACR.Term AS Term,
			ACR.RateEnd AS ContractEndDate,
			ACR.RateCode,
			ACR.RateId

	FROM	#Account A (NOLOCK)
	JOIN	Utility U (NOLOCK) ON A.UtilityID = U.ID	
	JOIN	LibertyPower.dbo.AccountStatus ACS (NOLOCK) ON A.AccountContractID = ACS.AccountContractID
	JOIN	vw_AccountContractRate ACR (NOLOCK) ON A.AccountContractID = ACR.AccountContractID --AND ACR2.IsContractedRate = 1
	LEFT	JOIN AccountLatestService ASERVICE (NOLOCK) ON A.AccountID = ASERVICE.AccountID
	LEFT	JOIN LibertyPower.dbo.Name AName (NOLOCK)	ON A.AccountNameID = AName.NameID

	SET NOCOUNT OFF;
END
